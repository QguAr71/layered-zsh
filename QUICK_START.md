# 🚀 Quick Start Guide - Layered ZSH v3.0

## 📋 Wymagania wstępne

### 🔧 Podstawowe (wymagane):
- **Zsh 5.8+** - główna powłoka
- **Git** - zarządzanie repozytorium
- **Systemd** - zarządzanie usługami

### 🤖 Opcjonalne (dla pełnej funkcjonalności):
- **Ollama** - AI i funkcje kodowania
- **lm_sensors** - monitoring temperatury
- **FZF** - fuzzy search
- **Atuin** - historia poleceń
- **Zoxide** - inteligentna nawigacja

---

## ⚡ Szybka instalacja (5 minut)

### 1. **Instalacja podstawowa:**
```bash
# Klonuj repozytorium
git clone https://github.com/QguAr71/layered-zsh.git ~/.config/layered

# Dodaj do .zshrc
echo 'source ~/.config/layered/core/init.zsh' >> ~/.zshrc

# Przeładuj Zsh
source ~/.zshrc
```

### 2. **Sprawdź instalację:**
```bash
# Pokaż pomoc
lhelp

# Sprawdź status
status

# Sprawdź tryb pracy
echo $LAYERED_MODE
```

---

## 🎮 Pierwsze kroki

### **Podstawowe komendy:**
```bash
lhelp          # Pełna lista komend
status         # Status systemu
hud            # Dynamiczny HUD
lconfig        # Przejdź do konfiguracji
```

### **Nawigacja:**
```bash
zi projekt123  # Inteligentne cd (Zoxide)
fn             # Fuzzy cd (FZF)
..             # cd ..
...            # cd ../..
```

### **Systemowe:**
```bash
up             # Aktualizacja systemu
c              # Clear terminal
ll             # ls -la
```

---

## 🤖 Konfiguracja AI (opcjonalne)

### 1. **Instalacja Ollama:**
```bash
curl -fsSL https://ollama.ai/install.sh | sh
```

### 2. **Pobierz model:**
```bash
ollama pull deepseek-coder-v2:lite
```

### 3. **Test AI:**
```bash
sc "Jak działa ten system?"
si "Wyjaśnij mi Zsh"
fix            # AI naprawa systemu
```

---

## 🔧 Konfiguracja sekretów (opcjonalne)

### 1. **Skopiuj szablon:**
```bash
cp ~/.config/layered/.local.zsh.example ~/.config/layered/.local.zsh
```

### 2. **Edytuj plik:**
```bash
micro ~/.config/layered/.local.zsh
```

### 3. **Dodaj swoje sekrety:**
```bash
# GitHub token
export GITHUB_TOKEN="ghp_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

# Personalne ustawienia
export GIT_AUTHOR_NAME="Twoje Imię"
export GIT_AUTHOR_EMAIL="twoj.email@example.com"

# Custom aliasy
alias myproject="cd ~/projects/myproject"
```

---

## 🌡️ Konfiguracja monitoringu (opcjonalne)

### 1. **Instalacja lm_sensors:**
```bash
sudo pacman -S lm_sensors  # Arch Linux
sudo sensors-detect
```

### 2. **Uruchom monitoring:**
```bash
monitor_start
monitor_status
hud
```

---

## 📚 Codzienne scenariusze

### **Programowanie:**
```bash
# AI pomoc
sc "Napisz funkcję w Python do sortowania listy"

# Optymalizacja kodu
optimize script.py

# Wyjaśnienie komendy
explain "git rebase"
```

### **Administracja:**
```bash
# Szybki status
status

# Monitoring
hud

# Audit sesji
laudit

# Aktualizacja
up
```

### **Bezpieczeństwo:**
```bash
# Tryb immutable
lmode immutable

# Panic mode
lpanic

# Odblokowanie
lrecover

# Audit logów
laudit_stats
```

---

## 🎯 Przykładowy workflow

### **Poranek - sprawdzanie systemu:**
```bash
status          # Sprawdź status
hud             # Zobacz monitoring
laudit          # Sprawdź logi
```

### **Praca - programowanie:**
```bash
zi projekt123   # Przejdź do projektu
sc "Help me debug this function"  # AI pomoc
optimize main.py # Optymalizuj kod
```

### **Koniec dnia - czyszczenie:**
```bash
laudit_clean    # Czyść logi
lmode immutable # Tryb bezpieczny
```

---

## 🔧 Rozwiązywanie problemów

### **Brak komend:**
```bash
# Przeładuj konfigurację
source ~/.zshrc

# Sprawdź pliki
ls ~/.config/layered/core/
```

### **AI nie działa:**
```bash
# Sprawdź Ollama
ollama list

# Sprawdź model
ollama run deepseek-coder-v2:lite "test"
```

### **Monitoring nie działa:**
```bash
# Sprawdź sensors
sensors

# Sprawdź status
monitor_status
```

---

## 📖 Dalej

### **Pełna dokumentacja:**
- `README.md` - pełna dokumentacja
- `INSTALL.md` - szczegółowa instalacja
- `CHANGELOG.md` - historia zmian

### **Pomoc:**
```bash
lhelp          # Pełna lista komend
layered        # Alias do lhelp
helpme         # AI pomoc
```

### **Repozytorium:**
- **GitHub:** https://github.com/QguAr71/layered-zsh
- **Issues:** https://github.com/QguAr71/layered-zsh/issues
- **Wiki:** https://github.com/QguAr71/layered-zsh/wiki

---

## 🎉 Gratulacje!

**Udało Ci się zainstalować i skonfigurować Layered ZSH v3.0!**

Teraz masz dostęp do:
- ✅ **60+ komend i aliasów**
- ✅ **AI asystenta kodowania**
- ✅ **System monitoringu**
- ✅ **Zabezpieczeń i audytu**
- ✅ **Modularnej architektury**

**Miłego korzystania!** 🚀
