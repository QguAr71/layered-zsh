#!/bin/bash

# 🎯 LAYERED ZSH LEGACY - INSTALLER
# Prosta instalacja wersji legacy

echo "🎯 Layered ZSH Legacy Simple Version Installer"
echo "============================================"
echo ""

# Sprawdzenie czy zsh jest zainstalowane
if ! command -v zsh >/dev/null 2>&1; then
    echo "❌ Zsh nie jest zainstalowany. Zainstaluj zsh najpierw."
    echo "   Ubuntu/Debian: sudo apt install zsh"
    echo "   Arch: sudo pacman -S zsh"
    echo "   macOS: brew install zsh"
    exit 1
fi

# Tworzenie katalogu
echo "📁 Tworzenie katalogu ~/.config/layered-legacy..."
mkdir -p ~/.config/layered-legacy

# Pobieranie plików
echo "📥 Pobieranie plików konfiguracyjnych..."

# Jeśli jesteśmy w repozytorium, kopiuj lokalnie
if [ -f "legacy/legacy.zsh" ]; then
    cp legacy/legacy.zsh ~/.config/layered-legacy/
    cp legacy/README_LEGACY.md ~/.config/layered-legacy/
else
    # Pobieranie z GitHub
    curl -fsSL https://raw.githubusercontent.com/QguAr71/layered-zsh/main/legacy/legacy.zsh -o ~/.config/layered-legacy/legacy.zsh
    curl -fsSL https://raw.githubusercontent.com/QguAr71/layered-zsh/main/legacy/README_LEGACY.md -o ~/.config/layered-legacy/README_LEGACY.md
fi

# Sprawdzenie czy pliki się pobrały
if [ ! -f ~/.config/layered-legacy/legacy.zsh ]; then
    echo "❌ Błąd pobierania plików. Spróbuj ponownie."
    exit 1
fi

# Dodawanie do .zshrc
echo "🔧 Dodawanie do ~/.zshrc..."

# Sprawdzenie czy już jest dodane
if grep -q "layered-legacy" ~/.zshrc; then
    echo "ℹ️  Legacy jest już dodane do ~/.zshrc"
else
    echo "" >> ~/.zshrc
    echo "# Layered ZSH Legacy Simple Version" >> ~/.zshrc
    echo "source ~/.config/layered-legacy/legacy.zsh" >> ~/.zshrc
    echo "✅ Dodano do ~/.zshrc"
fi

# Informacje
echo ""
echo "🎉 Instalacja zakończona!"
echo ""
echo "📋 Co teraz:"
echo "1. Uruchom nowy terminal lub: source ~/.zshrc"
echo "2. Wpisz 'help-legacy' aby zobaczyć komendy"
echo "3. Wpisz 'legacy-status' aby sprawdzić status"
echo ""
echo "🎭 To jest wersja, którą chciał Rotolf."
echo "🎯 Prosta, działająca, bez microservices."
echo ""
echo "📖 Dokumentacja: ~/.config/layered-legacy/README_LEGACY.md"
echo "🌐 GitHub: https://github.com/QguAr71/layered-zsh"
echo ""
echo "🎪 Miłego używania prostego shella!"
