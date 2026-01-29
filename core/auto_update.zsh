# =============================================================================
# LAYERED ZSH - COMPREHENSIVE AUTO-UPDATE SYSTEM
# =============================================================================
# 
# Uniwersalny system blokowania aktualizacji dla:
# - Konfiguracji Layered ZSH
# - Pluginów Zinit
# - Modeli AI (Ollama)
# - Aktualizacji systemowych
# 
# Wersja: v3.1
# Autor: Layered ZSH Team
# =============================================================================

# Konfiguracja
export LAYERED_UPDATE_DIR="$HOME/.local/share/layered/updates"
export LAYERED_UPDATE_LOG="$LAYERED_UPDATE_DIR/update.log"
export LAYERED_UPDATE_CONFIG="$LAYERED_UPDATE_DIR/config"
export LAYERED_LKG_DIR="$LAYERED_UPDATE_DIR/lkg"

# Upewnij się, że katalogi istnieją
mkdir -p "$LAYERED_UPDATE_DIR" "$LAYERED_LKG_DIR"

# Domyślne ustawienia
LAYERED_UPDATE_ENABLED=${LAYERED_UPDATE_ENABLED:-false}
LAYERED_UPDATE_SCHEDULE=${LAYERED_UPDATE_SCHEDULE:-"weekly"}
LAYERED_UPDATE_BLOCK_CONFIG=${LAYERED_UPDATE_BLOCK_CONFIG:-true}
LAYERED_UPDATE_BLOCK_PLUGINS=${LAYERED_UPDATE_BLOCK_PLUGINS:-true}
LAYERED_UPDATE_BLOCK_AI=${LAYERED_UPDATE_BLOCK_AI:-true}
LAYERED_UPDATE_BLOCK_SYSTEM=${LAYERED_UPDATE_BLOCK_SYSTEM:-false}

# =============================================================================
# FUNKCJE GŁÓWNE - ZARZĄDZANIE
# =============================================================================

lupdate_enable() {
    [[ $LAYERED_MODE == "immutable" ]] && echo "🔒 Auto-update zablokowane w trybie immutable" && return
    
    local schedule="$1"
    [[ -n "$schedule" ]] && LAYERED_UPDATE_SCHEDULE="$schedule"
    
    echo "🚀 Włączanie auto-update..."
    LAYERED_UPDATE_ENABLED=true
    
    # Zapisz konfigurację
    save_update_config
    
    # Ustaw systemd timer
    setup_systemd_timer
    
    # Zapisz LKG
    save_lkg
    
    echo "✅ Auto-update włączone"
    echo "📅 Harmonogram: $LAYERED_UPDATE_SCHEDULE"
    echo "🔧 Blokowanie:"
    echo "   • Konfiguracja: $LAYERED_UPDATE_BLOCK_CONFIG"
    echo "   • Pluginy: $LAYERED_UPDATE_BLOCK_PLUGINS"
    echo "   • AI: $LAYERED_UPDATE_BLOCK_AI"
    echo "   • System: $LAYERED_UPDATE_BLOCK_SYSTEM"
}

lupdate_disable() {
    [[ $LAYERED_MODE == "immutable" ]] && echo "🔒 Auto-update zablokowane w trybie immutable" && return
    
    echo "🛑 Wyłączanie auto-update..."
    LAYERED_UPDATE_ENABLED=false
    
    # Zapisz konfigurację
    save_update_config
    
    # Zatrzymaj systemd timer
    stop_systemd_timer
    
    echo "✅ Auto-update wyłączone"
}

lupdate_status() {
    echo "📊 Status auto-update:"
    echo "===================="
    echo "🔧 Włączone: $LAYERED_UPDATE_ENABLED"
    echo "📅 Harmonogram: $LAYERED_UPDATE_SCHEDULE"
    echo ""
    echo "🔒 Blokowanie:"
    echo "   • Konfiguracja Layered ZSH: $LAYERED_UPDATE_BLOCK_CONFIG"
    echo "   • Pluginy Zinit: $LAYERED_UPDATE_BLOCK_PLUGINS"
    echo "   • Modele AI (Ollama): $LAYERED_UPDATE_BLOCK_AI"
    echo "   • Aktualizacje systemowe: $LAYERED_UPDATE_BLOCK_SYSTEM"
    echo ""
    
    # Status systemd timer
    if systemctl is-active --quiet layered-update.timer 2>/dev/null; then
        echo "⏰ Systemd timer: aktywny"
        echo "📅 Następne uruchomienie: $(systemctl list-timers layered-update.timer --no-pager | tail -1 | awk '{print $1, $2, $3}')"
    else
        echo "⏰ Systemd timer: nieaktywny"
    fi
    
    echo ""
    echo "📁 Katalog LKG: $LAYERED_LKG_DIR"
    echo "📜 Log: $LAYERED_UPDATE_LOG"
}

