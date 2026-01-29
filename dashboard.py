#!/usr/bin/env python3
"""
Layered ZSH Web Dashboard
========================

Web interface for managing Layered ZSH
Real-time monitoring, configuration management, user interface

Author: Layered ZSH Team
Version: v3.2
"""

import os
import sys
import json
import time
import subprocess
from datetime import datetime
from flask import Flask, render_template, jsonify, request, send_from_directory
from flask_socketio import SocketIO, emit

app = Flask(__name__)
app.config['SECRET_KEY'] = 'layered-zsh-dashboard-secret'
socketio = SocketIO(app, cors_allowed_origins="*")

# Konfiguracja
LAYERED_DIR = os.path.expanduser("~/.config/layered")
LAYERED_CACHE_DIR = os.path.expanduser("~/.local/share/layered")
DASHBOARD_PORT = 8080

class LayeredZSHManager:
    def __init__(self):
        self.status_cache = {}
        self.last_update = {}
        
    def get_system_status(self):
        """Pobierz status systemu Layered ZSH"""
        try:
            # Status podstawowy
            result = subprocess.run(['status'], capture_output=True, text=True, timeout=5)
            status_text = result.stdout
            
            # AI status
            ai_result = subprocess.run(['ai_status'], capture_output=True, text=True, timeout=5)
            ai_status = ai_result.stdout
            
            # Monitoring status
            monitor_result = subprocess.run(['monitor-status'], capture_output=True, text=True, timeout=5)
            monitor_status = monitor_result.stdout
            
            # P10k status
            p10k_result = subprocess.run(['p10k-status'], capture_output=True, text=True, timeout=5)
            p10k_status = p10k_result.stdout
            
            # LDAP status
            ldap_result = subprocess.run(['ldap-status'], capture_output=True, text=True, timeout=5)
            ldap_status = ldap_result.stdout
            
            return {
                'timestamp': datetime.now().isoformat(),
                'layered_status': status_text,
                'ai_status': ai_status,
                'monitor_status': monitor_status,
                'p10k_status': p10k_status,
                'ldap_status': ldap_status,
                'uptime': self.get_uptime(),
                'memory_usage': self.get_memory_usage(),
                'cpu_usage': self.get_cpu_usage()
            }
        except Exception as e:
            return {
                'timestamp': datetime.now().isoformat(),
                'error': str(e),
                'status': 'error'
            }
    
    def get_uptime(self):
        """Pobierz uptime systemu"""
        try:
            with open('/proc/uptime', 'r') as f:
                uptime_seconds = float(f.readline().split()[0])
                days = int(uptime_seconds // 86400)
                hours = int((uptime_seconds % 86400) // 3600)
                minutes = int((uptime_seconds % 3600) // 60)
                return f"{days}d {hours}h {minutes}m"
        except:
            return "Unknown"
    
    def get_memory_usage(self):
        """Pobierz użycie pamięci"""
        try:
            with open('/proc/meminfo', 'r') as f:
                meminfo = f.read()
            
            total = 0
            available = 0
            
            for line in meminfo.split('\n'):
                if line.startswith('MemTotal:'):
                    total = int(line.split()[1])
                elif line.startswith('MemAvailable:'):
                    available = int(line.split()[1])
            
            used = total - available
            usage_percent = (used / total) * 100
            
            return {
                'total': total // 1024,  # MB
                'used': used // 1024,    # MB
                'available': available // 1024,  # MB
                'usage_percent': round(usage_percent, 1)
            }
        except:
            return {'error': 'Unable to get memory info'}
    
    def get_cpu_usage(self):
        """Pobierz użycie CPU"""
        try:
            with open('/proc/stat', 'r') as f:
                cpu_line = f.readline()
            
            cpu_times = list(map(int, cpu_line.split()[1:8]))
            idle = cpu_times[3]
            total = sum(cpu_times)
            
            # Poczekaj chwilę
            time.sleep(0.1)
            
            with open('/proc/stat', 'r') as f:
                cpu_line = f.readline()
            
            cpu_times = list(map(int, cpu_line.split()[1:8]))
            idle_diff = cpu_times[3] - idle
            total_diff = sum(cpu_times) - total
            
            usage_percent = (1 - idle_diff / total_diff) * 100
            
            return round(usage_percent, 1)
        except:
            return 0.0
    
    def execute_command(self, command):
        """Wykonaj komendę Layered ZSH"""
        try:
            result = subprocess.run(
                command, 
                shell=True, 
                capture_output=True, 
                text=True, 
                timeout=30,
                cwd=os.path.expanduser("~")
            )
            
            return {
                'success': True,
                'stdout': result.stdout,
                'stderr': result.stderr,
                'returncode': result.returncode
            }
        except subprocess.TimeoutExpired:
            return {
                'success': False,
                'error': 'Command timeout'
            }
        except Exception as e:
            return {
                'success': False,
                'error': str(e)
            }
    
    def get_ai_models(self):
        """Pobierz dostępne modele AI"""
        try:
            if os.path.exists('/usr/bin/ollama'):
                result = subprocess.run(['ollama', 'list'], capture_output=True, text=True)
                return result.stdout
            else:
                return "Ollama not installed"
        except:
            return "Unable to get AI models"
    
    def get_backups(self):
        """Pobierz listę kopii zapasowych"""
        try:
            backup_dir = os.path.join(LAYERED_CACHE_DIR, 'backups')
            if os.path.exists(backup_dir):
                backups = []
                for file in os.listdir(backup_dir):
                    if file.endswith('.tar.gz'):
                        file_path = os.path.join(backup_dir, file)
                        stat = os.stat(file_path)
                        backups.append({
                            'name': file,
                            'size': stat.st_size,
                            'date': datetime.fromtimestamp(stat.st_mtime).isoformat()
                        })
                return sorted(backups, key=lambda x: x['date'], reverse=True)
            else:
                return []
        except:
            return []
    
    def get_logs(self, log_type='system'):
        """Pobierz logi"""
        log_files = {
            'system': '/var/log/syslog',
            'layered': os.path.join(LAYERED_CACHE_DIR, 'updates', 'update.log'),
            'ai': os.path.join(LAYERED_CACHE_DIR, 'ai', 'logs', 'usage.log'),
            'ldap': os.path.join(LAYERED_DIR, 'ldap', 'logs', 'ldap.log')
        }
        
        log_file = log_files.get(log_type)
        if log_file and os.path.exists(log_file):
            try:
                with open(log_file, 'r') as f:
                    lines = f.readlines()
                    return lines[-100:]  # Ostatnie 100 linii
            except:
                return []
        else:
            return []

# Globalny manager
manager = LayeredZSHManager()

# Routes
@app.route('/')
def index():
    """Główna strona dashboard"""
    return render_template('index.html')

@app.route('/api/status')
def api_status():
    """API endpoint dla statusu systemu"""
    return jsonify(manager.get_system_status())

@app.route('/api/execute', methods=['POST'])
def api_execute():
    """API endpoint dla wykonywania komend"""
    data = request.json
    command = data.get('command', '')
    
    if not command:
        return jsonify({'success': False, 'error': 'No command provided'})
    
    # Lista dozwolonych komend
    allowed_commands = [
        'status', 'lhelp', 'ai_status', 'monitor-status', 'p10k-status',
        'ldap-status', 'lbackup_info', 'lbackup_list', 'lupdate_status',
        'hud', 'ai_clear', 'ldap-cache-stats'
    ]
    
    # Sprawdź czy komenda jest dozwolona
    if not any(command.startswith(cmd) for cmd in allowed_commands):
        return jsonify({'success': False, 'error': 'Command not allowed'})
    
    result = manager.execute_command(command)
    return jsonify(result)

@app.route('/api/ai-models')
def api_ai_models():
    """API endpoint dla modeli AI"""
    return jsonify({'models': manager.get_ai_models()})

@app.route('/api/backups')
def api_backups():
    """API endpoint dla kopii zapasowych"""
    return jsonify({'backups': manager.get_backups()})

@app.route('/api/logs/<log_type>')
def api_logs(log_type):
    """API endpoint dla logów"""
    return jsonify({'logs': manager.get_logs(log_type)})

@app.route('/api/config')
def api_config():
    """API endpoint dla konfiguracji"""
    try:
        config = {}
        
        # Pobierz konfigurację z różnych plików
        config_files = {
            'ai': os.path.join(LAYERED_DIR, 'ai', 'config'),
            'ldap': os.path.join(LAYERED_DIR, 'ldap', 'config'),
            'p10k': os.path.join(LAYERED_DIR, 'themes', 'p10k.zsh')
        }
        
        for name, path in config_files.items():
            if os.path.exists(path):
                with open(path, 'r') as f:
                    config[name] = f.read()
            else:
                config[name] = None
        
        return jsonify(config)
    except Exception as e:
        return jsonify({'error': str(e)})

# WebSocket events
@socketio.on('connect')
def handle_connect():
    """Obsługa połączenia WebSocket"""
    emit('connected', {'data': 'Connected to Layered ZSH Dashboard'})
    
    # Wysyłaj status co 5 sekund
    while True:
        status = manager.get_system_status()
        emit('status_update', status)
        socketio.sleep(5)

@socketio.on('disconnect')
def handle_disconnect():
    """Obsługa rozłączenia WebSocket"""
    print('Client disconnected')

@socketio.on('execute_command')
def handle_execute_command(data):
    """Obsługa wykonywania komend przez WebSocket"""
    command = data.get('command', '')
    
    if command:
        result = manager.execute_command(command)
        emit('command_result', result)

# Szablony HTML
@app.route('/templates/<path:filename>')
def templates(filename):
    """Serwuj szablony"""
    return send_from_directory('templates', filename)

# Główna funkcja
def main():
    """Główna funkcja dashboard"""
    import argparse
    
    parser = argparse.ArgumentParser(description='Layered ZSH Web Dashboard')
    parser.add_argument('--port', type=int, default=DASHBOARD_PORT, help='Port number')
    parser.add_argument('--host', default='localhost', help='Host address')
    parser.add_argument('--debug', action='store_true', help='Enable debug mode')
    
    args = parser.parse_args()
    
    print(f"🚀 Starting Layered ZSH Dashboard on http://{args.host}:{args.port}")
    print("📊 Dashboard provides real-time monitoring and management")
    print("🔐 Make sure Layered ZSH is properly configured")
    
    # Stwórz katalog szablonów jeśli nie istnieje
    template_dir = os.path.join(os.path.dirname(__file__), 'templates')
    os.makedirs(template_dir, exist_ok=True)
    
    # Stwórz podstawowy szablon jeśli nie istnieje
    index_template = os.path.join(template_dir, 'index.html')
    if not os.path.exists(index_template):
        create_basic_template(index_template)
    
    try:
        socketio.run(app, host=args.host, port=args.port, debug=args.debug)
    except KeyboardInterrupt:
        print("\n👋 Dashboard stopped")
    except Exception as e:
        print(f"❌ Error starting dashboard: {e}")

def create_basic_template(path):
    """Stwórz podstawowy szablon HTML"""
    html_content = '''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Layered ZSH Dashboard</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/socket.io/4.0.1/socket.io.js"></script>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; }
        .header { background: #2c3e50; color: white; padding: 20px; border-radius: 8px; margin-bottom: 20px; }
        .status-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; }
        .status-card { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .status-card h3 { margin-top: 0; color: #2c3e50; }
        .status-item { margin: 10px 0; }
        .status-value { font-weight: bold; color: #27ae60; }
        .error { color: #e74c3c; }
        .warning { color: #f39c12; }
        .command-input { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; margin: 10px 0; }
        .command-button { background: #3498db; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; }
        .command-button:hover { background: #2980b9; }
        .log-viewer { background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 4px; font-family: monospace; height: 200px; overflow-y: auto; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚀 Layered ZSH Dashboard</h1>
            <p>Real-time monitoring and management</p>
        </div>
        
        <div class="status-grid">
            <div class="status-card">
                <h3>📊 System Status</h3>
                <div id="system-status">Loading...</div>
            </div>
            
            <div class="status-card">
                <h3>🤖 AI Status</h3>
                <div id="ai-status">Loading...</div>
            </div>
            
            <div class="status-card">
                <h3>📈 Performance</h3>
                <div id="performance-status">Loading...</div>
            </div>
            
            <div class="status-card">
                <h3>🔐 Security</h3>
                <div id="security-status">Loading...</div>
            </div>
        </div>
        
        <div class="status-card">
            <h3>🔧 Command Execution</h3>
            <input type="text" id="command-input" class="command-input" placeholder="Enter Layered ZSH command...">
            <button onclick="executeCommand()" class="command-button">Execute</button>
            <div id="command-result"></div>
        </div>
        
        <div class="status-card">
            <h3>📋 System Logs</h3>
            <div id="logs" class="log-viewer">Loading...</div>
        </div>
    </div>
    
    <script>
        const socket = io();
        
        socket.on('connect', function() {
            console.log('Connected to dashboard');
        });
        
        socket.on('status_update', function(data) {
            updateStatus(data);
        });
        
        socket.on('command_result', function(data) {
            document.getElementById('command-result').innerHTML = 
                '<pre>' + JSON.stringify(data, null, 2) + '</pre>';
        });
        
        function updateStatus(data) {
            // System status
            const systemDiv = document.getElementById('system-status');
            if (data.error) {
                systemDiv.innerHTML = '<span class="error">Error: ' + data.error + '</span>';
            } else {
                systemDiv.innerHTML = `
                    <div class="status-item">Uptime: <span class="status-value">${data.uptime}</span></div>
                    <div class="status-item">Last Update: <span class="status-value">${new Date(data.timestamp).toLocaleString()}</span></div>
                `;
            }
            
            // AI status
            const aiDiv = document.getElementById('ai-status');
            if (data.ai_status) {
                aiDiv.innerHTML = '<pre>' + data.ai_status.substring(0, 200) + '...</pre>';
            }
            
            // Performance
            const perfDiv = document.getElementById('performance-status');
            if (data.memory_usage && data.cpu_usage !== undefined) {
                perfDiv.innerHTML = `
                    <div class="status-item">CPU: <span class="status-value">${data.cpu_usage}%</span></div>
                    <div class="status-item">Memory: <span class="status-value">${data.memory_usage.usage_percent}%</span></div>
                    <div class="status-item">Available: <span class="status-value">${data.memory_usage.available}MB</span></div>
                `;
            }
            
            // Security
            const securityDiv = document.getElementById('security-status');
            if (data.ldap_status) {
                securityDiv.innerHTML = '<pre>' + data.ldap_status.substring(0, 200) + '...</pre>';
            }
        }
        
        function executeCommand() {
            const input = document.getElementById('command-input');
            const command = input.value.trim();
            
            if (command) {
                socket.emit('execute_command', { command: command });
                input.value = '';
            }
        }
        
        // Load initial status
        fetch('/api/status')
            .then(response => response.json())
            .then(data => updateStatus(data));
    </script>
</body>
</html>'''
    
    with open(path, 'w') as f:
        f.write(html_content)

if __name__ == '__main__':
    main()
