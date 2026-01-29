# =============================================================================
# LAYERED ZSH - ENHANCED AI SYSTEM
# =============================================================================
# 
# Wielomodelowy system AI z opcją darmowych i płatnych modeli
# Wsparcie dla: DeepSeek, Llama, Grok, Claude, GPT
# 
# Wersja: v3.1
# Autor: Layered ZSH Team
# =============================================================================

# Konfiguracja AI
export LAYERED_AI_DIR="$HOME/.config/layered/ai"
export LAYERED_AI_CONFIG="$LAYERED_AI_DIR/config"
export LAYERED_AI_CACHE="$HOME/.cache/layered_ai"
export LAYERED_AI_LOGS="$LAYERED_AI_DIR/logs"

# Upewnij się, że katalogi istnieją
mkdir -p "$LAYERED_AI_DIR" "$LAYERED_AI_CACHE" "$LAYERED_AI_LOGS"

# Domyślne ustawienia
LAYERED_AI_ENABLED=${LAYERED_AI_ENABLED:-true}
LAYERED_AI_DEFAULT_MODEL=${LAYERED_AI_DEFAULT_MODEL:-"deepseek-coder-v2:lite"}
LAYERED_AI_FALLBACK_MODEL=${LAYERED_AI_FALLBACK_MODEL:-"deepseek-coder-v2:lite"}

# =============================================================================
# KONFIGURACJA MODELI AI
# =============================================================================

# Darmowe modele (lokalne)
declare -A LAYERED_AI_FREE_MODELS=(
    ["deepseek"]="deepseek-coder-v2:lite"
    ["llama"]="llama3.2"
    ["codellama"]="codellama:7b"
    ["mistral"]="mistral"
)

# Płatne modele (API)
declare -A LAYERED_AI_PREMIUM_MODELS=(
    ["claude"]="claude-3-sonnet-20240229"
    ["gpt"]="gpt-4"
    ["gpt-3.5"]="gpt-3.5-turbo"
    ["grok"]="grok-beta"
)

# Konfiguracja API
declare -A LAYERED_AI_API_CONFIG=(
    ["claude"]="https://api.anthropic.com/v1/messages"
    ["gpt"]="https://api.openai.com/v1/chat/completions"
    ["gpt-3.5"]="https://api.openai.com/v1/chat/completions"
    ["grok"]="https://api.x.ai/v1/chat/completions"
)

# =============================================================================
# FUNKCJE KONFIGURACJI AI
# =============================================================================

ai_setup() {
    echo -e "${BLUE}🤖 Konfiguracja Layered ZSH AI${NC}"
    echo "================================"
    
    # Sprawdź czy Ollama jest zainstalowane
    if ! command -v ollama >/dev/null 2>&1; then
        echo -e "${YELLOW}⚠️  Ollama nie jest zainstalowane${NC}"
        echo -e "${YELLOW}💡 Zainstaluj: curl -fsSL https://ollama.com/install.sh | sh${NC}"
        echo ""
    fi
    
    # Wybór modeli
    echo "🔧 Wybierz modele AI do skonfigurowania:"
    echo ""
    
    # Darmowe modele
    echo -e "${GREEN}🆓 Darmowe modele (lokalne):${NC}"
    for model in "${!LAYERED_AI_FREE_MODELS[@]}"; do
        echo "  • $model (${LAYERED_AI_FREE_MODELS[$model]})"
    done
    echo ""
    
    # Płatne modele
    echo -e "${YELLOW}💳 Płatne modele (API):${NC}"
    for model in "${!LAYERED_AI_PREMIUM_MODELS[@]}"; do
        echo "  • $model (${LAYERED_AI_PREMIUM_MODELS[$model]})"
    done
    echo ""
    
    # Konfiguracja API keys
    echo -e "${BLUE}🔑 Konfiguracja kluczy API:${NC}"
    echo "Claude (Anthropic):"
    read -p "  API key (opcjonalnie): " claude_key
    echo "GPT (OpenAI):"
    read -p "  API key (opcjonalnie): " gpt_key
    echo "Grok (X/Twitter):"
    read -p "  API key (opcjonalnie): " grok_key
    
    # Zapisz konfigurację
    save_ai_config "$claude_key" "$gpt_key" "$grok_key"
    
    # Wybór domyślnego modelu
    echo ""
    echo -e "${BLUE}🎯 Wybierz domyślny model:${NC}"
    echo "1. DeepSeek (darmowy)"
    echo "2. Llama (darmowy)"
    echo "3. Claude (płatny)"
    echo "4. GPT (płatny)"
    echo "5. Grok (darmowy API)"
    echo ""
    read -p "Wybierz (1-5): " model_choice
    
    case $model_choice in
        1) LAYERED_AI_DEFAULT_MODEL="deepseek-coder-v2:lite" ;;
        2) LAYERED_AI_DEFAULT_MODEL="llama3.2" ;;
        3) LAYERED_AI_DEFAULT_MODEL="claude-3-sonnet-20240229" ;;
        4) LAYERED_AI_DEFAULT_MODEL="gpt-4" ;;
        5) LAYERED_AI_DEFAULT_MODEL="grok-beta" ;;
        *) LAYERED_AI_DEFAULT_MODEL="deepseek-coder-v2:lite" ;;
    esac
    
    # Zapisz konfigurację
    save_ai_config "$claude_key" "$gpt_key" "$grok_key"
    
    echo -e "${GREEN}✅ Konfiguracja AI zakończona${NC}"
    echo -e "${BLUE}🎯 Domyślny model: $LAYERED_AI_DEFAULT_MODEL${NC}"
    
    # Testowanie
    echo ""
    echo -e "${BLUE}🧪 Testowanie połączenia...${NC}"
    if ai_test_connection; then
        echo -e "${GREEN}✅ Połączenie z AI działa poprawnie${NC}"
    else
        echo -e "${YELLOW}⚠️  Problem z połączeniem - używam trybu mock${NC}"
    fi
}

