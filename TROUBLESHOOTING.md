# LAYERED ZSH - TROUBLESHOOTING GUIDE

## 🚨 WSPÓLNE PROBLEMY I ROZWIĄZANIA

### 📦 INSTALATION ISSUES

#### Problem: "Zsh not found"
```bash
# Rozwiązanie:
sudo pacman -S zsh  # Arch/Manjaro
sudo apt install zsh  # Ubuntu/Debian
brew install zsh  # macOS
```

#### Problem: "Git not found"
```bash
# Rozwiązanie:
sudo pacman -S git  # Arch/Manjaro
sudo apt install git  # Ubuntu/Debian
brew install git  # macOS
```

#### Problem: "Permission denied during installation"
```bash
# Rozwiązanie:
chmod +x install.sh
./install.sh
```

#### Problem: "whiptail not found"
```bash
# Rozwiązanie:
sudo pacman -S libnewt  # Arch/Manjaro
sudo apt install whiptail  # Ubuntu/Debian
```

### 🎨 PROMPT ISSUES

#### Problem: "Powerlevel10k not loading"
```bash
# Rozwiązanie:
export LAYERED_USE_P10K=true
source ~/.zshrc

# Lub zainstaluj ręcznie:
p10k-install
```

#### Problem: "Prompt looks broken"
```bash
# Rozwiązanie:
p10k-configure  # Uruchom wizard
# Lub zresetuj:
p10k-reset
source ~/.zshrc
```

#### Problem: "Custom segments not showing"
```bash
# Rozwiązanie:
p10k-status  # Sprawdź status
# Upewnij się, że LAYERED_USE_P10K=true
```

### 🤖 AI ISSUES

#### Problem: "AI not working"
```bash
# Rozwiązanie:
ai_status  # Sprawdź status
ai_setup   # Skonfiguruj AI

# Jeśli Ollama nie działa:
curl -fsSL https://ollama.com/install.sh | sh
```

#### Problem: "API keys not working"
```bash
# Rozwiązanie:
ai_setup  # Ponownie skonfiguruj klucze
# Sprawdź czy klucze są poprawne
ai_test   # Test połączenia
```

#### Problem: "AI responses are slow"
```bash
# Rozwiązanie:
ai_clear  # Wyczyść cache
# Użyj szybszego modelu:
ai -m deepseek "pytanie"
```

### 📊 MONITORING ISSUES

#### Problem: "Monitoring not working"
```bash
# Rozwiązanie:
sudo pacman -S lm_sensors  # Arch/Manjaro
sudo sensors-detect  # Wykryj czujniki
```

#### Problem: "HUD not showing"
```bash
# Rozwiązanie:
hud  # Uruchom HUD
# Sprawdź czy monitoring jest włączony
monitor-status
```

#### Problem: "Temperature sensors not working"
```bash
# Rozwiązanie:
sudo sensors-detect
# Zrestartuj system
```

### 🔧 AUTO-UPDATE ISSUES

#### Problem: "Auto-update not working"
```bash
# Rozwiązanie:
lupdate_status  # Sprawdź status
lupdate_enable  # Włącz auto-update
```

#### Problem: "Update failed"
```bash
# Rozwiązanie:
lupdate_rollback  # Przywróć z LKG
lupdate_now       # Spróbuj ponownie
```

#### Problem: "Systemd timer not working"
```bash
# Rozwiązanie:
systemctl --user status layered-update.timer
systemctl --user start layered-update.timer
```

### 💾 BACKUP ISSUES

#### Problem: "Backup not working"
```bash
# Rozwiązanie:
lbackup_info  # Sprawdź status
# Upewnij się, że katalog istnieje
mkdir -p ~/.local/share/layered/backups
```

#### Problem: "Restore failed"
```bash
# Rozwiązanie:
lbackup_list  # Sprawdź dostępne kopie
# Wybierz inną kopię
lrestore /path/to/backup.tar.gz
```

#### Problem: "Permission denied on backup"
```bash
# Rozwiązanie:
chmod 755 ~/.local/share/layered
chmod 755 ~/.local/share/layered/backups
```

### 🔒 SECURITY ISSUES

#### Problem: "Can't exit immutable mode"
```bash
# Rozwiązanie:
# Sprawdź czy naprawdę chcesz wyjść
lmode safe  # Użyj trybu safe zamiast
```

#### Problem: "Audit not working"
```bash
# Rozwiązanie:
audit-status  # Sprawdź status
audit-start   # Uruchom audyt
```

#### Problem: "Rollback not working"
```bash
# Rozwiązanie:
rollback-status  # Sprawdź status
rollback-list    # Sprawdź dostępne rollbacki
```

### ⚡ PERFORMANCE ISSUES

#### Problem: "Slow startup"
```bash
# Rozwiązanie:
./benchmark.sh quick  # Test wydajności
# Wyłącz ciężkie moduły
# Użyj trybu minimal
```

