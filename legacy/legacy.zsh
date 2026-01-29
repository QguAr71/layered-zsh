#!/bin/bash

# 🎯 LAYERED ZSH - LEGACY SIMPLE VERSION
# Prosta wersja, która naprawdę działa

# Kolory
export CLICOLOR=1
export LS_COLORS='di=34:fi=0:ln=35:pi=33:so=32:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'

# Podstawowe aliasy
alias ll='ls -la --color=auto'
alias la='ls -la --color=auto'
alias l='ls --color=auto'

# Nawigacja
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Przydatne
alias grep='grep --color=auto'
alias mkdir='mkdir -pv'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias df='df -h'
alias du='du -h'

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'

# Prosty, czytelny prompt
PROMPT='%F{blue}%n%f@%F{green}%m%f:%F{yellow}%~%f$ '
RPROMPT='%F{gray}%T%f'

# Użyteczne funkcje

# Tworzy folder i wchodzi do niego
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Wypakowuje dowolny archiwum
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Szybkie wyszukiwanie plików
findf() {
    find . -name "*$1*" 2>/dev/null
}

# Prosta pogoda (jeśli curl jest dostępny)
weather() {
    if command -v curl >/dev/null 2>&1; then
        curl -s "wttr.in/$1?format=3"
    else
        echo "Weather requires curl"
    fi
}

# Pomoc
help-legacy() {
    echo "🎯 Layered ZSH - Legacy Simple Version"
    echo ""
    echo "🔧 Aliasy:"
    echo "  ll, la, l     - Lepsze ls"
    echo "  .., ..., .... - Nawigacja w górę"
    echo "  grep, mkdir   - Kolorowe/potwierdzone"
    echo "  gs, ga, gc    - Git status, add, commit"
    echo ""
    echo "⚡ Funkcje:"
    echo "  mkcd folder   - Tworzy folder i wchodzi"
    echo "  extract file  - Wypakowuje archiwum"
    echo "  findf nazwa   - Szuka pliku"
    echo "  weather city  - Pogoda"
    echo ""
    echo "🎯 To jest wersja, którą chciał Rotolf."
    echo "🎭 Prosta, działająca, bez microservices."
}

# Status wersji
legacy-status() {
    echo "🎯 Layered ZSH Legacy Simple Version"
    echo "✅ Status: Działa"
    echo "📦 Rozmiar: ~50 linii kodu"
    echo "🎨 Prompt: Prosty i kolorowy"
    echo "🔧 Funkcje: 3 podstawowe"
    echo "🏢 Enterprise features: 0"
    echo "🎭 Microservices: 0"
    echo "🚀 AI integration: 0"
    echo "✨ Praktyczność: 100%"
    echo ""
    echo "🎭 To jest przeciwieństwo enterprise monumentum."
    echo "🎯 I to jest piękne."
}

# Informacja o załadowaniu
echo "🎯 Layered ZSH Legacy Simple Version loaded"
echo "💡 Wpisz 'help-legacy' aby zobaczyć komendy"
