# Installation

## Requirements

- Zsh 5.8+
- Ollama (optional for AI features)
- lm_sensors (optional for temperature monitoring)
- Systemd

## Quick Install

```bash
# Clone the repository
git clone https://github.com/twoj-repo/layered-zsh.git ~/.config/layered

# Add to .zshrc
echo 'source ~/.config/layered/core/init.zsh' >> ~/.zshrc

# Reload Zsh
source ~/.zshrc
```

## Manual Install

### 1. Download Files

```bash
# Create directory
mkdir -p ~/.config/layered

# Download files (replace with actual URLs)
curl -o ~/.config/layered/core/init.zsh https://raw.githubusercontent.com/twoj-repo/layered-zsh/main/core/init.zsh
curl -o ~/.config/layered/core/aliases.zsh https://raw.githubusercontent.com/twoj-repo/layered-zsh/main/core/aliases.zsh
# ... download all other files
```

### 2. Configure .zshrc

```bash
# Add to ~/.zshrc
cat >> ~/.zshrc << 'EOF'

# Layered ZSH
if [[ -f "$HOME/.config/layered/core/init.zsh" ]]; then
  source "$HOME/.config/layered/core/init.zsh"
fi

EOF
```

### 3. Install Dependencies

#### Ollama (AI)
```bash
curl https://ollama.ai/install.sh | sh
ollama pull deepseek-coder-v2:lite
ollama pull llama3.2
```

#### lm_sensors (Temperature)
```bash
sudo pacman -S lm_sensors
sudo sensors-detect
```

## Verify Installation

```bash
# Check if Layered ZSH is loaded
lhelp

# Check status
status

# Test AI (if Ollama installed)
sc "test"
```

## Uninstall

```bash
# Remove Layered ZSH
rm -rf ~/.config/layered

# Remove from .zshrc
sed -i '/Layered ZSH/d' ~/.zshrc

# Reload Zsh
source ~/.zshrc
```

## Troubleshooting

### Installation Issues

```bash
# Check if files exist
ls -la ~/.config/layered/

# Check permissions
chmod -R 755 ~/.config/layered/

# Check syntax
zsh -n ~/.config/layered/core/init.zsh
```

### Function Not Found

```bash
# Check if functions are loaded
type status

# Reload configuration
source ~/.zshrc

# Check for errors
zsh -n ~/.zshrc
```

### AI Not Working

```bash
# Check Ollama status
ollama list

# Check Ollama service
systemctl status ollama

# Test Ollama directly
ollama run deepseek-coder-v2:lite "test"
```
