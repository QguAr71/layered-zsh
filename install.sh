#!/bin/bash

# =============================================================================
# LAYERED ZSH - MODULAR INSTALLER
# =============================================================================
# 
# Interaktywny instalator modułowy z checklistą
# Wymaga: whiptail
# =============================================================================

set -e

# Kolory
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Konfiguracja
INSTALL_DIR="$HOME/.config/layered"
BACKUP_DIR="$HOME/.local/share/layered/backups"
TEMP_DIR="/tmp/layered-installer"

# Sprawdzenie zależności
check_dependencies() {
    echo -e "${BLUE}🔍 Sprawdzanie zależności...${NC}"
    
    # Sprawdź whiptail
    if ! command -v whiptail >/dev/null 2>&1; then
        echo -e "${RED}❌ whiptail nie jest zainstalowany!${NC}"
        echo -e "${YELLOW}💡 Zainstaluj: sudo pacman -S libnewt${NC}"
        exit 1
    fi
    
    # Sprawdź Zsh
    if ! command -v zsh >/dev/null 2>&1; then
        echo -e "${RED}❌ Zsh nie jest zainstalowany!${NC}"
        echo -e "${YELLOW}💡 Zainstaluj: sudo pacman -S zsh${NC}"
        exit 1
    fi
    
    # Sprawdź Git
    if ! command -v git >/dev/null 2>&1; then
        echo -e "${RED}❌ Git nie jest zainstalowany!${NC}"
        echo -e "${YELLOW}💡 Zainstaluj: sudo pacman -S git${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Wszystkie zależności spełnione${NC}"
}

# Wyświetlanie informacji
show_info() {
    whiptail --title "Layered ZSH v3.0" --msgbox "
🚀 Layered ZSH - Modularny system konfiguracyjny Zsh

🎯 Cechy:
• Modułowa architektura (3 warstwy)
• AI integration (DeepSeek, Llama)
• System monitoring (HUD, sensors)
• Security & audit features
• 60+ poleceń i aliasów

📁 Struktura:
• core/ - podstawowe funkcje
• security/ - bezpieczeństwo
• productivity/ - produktywność

🛠️ Ten instalator pozwala wybrać moduły do zainstalowania.
" 20 60
}

