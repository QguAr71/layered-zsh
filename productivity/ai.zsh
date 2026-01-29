# AI ZSH - rozszerzone funkcje AI

# Funkcja fix - automatyczne naprawy systemu
fix() {
  echo "🔧 Layered ZSH - Diagnoza i naprawa systemu"
  echo "=========================================="
  
  # Sprawdzanie problemów
  local problems=()
  local solutions=()
  
  # 1. Sprawdź systemd services
  echo "📋 Sprawdzanie systemd services..."
  local failed_services=$(systemctl --failed --no-legend 2>/dev/null | awk '{print $1}')
  if [[ -n "$failed_services" ]]; then
    problems+=("Failed systemd services: $failed_services")
    solutions+=("sudo systemctl restart $failed_services")
  fi
  
  # 2. Sprawdź przestrzeń dyskową
  echo "💾 Sprawdzanie przestrzeni dyskowej..."
  local disk_usage=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
  if [[ "$disk_usage" -gt 90 ]]; then
    problems+=("Niska przestrzeń dyskowa: ${disk_usage}%")
    solutions+=("sudo pacman -Sc && sudo pacman -Scc")
  fi
  
  # 3. Sprawdź pamięć RAM
  echo "🧠 Sprawdzanie pamięci RAM..."
  local ram_usage=$(free | awk '/^Mem:/ {printf "%.0f", $3/$2*100}')
  if [[ "$ram_usage" -gt 90 ]]; then
    problems+=("Wysokie użycie RAM: ${ram_usage}%")
    solutions+=("sudo systemctl restart --user && echo 3 > /proc/sys/vm/drop_caches")
  fi
  
  # 4. Sprawdź temperaturę
  echo "🌡️ Sprawdzanie temperatury..."
  if command -v sensors >/dev/null 2>&1; then
    local temp=$(sensors | grep -m1 'Package id 0:' | awk '{print $4}' | tr -d '+°C' 2>/dev/null)
    if [[ -n "$temp" && "${temp%.*}" -gt 80 ]]; then
      problems+=("Wysoka temperatura CPU: ${temp}°C")
      solutions+=("sudo systemctl stop thermald && sudo sensors-detect")
    fi
  fi
  
  # 5. Sprawdź coredumps
  echo "💥 Sprawdzanie awarii..."
  local coredumps=$(coredumpctl list --since yesterday --no-legend 2>/dev/null | wc -l)
  if [[ "$coredumps" -gt 0 ]]; then
    problems+=("$coredumps awarii systemu")
    solutions+=("coredumpctl list --since yesterday && journalctl -p 3 -xb")
  fi
  
  # 6. Sprawdź aktualizacje
  echo "📦 Sprawdzanie aktualizacje..."
  local updates=$(checkupdates 2>/dev/null | wc -l)
  if [[ "$updates" -gt 0 ]]; then
    problems+=("$updates dostępnych aktualizacji")
    solutions+=("sudo pacman -Syu")
  fi
  
  # 7. Sprawdź DNS
  echo "🌐 Sprawdzanie DNS..."
  if ! nslookup google.com >/dev/null 2>&1; then
    problems+=("Problem z DNS")
    solutions+=("sudo systemctl restart systemd-resolved && sudo systemctl restart NetworkManager")
  fi
  
  # 8. Sprawdź Zsh błędy
  echo "🐚 Sprawdzanie błędy Zsh..."
  if [[ -f ~/.zshrc ]]; then
    if zsh -n ~/.zshrc 2>/dev/null; then
      echo "✅ Zsh config OK"
    else
      problems+=("Błędy w konfiguracji Zsh")
      solutions+=("zsh -n ~/.zshrc && napraw błędy")
    fi
  fi
  
  echo ""
  echo "📊 WYNIKI DIAGNOZY:"
  echo "=================="
  
  if [[ ${#problems[@]} -eq 0 ]]; then
    echo "✅ Nie znaleziono problemów!"
    return 0
  fi
  
  # Wyświetl problemy
  for i in "${!problems[@]}"; do
    echo "❌ ${problems[$i]}"
    echo "💡 ${solutions[$i]}"
    echo ""
  done
  
  # Pytaj o naprawę
  echo "🔧 Czy chcesz wykonać automatyczne naprawy? (tak/nie): "
  read -r response
  
  if [[ "$response" =~ ^(tak|t|yes|y)$ ]]; then
    echo "🔧 Wykonuję naprawy..."
    
    # Wykonaj rozwiązania
    for solution in "${solutions[@]}"; do
      echo "🔧 Wykonuję: $solution"
      if eval "$solution" 2>/dev/null; then
        echo "✅ Ukończono"
      else
        echo "❌ Błąd wykonania"
      fi
      echo ""
    done
    
    echo "🎉 Naprawy zakończone!"
    echo "✅ Naprawione: $fixed"
    echo "❌ Błędy: $failed"
    
    if [[ $failed -gt 0 ]]; then
      echo ""
      echo "⚠️ Niektóre naprawy się nie powiodły. Sprawdź logi i wykonaj ręcznie."
    fi
    
  else
    echo ""
    echo "ℹ️ Naprawy anulowane. Możesz je wykonać ręcznie:"
    echo ""
    for i in "${!solutions[@]}"; do
      echo "${problems[$i]}"
      echo "💡 Ręcznie: ${solutions[$i]}"
      echo ""
    done
  fi
}

# Funkcja changelog - generuje changelog z git
changelog() {
  local n=${1:-10}
  local commits=$(git log --oneline -n "$n" 2>/dev/null)
  
  if [[ -z "$commits" ]]; then
    echo "❌ Nie jesteś w repozytorium git"
    return 1
  fi
  
  echo "$commits" | ai "Stwórz changelog z tych commitów. Po polsku. Format: - [typ] opis"
}

# Funkcja ask-zsh - pytanie AI o shell
ask-zsh() {
  ai "Pytanie o ZSH/shell: $*"
}

# Funkcja helpme - pomoc AI
helpme() {
  ai "Mam problem z: $*. Pomóż mi rozwiązać krok po kroku. Po polsku."
}

# Funkcja explain - wyjaśnij komendę
explain() {
  ai "Wyjaśnij co robi komenda '$*' i jakie są opcje. Po polsku."
}

# Funkcja optimize - optymalizuj kod
optimize() {
  local file="$1"
  [[ -z "$file" ]] && { echo "Podaj plik do optymalizacji"; return 1; }
  
  if [[ ! -f "$file" ]]; then
    echo "❌ Plik nie istnieje: $file"
    return 1
  fi
  
  cat "$file" | ai "Zoptymalizuj ten kod. Wyjaśnij zmiany. Po polsku."
}

# Dodatkowe aliasy
alias ask='ask-zsh'
alias helpme='helpme'
alias explain='explain'
alias optimize='optimize'
