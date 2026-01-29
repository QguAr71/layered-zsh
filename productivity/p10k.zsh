# =============================================================================
# LAYERED ZSH - POWERLEVEL10K INTEGRATION
# =============================================================================
# 
# Integracja Powerlevel10k z Layered ZSH
# Wsparcie dla warstw, motywów, statusów AI, monitoringu
# 
# Wersja: v3.1
# Autor: Layered ZSH Team
# =============================================================================

# Konfiguracja Powerlevel10k
export LAYERED_P10K_DIR="$HOME/.config/layered/themes"
export LAYERED_P10K_CONFIG="$LAYERED_P10K_DIR/p10k.zsh"
export LAYERED_P10K_CUSTOM="$LAYERED_P10K_DIR/custom.zsh"

# Upewnij się, że katalogi istnieją
mkdir -p "$LAYERED_P10K_DIR"

# =============================================================================
# INSTALACJA POWERLEVEL10K
# =============================================================================

p10k_install() {
    echo -e "${BLUE}🚀 Instalacja Powerlevel10k dla Layered ZSH${NC}"
    echo "==========================================="
    
    # Sprawdź czy Zinit jest dostępne
    if ! command -v zinit >/dev/null 2>&1; then
        echo -e "${RED}❌ Zinit nie jest dostępne${NC}"
        echo -e "${YELLOW}💡 Zainstaluj najpierw moduł Productivity${NC}"
        return 1
    fi
    
    echo -e "${BLUE}📦 Instalacja Powerlevel10k przez Zinit...${NC}"
    
    # Instalacja Powerlevel10k
    zinit load romkatv/powerlevel10k
    
    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}✅ Powerlevel10k zainstalowane${NC}"
    else
        echo -e "${RED}❌ Błąd instalacji Powerlevel10k${NC}"
        return 1
    fi
    
    # Konfiguracja domyślna
    p10k_configure_default
    
    echo -e "${GREEN}🎉 Powerlevel10k gotowe do użycia!${NC}"
    echo -e "${YELLOW}💡 Uruchom 'p10k configure' dla personalizacji${NC}"
}

# =============================================================================
# KONFIGURACJA POWERLEVEL10K
# =============================================================================

p10k_configure_default() {
    echo -e "${BLUE}🔧 Konfiguracja domyślna Powerlevel10k${NC}"
    
    # Stwórz domyślną konfigurację
    cat > "$LAYERED_P10K_CONFIG" << 'EOF'
# =============================================================================
# LAYERED ZSH - POWERLEVEL10K CONFIGURATION
# =============================================================================
# 
# Dostosowana konfiguracja Powerlevel10k dla Layered ZSH
# Wsparcie dla warstw, AI, monitoringu, security
# =============================================================================

# Temporarily switch to 256-color mode for better compatibility
if [[ $TERM != *-256color ]]; then
    export TERM=xterm-256color
fi

# Instant prompt mode
POWERLEVEL9K_INSTANT_PROMPT=quiet

# Powerlevel10k configuration
# Style: Lean, with Layered ZSH integration

# Left prompt segments
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  os_icon                 # OS icon
  dir                     # Current directory
  vcs                     # Git status
  command_execution_time  # Command execution time
  layered_mode            # Layered ZSH mode (custom)
  layered_ai              # AI status (custom)
)

# Right prompt segments
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  status                  # Exit code
  layered_monitoring      # Monitoring status (custom)
  layered_security        # Security status (custom)
  time                    # Current time
)

# OS icon configuration
typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=blue
typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=white

# Directory configuration
typeset -g POWERLEVEL9K_DIR_FOREGROUND=cyan
typeset -g POWERLEVEL9K_DIR_BACKGROUND=black
typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
typeset -g POWERLEVEL9K_SHORTEN_FOLDER_MARKER=

# Git configuration
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=green
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=yellow
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=red
typeset -g POWERLEVEL9K_VCS_BACKGROUND=black

# Command execution time
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=yellow
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=black
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=1

# Status configuration
typeset -g POWERLEVEL9K_STATUS_OK=false
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=red
typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=black

