# AI CACHE - zarządzanie cache odpowiedzi AI

ai_cache_valid() {
  local file="$1"
  local max_age=86400  # 24 godziny
  
  [[ ! -f "$file" ]] && return 1
  
  local file_age=$(($(date +%s) - $(stat -c %Y "$file" 2>/dev/null || echo 0)))
  [[ $file_age -lt $max_age ]]
}

ai_cache_clear() {
  rm -rf "$AI_CACHE"/*.md 2>/dev/null
  echo "🗑️ AI cache wyczyszczony"
}

ai_cache_size() {
  local size=$(du -sh "$AI_CACHE" 2>/dev/null | cut -f1 || echo "0B")
  echo "📊 AI cache size: $size"
}

ai_cache_list() {
  echo "📋 AI cache entries:"
  ls -la "$AI_CACHE"/*.md 2>/dev/null | wc -l
  [[ -n "$(ls "$AI_CACHE"/*.md 2>/dev/null)" ]] && ls -la "$AI_CACHE"/*.md
}

# Aliasy cache
alias ai-clear='ai_cache_clear'
alias ai-size='ai_cache_size'
alias ai-list='ai_cache_list'
