# =============================================================================
# QguAr CORE - środowisko podstawowe (zawsze ładowane)
# =============================================================================

[[ -n $KITTY_WINDOW_ID ]] && export TERM="xterm-kitty"
export COLORTERM="truecolor"
export EDITOR="micro"
export VISUAL="micro"
export MICRO_TRUECOLOR=1
export BAT_THEME="gruvbox-dark"
export RUSTFLAGS="-C target-cpu=native"
export PATH="$HOME/bin:/usr/local/bin:$HOME/.cargo/bin:$PATH"

# Narzędzia nawigacyjne
eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"

# FZF konfiguracja
export FZF_DEFAULT_OPTS="--color=bg+:#3c3836,bg:-1,spinner:#fe8019,hl:#83a598,fg:#ebdbb2,header:#83a598,info:#8ec07c,pointer:#a597d2,marker:#a597d2,fg+:#ebdbb2,prompt:#a597d2,hl+:#8ec07c,border:#504945 --inline-info --border=rounded"

# Podstawowe zmienne
export LANG=pl_PL.UTF-8
export LC_ALL=pl_PL.UTF-8
export TZ="Europe/Warsaw"

# Cache katalogi
mkdir -p "$HOME/.cache/qguar"
mkdir -p "$HOME/.local/share/qguar"
