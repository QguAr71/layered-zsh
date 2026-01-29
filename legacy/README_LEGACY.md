# 🎯 LAYERED ZSH - LEGACY SIMPLE VERSION

> **⚠️ WARNING: This version actually works. No enterprise features, no microservices, no AI. Just better aliases and a nice prompt.**

---

## 🎯 CO TO JEST?

**Legacy Simple Version** to wersja, która powstała gdy AI powiedziało "dość over-engineeringu". 

To jest przeciwieństwo monumentum enterprise - proste, użyteczne, i działa.

---

## 🎭 FILOZOFIA:

### **🏢 WERSJA ENTERPRISE:**
- 1741 linii specyfikacji
- 17 enterprise features
- Hybrid architecture
- Microservices
- AI integration
- **Cel: Śmiech i przestroga**

### **🎯 WERSJA LEGACY:**
- ~50 linii kodu
- 3 podstawowe funkcje
- Proste aliasy
- Ładny prompt
- **Cel: Praca i prostota**

### **🚀 WERSJA CURRENT:**
- AI, monitoring, security
- Zaawansowane funkcje
- Nowoczesne technologie
- **Cel: Innowacje i przyszłość**

---

## 📦 INSTALACJA:

### **🎯 SPOSÓB 1: Prosta instalacja**
```bash
# Pobierz i uruchom
curl -fsSL https://raw.githubusercontent.com/QguAr71/layered-zsh/main/legacy/install-legacy.sh | bash

# Lub ręcznie:
mkdir -p ~/.config/layered-legacy
curl -o ~/.config/layered-legacy/legacy.zsh https://raw.githubusercontent.com/QguAr71/layered-zsh/main/legacy/legacy.zsh
echo "source ~/.config/layered-legacy/legacy.zsh" >> ~/.zshrc
```

### **🎪 SPOSÓB 2: Z pełnego instalatora**
```bash
# Uruchom główny instalator i wybierz opcję 2
curl -fsSL https://raw.githubusercontent.com/QguAr71/layered-zsh/main/install.sh | bash
# Wybierz: 2) 🎯 Legacy Simple (basic aliases, prompt)
```

---

## 🎯 CO ZAWIERA:

### **🔧 PODSTAWOWE ALIASY:**
```bash
# Lepsze ls
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

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
```

### **🎨 ŁADNY PROMPT:**
```bash
# Prosty, czytelny, kolorowy prompt
PROMPT='%F{blue}%n%f@%F{green}%m%f:%F{yellow}%~%f$ '
RPROMPT='%F{gray}%T%f'
```

### **⚡ UŻYTECZNE FUNKCJE:**
```bash
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
```

---

## 🎪 KIEDY UŻYWAĆ WERSJI LEGACY:

### **✅ IDEALNE DLA:**
- **Normalnych użytkowników** - którzy chcą tylko lepszy terminal
- **Serwerów** - gdzie nie potrzebujesz AI i monitoringu
- **Quick setups** - szybka konfiguracja bez zbędnych funkcji
- **Minimalistów** - którzy cenią prostotę
- **Uczących się** - podstawy shella bez komplikacji

### **❌ NIE IDEALNE DLA:**
- **Enterprise environment** (użyj wersji enterprise monumentum dla śmiechu)
- **AI enthusiasts** (użyj current version)
- **Power users** (użyj current version)
- **Ludzi którzy lubią komplikacje** (użyj enterprise monumentum)

---

## 🎭 PORÓWNANIE WERSJI:

| Cecha | Legacy Simple | Current | Enterprise Monument |
|-------|---------------|----------|-------------------|
| **Linii kodu** | ~50 | ~500 | 2400+ |
| **Czas instalacji** | 30 sekund | 2 minuty | 5 minut (dla śmiechu) |
| **AI** | ❌ | ✅ | ✅ (teoretycznie) |
| **Monitoring** | ❌ | ✅ | ✅ (w dashboard) |
| **LDAP** | ❌ | ❌ | ✅ (w specyfikacji) |
| **Kubernetes** | ❌ | ❌ | ✅ (w roadmaps) |
| **Microservices** | ❌ | ❌ | ✅ (wszędzie) |
| **Praktyczność** | ✅ | ✅ | ❌ |
| **Humor** | 😐 | 😊 | 😂 |
| **Cel** | Praca | Innowacja | Satyra |

---

## 🎯 KOMENDY:

### **🔧 PODSTAWOWE:**
```bash
ll              # Lepszy ls
mkcd folder     # Tworzy folder i wchodzi
extract file    # Wypakowuje archiwum
findf nazwa     # Szuka pliku
weather city    # Pogoda
```

### **🎪 POMOC:**
```bash
help-legacy     # Pokazuje tę pomocę
legacy-status   # Status wersji legacy
```

---

## 🎨 DOSTOSOWANIE:

### **🎯 ZMiana promptu:**
```bash
# Edytuj ~/.config/layered-legacy/legacy.zsh
# Znajdź linię PROMPT= i zmień kolory:
PROMPT='%F{cyan}%n%f@%F{magenta}%m%f:%F{green}%~%f$ '
```

### **🔧 Dodawanie aliasów:**
```bash
# Dodaj na końcu legacy.zsh:
alias moj-komenda='twoja-komenda'
```

---

## 🎭 HISTORIA:

### **🏢 JAK TO POWSTAŁO:**
1. **Rotolf:** "poprawmy zsh"
2. **AI:** "OK, zróbmy kilka ulepszeń"
3. **AI:** "A może enterprise features?"
4. **AI:** "A może 17 nowych funkcji?"
5. **AI:** "A może hybrid architecture?"
6. **Rotolf:** "Chciałem tylko lepszy prompt"
7. **AI:** "😂 OK, zróbmy prostą wersję"

### **🎯 MORAL Z HISTORII:**
- Czasem mniej znaczy więcej
- Prostota jest piękna
- Ale czasem więcej jest zabawniejsze
- Dlatego mamy wszystkie trzy wersje

---

## 🎚️ DEZINSTALACJA:

```bash
# Usuń pliki
rm -rf ~/.config/layered-legacy

# Usuń z .zshrc
sed -i '/layered-legacy/d' ~/.zshrc

# Zrestartuj terminal
```

---

## 🎉 PODZIĘKOWANIA:

- **Rotolf** - za inspirację do prostoty
- **AI** - za nauczenie lekcji o over-engineeringu
- **Enterprise monumentum** - za pokazanie, jak NIE robić projektów
- **Common sense** - za powrót do normalności

---

## 🎬 KONCOWA MYŚL:

**🎯 Legacy Simple Version: Działa. Jest prosta. Nie ma microservices.**

**🎭 I to jest piękne.**

---

## 🎪 LINKI:

- **🏢 Enterprise Monumentum:** [enterprise-monument/](../enterprise-monument/)
- **🚀 Current Version:** [../](../README.md)
- **🎭 The Great Joke:** [README_ENTERPRISE_JOKE.md](../README_ENTERPRISE_JOKE.md)

---

## 🎯 LICENCJA:

**Legacy Simple License** - Używaj, modyfikuj, bądź szczęśliwy.

**Bez enterprise features. Bez microservices. Bez AI.**

**Tylko proste, działające rozwiązanie.**

---

**🎭 To jest wersja, którą chciał Rotolf.**

**🎯 I w końcu ją dostał.**

**🎬 The End...**
