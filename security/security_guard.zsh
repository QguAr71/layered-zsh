# SECURITY GUARD – blokuje/ostrzega przed niebezpiecznymi komendami

typeset -gA DANGEROUS_PATTERNS=(
  "rm -rf /"               "usuwa cały system"
  "rm -rf ~"               "usuwa cały dom"
  "sudo rm -rf"            "sudo usuwa wszystko"
  "> /dev/"                "nadpisuje dysk"
  "mkfs"                   "formatuje dysk"
  "dd if="                 "może zniszczyć dysk"
  ":(){ :|: & };"          "fork bomb"
)

GUARD_LOG="$HOME/.cache/qguar_guard.log"
mkdir -p "$(dirname "$GUARD_LOG")"

security_guard_preexec() {
  [[ $- != *i* ]] && return 0
  [[ ${PANIC_MODE:-0} -eq 1 ]] && return 0

  local cmd="$1"

  # Pełna blokada w trybie immutable
  if [[ $QGUAR_MODE == "immutable" ]]; then
    if [[ $cmd == *sudo* || $cmd == *pacman*-S* || $cmd == *yay* || $cmd == *rm* || $cmd == *dd* || $cmd == *mkfs* || $cmd == *chattr* ]]; then
      echo -e "\e[1;31m🔒 GUARD (immutable): Komenda zablokowana!\e[0m $cmd"
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] BLOCKED immutable: $cmd" >> "$GUARD_LOG"
      return 1
    fi
  fi

  # Ostrzeżenie + potwierdzenie dla niebezpiecznych wzorców
  for pat in "${(@k)DANGEROUS_PATTERNS}"; do
    if [[ $cmd == *${pat}* ]]; then
      echo -e "\e[1;33m⚠️  GUARD: Niebezpieczna komenda wykryta!\e[0m"
      echo "   $cmd"
      echo "   ${DANGEROUS_PATTERNS[$pat]}"
      echo -n "   Kontynuować? [y/N] "
      read -r confirm </dev/tty
      if [[ ! $confirm =~ ^[yY]$ ]]; then
        echo -e "\e[32mAnulowano.\e[0m"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] DENIED: $cmd" >> "$GUARD_LOG"
        return 1
      fi
      echo -e "\e[33mWykonano po potwierdzeniu.\e[0m"
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] ALLOWED: $cmd" >> "$GUARD_LOG"
      break
    fi
  done

  return 0
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec security_guard_preexec

alias guard-log='tail -n 30 "$GUARD_LOG" 2>/dev/null || echo "Brak wpisów"'
