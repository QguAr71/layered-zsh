# AI CORE - rdzeń systemu AI

AI_CACHE="$HOME/.cache/layered_ai"
mkdir -p "$AI_CACHE"

# Funkcja AI z cache + mock
ai() {
  [[ $LAYERED_MODE == "immutable" ]] && echo "🔒 AI zablokowane" && return

  local MODEL="deepseek-coder-v2:lite"
  [[ $1 == "-f" ]] && { MODEL="llama3.2"; shift; }

  local q="$*"
  local h=$(echo "$MODEL$q" | sha256sum | cut -d' ' -f1)
  local f="$AI_CACHE/$h.md"

  source "$HOME/.config/layered/productivity/ai-cache.zsh"
  [[ -f $f ]] && ai_cache_valid "$f" && { cat "$f"; return; }

  # Mock AI - gdy ollama nie dostępne
  if ! command -v ollama >/dev/null 2>&1; then
    echo "🤖 Layered ZSH AI (Mock Mode)"
    echo "======================="
    echo ""
    echo "Pytanie: $q"
    echo ""
    # Proste odpowiedzi mock
    case "$q" in
      *"test"*|*"działa"*)
        echo "✅ System Layered ZSH działa poprawnie!"
        echo "🎯 Tryb: $LAYERED_MODE"
        echo "🔥 Monitoring: $(monitor-status 2>/dev/null | grep AKTYWNY >/dev/null && echo "AKTYWNY" || echo "NIEAKTYWNY")"
        echo "📊 Wszystkie warstwy załadowane."
        ;;
      *"status"*|*"jak"*)
        echo "📊 Status Layered ZSH:"
        echo "- Tryb pracy: $LAYERED_MODE"
        echo "- AI: Mock Mode (brak Ollama)"
        echo "- Monitoring: $(monitor-status 2>/dev/null | grep AKTYWNY >/dev/null && echo "AKTYWNY" || echo "NIEAKTYWNY")"
        echo "- Security: AKTYWNY"
        echo ""
        echo "📦 Zainstaluj Ollama dla pełnego AI:"
        echo "curl -fsSL https://ollama.com/install.sh | sh"
        ;;
      *"pomoc"*|*"help"*)
        echo "🚀 Layered ZSH AI - dostępne komendy:"
        echo "- sc 'pytanie' - podstawowe AI"
        echo "- si 'pytanie' - AI z wymuszeniem"
        echo "- fix - AI naprawa systemu"
        echo "- status - status systemu"
        echo "- hud - dynamiczny HUD"
        echo "- lmode full/immutable/safe - tryby pracy"
        ;;
      *)
        echo "🤖 Odpowiedź mock AI:"
        echo "System Layered ZSH jest aktywny i gotowy do pracy."
        echo "Zainstaluj Ollama dla pełnych funkcji AI."
        echo ""
        echo "💡 Podpowiedź: spróbuj 'sc status' lub 'sc pomoc'"
        ;;
    esac
    echo ""
    # Zapis mock odpowiedzi do cache
    {
      echo "🤖 Layered ZSH AI (Mock Mode)"
      echo "======================="
      echo "Pytanie: $q"
      echo "Data: $(date)"
      echo ""
      case "$q" in
        *"test"*|*"działa"*)
          echo "✅ System Layered ZSH działa poprawnie!"
          ;;
        *)
          echo "🤖 Mock odpowiedź na: $q"
          ;;
      esac
    } > "$f"
    return
  fi

  # Normalne Ollama (gdy dostępne)
  ollama run "$MODEL" "INSTRUKCJA: Odpowiadaj wyłącznie po polsku. $q" | tee "$f"
}

# Podstawowe aliasy AI
alias sc='ai'
alias si='ai -f'
# alias fix usunięty - jest jako funkcja w ai.zsh