lupdate_now() {
    [[ $LAYERED_MODE == "immutable" ]] && echo "🔒 Auto-update zablokowane w trybie immutable" && return
    
    echo "🔄 Natychmiastowa aktualizacja..."
    
    # Sprawdź połączenie
    if ! ping -c 1 github.com >/dev/null 2>&1; then
        echo "❌ Brak połączenia z GitHub"
        return 1
    fi
    
    # Zapisz LKG przed aktualizacją
    save_lkg
    
    # Wykonaj aktualizację
    if perform_update; then
        echo "✅ Aktualizacja zakończona pomyślnie"
        log_update "SUCCESS" "Manual update completed"
    else
        echo "❌ Aktualizacja nie powiodła się"
        echo "🔄 Przywracanie z LKG..."
        restore_from_lkg
        log_update "FAILED" "Manual update failed, restored from LKG"
        return 1
    fi
}

lupdate_rollback() {
    echo "🔄 Przywracanie z LKG..."
    
    if [[ ! -d "$LAYERED_LKG_DIR" ]] || [[ -z "$(ls -A "$LAYERED_LKG_DIR" 2>/dev/null)" ]]; then
        echo "❌ Brak dostępnej LKG"
        return 1
    fi
    
    if restore_from_lkg; then
        echo "✅ Przywracanie z LKG zakończone"
        log_update "ROLLBACK" "Manual rollback to LKG"
    else
        echo "❌ Przywracanie z LKG nie powiodło się"
        return 1
    fi
}

# =============================================================================
# FUNKCJE KONFIGURACJI
# =============================================================================

lupdate_config() {
    echo "⚙️ Konfiguracja auto-update:"
    echo "=========================="
    
    # Blokowanie konfiguracji
    local config_block=$(whiptail --title "Blokuje konfigurację" --yesno "Czy blokować aktualizacje konfiguracji Layered ZSH?" 8 40 3>&1 1>&2 2>&3)
    LAYERED_UPDATE_BLOCK_CONFIG=$([[ $? -eq 0 ]] && echo "true" || echo "false")
    
    # Blokowanie pluginów
    local plugins_block=$(whiptail --title "Blokuje pluginy" --yesno "Czy blokować aktualizacje pluginów Zinit?" 8 40 3>&1 1>&2 2>&3)
    LAYERED_UPDATE_BLOCK_PLUGINS=$([[ $? -eq 0 ]] && echo "true" || echo "false")
    
    # Blokowanie AI
    local ai_block=$(whiptail --title "Blokuje AI" --yesno "Czy blokować aktualizacje modeli AI?" 8 40 3>&1 1>&2 2>&3)
    LAYERED_UPDATE_BLOCK_AI=$([[ $? -eq 0 ]] && echo "true" || echo "false")
    
    # Blokowanie systemu
    local system_block=$(whiptail --title "Blokuje system" --yesno "Czy blokować aktualizacje systemowe?" 8 40 3>&1 1>&2 2>&3)
    LAYERED_UPDATE_BLOCK_SYSTEM=$([[ $? -eq 0 ]] && echo "true" || echo "false")
    
    # Harmonogram
    local schedule=$(whiptail --title "Harmonogram" --menu "Wybierz harmonogram aktualizacji:" 12 40 4 \
        "daily" "Codziennie" \
        "weekly" "Co tydzień" \
        "monthly" "Co miesiąc" \
        "never" "Nigdy" 3>&1 1>&2 2>&3)
    
    [[ -n "$schedule" && "$schedule" != "never" ]] && LAYERED_UPDATE_SCHEDULE="$schedule"
    
    # Zapisz konfigurację
    save_update_config
    
    echo "✅ Konfiguracja zapisana"
    lupdate_status
}

lupdate_schedule() {
    local schedule="$1"
    if [[ -n "$schedule" ]]; then
        LAYERED_UPDATE_SCHEDULE="$schedule"
        save_update_config
        setup_systemd_timer
        echo "✅ Harmonogram ustawiony: $schedule"
    else
        echo "📅 Obecny harmonogram: $LAYERED_UPDATE_SCHEDULE"
    fi
}