# Wybór modułów
select_modules() {
    echo -e "${BLUE}📋 Wybieranie modułów...${NC}"
    
    # Wynik wyboru
    MODULES=$(whiptail --title "Wybierz moduły" --checklist "
Wybierz moduły Layered ZSH do zainstalowania:
" 20 70 10 \
    "AI" "AI integration (DeepSeek, Llama, Ollama)" ON \
    "MONITORING" "System monitoring (HUD, sensors, lm_sensors)" ON \
    "SECURITY" "Security & audit features (audit, rollback)" ON \
    "PRODUCTIVITY" "Productivity plugins (Zinit, plugins)" ON \
    "NAVIGATION" "Navigation tools (zoxide, fzf, atuin)" ON \
    "THEMES" "Visual themes and customization" ON \
    "P10K" "Powerlevel10k prompt integration" ON \
    "DEVELOPMENT" "Development tools and aliases" ON \
    "NETWORKING" "Network tools and diagnostics" OFF \
    "BACKUP" "Backup/Restore system" ON \
    "PERFORMANCE" "Performance optimization" OFF \
    3>&1 1>&2 2>&3)
    
    if [[ $? -ne 0 ]]; then
        echo -e "${YELLOW}❌ Anulowano instalację${NC}"
        exit 0
    fi
    
    # Konwersja na tablicę
    MODULES_ARRAY=()
    for module in $MODULES; do
        # Usuń cudzysłowy
        module=$(echo "$module" | sed 's/"//g')
        MODULES_ARRAY+=("$module")
    done
    
    echo -e "${GREEN}✅ Wybrane moduły: ${MODULES_ARRAY[*]}${NC}"
}

# Potwierdzenie instalacji
confirm_installation() {
    local module_list=""
    for module in "${MODULES_ARRAY[@]}"; do
        module_list="$module_list• $module\n"
    done
    
    whiptail --title "Potwierdzenie instalacji" --yesno "
🚀 Zainstalować Layered ZSH z następującymi modułami:

${module_list}
📍 Lokalizacja: $INSTALL_DIR

Czy kontynuować?
" 20 60
    
    if [[ $? -ne 0 ]]; then
        echo -e "${YELLOW}❌ Anulowano instalację${NC}"
        exit 0
    fi
}

# Tworzenie kopii zapasowej
create_backup() {
    echo -e "${BLUE}💾 Tworzenie kopii zapasowej...${NC}"
    
    if [[ -d "$INSTALL_DIR" ]]; then
        local backup_name="layered-zsh-backup-$(date +%Y%m%d-%H%M%S)"
        local backup_file="$BACKUP_DIR/$backup_name.tar.gz"
        
        mkdir -p "$BACKUP_DIR"
        tar -czf "$backup_file" -C "$(dirname "$INSTALL_DIR")" "$(basename "$INSTALL_DIR")" 2>/dev/null
        
        echo -e "${GREEN}✅ Kopia zapasowa utworzona: $backup_file${NC}"
    else
        echo -e "${YELLOW}ℹ️  Brak istniejącej instalacji - pomijam backup${NC}"
    fi
}

# Instalacja podstawowa
install_base() {
    echo -e "${BLUE}📦 Instalacja podstawowa...${NC}"
    
    # Tworzenie katalogów
    mkdir -p "$INSTALL_DIR"/{core,security,productivity}
    mkdir -p "$HOME/.local/share/layered"/{backups,cache}
    
    # Pobieranie repozytorium
    if [[ ! -d "$TEMP_DIR" ]]; then
        git clone https://github.com/QguAr71/layered-zsh.git "$TEMP_DIR"
    else
        cd "$TEMP_DIR" && git pull
    fi
    
    # Kopiowanie podstawowych plików
    cp "$TEMP_DIR/core/init.zsh" "$INSTALL_DIR/core/"
    cp "$TEMP_DIR/core/core.zsh" "$INSTALL_DIR/core/"
    cp "$TEMP_DIR/core/modes.zsh" "$INSTALL_DIR/core/"
    cp "$TEMP_DIR/core/aliases.zsh" "$INSTALL_DIR/core/"
    cp "$TEMP_DIR/core/rollback.zsh" "$INSTALL_DIR/core/"
    
    echo -e "${GREEN}✅ Podstawowe pliki zainstalowane${NC}"
}

# Instalacja modułów
install_modules() {
    echo -e "${BLUE}🔧 Instalacja modułów...${NC}"
    
    for module in "${MODULES_ARRAY[@]}"; do
        case "$module" in
            "AI")
                install_ai_module
                ;;
            "MONITORING")
                install_monitoring_module
                ;;
            "SECURITY")
                install_security_module
                ;;
            "PRODUCTIVITY")
                install_productivity_module
                ;;
            "NAVIGATION")
                install_navigation_module
                ;;
            "THEMES")
                install_themes_module
                ;;
            "DEVELOPMENT")
                install_development_module
                ;;
            "NETWORKING")
                install_networking_module
                ;;
            "BACKUP")
                install_backup_module
                ;;
            "P10K")
                install_p10k_module
                ;;
        esac
    done
}

# Moduł AI (enhanced)
install_ai_module() {
    echo -e "${BLUE}🤖 Instalacja modułu AI (enhanced)...${NC}"
    
    # Kopiowanie plików AI
    cp "$TEMP_DIR/productivity/ai_core.zsh" "$INSTALL_DIR/productivity/"
    cp "$TEMP_DIR/productivity/ai.zsh" "$INSTALL_DIR/productivity/"
    cp "$TEMP_DIR/productivity/ai-cache.zsh" "$INSTALL_DIR/productivity/"
    cp "$TEMP_DIR/productivity/ai_enhanced.zsh" "$INSTALL_DIR/productivity/"
    
    # Interaktywna konfiguracja AI
    echo -e "${YELLOW}🤖 Chcesz skonfigurować AI teraz?${NC}"
    if whiptail --title "Konfiguracja AI" --yesno "Czy chcesz skonfigurować system AI teraz?\n\nMożesz wybrać darmowe modele (DeepSeek, Llama, Grok) lub dodać klucze API dla modeli płatnych (Claude, GPT)." 12 60 3>&1 1>&2 2>&3; then
        echo -e "${BLUE}🔧 Uruchamiam konfigurację AI...${NC}"
        
        # Tymczasowo załaduj AI do konfiguracji
        source "$INSTALL_DIR/productivity/ai_enhanced.zsh"
        
        # Uruchom konfigurację
        ai_setup
    else
        echo -e "${YELLOW}ℹ️  Możesz skonfigurować AI później komendą: ai_setup${NC}"
    fi
    
    echo -e "${GREEN}✅ Moduł AI (enhanced) zainstalowany${NC}"
}