save_ai_config() {
    local claude_key="$1"
    local gpt_key="$2"
    local grok_key="$3"
    
    # Zapisz klucze API w bezpiecznym pliku
    cat > "$LAYERED_AI_CONFIG" << EOF
# Layered ZSH AI Configuration
LAYERED_AI_ENABLED=$LAYERED_AI_ENABLED
LAYERED_AI_DEFAULT_MODEL="$LAYERED_AI_DEFAULT_MODEL"
LAYERED_AI_FALLBACK_MODEL="$LAYERED_AI_FALLBACK_MODEL"

# API Keys (bezpieczne przechowywanie)
CLAUDE_API_KEY="$claude_key"
GPT_API_KEY="$gpt_key"
GROK_API_KEY="$grok_key"

# Free Models Configuration
EOF
    
    # Dodaj konfigurację darmowych modeli
    for model in "${!LAYERED_AI_FREE_MODELS[@]}"; do
        echo "FREE_MODEL_$model=\"${LAYERED_AI_FREE_MODELS[$model]}\"" >> "$LAYERED_AI_CONFIG"
    done
    
    # Dodaj konfigurację płatnych modeli
    for model in "${!LAYERED_AI_PREMIUM_MODELS[@]}"; do
        echo "PREMIUM_MODEL_$model=\"${LAYERED_AI_PREMIUM_MODELS[$model]}\"" >> "$LAYERED_AI_CONFIG"
    done
    
    # Ustaw uprawnienia
    chmod 600 "$LAYERED_AI_CONFIG"
}

load_ai_config() {
    if [[ -f "$LAYERED_AI_CONFIG" ]]; then
        source "$LAYERED_AI_CONFIG"
    fi
}

ai_status() {
    echo -e "${BLUE}🤖 Status systemu AI Layered ZSH${NC}"
    echo "=================================="
    echo ""
    
    echo -e "${GREEN}🔧 Włączone: $LAYERED_AI_ENABLED${NC}"
    echo -e "${BLUE}🎯 Domyślny model: $LAYERED_AI_DEFAULT_MODEL${NC}"
    echo -e "${YELLOW}🔄 Fallback: $LAYERED_AI_FALLBACK_MODEL${NC}"
    echo ""
    
    # Status Ollama
    if command -v ollama >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Ollama: zainstalowane${NC}"
        
        # Lista dostępnych modeli
        echo -e "${BLUE}📦 Dostępne modele Ollama:${NC}"
        ollama list 2>/dev/null | grep -E "(deepseek|llama|codellama|mistral)" | while read -r line; do
            echo "  • $line"
        done
    else
        echo -e "${RED}❌ Ollama: nie zainstalowane${NC}"
    fi
    
    echo ""
    
    # Status API keys
    echo -e "${BLUE}🔑 Status kluczy API:${NC}"
    [[ -n "$CLAUDE_API_KEY" ]] && echo -e "${GREEN}✅ Claude API key: skonfigurowany${NC}" || echo -e "${RED}❌ Claude API key: brak${NC}"
    [[ -n "$GPT_API_KEY" ]] && echo -e "${GREEN}✅ GPT API key: skonfigurowany${NC}" || echo -e "${RED}❌ GPT API key: brak${NC}"
    [[ -n "$GROK_API_KEY" ]] && echo -e "${GREEN}✅ Grok API key: skonfigurowany${NC}" || echo -e "${RED}❌ Grok API key: brak${NC}"
    
    echo ""
    
    # Cache status
    local cache_size=$(du -sh "$LAYERED_AI_CACHE" 2>/dev/null | cut -f1)
    echo -e "${BLUE}💾 Cache AI: $cache_size${NC}"
    
    # Logs status
    local log_count=$(find "$LAYERED_AI_LOGS" -name "*.log" 2>/dev/null | wc -l)
    echo -e "${BLUE}📜 Logi AI: $log_count plików${NC}"
}

