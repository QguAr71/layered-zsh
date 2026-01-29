#!/bin/bash

# =============================================================================
# LAYERED ZSH - PERFORMANCE BENCHMARKING SUITE
# =============================================================================
# 
# Kompleksowy system testów wydajnościowych dla Layered ZSH
# Testy startu, zużycia pamięci, wydajności funkcji
# 
# Wersja: v3.1
# Autor: Layered ZSH Team
# =============================================================================

set -e

# Kolory
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Konfiguracja
BENCHMARK_DIR="$HOME/.local/share/layered/benchmarks"
RESULTS_DIR="$BENCHMARK_DIR/results"
COMPARISON_DIR="$BENCHMARK_DIR/comparisons"

# Upewnij się, że katalogi istnieją
mkdir -p "$RESULTS_DIR" "$COMPARISON_DIR"

# =============================================================================
# FUNKCJE POMOCNICZE
# =============================================================================

show_header() {
    echo -e "${BLUE}🚀 Layered ZSH Performance Benchmarking Suite${NC}"
    echo -e "${BLUE}===============================================${NC}"
    echo -e "${CYAN}Testy wydajnościowe dla Layered ZSH v3.1${NC}"
    echo ""
}

format_time() {
    local time_ns="$1"
    local time_ms=$((time_ns / 1000000))
    local time_sec=$((time_ms / 1000))
    
    if [[ $time_sec -gt 0 ]]; then
        echo "${time_sec}s"
    elif [[ $time_ms -gt 0 ]]; then
        echo "${time_ms}ms"
    else
        echo "${time_ns}ns"
    fi
}

format_memory() {
    local memory_kb="$1"
    local memory_mb=$((memory_kb / 1024))
    
    if [[ $memory_mb -gt 0 ]]; then
        echo "${memory_mb}MB"
    else
        echo "${memory_kb}KB"
    fi
}

get_timestamp() {
    date '+%Y%m%d-%H%M%S'
}

# =============================================================================
# TEST 1: STARTUP TIME BENCHMARK
# =============================================================================

benchmark_startup() {
    echo -e "${CYAN}📊 Test 1: Czas startu Layered ZSH${NC}"
    echo "=========================================="
    
    local iterations=10
    local total_time=0
    local times=()
    
    echo "🔄 Testowanie czasu startu ($iterations iteracji)..."
    
    for ((i=1; i<=iterations; i++)); do
        echo -n "  Iteracja $i/$iterations... "
        
        # Start time
        local start_time=$(date +%s%N)
        
        # Test ładowania w czystym środowisku
        zsh -c "source ~/.config/layered/core/init.zsh" >/dev/null 2>&1
        
        # End time
        local end_time=$(date +%s%N)
        local duration=$((end_time - start_time))
        
        times+=($duration)
        total_time=$((total_time + duration))
        
        echo "$(format_time $duration)"
    done
    
    # Obliczenia
    local avg_time=$((total_time / iterations))
    
    # Sort times for median
    IFS=$'\n' sorted_times=($(sort -n <<<"${times[*]}"))
    unset IFS
    
    local median_time=${sorted_times[$((iterations / 2))]}
    
    # Min/Max
    local min_time=${sorted_times[0]}
    local max_time=${sorted_times[$((iterations - 1))]}
    
    echo ""
    echo -e "${GREEN}📊 Wyniki czasu startu:${NC}"
    echo "  Średni czas: $(format_time $avg_time)"
    echo "  Mediana:      $(format_time $median_time)"
    echo "  Minimum:      $(format_time $min_time)"
    echo "  Maksimum:     $(format_time $max_time)"
    echo ""
    
    # Zapisz wyniki
    local timestamp=$(get_timestamp)
    local results_file="$RESULTS_DIR/startup-$timestamp.txt"
    
    cat > "$results_file" << EOF
Layered ZSH Startup Benchmark
Timestamp: $timestamp
Iterations: $iterations

Results:
Average: $(format_time $avg_time)
Median:  $(format_time $median_time)
Min:     $(format_time $min_time)
Max:     $(format_time $max_time)

Raw times (ns):
$(printf "%s\n" "${times[@]}")
EOF
    
    echo "📁 Wyniki zapisane: $results_file"
    
    # Ocena wydajności
    if [[ $avg_time -lt 100000000 ]]; then  # < 100ms
        echo -e "${GREEN}✅ Wydajność startu: DOSKONAŁA (< 100ms)${NC}"
    elif [[ $avg_time -lt 500000000 ]]; then  # < 500ms
        echo -e "${GREEN}✅ Wydajność startu: DOBRA (< 500ms)${NC}"
    elif [[ $avg_time -lt 1000000000 ]]; then  # < 1s
        echo -e "${YELLOW}⚠️  Wydajność startu: AKCEPTOWALNA (< 1s)${NC}"
    else
        echo -e "${RED}❌ Wydajność startu: WOLNA (> 1s)${NC}"
    fi
    
    echo ""
}

