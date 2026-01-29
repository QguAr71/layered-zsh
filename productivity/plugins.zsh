# =============================================================================
# Layered ZSH PLUGINS - Zinit + wtyczki (warstwa PRODUCTIVITY)
# =============================================================================

# Zinit - menedżer pakietów Zsh
if [[ ! -f "$HOME/.local/share/zinit/zinit.git/zinit.zsh" ]]; then
  echo "📦 Instalowanie Zinit..."
  mkdir -p "$HOME/.local/share/zinit" && \
    git clone https://github.com/zdharma-continuum/zinit.git "$HOME/.local/share/zinit/zinit.git"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Podstawowe narzędzia (działające alternatywy)
zinit light zdharma-continuum/zinit-annex-bin-gem-node
zinit light zdharma-continuum/zinit-annex-patch-dl

# Git - używamy biblioteki zamiast pluginu (działa)
zinit snippet https://github.com/ohmyzsh/ohmyzsh/raw/master/lib/git.zsh

# Systemowe narzędzia (działające alternatywy)
zinit snippet https://github.com/ohmyzsh/ohmyzsh/raw/master/plugins/sudo/sudo.plugin.zsh
zinit snippet https://github.com/ohmyzsh/ohmyzsh/raw/master/plugins/archlinux/archlinux.plugin.zsh
zinit snippet https://github.com/ohmyzsh/ohmyzsh/raw/master/plugins/systemd/systemd.plugin.zsh

# Programowanie (działające alternatywy)
zinit snippet https://github.com/ohmyzsh/ohmyzsh/raw/master/plugins/docker/docker.plugin.zsh
zinit snippet https://github.com/ohmyzsh/ohmyzsh/raw/master/plugins/node/node.plugin.zsh
zinit snippet https://github.com/ohmyzsh/ohmyzsh/raw/master/plugins/python/python.plugin.zsh
zinit snippet https://github.com/ohmyzsh/ohmyzsh/raw/master/plugins/rust/rust.plugin.zsh

# Powerlevel10k - prompt
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Składnia i autouzupełnianie (działające)
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# Historia i nawigacja (alternatywa)
zinit light zsh-users/zsh-history-substring-search

# Dodatkowe narzędzia
zinit light Aloxaf/fzf-tab
zinit light zdharma-continuum/fast-syntax-highlighting

# Przydatne funkcje
zinit light unixorn/git-extra-commands

echo "⚡ Zinit + wtyczki załadowane"
