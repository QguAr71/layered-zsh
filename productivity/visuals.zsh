# =============================================================================
# Layered ZSH VISUALS - HUD, motywy, wyświetlanie (warstwa PRODUCTIVITY)
# =============================================================================

# Dynamic HUD - system monitor (z Qguar)
hud() {
  clear; echo -ne "\e[?25l"; trap 'echo -ne "\e[?25h"; return' INT
  while true; do
    local temp=$(sensors | grep -m1 -E 'Package id 0|Core 0' | awk '{print ($4=="" ? $2 : $4)}' | tr -d '+')
    local cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    local ram=$(free | awk '/Mem:/ {printf "%.0f%%", $3/$2*100}')
    local mode="${IMMUTABLE:-0}"
    local m_col="\e[1;32m"; [[ $mode == "1" ]] && m_col="\e[1;31m"
    echo -ne "\e[H"
    echo -e " ◢◤ Layered ZSH DYNAMIC HUD ◢◤"
    echo -e "Tryb: $LAYERED_MODE | SAFE_BOOT: $LAYERED_SAFEBOOT | IMMUTABLE: $IMMUTABLE"
    echo -e "Temp CPU: $m_col$temp\e[0m°C | CPU: $cpu% | RAM: $ram"
    echo -e "⬆️ Naciśnij CTRL+C aby wyjść"
    sleep 1
  done
}

# Prosty HUD (jednorazowy)
status() {
  echo "🔥 Layered ZSH STATUS"
  echo "==============="
  echo "⏰ $(date '+%H:%M:%S')"
  echo "💻 CPU: $(grep -m1 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$3+$4+$5)} END {printf "%.1f%%", usage}')"
  echo "🧠 RAM: $(free -h | awk '/^Mem:/ {printf "%.1f%%", $3/$2*100}')"
  echo "🌡️ Temp: $(sensors 2>/dev/null | grep -m1 'Package id 0:' | awk '{print $4}' || echo "N/A")"
  echo "⚡ Load: $(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | tr -d ',')"
  echo "🎯 Tryb: $LAYERED_MODE"
}

# Kolory dla ls
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'

# Powerlevel10k konfiguracja
if [[ -f "$HOME/.p10k.zsh" ]]; then
  source "$HOME/.p10k.zsh"
fi

echo "🎨 Visuals + HUD załadowane"