# =============================================================================
# TEST 2: MEMORY USAGE BENCHMARK
# =============================================================================

benchmark_memory() {
    echo -e "${CYAN}📊 Test 2: Zużycie pamięci${NC}"
    echo "================================"
    
    echo "🔄 Testowanie zużycia pamięci..."
    
    # Pobierz PID shell
    local shell_pid=$$
    
    # Zużycie pamięci przed załadowaniem
    local memory_before=$(ps -o rss= -p $shell_pid | tr -d ' ')
    
    # Załaduj Layered ZSH
    zsh -c "source ~/.config/layered/core/init.zsh" &
    local layered_pid=$!
    
    # Czekaj na pełne załadowanie
    sleep 2
    
    # Zużycie pamięci po załadowaniu
    local memory_after=$(ps -o rss= -p $layered_pid | tr -d ' ')
    
    # Różnica
    local memory_diff=$((memory_after - memory_before))
    
    echo -e "${GREEN}📊 Wyniki zużycia pamięci:${NC}"
    echo "  Przed załadowaniem: $(format_memory $memory_before)"
    echo "  Po załadowaniu:    $(format_memory $memory_after)"
    echo "  Różnica:           $(format_memory $memory_diff)"
    echo ""
    
    # Zapisz wyniki
    local timestamp=$(get_timestamp)
    local results_file="$RESULTS_DIR/memory-$timestamp.txt"
    
    cat > "$results_file" << EOF
Layered ZSH Memory Benchmark
Timestamp: $timestamp

Results:
Before: $(format_memory $memory_before)
After:  $(format_memory $memory_after)
Diff:   $(format_memory $memory_diff)

Raw values (KB):
Before: $memory_before
After:  $memory_after
Diff:   $memory_diff
EOF
    
    echo "📁 Wyniki zapisane: $results_file"
    
    # Ocena wydajności
    if [[ $memory_diff -lt 10240 ]]; then  # < 10MB
        echo -e "${GREEN}✅ Zużycie pamięci: DOSKONALE (< 10MB)${NC}"
    elif [[ $memory_diff -lt 51200 ]]; then  # < 50MB
        echo -e "${GREEN}✅ Zużycie pamięci: DOBRE (< 50MB)${NC}"
    elif [[ $memory_diff -lt 102400 ]]; then  # < 100MB
        echo -e "${YELLOW}⚠️  Zużycie pamięci: AKCEPTOWALNE (< 100MB)${NC}"
    else
        echo -e "${RED}❌ Zużycie pamięci: WYSOKIE (> 100MB)${NC}"
    fi
    
    # Zakończ proces
    kill $layered_pid 2>/dev/null
    
    echo ""
}

# =============================================================================
# TEST 3: FUNCTION PERFORMANCE BENCHMARK
# =============================================================================

benchmark_functions() {
    echo -e "${CYAN}📊 Test 3: Wydajność funkcji${NC}"
    echo "================================="
    
    # Testowane funkcje
    local functions=("lhelp" "status" "hud" "lbackup_info")
    local iterations=20
    
    echo "🔄 Testowanie wydajności funkcji ($iterations iteracji)..."
    
    for func in "${functions[@]}"; do
        echo -n "  $func: "
        
        # Sprawdź czy funkcja istnieje
        if ! zsh -c "source ~/.config/layered/core/init.zsh && command -v $func" >/dev/null 2>&1; then
            echo -e "${RED}❌ Funkcja nie istnieje${NC}"
            continue
        fi
        
        local total_time=0
        local times=()
        
        for ((i=1; i<=iterations; i++)); do
            local start_time=$(date +%s%N)
            
            # Wykonaj funkcję
            zsh -c "source ~/.config/layered/core/init.zsh && $func" >/dev/null 2>&1
            
            local end_time=$(date +%s%N)
            local duration=$((end_time - start_time))
            
            times+=($duration)
            total_time=$((total_time + duration))
        done
        
        local avg_time=$((total_time / iterations))
        echo "$(format_time $avg_time)"
        
        # Ocena wydajności
        if [[ $avg_time -lt 50000000 ]]; then  # < 50ms
            echo -e "    ${GREEN}✅ Szybka${NC}"
        elif [[ $avg_time -lt 100000000 ]]; then  # < 100ms
            echo -e "    ${YELLOW}⚠️  Średnia${NC}"
        else
            echo -e "    ${RED}❌ Wolna${NC}"
        fi
    done
    
    echo ""
}

# =============================================================================
# TEST 4: COMPARISON BENCHMARK
# =============================================================================