# Time configuration
typeset -g POWERLEVEL9K_TIME_FOREGROUND=white
typeset -g POWERLEVEL9K_TIME_BACKGROUND=black
typeset -g POWERLEVEL9K_TIME_FORMAT=%D{%H:%M}

# Custom Layered ZSH segments
typeset -g POWERLEVEL9K_CUSTOM_LAYERED_MODE=layered_mode_segment
typeset -g POWERLEVEL9K_CUSTOM_LAYERED_MODE_FOREGROUND=magenta
typeset -g POWERLEVEL9K_CUSTOM_LAYERED_MODE_BACKGROUND=black

typeset -g POWERLEVEL9K_CUSTOM_LAYERED_AI=layered_ai_segment
typeset -g POWERLEVEL9K_CUSTOM_LAYERED_AI_FOREGROUND=blue
typeset -g POWERLEVEL9K_CUSTOM_LAYERED_AI_BACKGROUND=black

typeset -g POWERLEVEL9K_CUSTOM_LAYERED_MONITORING=layered_monitoring_segment
typeset -g POWERLEVEL9K_CUSTOM_LAYERED_MONITORING_FOREGROUND=green
typeset -g POWERLEVEL9K_CUSTOM_LAYERED_MONITORING_BACKGROUND=black

typeset -g POWERLEVEL9K_CUSTOM_LAYERED_SECURITY=layered_security_segment
typeset -g POWERLEVEL9K_CUSTOM_LAYERED_SECURITY_FOREGROUND=red
typeset -g POWERLEVEL9K_CUSTOM_LAYERED_SECURITY_BACKGROUND=black

# Performance optimizations
typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=true
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_PERCENT=0
typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX='%F{blue}┃%f'

# Transient prompt
typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=same-char
typeset -g POWERLEVEL9K_TRANSIENT_PROMPT_SYMBOL=❯
typeset -g POWERLEVEL9K_TRANSIENT_PROMPT_FOREGROUND=white
typeset -g POWERLEVEL9K_TRANSIENT_PROMPT_BACKGROUND=black
EOF

    echo -e "${GREEN}✅ Konfiguracja domyślna zapisana${NC}"
}

# =============================================================================
# CUSTOM SEGMENTS FOR LAYERED ZSH
# =============================================================================

layered_mode_segment() {
    [[ -n "$LAYERED_MODE" ]] || return
    
    case "$LAYERED_MODE" in
        "full")
            echo "%F{green}🚀%F{white}FULL%f"
            ;;
        "immutable")
            echo "%F{red}🔒%F{white}IMM%f"
            ;;
        "safe")
            echo "%F{yellow}🛡️%F{white}SAFE%f"
            ;;
        *)
            echo "%F{blue}🎯%F{white}${LAYERED_MODE:u}%f"
            ;;
    esac
}

layered_ai_segment() {
    # Sprawdź status AI
    if [[ "$LAYERED_AI_ENABLED" == "true" ]]; then
        if command -v ollama >/dev/null 2>&1; then
            echo "%F{blue}🤖%F{white}AI%f"
        else
            echo "%F{yellow}🤖%F{white}MOCK%f"
        fi
    fi
}

layered_monitoring_segment() {
    # Sprawdź status monitoringu
    if command -v monitor-status >/dev/null 2>&1; then
        local status=$(monitor-status 2>/dev/null)
        if echo "$status" | grep -q "AKTYWNY"; then
            echo "%F{green}📊%F{white}ON%f"
        else
            echo "%F{red}📊%F{white}OFF%f"
        fi
    fi
}

layered_security_segment() {
    # Sprawdź status security
    if [[ -f "$HOME/.layered_safe" ]]; then
        echo "%F{green}🔐%F{white}OK%f"
    elif [[ -f "$HOME/.layered_panic" ]]; then
        echo "%F{red}🚨%F{white}PANIC%f"
    else
        echo "%F{yellow}🔐%F{white}WARN%f"
    fi
}

# =============================================================================
# FUNKCJE ZARZĄDZANIA
# =============================================================================