#### Problem: "High memory usage"
```bash
# Rozwiązanie:
./benchmark.sh memory  # Test pamięci
ai_clear  # Wyczyść AI cache
lbackup_clean  # Wyczyść stare kopie
```

#### Problem: "Zsh is slow"
```bash
# Rozwiązanie:
# Wyłącz Powerlevel10k
unset LAYERED_USE_P10K
# Użyj prostszego prompta
```

### 🔧 PLUGIN ISSUES

#### Problem: "Zinit not working"
```bash
# Rozwiązanie:
rm -rf ~/.local/share/zinit
# Zrestartuj shell - Zinst zainstaluje się ponownie
```

#### Problem: "Completions not working"
```bash
# Rozwiązanie:
rm ~/.cache/zcompdump*
# Zrestartuj shell
```

#### Problem: "Syntax highlighting not working"
```bash
# Rozuwizanie:
zinit update zsh-users/zsh-syntax-highlighting
# Zrestartuj shell
```

### 🌐 NETWORK ISSUES

#### Problem: "Can't connect to GitHub"
```bash
# Rozwiązanie:
ping github.com
# Sprawdź firewall i DNS
```

#### Problem: "AI API not working"
```bash
# Rozwiązanie:
curl -I https://api.openai.com  # Test połączenia
# Sprawdź klucze API
ai_test
```

### 📱 MODE ISSUES

#### Problem: "Mode switching not working"
```bash
# Rozwiązanie:
lmode status  # Sprawdź obecny tryb
lmode full    # Włącz tryb pełny
```

#### Problem: "Stuck in safe mode"
```bash
# Rozwiązanie:
# Sprawdź co spowodowało tryb safe
cat ~/.layered_safe
# Napraw problem
lmode full
```

### 🔄 RESET AND RECOVERY

#### Full reset Layered ZSH:
```bash
# Backup najpierw
lbackup

# Reset konfiguracji
rm -rf ~/.config/layered
# Ponowna instalacja
./install.sh
```

#### Reset AI:
```bash
ai_clear
rm -rf ~/.config/layered/ai
ai_setup
```

#### Reset Powerlevel10k:
```bash
p10k-reset
p10k-configure
```

### 📞 GETTING HELP

#### Check system status:
```bash
status          # Ogólny status systemu
lhelp           # Pomoc Layered ZSH
ai_status       # Status AI
p10k_status     # Status Powerlevel10k
lupdate_status  # Status auto-update
```

#### Enable debugging:
```bash
export LAYERED_DEBUG=true
source ~/.zshrc
```

#### Check logs:
```bash
# AI logs
ai_logs

# Update logs
cat ~/.local/share/layered/updates/update.log

# Audit logs
audit-log
```

#### Report issues:
```bash
# Zbierz informacje
status > system-info.txt
lhelp >> system-info.txt
git log --oneline -5 >> system-info.txt
```

### 🎯 PREVENTIVE MAINTENANCE

#### Regular maintenance:
```bash
# Czyść cache
ai_clear
lbackup_clean

# Aktualizuj system
lupdate_now

# Test wydajności
./benchmark.sh quick

# Sprawdź status
status
```

#### Backup schedule:
```bash
# Automatyczny backup
lbackup

# Sprawdź kopie
lbackup_list
```

#### Update dependencies:
```bash
# Aktualizuj Ollama
ollama pull deepseek-coder-v2:lite

# Aktualizaj pluginy
zinit update
```

---

## 🔧 ADVANCED TROUBLESHOOTING

### Debug mode:
```bash
export LAYERED_DEBUG=true
export LAYERED_VERBOSE=true
source ~/.zshrc
```

### Force reload:
```bash
# Pełny reload
exec zsh

# Lub
source ~/.zshrc
```

### Check environment:
```bash
env | grep LAYERED
echo $LAYERED_MODE
echo $LAYERED_USE_P10K
```

### Test individual modules:
```bash
# Test AI
zsh -c "source ~/.config/layered/productivity/ai_core.zsh"

# Test monitoring
zsh -c "source ~/.config/layered/productivity/monitoring.zsh"

# Test backup
zsh -c "source ~/.config/layered/core/backup.zsh"
```

---

## 📞 SUPPORT

Jeśli problem nie został rozwiązany:
1. Sprawdź [GitHub Issues](https://github.com/QguAr71/layered-zsh/issues)
2. Użyj `lhelp` dla lokalnej pomocy
3. Sprawdź [README](https://github.com/QguAr71/layered-zsh)
4. Zgłoś issue z `system-info.txt`

---

**Pamiętaj:** Layered ZSH ma wbudowane systemy bezpieczeństwa i odzyskiwania. W razie problemów użyj `lrestore` lub `lupdate_rollback`.