benchmark_comparison() {
    echo -e "${CYAN}📊 Test 4: Porównanie z innymi konfiguracjami${NC}"
    echo "============================================"
    
    echo "🔄 Porównywanie z innymi konfiguracjami..."
    
    # Test czystego Zsh
    echo -n "  Czysty Zsh: "
    local start_time=$(date +%s%N)
    zsh -c "echo 'test'" >/dev/null 2>&1
    local end_time=$(date +%s%N)
    local clean_time=$((end_time - start_time))
    echo "$(format_time $clean_time)"
    
    # Test Oh My Zsh (jeśli zainstalowany)
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        echo -n "  Oh My Zsh: "
        local start_time=$(date +%s%N)
        zsh -c "source ~/.oh-my-zsh/oh-my-zsh.sh" >/dev/null 2>&1
        local end_time=$(date +%s%N)
        local omz_time=$((end_time - start_time))
        echo "$(format_time $omz_time)"
        
        # Porównanie
        local ratio=$((clean_time * 100 / omz_time))
        if [[ $ratio -gt 100 ]]; then
            echo -e "    ${GREEN}✅ Layered ZSH jest $((ratio - 100))% szybszy${NC}"
        else
            echo -e "    ${RED}❌ Oh My Zsh jest $((100 - ratio))% szybszy${NC}"
        fi
    else
        echo "  Oh My Zsh: ${YELLOW}nie zainstalowany${NC}"
    fi
    
    # Test Prezto (jeśli zainstalowany)
    if [[ -d "$HOME/.zprezto" ]]; then
        echo -n "  Prezto: "
        local start_time=$(date +%s%N)
        zsh -c "source ~/.zprezto/init.zsh" >/dev/null 2>&1
        local end_time=$(date +%s%N)
        local prezto_time=$((end_time - start_time))
        echo "$(format_time $prezto_time)"
        
        # Porównanie
        local ratio=$((clean_time * 100 / prezto_time))
        if [[ $ratio -gt 100 ]]; then
            echo -e "    ${GREEN}✅ Layered ZSH jest $((ratio - 100))% szybszy${NC}"
        else
            echo -e "    ${RED}❌ Prezto jest $((100 - ratio))% szybszy${NC}"
        fi
    else
        echo "  Prezto: ${YELLOW}nie zainstalowany${NC}"
    fi
    
    echo ""
}

# =============================================================================
# TEST 5: SYSTEM RESOURCE BENCHMARK
# =============================================================================

benchmark_system() {
    echo -e "${CYAN}📊 Test 5: Zasoby systemowe${NC}"
    echo "==============================="
    
    echo "🔄 Testowanie zasobów systemowych..."
    
    # CPU usage
    echo -n "  CPU usage: "
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    echo "${cpu_usage}%"
    
    # Memory usage
    echo -n "  Memory usage: "
    local mem_usage=$(free | grep Mem | awk '{printf "%.1f%%", $3/$2 * 100.0}')
    echo "$mem_usage"
    
    # Disk usage
    echo -n "  Disk usage: "
    local disk_usage=$(df -h ~/.config/layered | tail -1 | awk '{print $5}')
    echo "$disk_usage"
    
    # Load average
    echo -n "  Load average: "
    local load_avg=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | tr -d ',')
    echo "$load_avg"
    
    echo ""
}

# =============================================================================
# GENEROWANIE RAPORTU
# =============================================================================