p10k_configure() {
    echo -e "${BLUE}🔧 Konfiguracja Powerlevel10k${NC}"
    echo "=============================="
    
    echo -e "${YELLOW}Uruchamiam wizard Powerlevel10k...${NC}"
    echo -e "${YELLOW}💡 Wybierz 'Lean' dla najlepszej wydajności${NC}"
    echo ""
    
    # Uruchom wizard
    if command -v p10k >/dev/null 2>&1; then
        p10k configure
    else
        echo -e "${RED}❌ Powerlevel10k nie jest dostępne${NC}"
        echo -e "${YELLOW}💡 Uruchom 'p10k install' najpierw${NC}"
    fi
}

p10k_status() {
    echo -e "${BLUE}📊 Status Powerlevel10k${NC}"
    echo "=========================="
    
    # Sprawdź czy Powerlevel10k jest załadowane
    if command -v p10k >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Powerlevel10k: zainstalowane${NC}"
    else
        echo -e "${RED}❌ Powerlevel10k: nie zainstalowane${NC}"
        return 1
    fi
    
    # Sprawdź konfigurację
    if [[ -f "$LAYERED_P10K_CONFIG" ]]; then
        echo -e "${GREEN}✅ Konfiguracja Layered ZSH: istnieje${NC}"
        echo -e "${BLUE}📁 Plik: $LAYERED_P10K_CONFIG${NC}"
    else
        echo -e "${YELLOW}⚠️  Konfiguracja Layered ZSH: brak${NC}"
    fi
    
    # Sprawdź czy jest załadowane w shell
    if [[ -n "$POWERLEVEL9K_LEFT_PROMPT_ELEMENTS" ]]; then
        echo -e "${GREEN}✅ Powerlevel10k: aktywne${NC}"
    else
        echo -e "${YELLOW}⚠️  Powerlevel10k: nieaktywne${NC}"
        echo -e "${YELLOW}💡 Uruchom 'source ~/.zshrc'${NC}"
    fi
    
    echo ""
    echo -e "${BLUE}🎨 Segmenty Layered ZSH:${NC}"
    echo "  • Tryb pracy: $(layered_mode_segment)"
    echo "  • Status AI: $(layered_ai_segment)"
    echo "  • Monitoring: $(layered_monitoring_segment)"
    echo "  • Security: $(layered_security_segment)"
}

p10k_reset() {
    echo -e "${YELLOW}🔄 Resetowanie konfiguracji Powerlevel10k${NC}"
    
    # Backup obecnej konfiguracji
    if [[ -f "$LAYERED_P10K_CONFIG" ]]; then
        local backup_file="$LAYERED_P10K_CONFIG.backup-$(date +%Y%m%d-%H%M%S)"
        cp "$LAYERED_P10K_CONFIG" "$backup_file"
        echo -e "${BLUE}💾 Backup zapisany: $backup_file${NC}"
    fi
    
    # Resetuj konfigurację
    p10k_configure_default
    
    echo -e "${GREEN}✅ Konfiguracja zresetowana${NC}"
    echo -e "${YELLOW}💡 Uruchom 'source ~/.zshrc' aby zastosować${NC}"
}

p10k_uninstall() {
    echo -e "${RED}🗑️  Odinstalowywanie Powerlevel10k${NC}"
    
    # Usuń z Zinit
    if command -v zinit >/dev/null 2>&1; then
        zinit unload romkatv/powerlevel10k
        zinit delete romkatv/powerlevel10k
        echo -e "${GREEN}✅ Powerlevel10k usunięte z Zinit${NC}"
    fi
    
    # Usuń konfigurację
    if [[ -f "$LAYERED_P10K_CONFIG" ]]; then
        rm "$LAYERED_P10K_CONFIG"
        echo -e "${GREEN}✅ Konfiguracja usunięta${NC}"
    fi
    
    # Usuń katalog
    if [[ -d "$LAYERED_P10K_DIR" ]]; then
        rm -rf "$LAYERED_P10K_DIR"
        echo -e "${GREEN}✅ Katalog usunięty${NC}"
    fi
    
    echo -e "${YELLOW}💡 Uruchom 'source ~/.zshrc' aby zastosować${NC}"
}

# =============================================================================
# MOTYWY POWERLEVEL10K
# =============================================================================