# Moduł monitoringu
install_monitoring_module() {
    echo -e "${BLUE}🌡️  Instalacja modułu monitoringu...${NC}"
    
    # Kopiowanie plików monitoringu
    cp "$TEMP_DIR/productivity/monitoring.zsh" "$INSTALL_DIR/productivity/"
    cp "$TEMP_DIR/productivity/visuals.zsh" "$INSTALL_DIR/productivity/"
    
    # Instalacja lm_sensors (opcjonalnie)
    if command -v sensors >/dev/null 2>&1; then
        echo -e "${GREEN}✅ lm_sensors już zainstalowane${NC}"
    else
        echo -e "${YELLOW}⚠️  lm_sensors nie jest zainstalowane - monitoring temperatury będzie ograniczony${NC}"
        echo -e "${YELLOW}💡 Zainstaluj: sudo pacman -S lm_sensors && sudo sensors-detect${NC}"
    fi
    
    echo -e "${GREEN}✅ Moduł monitoringu zainstalowany${NC}"
}

# Moduł bezpieczeństwa
install_security_module() {
    echo -e "${BLUE}🛡️  Instalacja modułu bezpieczeństwa...${NC}"
    
    # Kopiowanie plików security
    cp "$TEMP_DIR/security/"*.zsh "$INSTALL_DIR/security/"
    
    echo -e "${GREEN}✅ Moduł bezpieczeństwa zainstalowany${NC}"
}

# Moduł produktywności
install_productivity_module() {
    echo -e "${BLUE}⚡ Instalacja modułu produktywności...${NC}"
    
    # Kopiowanie plików produktywności
    cp "$TEMP_DIR/productivity/plugins.zsh" "$INSTALL_DIR/productivity/"
    
    echo -e "${GREEN}✅ Moduł produktywności zainstalowany${NC}"
}

# Moduł nawigacji
install_navigation_module() {
    echo -e "${BLUE}🧭 Instalacja modułu nawigacji...${NC}"
    
    # Sprawdzenie narzędzi nawigacyjnych
    local tools_installed=0
    
    if command -v zoxide >/dev/null 2>&1; then
        echo -e "${GREEN}✅ zoxide już zainstalowane${NC}"
        tools_installed=$((tools_installed + 1))
    else
        echo -e "${YELLOW}⚠️  zoxide nie jest zainstalowane${NC}"
        echo -e "${YELLOW}💡 Zainstaluj: sudo pacman -S zoxide${NC}"
    fi
    
    if command -v fzf >/dev/null 2>&1; then
        echo -e "${GREEN}✅ fzf już zainstalowane${NC}"
        tools_installed=$((tools_installed + 1))
    else
        echo -e "${YELLOW}⚠️  fzf nie jest zainstalowane${NC}"
        echo -e "${YELLOW}💡 Zainstaluj: sudo pacman -S fzf${NC}"
    fi
    
    if command -v atuin >/dev/null 2>&1; then
        echo -e "${GREEN}✅ atuin już zainstalowane${NC}"
        tools_installed=$((tools_installed + 1))
    else
        echo -e "${YELLOW}⚠️  atuin nie jest zainstalowane${NC}"
        echo -e "${YELLOW}💡 Zainstaluj: curl --proto '=https' --tlsv1.2 -sSf https://atuin.sh/install.sh | sh${NC}"
    fi
    
    echo -e "${GREEN}✅ Moduł nawigacji zainstalowany ($tools_installed/3 narzędzi)${NC}"
}