generate_report() {
    echo -e "${CYAN}📊 Generowanie raportu${NC}"
    echo "========================"
    
    local timestamp=$(get_timestamp)
    local report_file="$RESULTS_DIR/benchmark-report-$timestamp.txt"
    
    cat > "$report_file" << EOF
Layered ZSH Performance Benchmark Report
========================================
Generated: $(date)
System: $(uname -a)
Shell: $SHELL
Zsh version: $(zsh --version)

Test Results:
------------

EOF
    
    # Dodaj wyniki z plików
    for result_file in "$RESULTS_DIR"/*-$(date +%Y%m%d)*.txt; do
        if [[ -f "$result_file" ]]; then
            echo "" >> "$report_file"
            echo "$(basename "$result_file" .txt | tr '-' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')" >> "$report_file"
            echo "----------------------------------------" >> "$report_file"
            cat "$result_file" >> "$report_file"
        fi
    done
    
    echo -e "${GREEN}📁 Raport wygenerowany: $report_file${NC}"
    
    # Podsumowanie
    echo ""
    echo -e "${BLUE}📊 Podsumowanie benchmarkingu:${NC}"
    echo "=================================="
    echo "📁 Wszystkie wyniki: $RESULTS_DIR"
    echo "📄 Raport: $report_file"
    echo "📅 Data: $(date)"
    echo ""
}

# =============================================================================
# FUNKCJE POMOCNICZE DLA BENCHMARKINGU
# =============================================================================

run_all_benchmarks() {
    show_header
    
    # Uruchom wszystkie testy
    benchmark_startup
    benchmark_memory
    benchmark_functions
    benchmark_comparison
    benchmark_system
    
    # Generuj raport
    generate_report
    
    echo -e "${GREEN}🎉 Benchmarking zakończony!${NC}"
}

run_quick_benchmark() {
    show_header
    
    echo -e "${YELLOW}🚀 Szybki benchmark (tylko podstawowe testy)${NC}"
    echo ""
    
    benchmark_startup
    benchmark_memory
    
    echo -e "${GREEN}✅ Szybki benchmark zakończony!${NC}"
}

show_history() {
    echo -e "${CYAN}📊 Historia benchmarków${NC}"
    echo "=========================="
    
    if [[ ! -d "$RESULTS_DIR" ]] || [[ -z "$(ls -A "$RESULTS_DIR" 2>/dev/null)" ]]; then
        echo "❌ Brak wyników benchmarkingu"
        return 1
    fi
    
    echo "📁 Wyniki w: $RESULTS_DIR"
    echo ""
    
    # Pokaż ostatnie wyniki
    echo "📊 Ostatnie benchmarki:"
    ls -lt "$RESULTS_DIR"/*.txt 2>/dev/null | head -10 | while read -r line; do
        local file=$(echo "$line" | awk '{print $9}')
        local date=$(echo "$line" | awk '{print $6, $7, $8}')
        local name=$(basename "$file" .txt)
        echo "  📄 $name ($date)"
    done
}

clean_results() {
    echo -e "${YELLOW}🧹 Czyszczenie wyników benchmarkingu${NC}"
    
    if [[ -d "$RESULTS_DIR" ]]; then
        rm -rf "$RESULTS_DIR"
        echo "✅ Wyniki usunięte"
    else
        echo "ℹ️  Brak wyników do usunięcia"
    fi
}

# =============================================================================
# MENU GŁÓWNE
# =============================================================================

show_menu() {
    echo -e "${BLUE}🚀 Layered ZSH Performance Benchmarking${NC}"
    echo -e "${BLUE}=====================================${NC}"
    echo ""
    echo "1. 📊 Pełny benchmark (wszystkie testy)"
    echo "2. ⚡ Szybki benchmark (podstawowe testy)"
    echo "3. 📈 Tylko czas startu"
    echo "4. 💾 Tylko zużycie pamięci"
    echo "5. ⚙️  Tylko wydajność funkcji"
    echo "6. 🔍 Tylko porównanie"
    echo "7. 📋 Pokaż historię"
    echo "8. 🧹 Wyczyść wyniki"
    echo "9. 🚪 Wyjście"
    echo ""
}

# =============================================================================
# GŁÓWNA FUNKCJA
# =============================================================================

main() {
    # Sprawdzenie argumentów
    case "${1:-}" in
        "full"|"all")
            run_all_benchmarks
            return 0
            ;;
        "quick"|"fast")
            run_quick_benchmark
            return 0
            ;;
        "startup")
            benchmark_startup
            return 0
            ;;
        "memory")
            benchmark_memory
            return 0
            ;;
        "functions")
            benchmark_functions
            return 0
            ;;
        "comparison")
            benchmark_comparison
            return 0
            ;;
        "history")
            show_history
            return 0
            ;;
        "clean")
            clean_results
            return 0
            ;;
        "help"|"-h"|"--help")
            echo "Użycie: $0 [opcja]"
            echo ""
            echo "Opcje:"
            echo "  full, all     - Pełny benchmark"
            echo "  quick, fast  - Szybki benchmark"
            echo "  startup      - Tylko czas startu"
            echo "  memory       - Tylko zużycie pamięci"
            echo "  functions    - Tylko wydajność funkcji"
            echo "  comparison   - Tylko porównanie"
            echo "  history      - Pokaż historię"
            echo "  clean        - Wyczyść wyniki"
            echo "  help         - Pokaż pomoc"
            return 0
            ;;
    esac
    
    # Interaktywne menu
    while true; do
        show_menu
        echo -n "Wybierz opcję (1-9): "
        read -r choice
        
        case $choice in
            1)
                run_all_benchmarks
                ;;
            2)
                run_quick_benchmark
                ;;
            3)
                benchmark_startup
                ;;
            4)
                benchmark_memory
                ;;
            5)
                benchmark_functions
                ;;
            6)
                benchmark_comparison
                ;;
            7)
                show_history
                ;;
            8)
                clean_results
                ;;
            9)
                echo -e "${GREEN}👋 Do widzenia!${NC}"
                break
                ;;
            *)
                echo -e "${RED}❌ Nieprawidłowa opcja${NC}"
                ;;
        esac
        
        echo ""
        echo -n "Naciśnij Enter, aby kontynuować..."
        read -r
    done
}

# Uruchomienie
main "$@"
