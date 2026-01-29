# =============================================================================
# LAYERED ZSH - BACKUP & RESTORE SYSTEM
# =============================================================================
# 
# Funkcje backup/restore dla konfiguracji Layered ZSH
# Wersja: v3.1
# Autor: Layered ZSH Team
# =============================================================================

# Konfiguracja backup
export LAYERED_BACKUP_DIR="$HOME/.local/share/layered/backups"
export LAYERED_BACKUP_MAX=10  # Maksymalna liczba kopii
export LAYERED_BACKUP_FORMAT="tar.gz"

# Upewnij się, że katalog backup istnieje
[[ ! -d "$LAYERED_BACKUP_DIR" ]] && mkdir -p "$LAYERED_BACKUP_DIR"

# =============================================================================
# FUNKCJA GŁÓWNA - BACKUP
# =============================================================================

lbackup() {
    [[ $LAYERED_MODE == "immutable" ]] && echo "🔒 Backup zablokowany w trybie immutable" && return
    
    echo "🔄 Tworzenie kopii zapasowej Layered ZSH..."
    
    # Nazwa backupu z datą i czasem
    local backup_name="layered-zsh-backup-$(date +%Y%m%d-%H%M%S)"
    local backup_file="$LAYERED_BACKUP_DIR/$backup_name.tar.gz"
    
    # Sprawdź czy katalog źródłowy istnieje
    if [[ ! -d "$HOME/.config/layered" ]]; then
        echo "❌ Katalog ~/.config/layered nie istnieje!"
        return 1
    fi
    
    # Sprawdź czy są pliki do backupu
    local file_count=$(find "$HOME/.config/layered" -name "*.zsh" -type f | wc -l)
    if [[ $file_count -eq 0 ]]; then
        echo "❌ Brak plików .zsh do backupu!"
        return 1
    fi
    
    echo "📦 Plików do backupu: $file_count"
    
    # Tworzenie backupu
    echo "📦 Tworzenie archiwum..."
    tar -czf "$backup_file" -C "$HOME/.config/" layered/ 2>/dev/null
    
    if [[ $? -eq 0 ]]; then
        local backup_size=$(du -h "$backup_file" | cut -f1)
        echo "✅ Backup utworzony pomyślnie!"
        echo "📁 Plik: $backup_file"
        echo "📏 Rozmiar: $backup_size"
        
        # Dodaj metadane
        echo "# Layered ZSH Backup - $(date)" > "$backup_file.meta"
        echo "# Plików: $file_count" >> "$backup_file.meta"
        echo "# Rozmiar: $backup_size" >> "$backup_file.meta"
        echo "# Host: $(hostname)" >> "$backup_file.meta"
        echo "# User: $(whoami)" >> "$backup_file.meta"
        echo "# Mode: $LAYERED_MODE" >> "$backup_file.meta"
        
        # Czyść stare backupy
        lbackup_clean
        
        # Pokaż listę backupów
        lbackup_list
        
        # Logowanie
        echo "$(date): Backup created: $backup_name" >> "$LAYERED_BACKUP_DIR/backup.log"
        
    else
        echo "❌ Błąd podczas tworzenia backupu!"
        return 1
    fi
}

# =============================================================================
# FUNKCJA GŁÓWNA - RESTORE
# =============================================================================