ai_test_connection() {
    # Testowanie domyślnego modelu
    case "$LAYERED_AI_DEFAULT_MODEL" in
        *deepseek*|*llama*|*codellama*|*mistral*)
            # Test Ollama
            if command -v ollama >/dev/null 2>&1; then
                ollama list | grep -q "$(echo "$LAYERED_AI_DEFAULT_MODEL" | cut -d':' -f1)" && return 0
            fi
            ;;
        *claude*)
            # Test Claude API
            if [[ -n "$CLAUDE_API_KEY" ]]; then
                curl -s -o /dev/null -w "%{http_code}" \
                    -H "x-api-key: $CLAUDE_API_KEY" \
                    -H "content-type: application/json" \
                    -d '{"model":"claude-3-sonnet-20240229","max_tokens":10,"messages":[{"role":"user","content":"test"}]}' \
                    "https://api.anthropic.com/v1/messages" | grep -q "200" && return 0
            fi
            ;;
        *gpt*)
            # Test GPT API
            if [[ -n "$GPT_API_KEY" ]]; then
                curl -s -o /dev/null -w "%{http_code}" \
                    -H "Authorization: Bearer $GPT_API_KEY" \
                    -H "content-type: application/json" \
                    -d '{"model":"gpt-4","max_tokens":10,"messages":[{"role":"user","content":"test"}]}' \
                    "https://api.openai.com/v1/chat/completions" | grep -q "200" && return 0
            fi
            ;;
        *grok*)
            # Test Grok API
            if [[ -n "$GROK_API_KEY" ]]; then
                curl -s -o /dev/null -w "%{http_code}" \
                    -H "Authorization: Bearer $GROK_API_KEY" \
                    -H "content-type: application/json" \
                    -d '{"model":"grok-beta","max_tokens":10,"messages":[{"role":"user","content":"test"}]}' \
                    "https://api.x.ai/v1/chat/completions" | grep -q "200" && return 0
            fi
            ;;
    esac
    
    return 1
}

# =============================================================================
# GŁÓWNA FUNKCJA AI (ENHANCED)
# =============================================================================