# =============================================================================
# FUNKCJE POMOCNICZE
# =============================================================================

save_update_config() {
    cat > "$LAYERED_UPDATE_CONFIG" << EOF
# Layered ZSH Auto-Update Configuration
LAYERED_UPDATE_ENABLED=$LAYERED_UPDATE_ENABLED
LAYERED_UPDATE_SCHEDULE=$LAYERED_UPDATE_SCHEDULE
LAYERED_UPDATE_BLOCK_CONFIG=$LAYERED_UPDATE_BLOCK_CONFIG
LAYERED_UPDATE_BLOCK_PLUGINS=$LAYERED_UPDATE_BLOCK_PLUGINS
LAYERED_UPDATE_BLOCK_AI=$LAYERED_UPDATE_BLOCK_AI
LAYERED_UPDATE_BLOCK_SYSTEM=$LAYERED_UPDATE_BLOCK_SYSTEM
EOF
}

load_update_config() {
    if [[ -f "$LAYERED_UPDATE_CONFIG" ]]; then
        source "$LAYERED_UPDATE_CONFIG"
    fi
}

log_update() {
    local status="$1"
    local message="$2"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$status] $message" >> "$LAYERED_UPDATE_LOG"
}

# =============================================================================
# FUNKCJE LKG (LAST KNOWN GOOD)
# =============================================================================

save_lkg() {
    echo "💾 Zapisywanie LKG..."
    
    local lkg_name="lkg-$(date +%Y%m%d-%H%M%S)"
    local lkg_dir="$LAYERED_LKG_DIR/$lkg_name"
    
    mkdir -p "$lkg_dir"
    
    # Backup konfiguracji Layered ZSH
    if [[ $LAYERED_UPDATE_BLOCK_CONFIG == true ]]; then
        cp -r "$HOME/.config/layered" "$lkg_dir/" 2>/dev/null
    fi
    
    # Backup pluginów Zinit
    if [[ $LAYERED_UPDATE_BLOCK_PLUGINS == true ]]; then
        cp -r "$HOME/.local/share/zinit" "$lkg_dir/" 2>/dev/null
        cp "$HOME/.zshrc" "$lkg_dir/" 2>/dev/null
    fi
    
    # Backup modeli AI
    if [[ $LAYERED_UPDATE_BLOCK_AI == true ]] && command -v ollama >/dev/null 2>&1; then
        ollama list > "$lkg_dir/ollama_models.txt" 2>/dev/null
    fi
    
    # Backup systemowy
    if [[ $LAYERED_UPDATE_BLOCK_SYSTEM == true ]]; then
        pacman -Qqe > "$lkg_dir/system_packages.txt" 2>/dev/null
    fi
    
    # Metadane
    cat > "$lkg_dir/metadata.txt" << EOF
LKG Name: $lkg_name
Date: $(date)
Host: $(hostname)
User: $(whoami)
Layered Mode: $LAYERED_MODE
Blocked:
- Config: $LAYERED_UPDATE_BLOCK_CONFIG
- Plugins: $LAYERED_UPDATE_BLOCK_PLUGINS
- AI: $LAYERED_UPDATE_BLOCK_AI
- System: $LAYERED_UPDATE_BLOCK_SYSTEM
EOF
    
    # Czyść stare LKG (zostaw 5)
    ls -t "$LAYERED_LKG_DIR" | tail -n +6 | xargs -I {} rm -rf "$LAYERED_LKG_DIR/{}" 2>/dev/null
    
    echo "✅ LKG zapisane: $lkg_name"
}

restore_from_lkg() {
    local lkg_name=$(ls -t "$LAYERED_LKG_DIR" | head -1)
    local lkg_dir="$LAYERED_LKG_DIR/$lkg_name"
    
    if [[ ! -d "$lkg_dir" ]]; then
        echo "❌ LKG nie istnieje"
        return 1
    fi
    
    echo "🔄 Przywracanie z LKG: $lkg_name"
    
    # Przywracanie konfiguracji
    if [[ -d "$lkg_dir/layered" ]]; then
        rm -rf "$HOME/.config/layered" 2>/dev/null
        cp -r "$lkg_dir/layered" "$HOME/.config/"
    fi
    
    # Przywracanie pluginów
    if [[ -d "$lkg_dir/zinit" ]]; then
        rm -rf "$HOME/.local/share/zinit" 2>/dev/null
        cp -r "$lkg_dir/zinit" "$HOME/.local/share/"
    fi
    
    if [[ -f "$lkg_dir/.zshrc" ]]; then
        cp "$lkg_dir/.zshrc" "$HOME/"
    fi
    
    # Przywracanie AI
    if [[ -f "$lkg_dir/ollama_models.txt" ]] && command -v ollama >/dev/null 2>&1; then
        echo "🤖 Przywracanie modeli AI..."
        # Tutaj logika przywracania modeli
    fi
    
    echo "✅ Przywracanie z LKG zakończone"
    return 0
}