lrestore() {
    [[ $LAYERED_MODE == "immutable" ]] && echo "🔒 Restore zablokowany w trybie immutable" && return
    
    echo "🔄 Przywracanie konfiguracji Layered ZSH..."
    
    # Sprawdź czy są backupy
    local backup_count=$(ls -1 "$LAYERED_BACKUP_DIR"/*.tar.gz 2>/dev/null | wc -l)
    if [[ $backup_count -eq 0 ]]; then
        echo "❌ Brak dostępnych kopii zapasowych!"
        echo "💡 Użyj 'lbackup' aby stworzyć kopię zapasową."
        return 1
    fi
    
    # Pokaż listę backupów
    lbackup_list
    
    # Jeśli podano argument, użyj go
    if [[ -n "$1" ]]; then
        local backup_file="$LAYERED_BACKUP_DIR/$1"
        if [[ ! -f "$backup_file" ]]; then
            echo "❌ Plik backupu nie istnieje: $backup_file"
            return 1
        fi
    else
        # Użyj najnowszego backupu
        local backup_file=$(ls -t "$LAYERED_BACKUP_DIR"/*.tar.gz 2>/dev/null | head -1)
        echo "🎯 Używam najnowszego backupu: $(basename "$backup_file")"
    fi
    
    # Potwierdzenie
    echo -n "⚠️  Czy na pewno chcesz przywrócić konfigurację? [t/N]: "
    read -r confirm
    if [[ ! "$confirm" =~ ^[tT]$ ]]; then
        echo "❌ Anulowano przywracanie."
        return 0
    fi
    
    # Stwórz backup obecnej konfiguracji
    echo "📦 Tworzenie backupu obecnej konfiguracji..."
    local current_backup="layered-zsh-pre-restore-$(date +%Y%m%d-%H%M%S)"
    tar -czf "$LAYERED_BACKUP_DIR/$current_backup.tar.gz" -C "$HOME/.config/" layered/ 2>/dev/null
    
    # Przywracanie
    echo "🔄 Przywracanie plików..."
    rm -rf "$HOME/.config/layered" 2>/dev/null
    tar -xzf "$backup_file" -C "$HOME/.config/" 2>/dev/null
    
    if [[ $? -eq 0 ]]; then
        echo "✅ Konfiguracja przywrócona pomyślnie!"
        echo "🔄 Przeładuj shell: 'source ~/.zshrc' lub 'exec zsh'"
        
        # Logowanie
        echo "$(date): Restored from: $(basename "$backup_file")" >> "$LAYERED_BACKUP_DIR/restore.log"
        
        # Pokaż metadane
        if [[ -f "$backup_file.meta" ]]; then
            echo "📋 Metadane backupu:"
            cat "$backup_file.meta"
        fi
        
    else
        echo "❌ Błąd podczas przywracania!"
        echo "💡 Spróbuj ręcznie przywrócić z: $backup_file"
        return 1
    fi
}

# =============================================================================
# FUNKCJE POMOCNICZE
# =============================================================================

lbackup_list() {
    echo "📋 Lista kopii zapasowych:"
    echo "========================"
    
    local backup_count=$(ls -1 "$LAYERED_BACKUP_DIR"/*.tar.gz 2>/dev/null | wc -l)
    if [[ $backup_count -eq 0 ]]; then
        echo "❌ Brak dostępnych kopii zapasowych."
        return 0
    fi
    
    # Pokaż listę backupów z metadanymi
    ls -lt "$LAYERED_BACKUP_DIR"/*.tar.gz 2>/dev/null | while read -r line; do
        local file=$(echo "$line" | awk '{print $9}')
        local size=$(echo "$line" | awk '{print $5}')
        local date=$(echo "$line" | awk '{print $6, $7, $8}')
        local basename_file=$(basename "$file")
        
        echo "📁 $basename_file"
        echo "   📏 Rozmiar: $size"
        echo "   📅 Data: $date"
        
        # Pokaż metadane jeśli istnieją
        if [[ -f "$file.meta" ]]; then
            echo "   📋 $(grep "# Host:" "$file.meta" | cut -d' ' -f3-)"
            echo "   👤 $(grep "# User:" "$file.meta" | cut -d' ' -f3-)"
        fi
        echo ""
    done
    
    echo "📊 Łącznie kopii: $backup_count"
    echo "📁 Katalog: $LAYERED_BACKUP_DIR"
}

lbackup_clean() {
    echo "🧹 Czyszczenie starych kopii zapasowych..."
    
    local backup_count=$(ls -1 "$LAYERED_BACKUP_DIR"/*.tar.gz 2>/dev/null | wc -l)
    if [[ $backup_count -le $LAYERED_BACKUP_MAX ]]; then
        echo "✅ Liczba kopii ($backup_count) nie przekracza limitu ($LAYERED_BACKUP_MAX)"
        return 0
    fi
    
    # Usuń najstarsze backupy
    local remove_count=$((backup_count - LAYERED_BACKUP_MAX))
    echo "🗑️  Usuwanie $remove_count najstarszych kopii..."
    
    ls -t "$LAYERED_BACKUP_DIR"/*.tar.gz 2>/dev/null | tail -$remove_count | while read -r file; do
        echo "🗑️  Usuwam: $(basename "$file")"
        rm -f "$file" "$file.meta" 2>/dev/null
    done
    
    echo "✅ Czyszczenie zakończone"
}

lbackup_info() {
    echo "📋 Informacje o systemie backup:"
    echo "==============================="
    echo "📁 Katalog backup: $LAYERED_BACKUP_DIR"
    echo "📊 Maks. kopii: $LAYERED_BACKUP_MAX"
    echo "📦 Format: $LAYERED_BACKUP_FORMAT"
    echo ""
    
    # Sprawdź dostępne miejsce
    if command -v df >/dev/null 2>&1; then
        local available=$(df -h "$LAYERED_BACKUP_DIR" | tail -1 | awk '{print $4}')
        echo "💾 Dostępne miejsce: $available"
    fi
    
    # Pokaż logi
    if [[ -f "$LAYERED_BACKUP_DIR/backup.log" ]]; then
        echo "📜 Ostatnie backupy:"
        tail -5 "$LAYERED_BACKUP_DIR/backup.log"
    fi
    
    if [[ -f "$LAYERED_BACKUP_DIR/restore.log" ]]; then
        echo "📜 Ostatnie przywrócenia:"
        tail -5 "$LAYERED_BACKUP_DIR/restore.log"
    fi
}

# =============================================================================
# ALIASY
# =============================================================================

alias lb="lbackup"
alias lr="lrestore"
alias llb="lbackup_list"
alias lbc="lbackup_clean"
alias lbi="lbackup_info"

# =============================================================================
# INTEGRACJA Z SYSTEMEM
# =============================================================================

# Automatyczny backup przy dużych zmianach
lbackup_auto() {
    local trigger="$1"
    echo "🔄 Automatyczny backup (trigger: $trigger)"
    lbackup
}

# Backup przed trybem panic
lpanic_backup() {
    echo "🚨 Backup przed trybem panic"
    lbackup_auto "panic_mode"
}

# Sprawdzenie integralności backupu
lbackup_check() {
    local backup_file="$1"
    if [[ ! -f "$backup_file" ]]; then
        echo "❌ Plik backupu nie istnieje: $backup_file"
        return 1
    fi
    
    echo "🔍 Sprawdzanie integralności: $(basename "$backup_file")"
    
    # Test archiwum
    if tar -tzf "$backup_file" >/dev/null 2>&1; then
        echo "✅ Archiwum jest poprawne"
        
        # Pokaż zawartość
        echo "📋 Zawartość:"
        tar -tzf "$backup_file" | head -10
        echo "   ... ($(tar -tzf "$backup_file" | wc -l) plików)"
        
        return 0
    else
        echo "❌ Archiwum jest uszkodzone!"
        return 1
    fi
}

# =============================================================================
# INICJALIZACJA
# =============================================================================

echo "🔄 Backup/Restore system załadowany"
echo "💡 Komendy: lbackup, lrestore, lbackup_list, lbackup_clean, lbackup_info"
