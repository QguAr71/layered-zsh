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

- Zsh 5.8+
- Ollama (opcjonalnie dla AI)
- lm_sensors (opcjonalnie dla monitoringu temperatury)
- Systemd

## 📄 Licencja

MIT License

---

**Layered ZSH v3.0** - Neutralny, potężny system konfiguracyjny Zsh
