# =============================================================================
# Layered ZSH AUDIT - system audytu i logowania (warstwa SECURITY)
# =============================================================================

# Audit log directory
LAYERED_AUDIT_LOG="$HOME/.cache/layered_audit.log"
mkdir -p "$(dirname "$LAYERED_AUDIT_LOG")"

# --- [ AUDIT FUNCTIONS ] ---
l_audit_log() {
  local action="$1"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  local user=$(whoami)
  local host=$(hostname)
  local pwd=$(pwd)
  
  echo "[$timestamp] $user@$host:$pwd - $action" >> "$LAYERED_AUDIT_LOG"
}

# --- [ SESSION AUDIT ] ---
l_audit_session_start() {
  l_audit_log "SESSION_START"
}

l_audit_session_end() {
  l_audit_log "SESSION_END"
}

# --- [ COMMAND AUDIT ] ---
l_audit_command() {
  local cmd="$1"
  l_audit_log "COMMAND: $cmd"
}

# --- [ DANGEROUS COMMANDS ] ---
l_audit_dangerous() {
  local cmd="$1"
  if [[ "$cmd" =~ (rm\ -rf|sudo\ rm|dd\ if=|mkfs|format|fdisk|sudo\ pacman\ -R) ]]; then
    l_audit_log "DANGEROUS_COMMAND: $cmd"
    echo "⚠️ Niebezpieczna komenda zalogowana!"
  fi
}

# --- [ AUDIT VIEW ] ---
laudit() {
  if [[ ! -f "$LAYERED_AUDIT_LOG" ]]; then
    echo "❌ Brak logu audytu"
    return 1
  fi
  
  echo "🕵️ Layered ZSH AUDIT LOG (ostatnie 50 wpisów)"
  echo "=========================================="
  tail -n 50 "$LAYERED_AUDIT_LOG"
  echo ""
  echo "📊 Pełny log: $LAYERED_AUDIT_LOG"
  echo "📊 Rozmiar: $(wc -l < "$LAYERED_AUDIT_LOG") wpisów"
}

# --- [ AUDIT STATS ] --
laudit_stats() {
  if [[ ! -f "$LAYERED_AUDIT_LOG" ]]; then
    echo "❌ Brak logu audytu"
    return 1
  fi
  
  echo "📊 Layered ZSH AUDIT STATS"
  echo "=========================="
  echo "📝 Total entries: $(wc -l < "$LAYERED_AUDIT_LOG")"
  echo "⚠️ Dangerous commands: $(grep -c "DANGEROUS_COMMAND" "$LAYERED_AUDIT_LOG")"
  echo "🔄 Sessions: $(grep -c "SESSION" "$LAYERED_AUDIT_LOG")"
  echo "📅 First entry: $(head -n 1 "$LAYERED_AUDIT_LOG" | awk '{print $1, $2}')"
  echo "📅 Last entry: $(tail -n 1 "$LAYERED_AUDIT_LOG" | awk '{print $1, $2}')"
}

# --- [ AUDIT CLEAN ] ---
laudit_clean() {
  local days=${1:-30}
  local cutoff_date=$(date -d "$days days ago" '+%Y-%m-%d')
  
  if [[ ! -f "$LAYERED_AUDIT_LOG" ]]; then
    echo "❌ Brak logu audytu"
    return 1
  fi
  
  echo "🧹 Czyszczę log audytu (starsze niż $days dni)..."
  
  # Tworzę backup
  cp "$LAYERED_AUDIT_LOG" "$LAYERED_AUDIT_LOG.backup"
  
  # Filtruję logi
  awk -v cutoff="$cutoff_date" '
    $1 >= cutoff { print }
  ' "$LAYERED_AUDIT_LOG.backup" > "$LAYERED_AUDIT_LOG"
  
  echo "✅ Log audytu wyczyszczony"
  echo "📊 Stary rozmiar: $(wc -l < "$LAYERED_AUDIT_LOG.backup") wpisów"
  echo "📊 Nowy rozmiar: $(wc -l < "$LAYERED_AUDIT_LOG") wpisów"
  
  rm "$LAYERED_AUDIT_LOG.backup"
}

# Hook dla zsh
if [[ -n "$ZSH_VERSION" ]]; then
  # Logowanie rozpoczęcia sesji
  l_audit_session_start
  
  # Hook dla komend
  l_audit_preexec() {
    l_audit_command "$1"
    l_audit_dangerous "$1"
  }
  
  # Hook dla zakończenia sesji
  l_audit_zshexit() {
    l_audit_session_end
  }
  
  # Podpinam hooki
  autoload -Uz add-zsh-hook
  add-zsh-hook preexec l_audit_preexec
  add-zsh-hook zshexit l_audit_zshexit
fi

echo "🕵️ System audytu Layered ZSH załadowany"
