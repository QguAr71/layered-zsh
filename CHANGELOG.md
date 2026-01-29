# Changelog

## [3.0.0] - 2026-01-29

### 🎉 Wersja Główna
- **Pełna refaktoryzacja z QguAr na Layered ZSH**
- **Neutral branding** - bez specyficznych nazw użytkownika
- **Modularna architektura** - 3 warstwy systemowe

### ✨ Nowe Funkcje
- **🤖 AI System** - integracja z Ollama (DeepSeek Coder, Llama 3.2)
- **🌡️ Monitoring termiczny** - CPU, RAM, load average
- **🛡️ Security & Audit** - pełny system audytu
- **🎨 Dynamiczny HUD** - system monitor w czasie rzeczywistym
- **🔄 Rollback system** - snapshoty i przywracanie konfiguracji

### 🔧 Funkcje Systemowe (25+)
- **Tryby pracy:** full, immutable, safe, safe boot, panic
- **Runtime control:** lpanic, lrecover, lrestore, laudit
- **AI funkcje:** sc, si, ai, fix, ask-zsh, helpme, explain, optimize
- **Monitoring:** monitor_start, monitor_stop, monitor_status
- **Security:** llock, lunlock, lmode immutable

### ⌨️ Aliasy (30+)
- **Quick edit:** leinit, lealias, leai
- **Nawigacja:** zi, fn, .., ..., ....
- **Systemowe:** c, ls, ll, la, v, micro, edit, cy, update, cleanup
- **Katalogi:** lconfig, lcache, llocal
- **AI:** sc, si, ask, helpme, explain, optimize

### 🛡️ Security
- **Tryb immutable** - ochrona przed zmianami
- **Audit system** - logowanie wszystkich akcji
- **Safe boot** - start w trybie awaryjnym
- **Panic mode** - minimalny system do naprawy

### 🌡️ Monitoring
- **Temperatura CPU** - ostrzeżenia > 80°C
- **Użycie RAM** - ostrzeżenia > 90%
- **Load average** - ostrzeżenia > 2.0
- **Czytelne komunikaty** z sugestiami działań

### 🤖 AI Integracja
- **Ollama support** - DeepSeek Coder v2:lite, Llama 3.2
- **Cache system** - automatyczne cache'owanie odpowiedzi
- **Mock mode** - fallback gdy Ollama niedostępne
- **Funkcja fix** - automatyczna diagnoza i naprawa

### 📊 Struktura Systemu
```
~/.config/layered/
├── core/                    # CORE - zawsze włączona
├── security/               # SECURITY & AUDIT
└── productivity/          # PRODUCTIVITY & AI
```

### 🔧 Poprawki
- **Function-based alias errors** - naprawione
- **Zinit plugin 404 errors** - naprawione
- **Parse errors** - naprawione
- **Snapshot hang** - naprawione
- **System loading** - zoptymalizowane

### 📚 Dokumentacja
- **Pełna dokumentacja** - 582 linie, 12 sekcji
- **Troubleshooting** - 8 problemów z rozwiązaniami
- **FAQ** - najczęstsze pytania
- **Przykłady użycia** - dla każdej funkcji

### 🚀 Wymagania
- Zsh 5.8+
- Ollama (opcjonalnie)
- lm_sensors (opcjonalnie)
- Systemd

---

## [2.x.x] - Poprzednie QguAr

- **QguAr branding** - specyficzne dla użytkownika
- **Podstawowe funkcje** - AI, monitoring, HUD
- **Tryby pracy** - immutable, full, safe
- **Rollback system** - podstawowy

---

*Wszystkie zmiany są kompatybilne wstecz z wyjątkiem zmian brandingowych.*