# =============================================================================
# GŁÓWNA FUNKCJA AKTUALIZACJI
# =============================================================================

perform_update() {
    echo "🔄 Wykonywanie aktualizacji..."
    
    local update_failed=false
    
    # Aktualizacja konfiguracji Layered ZSH
    if [[ $LAYERED_UPDATE_BLOCK_CONFIG == true ]]; then
        echo "📦 Aktualizacja konfiguracji Layered ZSH..."
        if ! update_layered_config; then
            update_failed=true
        fi
    fi
    
    # Aktualizacja pluginów
    if [[ $LAYERED_UPDATE_BLOCK_PLUGINS == true && $update_failed == false ]]; then
        echo "🔌 Aktualizacja pluginów Zinit..."
        if ! update_zinit_plugins; then
            update_failed=true
        fi
    fi
    
    # Aktualizacja AI
    if [[ $LAYERED_UPDATE_BLOCK_AI == true && $update_failed == false ]]; then
        echo "🤖 Aktualizacja modeli AI..."
        if ! update_ai_models; then
            update_failed=true
        fi
    fi
    
    # Aktualizacja systemowa
    if [[ $LAYERED_UPDATE_BLOCK_SYSTEM == true && $update_failed == false ]]; then
        echo "🌐 Aktualizacja systemowa..."
        if ! update_system_packages; then
            update_failed=true
        fi
    fi
    
    return $([[ $update_failed == true ]] && echo 1 || echo 0)
}

# =============================================================================
# FUNKCJE SPECYFICZNE DLA TYPÓW AKTUALIZACJI
# =============================================================================

