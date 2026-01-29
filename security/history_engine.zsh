# HISTORY ENGINE – tagowanie sesji + wyszukiwanie + AI podsumowanie

setopt HIST_IGNORE_SPACE HIST_SAVE_NO_DUPS HIST_EXPIRE_DUPS_FIRST

export HIST_SESSION_TAG="${HIST_SESSION_TAG:-general}"

zshaddhistory() {
  local line="${1%%$'\n'}"
  [[ -z "$line" || "$line" == [[:space:]]# ]] && return 2
  print -r -- "${line} #tag:${HIST_SESSION_TAG}" >> "$HISTFILE"
  return 0
}

he() {
  local selected
  selected=$(atuin search --limit 5000 --format '{time} {duration} {command}' |
    fzf --height 70% --preview 'echo {} | cut -d" " -f3- | sed "s/ #tag:.*//"' \
        --preview-window=right:60%:wrap \
        --header="Historia (tag: ${HIST_SESSION_TAG}) – ↑↓ wybierz" \
        --bind 'ctrl-t:change-header(Nowy tag):execute(echo "Nowy tag: "; read tag; echo "$tag")+abort'
  )

  [[ -n "$selected" ]] && zle -U "${selected##* }"
}

zle -N he
bindkey '^R' he

htag() {
  [[ -z "$1" ]] && { echo "Tag: ${HIST_SESSION_TAG}"; return; }
  export HIST_SESSION_TAG="$1"
  echo "Sesja tagowana jako: \e[1;36m$1\e[0m"
}

hal() {
  local n=${1:-15}
  local last_cmds=$(tail -n "$n" "$HISTFILE" | sed 's/ #tag:.*//' | tac)
  echo "$last_cmds" | ai "Podsumuj w 3-5 zdaniach co robiłem w terminalu w ostatnich minutach. Po polsku."
}
