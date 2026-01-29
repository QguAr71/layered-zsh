# =============================================================================
# Layered ZSH ROLLBACK - system snapshotów i przywracania
# =============================================================================

LAYERED_SNAPSHOTS_DIR="$HOME/.local/share/layered/snapshots"
mkdir -p "$LAYERED_SNAPSHOTS_DIR"

# Tworzenie snapshotu (uproszczone)
q_snapshot() {
  local snapshot_name="snapshot-$(date +%Y%m%d-%H%M%S)"
  local snapshot_dir="$LAYERED_SNAPSHOTS_DIR/$snapshot_name"
  
  mkdir -p "$snapshot_dir"
  
  # Kopiuj tylko ważne pliki (bez rekurencji która może zawieszać)
  cp ~/.zshrc "$snapshot_dir/" 2>/dev/null || true
  
  # Zapisz informację o snapshotie
  echo "Snapshot: $snapshot_name" > "$snapshot_dir/info.txt"
  echo "Data: $(date)" >> "$snapshot_dir/info.txt"
  echo "Tryb: $LAYERED_MODE" >> "$snapshot_dir/info.txt"
  
  echo "✅ Snapshot utworzony: $snapshot_name"
}

# Przywracanie ostatniego snapshotu
q_restore_last() {
  local last_snapshot=$(ls -t "$LAYERED_SNAPSHOTS_DIR" | head -1)
  
  if [[ -z "$last_snapshot" ]]; then
    echo "❌ Brak dostępnych snapshotów"
    return 1
  fi
  
  local snapshot_dir="$LAYERED_SNAPSHOTS_DIR/$last_snapshot"
  
  echo "🔄 Przywracanie snapshotu: $last_snapshot"
  echo "Kontynuować? [y/N] "
  read -r confirm
  
  if [[ ! $confirm =~ ^[yY]$ ]]; then
    echo "❌ Anulowano"
    return 1
  fi
  
  # Przywróć pliki
  cp "$snapshot_dir/.zshrc" ~ 2>/dev/null || true
  
  echo "✅ Snapshot przywrócony"
  echo "🔄 Uruchom ponownie terminal"
}

# Lista snapshotów
q_list_snapshots() {
  echo "📋 Dostępne snapshoty:"
  ls -la "$LAYERED_SNAPSHOTS_DIR" | grep "^d" | awk '{print $9}' | while read snapshot; do
    if [[ -n "$snapshot" && "$snapshot" != "." && "$snapshot" != ".." ]]; then
      echo "  📸 $snapshot"
      if [[ -f "$LAYERED_SNAPSHOTS_DIR/$snapshot/info.txt" ]]; then
        grep "Data:" "$LAYERED_SNAPSHOTS_DIR/$snapshot/info.txt" | sed 's/^/    /'
      fi
    fi
  done
}

# Aliasy
alias qsnapshot='q_snapshot'
alias qrestore='q_restore_last'
alias qlist='q_list_snapshots'
