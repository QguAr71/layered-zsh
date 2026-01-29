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

## 🎯 Główne Cechy

- **🧬 3 Warstwy:** CORE, SECURITY + AUDIT, PRODUCTIVITY + AI
- **🤖 AI System:** Integracja z Ollama (DeepSeek Coder, Llama 3.2)
- **🌡️ Monitoring:** Termiczny, RAM, load average
- **🛡️ Security:** Tryby pracy, audit, rollback
- **🎨 HUD:** Dynamiczny system monitor
- **📊 25+ funkcji** systemowych
- **⌨️ 30+ aliasów** usprawniających pracę

## 📋 Dokumentacja

Pełna dokumentacja dostępna w pliku [README.md](README.md) zawiera:

- 🔧 **Instalacja** i konfiguracja
- 🎮 **Tryby pracy** (full, immutable, safe, safe boot, panic)
- 🤖 **AI funkcje** z przykładami użycia
- 🌡️ **Monitoring** systemowy z ostrzeżeniami
- 🛡️ **Security & Audit** system
- ⌨️ **Wszystkie aliasy** i funkcje
- 🚨 **Troubleshooting** - 8 problemów z rozwiązaniami
- ❓ **FAQ** z najczęstszymi pytaniami

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

## 📊 Wymagania

- Zsh 5.8+
- Ollama (opcjonalnie dla AI)
- Sensory (dla monitoringu temperatury)

## 📄 Licencja

MIT License

---

**Layered ZSH v3.0** - Neutralny, potężny system konfiguracyjny Zsh
