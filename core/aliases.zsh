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

  echo -e "\n📋 WSZYSTKIE DOSTĘPNE KOMENDY I ALIASY:"
  echo -e "─────────────────────────────────────────────────────"
  
  # Runtime Control
  echo -e "\n🔧 Runtime Control:"
  echo -e "  lpanic        - tryb paniki"
  echo -e "  lrecover      - odblokowanie paniki"
  echo -e "  lrestore      - przywrócenie snapshotu"
  echo -e "  laudit        - audit sesji"
  echo -e "  llock         - blokada edycji"
  echo -e "  lunlock       - odblokowanie edycji"
  
  # Rollback System
  echo -e "\n🔄 Rollback System:"
  echo -e "  q_snapshot    - tworzenie snapshotu"
  echo -e "  q_restore_last - przywrócenie ostatniego snapshotu"
  echo -e "  q_list_snapshots - lista snapshotów"
  echo -e "  q_rollback    - rollback systemu"
  
  # Systemowe
  echo -e "\n⚙️ Systemowe:"
  echo -e "  up            - aktualizacja systemu"
  echo -e "  status        - status systemu"
  echo -e "  check_system_health - sprawdzanie zdrowia systemu"
  
  # Profile
  echo -e "\n👤 Profile:"
  echo -e "  lprofile      - profil użytkownika"
  echo -e "  lsafeboot     - przełącz safe boot"
  
  # AI System
  echo -e "\n🤖 AI System:"
  echo -e "  sc \"pytanie\"  - AI podstawowe (DeepSeek Coder)"
  echo -e "  si \"pytanie\"  - AI rozszerzone (Llama 3.2)"
  echo -e "  ai \"pytanie\"  - główna funkcja AI"
  echo -e "  fix           - AI naprawa systemu"
  echo -e "  ask-zsh \"pytanie\" - pytania o Zsh"
  echo -e "  helpme        - pomoc AI"
  echo -e "  explain \"komenda\" - wyjaśnienie komendy"
  echo -e "  optimize plik - optymalizacja kodu"
  echo -e "  changelog     - generowanie changelog z git"
  
  # Monitoring
  echo -e "\n🌡️ Monitoring:"
  echo -e "  monitor_start - start monitoringu"
  echo -e "  monitor_stop  - stop monitoringu"
  echo -e "  monitor_status - status monitoringu"
  echo -e "  hud           - dynamiczny HUD"
  echo -e "  status        - prosty status"
  
  # Security
  echo -e "\n🛡️ Security:"
  echo -e "  laudit        - ostatnie 50 wpisów"
  echo -e "  laudit_stats  - statystyki audytu"
  echo -e "  laudit_clean  - czyszczenie logów"
  echo -e "  lmode immutable - tryb tylko do odczytu"
  
  # Quick Edit
  echo -e "\n📝 Quick Edit:"
  echo -e "  leinit        - edycja init.zsh"
  echo -e "  lealias       - edycja aliases.zsh"
  echo -e "  leai          - edycja ai.zsh"
  
  # Nawigacja
  echo -e "\n🧭 Nawigacja:"
  echo -e "  zi            - Zoxide cd"
  echo -e "  fn            - fzf cd"
  echo -e "  ..            - cd .."
  echo -e "  ...           - cd ../.."
  echo -e "  ....          - cd ../../.."
  
  # Systemowe aliasy
  echo -e "\n⌨️ Systemowe:"
  echo -e "  c             - clear"
  echo -e "  ls            - ls --color=auto"
  echo -e "  ll            - ls -la"
  echo -e "  la            - ls -la"
  echo -e "  rm            - rm -i"
  echo -e "  cp            - cp -i"
  echo -e "  mv            - mv -i"
  echo -e "  v             - vim"
  echo -e "  micro         - micro"
  echo -e "  edit          - micro"
  echo -e "  vi            - micro"
  echo -e "  vim           - micro"
  echo -e "  cy            - Cytadela"
  echo -e "  update        - aktualizacja systemu"
  echo -e "  cleanup       - czyszczenie systemu"
  
  # Katalogi
  echo -e "\n📁 Katalogi:"
  echo -e "  lconfig       - ~/.config/layered"
  echo -e "  lcache        - ~/.cache/layered"
  echo -e "  llocal        - ~/.local/share/layered"
  
  # AI aliasy
  echo -e "\n🤖 AI:"
  echo -e "  sc, si        - AI funkcje"
  echo -e "  ask, helpme   - pomoc AI"
  echo -e "  explain       - wyjaśnienia"
  echo -e "  optimize      - optymalizacja"
  
  # Funkcje systemowe
  echo -e "\n🔧 Funkcje systemowe:"
  echo -e "  mkcd          - mkdir + cd"
  echo -e "  md            - alias do mkcd"
  
  # Tryby pracy
  echo -e "\n🎮 Tryby pracy:"
  echo -e "  lmode full    - pełna funkcjonalność"
  echo -e "  lmode immutable - tylko odczyt"
  echo -e "  lmode safe    - tryb bezpieczny"
  echo -e "  lfull         - skrót do full"
  echo -e "  limmutable    - skrót do immutable"
  echo -e "  lsafe         - skrót do safe"

  echo -e "\n─────────────────────────────────────────────────────"
  echo -e "📚 Pełna dokumentacja: https://github.com/QguAr71/layered-zsh"
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