ai() {
    [[ $LAYERED_MODE == "immutable" ]] && echo "🔒 AI zablokowane w trybie immutable" && return
    
    # Załaduj konfigurację
    load_ai_config
    
    local model="$LAYERED_AI_DEFAULT_MODEL"
    local force_model=""
    
    # Parsowanie argumentów
    while [[ $# -gt 0 ]]; do
        case $1 in
            -m|--model)
                model="$2"
                shift 2
                ;;
            -f|--force)
                force_model="$2"
                shift 2
                ;;
            -h|--help)
                ai_help
                return 0
                ;;
            *)
                break
                ;;
        esac
    done
    
    # Użyj force model jeśli podany
    [[ -n "$force_model" ]] && model="$force_model"
    
    local question="$*"
    
    # Sprawdź czy pytanie jest puste
    [[ -z "$question" ]] && echo "❌ Podaj pytanie" && return 1
    
    # Cache
    local cache_key=$(echo "$model$question" | sha256sum | cut -d' ' -f1)
    local cache_file="$LAYERED_AI_CACHE/$cache_key.md"
    
    # Sprawdź cache
    if [[ -f "$cache_file" ]]; then
        local cache_age=$(($(date +%s) - $(stat -c %Y "$cache_file" 2>/dev/null || echo 0)))
        if [[ $cache_age -lt 3600 ]]; then  # 1 godzina
            cat "$cache_file"
            return 0
        fi
    fi
    
    # Wywołaj AI w zależności od modelu
    local response=""
    
    case "$model" in
        *deepseek*|*llama*|*codellama*|*mistral*)
            response=$(ai_call_ollama "$model" "$question")
            ;;
        *claude*)
            response=$(ai_call_claude "$question")
            ;;
        *gpt*)
            response=$(ai_call_gpt "$question")
            ;;
        *grok*)
            response=$(ai_call_grok "$question")
            ;;
        *)
            echo "❌ Nieznany model: $model"
            return 1
            ;;
    esac
    
    # Jeśli odpowiedź jest pusta, użyj fallback
    if [[ -z "$response" ]]; then
        echo -e "${YELLOW}⚠️  Problem z modelem $model, używam fallback${NC}"
        response=$(ai_call_ollama "$LAYERED_AI_FALLBACK_MODEL" "$question")
    fi
    
    # Jeśli nadal pusta, użyj mock
    if [[ -z "$response" ]]; then
        response=$(ai_mock_response "$question")
    fi
    
    # Zapisz do cache
    echo "$response" > "$cache_file"
    
    # Loguj użycie
    ai_log_usage "$model" "$question"
    
    # Wyświetl odpowiedź
    echo "$response"
}

# =============================================================================
# FUNKCJE WYWOŁUJĄCE RÓŻNE MODELE
# =============================================================================

ai_call_ollama() {
    local model="$1"
    local question="$2"
    
    if ! command -v ollama >/dev/null 2>&1; then
        return 1
    fi
    
    # Sprawdź czy model jest dostępny
    if ! ollama list | grep -q "$(echo "$model" | cut -d':' -f1)"; then
        echo -e "${YELLOW}📥 Pobieranie modelu $model...${NC}"
        ollama pull "$model" >/dev/null 2>&1
    fi
    
    # Wywołaj Ollama
    ollama run "$model" "INSTRUKCJA: Odpowiadaj wyłącznie po polsku. Bądź pomocny i zwięzły. $question" 2>/dev/null
}

ai_call_claude() {
    local question="$1"
    
    if [[ -z "$CLAUDE_API_KEY" ]]; then
        return 1
    fi
    
    local response=$(curl -s \
        -H "x-api-key: $CLAUDE_API_KEY" \
        -H "content-type: application/json" \
        -d "{
            \"model\": \"claude-3-sonnet-20240229\",
            \"max_tokens\": 1000,
            \"messages\": [
                {
                    \"role\": \"user\",
                    \"content\": \"Odpowiedz wyłącznie po polsku. $question\"
                }
            ]
        }" \
        "https://api.anthropic.com/v1/messages" 2>/dev/null)
    
    if echo "$response" | grep -q "content"; then
        echo "$response" | jq -r '.content[0].text' 2>/dev/null
    fi
}

ai_call_gpt() {
    local question="$1"
    
    if [[ -z "$GPT_API_KEY" ]]; then
        return 1
    fi
    
    local response=$(curl -s \
        -H "Authorization: Bearer $GPT_API_KEY" \
        -H "content-type: application/json" \
        -d "{
            \"model\": \"gpt-4\",
            \"max_tokens\": 1000,
            \"messages\": [
                {
                    \"role\": \"user\",
                    \"content\": \"Odpowiedz wyłącznie po polsku. $question\"
                }
            ]
        }" \
        "https://api.openai.com/v1/chat/completions" 2>/dev/null)
    
    if echo "$response" | grep -q "choices"; then
        echo "$response" | jq -r '.choices[0].message.content' 2>/dev/null
    fi
}

ai_call_grok() {
    local question="$1"
    
    if [[ -z "$GROK_API_KEY" ]]; then
        return 1
    fi
    
    local response=$(curl -s \
        -H "Authorization: Bearer $GROK_API_KEY" \
        -H "content-type: application/json" \
        -d "{
            \"model\": \"grok-beta\",
            \"max_tokens\": 1000,
            \"messages\": [
                {
                    \"role\": \"user\",
                    \"content\": \"Odpowiedz wyłącznie po polsku. $question\"
                }
            ]
        }" \
        "https://api.x.ai/v1/chat/completions" 2>/dev/null)
    
    if echo "$response" | grep -q "choices"; then
        echo "$response" | jq -r '.choices[0].message.content' 2>/dev/null
    fi
}