update_layered_config() {
    echo "📦 Sprawdzanie aktualizacji Layered ZSH..."
    
    # Sprawdź czy są nowe wersje
    cd "$HOME/.config/layered" 2>/dev/null || return 1
    
    git fetch origin >/dev/null 2>&1
    local current_commit=$(git rev-parse HEAD)
    local latest_commit=$(git rev-parse origin/main)
    
    if [[ "$current_commit" == "$latest_commit" ]]; then
        echo "✅ Konfiguracja jest aktualna"
        return 0
    fi
    
    echo "📥 Pobieranie aktualizacji..."
    if ! git pull origin main >/dev/null 2>&1; then
        echo "❌ Błąd pobierania aktualizacji"
        return 1
    fi
    
    # Testowanie składni
    echo "🔍 Testowanie składni..."
    for file in core/*.zsh security/*.zsh productivity/*.zsh; do
        if [[ -f "$file" ]] && ! zsh -n "$file" 2>/dev/null; then
            echo "❌ Błąd składni w $file"
            git reset --hard "$current_commit" >/dev/null
            return 1
        fi
    done
    
    # Testowanie ładowania
    echo "🧪 Testowanie ładowania..."
    if ! zsh -c "source core/init.zsh" >/dev/null 2>&1; then
        echo "❌ Błąd ładowania konfiguracji"
        git reset --hard "$current_commit" >/dev/null
        return 1
    fi
    
    echo "✅ Konfiguracja zaktualizowana"
    return 0
}

update_zinit_plugins() {
    echo "🔌 Aktualizacja pluginów Zinit..."
    
    if ! command -v zinit >/dev/null 2>&1; then
        echo "⚠️ Zinit nie jest zainstalowany"
        return 0
    fi
    
    # Backup obecnych pluginów
    local plugins_backup="$LAYERED_UPDATE_DIR/plugins_backup"
    mkdir -p "$plugins_backup"
    cp -r "$HOME/.local/share/zinit" "$plugins_backup/" 2>/dev/null
    
    # Aktualizacja pluginów
    if ! zinit update >/dev/null 2>&1; then
        echo "❌ Błąd aktualizacji pluginów"
        # Przywróć backup
        rm -rf "$HOME/.local/share/zinit" 2>/dev/null
        cp -r "$plugins_backup/zinit" "$HOME/.local/share/"
        return 1
    fi
    
    echo "✅ Pluginy zaktualizowane"
    return 0
}

update_ai_models() {
    echo "🤖 Aktualizacja modeli AI..."
    
    if ! command -v ollama >/dev/null 2>&1; then
        echo "⚠️ Ollama nie jest zainstalowany"
        return 0
    fi
    
    # Sprawdź obecne modele
    local current_models=$(ollama list | awk 'NR>1 {print $1}')
    
    # Aktualizacja Ollama
    echo "📥 Aktualizacja Ollama..."
    if ! curl -fsSL https://ollama.ai/install.sh | sh >/dev/null 2>&1; then
        echo "⚠️ Nie można zaktualizować Ollama"
    fi
    
    # Sprawdź czy modele są nadal dostępne
    echo "🔍 Sprawdzanie modeli..."
    for model in $current_models; do
        if ! ollama list | grep -q "$model"; then
            echo "📥 Przywracanie modelu: $model"
            ollama pull "$model" >/dev/null 2>&1
        fi
    done
    
    echo "✅ Modele AI zaktualizowane"
    return 0
}

update_system_packages() {
    echo "🌐 Aktualizacja pakietów systemowych..."
    
    # Sprawdź dystrybucję
    if command -v pacman >/dev/null 2>&1; then
        echo "📦 Aktualizacja pakietów (Arch Linux)..."
        if ! sudo pacman -Syu --noconfirm >/dev/null 2>&1; then
            echo "❌ Błąd aktualizacji pakietów"
            return 1
        fi
    elif command -v apt >/dev/null 2>&1; then
        echo "📦 Aktualizacja pakietów (Debian/Ubuntu)..."
        if ! sudo apt update && sudo apt upgrade -y >/dev/null 2>&1; then
            echo "❌ Błąd aktualizacji pakietów"
            return 1
        fi
    else
        echo "⚠️ Nieobsługiwana dystrybucja"
        return 0
    fi
    
    echo "✅ Pakiety systemowe zaktualizowane"
    return 0
}

# =============================================================================
# SYSTEMD INTEGRATION
# =============================================================================

setup_systemd_timer() {
    echo "⏰ Konfiguracja systemd timer..."
    
    # Tworzenie katalogu systemd user
    mkdir -p "$HOME/.config/systemd/user"
    
    # Tworzenie service file
    cat > "$HOME/.config/systemd/user/layered-update.service" << EOF
[Unit]
Description=Layered ZSH Auto-Update
After=network-online.target

[Service]
Type=oneshot
ExecStart=$HOME/.config/layered/core/auto_update.zsh perform_update
Environment=DISPLAY=:1
EOF
    
    # Tworzenie timer file
    local schedule="weekly"
    case "$LAYERED_UPDATE_SCHEDULE" in
        "daily") schedule="daily" ;;
        "weekly") schedule="weekly" ;;
        "monthly") schedule="monthly" ;;
        *) return 0 ;;
    esac
    
    cat > "$HOME/.config/systemd/user/layered-update.timer" << EOF
[Unit]
Description=Layered ZSH Auto-Update Timer
Requires=layered-update.service

[Timer]
OnCalendar=$schedule
Persistent=true

[Install]
WantedBy=timers.target
EOF
    
    # Przeładuj i włącz timer
    systemctl --user daemon-reload >/dev/null 2>&1
    systemctl --user enable layered-update.timer >/dev/null 2>&1
    systemctl --user start layered-update.timer >/dev/null 2>&1
    
    echo "✅ Systemd timer skonfigurowany"
}

stop_systemd_timer() {
    echo "⏹️ Zatrzymywanie systemd timer..."
    
    systemctl --user stop layered-update.timer >/dev/null 2>&1
    systemctl --user disable layered-update.timer >/dev/null 2>&1
    
    echo "✅ Systemd timer zatrzymany"
}

# =============================================================================
# ALIASY
# =============================================================================

alias lue='lupdate_enable'
alias lud='lupdate_disable'
alias lus='lupdate_status'
alias lun='lupdate_now'
alias lur='lupdate_rollback'
alias luc='lupdate_config'
alias lusch='lupdate_schedule'

# =============================================================================
# INICJALIZACJA
# =============================================================================

# Załaduj konfigurację
load_update_config

echo "🔄 Kompleksowy auto-update system załadowany"
echo "💡 Komendy: lupdate_enable, lupdate_disable, lupdate_status, lupdate_now, lupdate_rollback, lupdate_config"
