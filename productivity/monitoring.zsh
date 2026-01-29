# =============================================================================
# Layered ZSH MONITORING - monitoring termiczny i systemowy (warstwa PRODUCTIVITY)
# =============================================================================

# Monitoring termiczny w tle
export LAYERED_MONITOR_PID=""
LAYERED_MONITOR_FILE="$HOME/.config/layered/.monitor_pid"

# --- [ SYSTEM HEALTH CHECK ] ---
check_system_health() {
  local c=$(coredumpctl list --since yesterday --no-legend 2>/dev/null | wc -l)
  (( c > 0 )) && echo "⚠️ $c awarie – wpisz fix"
}

# --- [ COMMAND MONITORING ] ---
preexec() {
  LAYERED_CMD_START=$EPOCHSECONDS
  LAYERED_LAST_CMD=$1
}

precmd() {
  (( LAYERED_CMD_START )) || return
  local d=$((EPOCHSECONDS - LAYERED_CMD_START))
  (( d > 10 )) && notify-send "Layered ZSH" "$LAYERED_LAST_CMD (${d}s)"
  unset LAYERED_CMD_START
}

# --- [ HISTORY MONITORING ] ---
zshaddhistory() {
  echo "◢◤ Layered ZSH ONLINE ◢◤ Aktualizacje: $(checkupdates 2>/dev/null | wc -l)"
  unfunction zshaddhistory
}

monitor_start() {
  # Odczytaj PID z pliku jeśli istnieje
  if [[ -f "$LAYERED_MONITOR_FILE" ]]; then
    LAYERED_MONITOR_PID=$(cat "$LAYERED_MONITOR_FILE")
    if [[ -n "$LAYERED_MONITOR_PID" ]] && kill -0 "$LAYERED_MONITOR_PID" 2>/dev/null; then
      echo "🌡️ Monitoring już działa (PID: $LAYERED_MONITOR_PID)"
      return
    fi
  fi
  
  if [[ -n "$LAYERED_MONITOR_PID" ]] && kill -0 "$LAYERED_MONITOR_PID" 2>/dev/null; then
    echo "🌡️ Monitoring już działa (PID: $LAYERED_MONITOR_PID)"
    return
  fi
  
  echo "🌡️ Uruchamiam monitoring termiczny..."
  
  (
    while true; do
      # Sprawdź temperaturę
      if command -v sensors >/dev/null 2>&1; then
        temp=$(sensors | grep -m1 'Package id 0:' | awk '{print $4}' | tr -d '+°C')
        if [[ -n "$temp" && "${temp%.*}" -gt 80 ]]; then
          echo "🔥 Uwaga: Wysoka temperatura CPU: $temp°C"
          echo "💡 Sugerowana czynność: Sprawdź obciążenie procesu i wentylację"
          echo ""
        fi
      fi
      
      # Sprawdź RAM
      ram_usage=$(free | awk '/^Mem:/ {printf "%.0f", $3/$2*100}')
      if [[ "$ram_usage" -gt 90 ]]; then
        echo "🧠 Uwaga: Wysokie użycie RAM: ${ram_usage}%"
        echo "💡 Sugerowana czynność: Zamknij niepotrzebne programy"
        echo ""
      fi
      
      # Sprawdź load average
      load=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | tr -d ',')
      if (( $(echo "$load > 2.0" | bc -l) )); then
        echo "⚡ Uwaga: Wysoki load average: $load"
        echo "💡 Sugerowana czynność: Sprawdź procesy obciążające CPU"
        echo ""
      fi
      
      sleep 30
    done
  ) &
  
  LAYERED_MONITOR_PID=$!
  echo "$LAYERED_MONITOR_PID" > "$LAYERED_MONITOR_FILE"
  echo "🌡️ Monitoring uruchomiony (PID: $LAYERED_MONITOR_PID)"
}

monitor_stop() {
  if [[ -n "$LAYERED_MONITOR_PID" ]]; then
    kill "$LAYERED_MONITOR_PID" 2>/dev/null
    unset LAYERED_MONITOR_PID
    rm -f "$LAYERED_MONITOR_FILE"
    echo "🌡️ Monitoring zatrzymany"
  else
    echo "🌡️ Monitoring nie był aktywny"
  fi
}

monitor_status() {
  # Sprawdź PID z pliku
  if [[ -f "$LAYERED_MONITOR_FILE" ]]; then
    LAYERED_MONITOR_PID=$(cat "$LAYERED_MONITOR_FILE")
  fi
  
  if [[ -n "$LAYERED_MONITOR_PID" ]] && kill -0 "$LAYERED_MONITOR_PID" 2>/dev/null; then
    echo "🌡️ Monitoring AKTYWNY (PID: $LAYERED_MONITOR_PID)"
  else
    echo "🌡️ Monitoring NIEAKTYWNY"
    unset LAYERED_MONITOR_PID
    rm -f "$LAYERED_MONITOR_FILE"
  fi
}

# Automatyczny start (tylko w trybie pełnym)
if [[ "$LAYERED_MODE" == "full" && "$LAYERED_SAFEBOOT" -eq 0 ]]; then
  monitor_start
fi

# Aliasy
alias monitor-start='monitor_start'
alias monitor-stop='monitor_stop'
alias monitor-status='monitor_status'

# Sprawdź zdrowie systemu
check_system_health

echo "🌡️ Monitoring termiczny załadowany"