ai_mock_response() {
    local question="$1"
    
    echo "🤖 Layered ZSH AI (Mock Mode)"
    echo "============================="
    echo ""
    echo "Pytanie: $question"
    echo ""
    
    case "$question" in
        *"test"*|*"działa"*)
            echo "✅ System Layered ZSH działa poprawnie!"
            echo "🎯 Tryb: $LAYERED_MODE"
            echo "🤖 AI: Mock Mode (brak połączenia)"
            echo "📊 Wszystkie warstwy załadowane."
            ;;
        *"status"*|*"jak"*)
            echo "📊 Status Layered ZSH:"
            echo "- Tryb pracy: $LAYERED_MODE"
            echo "- AI: Mock Mode"
            echo "- Monitoring: $(monitor-status 2>/dev/null | grep AKTYWNY >/dev/null && echo "AKTYWNY" || echo "NIEAKTYWNY")"
            echo "- Security: AKTYWNY"
            ;;
        *"pomoc"*|*"help"*)
            echo "🚀 Dostępne komendy AI:"
            echo "- ai 'pytanie' - podstawowe AI"
            echo "- ai -m model 'pytanie' - konkretny model"
            echo "- ai -f model 'pytanie' - wymuś model"
            echo "- ai_setup - konfiguracja AI"
            echo "- ai_status - status AI"
            echo "- ai_clear - wyczyść cache AI"
            ;;
        *)
            echo "🤖 Mock odpowiedź na: $question"
            echo "Zainstaluj Ollama lub skonfiguruj klucze API dla pełnych funkcji AI."
            ;;
    esac
}

# =============================================================================
# FUNKCJE POMOCNICZE
# =============================================================================

ai_help() {
    echo -e "${BLUE}🤖 Layered ZSH AI - Pomoc${NC}"
    echo "=========================="
    echo ""
    echo "📋 Dostępne komendy:"
    echo "  ai 'pytanie'                    - podstawowe AI"
    echo "  ai -m model 'pytanie'           - konkretny model"
    echo "  ai -f model 'pytanie'           - wymuś model"
    echo "  ai_setup                         - konfiguracja AI"
    echo "  ai_status                        - status AI"
    echo "  ai_clear                         - wyczyść cache AI"
    echo "  ai_test                          - test połączenia"
    echo ""
    echo "🎯 Dostępne modele:"
    echo "  🆓 Darmowe: deepseek, llama, codellama, mistral"
    echo "  💳 Płatne: claude, gpt, gpt-3.5, grok"
    echo ""
    echo "🔑 Konfiguracja API:"
    echo "  ai_setup - interaktywna konfiguracja"
    echo ""
    echo "💡 Przykłady:"
    echo "  ai 'jak działa Layered ZSH?'"
    echo "  ai -m claude 'pomoc z kodem'"
    echo "  ai -f grok 'analiza systemu'"
}

ai_clear() {
    echo -e "${YELLOW}🧹 Czyszczenie cache AI...${NC}"
    rm -rf "$LAYERED_AI_CACHE"
    mkdir -p "$LAYERED_AI_CACHE"
    echo -e "${GREEN}✅ Cache AI wyczyszczone${NC}"
}

ai_log_usage() {
    local model="$1"
    local question="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo "$timestamp - Model: $model - Question: ${question:0:50}..." >> "$LAYERED_AI_LOGS/usage.log"
}

ai_show_logs() {
    echo -e "${BLUE}📜 Logi użycia AI${NC}"
    echo "=================="
    
    if [[ -f "$LAYERED_AI_LOGS/usage.log" ]]; then
        tail -20 "$LAYERED_AI_LOGS/usage.log"
    else
        echo "Brak logów użycia"
    fi
}

# =============================================================================
# ALIASY
# =============================================================================

alias sc='ai'
alias si='ai -f'
alias ai_setup='ai_setup'
alias ai_status='ai_status'
alias ai_clear='ai_clear'
alias ai_test='ai_test_connection'
alias ai_logs='ai_show_logs'

# =============================================================================
# INICJALIZACJA
# =============================================================================

# Załaduj konfigurację
load_ai_config

echo "🤖 Enhanced AI system załadowany"
echo "💡 Komendy: ai, ai_setup, ai_status, ai_clear, ai_test"
echo "🎯 Dostępne modele: deepseek, llama, claude, gpt, grok"
