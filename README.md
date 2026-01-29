# Layered ZSH v3.0

Neutralny, modułowy system konfiguracyjny Zsh z warstwową architekturą, AI, monitoringiem i systemem bezpieczeństwa.

## 🚀 Szybki Start

```bash
# Klonuj repozytorium
git clone https://github.com/twoj-repo/layered-zsh.git ~/.config/layered

# Dodaj do .zshrc
echo 'source ~/.config/layered/core/init.zsh' >> ~/.zshrc

# Przeładuj Zsh
source ~/.zshrc
```

## 📁 Struktura Projektu

```
layered-zsh/
├── core/                    # Warstwa 1: CORE (zawsze włączona)
│   ├── init.zsh            # Główny loader
│   ├── aliases.zsh         # Aliasy podstawowe
│   ├── modes.zsh          # Tryby pracy
│   ├── rollback.zsh       # System rollback
│   └── core.zsh           # Podstawowe ustawienia
├── security/               # Warstwa 2: SECURITY & AUDIT
│   ├── security_guard.zsh # Ochrona przed błędami
│   ├── history_engine.zsh # Zarządzanie historią
│   ├── audit.zsh          # Podstawowy audit
│   ├── audit_system.zsh   # Pełny system audytu
│   ├── immutable.zsh      # Tryb immutable
│   └── integrity.zsh      # Weryfikacja integralności
├── productivity/          # Warstwa 3: PRODUCTIVITY & AI
│   ├── ai_core.zsh       # Rdzeń AI
│   ├── ai-cache.zsh      # Cache AI
│   ├── ai.zsh            # Funkcje AI
│   ├── plugins.zsh       # Zinit + pluginy
│   ├── visuals.zsh       # HUD i wizualizacje
│   └── monitoring.zsh    # Monitoring systemowy
├── docs/                  # Dokumentacja
├── README.md              # Pełna dokumentacja
├── README_SHORT.md        # Krótka prezentacja
├── CHANGELOG.md           # Historia zmian
├── INSTALL.md             # Instrukcja instalacji
└── LICENSE                # Licencja MIT
```

## 🎯 Główne Cechy

- **🧬 3 Warstwy:** CORE, SECURITY + AUDIT, PRODUCTIVITY + AI
- **🤖 AI System:** Integracja z Ollama (DeepSeek Coder, Llama 3.2)
- **🌡️ Monitoring:** Termiczny, RAM, load average
- **🛡️ Security:** Tryby pracy, audit, rollback
- **🎨 HUD:** Dynamiczny system monitor
- **📊 25+ funkcji** systemowych
- **⌨️ 30+ aliasów** usprawniających pracę

## 🎮 Tryby Pracy

```bash
lmode full        # Pełna funkcjonalność
lmode immutable   # Tylko odczyt
lmode safe        # Bez AI i monitoringu
lpanic            # Tryb awaryjny
```

## 🤖 AI Przykłady

```bash
sc "Jak działa ten system?"           # AI podstawowe
si "Wyjaśnij systemd"                # AI rozszerzone
fix                                     # Diagnoza i naprawa
optimize skrypt.sh                     # Optymalizacja kodu
```

## 🌡️ Monitoring

```bash
status          # Status systemu
hud             # Dynamiczny HUD
monitor_start   # Start monitoringu
monitor_stop    # Stop monitoringu
```

## 🛡️ Security

```bash
laudit          # Audit sesji
llock           # Blokada edycji
lrestore        # Przywrócenie snapshotu
```

## 📊 Funkcje Systemowe

### Runtime Control:
- `lpanic()` - Tryb paniki
- `lrecover()` - Odblokowanie paniki
- `lrestore()` - Przywrócenie snapshotu
- `laudit()` - Audit sesji
- `llock()` - Blokada edycji
- `lunlock()` - Odblokowanie edycji

### AI System:
- `sc "pytanie"` - AI podstawowe (DeepSeek Coder)
- `si "pytanie"` - AI rozszerzone (Llama 3.2)
- `ai "pytanie"` - Główna funkcja AI
- `fix` - AI naprawa systemu
- `ask-zsh "pytanie"` - Pytania o Zsh
- `helpme` - Pomoc AI
- `explain "komenda"` - Wyjaśnienie komendy
- `optimize plik` - Optymalizacja kodu
- `changelog` - Generowanie changelog z git