p10k_theme_set() {
    local theme="$1"
    
    case "$theme" in
        "layered"|"default")
            p10k_configure_default
            ;;
        "minimal")
            p10k_theme_minimal
            ;;
        "hacker")
            p10k_theme_hacker
            ;;
        "enterprise")
            p10k_theme_enterprise
            ;;
        "colorful")
            p10k_theme_colorful
            ;;
        *)
            echo -e "${RED}❌ Nieznany motyw: $theme${NC}"
            echo -e "${YELLOW}💡 Dostępne: layered, minimal, hacker, enterprise, colorful${NC}"
            return 1
            ;;
    esac
    
    echo -e "${GREEN}✅ Motyw ustawiony: $theme${NC}"
    echo -e "${YELLOW}💡 Uruchom 'source ~/.zshrc' aby zastosować${NC}"
}

p10k_theme_minimal() {
    cat > "$LAYERED_P10K_CONFIG" << 'EOF'
# Minimal Powerlevel10k configuration for Layered ZSH
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status)
typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_PERCENT=0
EOF
}

p10k_theme_hacker() {
    cat > "$LAYERED_P10K_CONFIG" << 'EOF'
# Hacker theme for Layered ZSH
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  os_icon
  dir
  vcs
  layered_mode
  command_execution_time
)
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  status
  layered_ai
  time
)
typeset -g POWERLEVEL9K_BACKGROUND=black
typeset -g POWERLEVEL9K_FOREGROUND=green
typeset -g POWERLEVEL9K_DIR_FOREGROUND=green
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=green
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=yellow
EOF
}

p10k_theme_enterprise() {
    cat > "$LAYERED_P10K_CONFIG" << 'EOF'
# Enterprise theme for Layered ZSH
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  os_icon
  dir
  vcs
  layered_mode
  layered_security
)
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  status
  layered_monitoring
  time
)
typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=true
typeset -g POWERLEVEL9K_BACKGROUND=black
typeset -g POWERLEVEL9K_FOREGROUND=blue
typeset -g POWERLEVEL9K_DIR_FOREGROUND=blue
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=blue
EOF
}

p10k_theme_colorful() {
    cat > "$LAYERED_P10K_CONFIG" << 'EOF'
# Colorful theme for Layered ZSH
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  os_icon
  dir
  vcs
  layered_mode
  layered_ai
  command_execution_time
)
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  status
  layered_monitoring
  layered_security
  time
)
typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=cyan
typeset -g POWERLEVEL9K_DIR_FOREGROUND=magenta
typeset -g POWERLEVEL9K_DIR_BACKGROUND=black
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=green
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=yellow
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=red
EOF
}

p10k_theme_list() {
    echo -e "${BLUE}🎨 Dostępne motywy Powerlevel10k:${NC}"
    echo "=================================="
    echo ""
    echo -e "${GREEN}🚀 layered/default${NC} - domyślny motyw Layered ZSH"
    echo -e "${YELLOW}🎯 minimal${NC} - minimalistyczny, szybki"
    echo -e "${GREEN}💻 hacker${NC} - styl hackerski, zielony"
    echo -e "${BLUE}🏢 enterprise${NC} - korporacyjny, profesjonalny"
    echo -e "${MAGENTA}🌈 colorful${NC} - kolorowy, wesoły"
    echo ""
    echo -e "${YELLOW}💡 Użycie: p10k_theme_set <motyw>${NC}"
}

# =============================================================================
# ALIASY
# =============================================================================

alias p10k-install='p10k_install'
alias p10k-configure='p10k_configure'
alias p10k-status='p10k_status'
alias p10k-reset='p10k_reset'
alias p10k-uninstall='p10k_uninstall'
alias p10k-theme='p10k_theme_set'
alias p10k-themes='p10k_theme_list'

# =============================================================================
# INICJALIZACJA
# =============================================================================

# Załaduj konfigurację jeśli istnieje
[[ -f "$LAYERED_P10K_CONFIG" ]] && source "$LAYERED_P10K_CONFIG"

echo "🎨 Powerlevel10k integration załadowana"
echo "💡 Komendy: p10k-install, p10k-configure, p10k-status, p10k-theme"
