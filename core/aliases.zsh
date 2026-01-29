# =============================================================================
# Layered ZSH ALIASES - podstawowe aliasy (warstwa CORE)
# =============================================================================

# --- [ QUICK EDIT ] ---
alias leinit='micro ~/.config/layered/core/init.zsh'
alias lealias='micro ~/.config/layered/core/aliases.zsh'
alias leai='micro ~/.config/layered/productivity/ai.zsh'

# --- [ RUNTIME CONTROL ] ---
lpanic()    { touch ~/.layered_panic; exec zsh }
lrecover()  { rm -f ~/.layered_panic; exec zsh }
lrestore()  { q_restore_last; exec zsh }
laudit()    { tail -n 50 ~/.cache/layered_audit.log }
llock()     { chmod -R a-w ~/.config/layered }
lunlock()   { chmod -R u+w ~/.config/layered }

# --- [ THE HELP FUNCTION ] ---
lhelp() {
  clear
  echo -e "🧬 Layered ZSH v3.0 - Neutral Modular System"
  echo -e "─────────────────────────────────────────────────────"
  echo -e "👤 USER: $(whoami)   🧬 MODE: $LAYERED_MODE"
  echo -e "─────────────────────────────────────────────────────"

  echo -e "\n1️⃣  🔄 AUTO-ROLLBACK (samoleczenie)"
  echo -e "  lrestore      - powrót do ostatniego dobrego stanu"
  echo -e "  * każda sesja = snapshot"

  echo -e "\n2️⃣  🧬 MODE PER-HOST"
  echo -e "  Tryb: $LAYERED_MODE (host: $(hostname))"

  echo -e "\n3️⃣  🕵️ RUNTIME AUDIT"
  echo -e "  laudit        - timeline sesji (ostatnie 50 wpisów)"

  echo -e "\n4️⃣  🧊 READ-ONLY MODE"
  echo -e "  llock         - blokada edycji (.config/layered)"
  echo -e "  lunlock       - odblokowanie edycji"

  echo -e "\n5️⃣  🧠 PANIC MODE"
  echo -e "  lpanic        - tryb paniki (minimalny system)"
  echo -e "  lrecover      - odblokowanie paniki"

  echo -e "\n🤖 Layered AI & NAV"
  echo -e "  sc / si       - AI podstawowe / rozszerzone"
  echo -e "  zi / y        - Zoxide / Yazi"
  echo -e "  hud / status  - System HUD / status"

  echo -e "\n⚙️ Systemowe:"
  echo -e "  up            - aktualizacja systemu"
  echo -e "  cy            - Cytadela"

  echo -e "─────────────────────────────────────────────────────"
  echo -e "Powrót tutaj: lhelp"
}

alias layered='lhelp'

# --- [ PODSTAWOWE ALIASY ] ---
alias c='clear'
alias ls='ls --color=auto'
alias ll='ls -la'
alias la='ls -la'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# --- [ KATALOGI ] ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# --- [ SYSTEM ] ---
alias cy='sudo ~/Cytadela/cytadela++.sh'
alias update='sudo pacman -Syu'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'

# --- [ EDYTORY ] ---
alias v='vim'
alias micro='micro'
alias edit='micro'
alias vi='micro'
alias vim='micro'

# --- [ FUNKCJE SYSTEMOWE ] ---
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Prosty status systemu
status() {
  echo "🔥 Layered ZSH STATUS"
  echo "==============="
  echo "⏰ $(date '+%H:%M:%S')"
  echo "💻 CPU: $(grep -m1 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$3+$4+$5)} END {printf "%.1f%%", usage}')"
  echo "🧠 RAM: $(free -h | awk '/^Mem:/ {printf "%.1f%%", $3/$2*100}')"
  echo "🌡️ Temp: $(sensors 2>/dev/null | grep -m1 'Package id 0:' | awk '{print $4}' || echo "N/A")"
  echo "⚡ Load: $(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | tr -d ',')"
  echo "🎯 Tryb: $LAYERED_MODE"
  echo "👤 User: $(whoami)"
  echo "🖥️ Host: $(hostname)"
}

alias md='mkcd'

# --- [ NAVIGACJA ] ---
alias zi='zoxide'
alias fn='z'

# --- [ QUICK CD ] ---
alias lconfig='cd ~/.config/layered'
alias lcache='cd ~/.cache/layered'
alias llocal='cd ~/.local/share/layered'

# --- [ FUNKCJE SYSTEMOWE ] ---
up() {
  [[ $LAYERED_MODE == "immutable" ]] && echo "🔒 immutable" && return
  sudo pacman -Syu --noconfirm
}

echo "🔧 Aliasy Layered ZSH załadowane"