# Moduł tematów
install_themes_module() {
    echo -e "${BLUE}🎨 Instalacja modułu tematów...${NC}"
    
    # Tworzenie katalogu tematów
    mkdir -p "$INSTALL_DIR/themes"
    
    # Podstawowy motyw
    cat > "$INSTALL_DIR/themes/default.zsh" << 'EOF'
# =============================================================================
# LAYERED ZSH - DEFAULT THEME
# =============================================================================

# Kolory
export LAYERED_COLOR_PRIMARY='\033[0;34m'  # Niebieski
export LAYERED_COLOR_SUCCESS='\033[0;32m'  # Zielony
export LAYERED_COLOR_WARNING='\033[1;33m'  # Żółty
export LAYERED_COLOR_ERROR='\033[0;31m'    # Czerwony

# Prompt (prosty)
setopt PROMPT_SUBST
PROMPT='${LAYERED_COLOR_PRIMARY}Layered${NC} ${LAYERED_COLOR_SUCCESS}%~${NC} $ '
EOF
    
    echo -e "${GREEN}✅ Moduł tematów zainstalowany${NC}"
}

# Moduł deweloperski
install_development_module() {
    echo -e "${BLUE}💻 Instalacja modułu deweloperskiego...${NC}"
    
    # Dodatkowe aliasy deweloperskie
    cat >> "$INSTALL_DIR/core/aliases.zsh" << 'EOF'

# =============================================================================
# DEVELOPMENT ALIASES (moduł deweloperski)
# =============================================================================

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'

# Docker
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias di='docker images'

# Node.js
alias ns='npm start'
alias nr='npm run'
alias ni='npm install'

# Python
alias py='python'
alias pip='pip3'
alias venv='python -m venv'

# System
alias ports='netstat -tulpn'
alias processes='ps aux'
alias mem='free -h'
EOF
    
    echo -e "${GREEN}✅ Moduł deweloperski zainstalowany${NC}"
}

# Moduł sieciowy
install_networking_module() {
    echo -e "${BLUE}🌐 Instalacja modułu sieciowego...${NC}"
    
    # Dodatkowe aliasy sieciowe
    cat >> "$INSTALL_DIR/core/aliases.zsh" << 'EOF'

# =============================================================================
# NETWORKING ALIASES (moduł sieciowy)
# =============================================================================

# Network info
alias ipinfo='ip addr show'
alias netstat='ss -tuln'
alias ping='ping -c 4'
alias ports='netstat -tulpn'

# DNS
alias dns='dig +short'
alias nslookup='nslookup'
alias host='host'

# Network troubleshooting
alias trace='traceroute'
alias mtr='mtr'
alias speed='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python'
EOF
    
    echo -e "${GREEN}✅ Moduł sieciowy zainstalowany${NC}"
}

# Moduł backup
install_backup_module() {
    echo -e "${BLUE}💾 Instalacja modułu backup...${NC}"
    
    # Kopiowanie plików backup
    cp "$TEMP_DIR/core/backup.zsh" "$INSTALL_DIR/core/"
    
    echo -e "${GREEN}✅ Moduł backup zainstalowany${NC}"
}

# Moduł Powerlevel10k
install_p10k_module() {
    echo -e "${BLUE}🎨 Instalacja modułu Powerlevel10k...${NC}"
    
    # Kopiowanie plików P10K
    cp "$TEMP_DIR/productivity/p10k.zsh" "$INSTALL_DIR/productivity/"
    
    # Ustaw zmienną środowiskową
    echo "export LAYERED_USE_P10K=true" >> "$HOME/.config/layered/.local.zsh" 2>/dev/null || echo "export LAYERED_USE_P10K=true" >> "$HOME/.zshrc"
    
    echo -e "${GREEN}✅ Moduł Powerlevel10k zainstalowany${NC}"
    echo -e "${YELLOW}💡 Uruchom 'source ~/.zshrc' aby załadować Powerlevel10k${NC}"
    echo -e "${YELLOW}💡 Konfiguracja: p10k-configure${NC}"
    echo -e "${YELLOW}💡 Motywy: p10k-themes${NC}"
}