### Monitoring:
- `monitor_start()` - Start monitoringu
- `monitor_stop()` - Stop monitoringu
- `monitor_status()` - Status monitoringu
- `preexec()` - Przed wykonaniem komendy
- `precmd()` - Po wykonaniu komendy
- `zshaddhistory()` - Dodanie do historii

### Security:
- `laudit()` - Ostatnie 50 wpisów
- `laudit_stats()` - Statystyki audytu
- `laudit_clean()` - Czyszczenie logów
- `lmode immutable` - Tryb tylko do odczytu

## ⌨️ Aliasy

### Quick Edit:
- `leinit` - Edycja init.zsh
- `lealias` - Edycja aliases.zsh
- `leai` - Edycja ai.zsh

### Nawigacja:
- `zi` - Zoxide cd
- `fn` - fzf cd
- `..`, `...`, `....` - Nawigacja w górę

### Systemowe:
- `c` - clear
- `ls`, `ll`, `la` - Listowanie
- `v`, `micro`, `edit` - Edytory
- `cy` - Cytadela
- `update` - Aktualizacja systemu
- `cleanup` - Czyszczenie systemu

### Katalogi:
- `lconfig` - ~/.config/layered
- `lcache` - ~/.cache/layered
- `llocal` - ~/.local/share/layered

### AI:
- `sc`, `si` - AI funkcje
- `ask`, `helpme` - Pomoc AI
- `explain` - Wyjaśnienia
- `optimize` - Optymalizacja

## 📋 Wymagania

### 🔧 Podstawowe wymagania:
- **Zsh 5.8+** - główna powłoka
- **Git** - zarządzanie repozytorium
- **Systemd** - zarządzanie usługami

### 🤖 Opcjonalne (dla pełnej funkcjonalności):
- **Ollama** - AI i funkcje kodowania
  ```bash
  curl -fsSL https://ollama.ai/install.sh | sh
  ollama pull deepseek-coder-v2:lite
  ```
- **lm_sensors** - monitoring temperatury
  ```bash
  sudo pacman -S lm_sensors
  sudo sensors-detect
  ```
- **Zinit** - menedżer pluginów (instalowany automatycznie)
- **Atuin** - historia poleceń (opcjonalne)
- **Zoxide** - inteligentna nawigacja (opcjonalne)

### 📦 Instalacja zależności (Arch Linux):
```bash
# Podstawowe
sudo pacman -S git zsh systemd

# Opcjonalne dla pełnej funkcjonalności
sudo pacman -S lm_sensors

# AI (Ollama)
curl -fsSL https://ollama.ai/install.sh | sh
ollama pull deepseek-coder-v2:lite

# Narzędzia nawigacyjne
sudo pacman -S fzf  # dla fzf-tab
```

## 🛠️ Roadmap

### 🎯 v3.1 (Optymalizacje i stabilność)
- [ ] **Auto-update blocklist** - systemd timer + LKG fallback
- [ ] **Backup/Restore config** - config-backup/restore
- [ ] **Deduplikacja PL/EN** - wydzielenie cytadela-core.sh
- [ ] **Modularyzacja** - lazy loading modułów
- [ ] **DNS Cache Stats** - cache-stats z Prometheus
- [ ] **Multi-blocklist** - blocklist-switch
- [ ] **Desktop Notifications** - notify-send
- [ ] **Web Dashboard** - localhost:9154

### 🚀 v3.2 (Advanced Features)
- [ ] **Grafana/Prometheus Integration** - monitoring historyczny
- [ ] **IDS DNS (Suricata/Zeek)** - analiza ruchu DNS
- [ ] **Per-device Policy** - polityki per MAC/IP
- [ ] **DNS Sinkhole** - wewnętrzny sinkhole
- [ ] **Immutable OS Integration** - Fedora Silverblue, nixOS
- [ ] **Geo/ASN Firewall** - blokowanie geograficzne

