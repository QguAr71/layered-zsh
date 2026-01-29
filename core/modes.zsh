# =============================================================================
# Layered ZSH MODES - tryby pracy
# =============================================================================

# Domyślny tryb
export LAYERED_MODE="${LAYERED_MODE:-full}"

# Funkcje trybów
lmode() {
  local new_mode="$1"
  case "$new_mode" in
    "immutable")
      export LAYERED_MODE="immutable"
      export IMMUTABLE=1
      echo "🔒 Tryb IMMUTABLE aktywny"
      ;;
    "full")
      export LAYERED_MODE="full"
      export IMMUTABLE=0
      echo "⚡ Tryb FULL aktywny"
      ;;
    "safe")
      export LAYERED_MODE="safe"
      export IMMUTABLE=0
      echo "🛡️ Tryb SAFE aktywny"
      ;;
    *)
      echo "Tryb: $LAYERED_MODE"
      echo "Dostępne: immutable, full, safe"
      ;;
  esac
}

# Aliasy trybów
alias limmutable='lmode immutable'
alias lfull='lmode full'
alias lsafe='lmode safe'