# Moduł wydajności
install_performance_module() {
    echo -e "${BLUE}⚡ Instalacja modułu wydajności...${NC}"
    
    # Optymalizacje wydajności
    cat > "$INSTALL_DIR/core/performance.zsh" << 'EOF'
# =============================================================================
# LAYERED ZSH - PERFORMANCE OPTIMIZATIONS
# =============================================================================

# Lazy loading dla ciężkich funkcji
lazy_load() {
    local cmd="$1"
    local init_cmd="$2"
    
    eval "$cmd() { \
        unset -f $cmd; \
        $init_cmd; \
        $cmd \$@; \
    }"
}

# Lazy loading dla AI
if command -v ollama >/dev/null 2>&1; then
    lazy_load sc "source ~/.config/layered/productivity/ai_core.zsh"
fi

# Optymalizacja historii
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY

# Szybkie_completion
autoload -Uz compinit
compinit -d ~/.cache/zcompdump-$HOST

# Cache dla completions
if [[ ! -d ~/.cache/zsh ]]; then
    mkdir -p ~/.cache/zsh
fi
EOF
    
    echo -e "${GREEN}✅ Moduł wydajności zainstalowany${NC}"
}

# Konfiguracja .zshrc
configure_zshrc() {
    echo -e "${BLUE}🔧 Konfiguracja .zshrc...${NC}"
    
    # Backup istniejącego .zshrc
    if [[ -f "$HOME/.zshrc" ]]; then
        cp "$HOME/.zshrc" "$HOME/.zshrc.backup-$(date +%Y%m%d-%H%M%S)"
        echo -e "${YELLOW}ℹ️  Backup .zshrc utworzony${NC}"
    fi
    
    # Dodanie Layered ZSH do .zshrc
    if ! grep -q "source ~/.config/layered/core/init.zsh" "$HOME/.zshrc" 2>/dev/null; then
        echo "# Layered ZSH" >> "$HOME/.zshrc"
        echo "source ~/.config/layered/core/init.zsh" >> "$HOME/.zshrc"
        echo -e "${GREEN}✅ Layered ZSH dodane do .zshrc${NC}"
    else
        echo -e "${YELLOW}ℹ️  Layered ZSH już jest w .zshrc${NC}"
    fi
}

# Finalizacja
finalize_installation() {
    echo -e "${BLUE}🎉 Finalizacja instalacji...${NC}"
    
    # Sprzątanie
    rm -rf "$TEMP_DIR"
    
    # Informacja końcowa
    whiptail --title "Instalacja zakończona" --msgbox "
🎉 Layered ZSH v3.0 zostało pomyślnie zainstalowane!

📦 Zainstalowane moduły:
${MODULES_ARRAY[*]}

📍 Lokalizacja: $INSTALL_DIR

🔄 Przeładuj shell:
source ~/.zshrc

📚 Pomoc:
lhelp - pełna lista komend

🌐 Dokumentacja:
https://github.com/QguAr71/layered-zsh

Miłego korzystania! 🚀
" 20 60
}

# Główna funkcja
main() {
    echo -e "${BLUE}🚀 Layered ZSH Modular Installer${NC}"
    echo -e "${BLUE}================================${NC}"
    
    # Sprawdzenie uprawnień
    if [[ $EUID -eq 0 ]]; then
        echo -e "${RED}❌ Nie uruchamiaj jako root!${NC}"
        exit 1
    fi
    
    # Sprawdzenie czy już zainstalowane
    if [[ -f "$INSTALL_DIR/core/init.zsh" ]]; then
        if ! whiptail --title "Instalacja wykryta" --yesno "
⚠️  Wykryto istniejącą instalację Layered ZSH w:
$INSTALL_DIR

Czy chcesz kontynuować instalację (nadpisze istniejące pliki)?
" 12 60; then
            echo -e "${YELLOW}❌ Anulowano instalację${NC}"
            exit 0
        fi
    fi
    
    # Proces instalacji
    check_dependencies
    show_info
    select_modules
    confirm_installation
    create_backup
    install_base
    install_modules
    configure_zshrc
    finalize_installation
    
    echo -e "${GREEN}🎉 Instalacja zakończona pomyślnie!${NC}"
    echo -e "${BLUE}💡 Uruchom 'source ~/.zshrc' aby załadować Layered ZSH${NC}"
}

# Uruchomienie
main "$@"