### 🔮 v4.0 (Next Generation)
- [ ] **Plugin Manager Integration** - pełne wsparcie dla Zinit/Zim
- [ ] **Theme System** - dynamiczne motywy
- [ ] **Cloud Sync** - synchronizacja konfiguracji
- [ ] **Mobile Support** - Termux compatibility
- [ ] **Enterprise Features** - LDAP integration

## 📘 Sugestie usprawnień

### 🧪 Testy i CI
- [ ] **GitHub Actions** - automatyczne testy
  - Shellcheck validation
  - Syntax checking
  - Performance benchmarks
- [ ] **Unit Tests** - testy funkcji systemowych
- [ ] **Integration Tests** - testy end-to-end
- [ ] **Security Scans** - skanowanie sekretów

### 📦 Zarządzanie pluginami
- [ ] **Zinit Configuration** - prekonfigurowane pluginy
- [ ] **Plugin Health Check** - sprawdzanie statusu pluginów
- [ ] **Auto-update** - automatyczne aktualizacje
- [ ] **Plugin Marketplace** - repozytorium pluginów

### 📌 Przykłady użytkowania
- [ ] **Quick Start Guide** - przewodnik dla początkujących
- [ ] **Daily Workflow** - codzienne scenariusze
- [ ] **Development Setup** - konfiguracja deweloperska
- [ ] **System Administration** - narzędzia admina

## 📚 Dokumentacja

### 📋 Przykład konfiguracji krok po kroku

#### 1. **Instalacja podstawowa:**
```bash
# Klonuj repozytorium
git clone https://github.com/QguAr71/layered-zsh.git ~/.config/layered

# Dodaj do .zshrc
echo 'source ~/.config/layered/core/init.zsh' >> ~/.zshrc

# Przeładuj Zsh
source ~/.zshrc
```

#### 2. **Konfiguracja AI:**
```bash
# Zainstaluj Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# Pobierz model
ollama pull deepseek-coder-v2:lite

# Test AI
sc "Jak działa ten system?"
```

#### 3. **Konfiguracja sekretów:**
```bash
# Skopiuj szablon
cp ~/.config/layered/.local.zsh.example ~/.config/layered/.local.zsh

# Edytuj plik
micro ~/.config/layered/.local.zsh

# Dodaj swoje sekrety
export GITHUB_TOKEN="ghp_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
export GIT_AUTHOR_NAME="Twoje Imię"
export GIT_AUTHOR_EMAIL="twoj.email@example.com"
```

#### 4. **Konfiguracja monitoringu:**
```bash
# Uruchom monitoring
monitor_start

# Sprawdź status
monitor_status

# Zobacz HUD
hud
```

### 🎮 Codzienne przykłady użytkowania

#### **Programowanie:**
```bash
# AI pomoc w kodowaniu
sc "Napisz funkcję w Python do sortowania listy"

# Optymalizacja kodu
optimize script.py

# Wyjaśnienie komendy
explain "git rebase"
```

#### **Administracja systemem:**
```bash
# Szybki status
status

# Monitoring
hud

# Audit sesji
laudit

# Aktualizacja systemu
up
```

#### **Nawigacja:**
```bash
# Inteligentne cd
zi projekt123

# Fuzzy cd
fn

# Quick directory jumps
lconfig  # ~/.config/layered
lcache   # ~/.cache/layered
llocal   # ~/.local/share/layered
```

#### **Bezpieczeństwo:**
```bash
# Tryb immutable
lmode immutable

# Audit logów
laudit_stats

# Czyszczenie logów
laudit_clean

# Panic mode
lpanic
```

### 🔧 Plugin Manager

#### **Zinit (domyślny):**
```bash
# Lista pluginów
zinit list

# Aktualizacja
zinit update

# Czyszczenie
zinit clean
```

#### **Konfiguracja pluginów:**
```bash
# Edytuj konfigurację
leinit  # init.zsh
lealias # aliases.zsh
leai    # ai.zsh
```

## 📄 Licencja

MIT License

---

**Layered ZSH v3.0** - Neutralny, potężny system konfiguracyjny Zsh
