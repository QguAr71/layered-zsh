# =============================================================================
# LAYERED ZSH INIT - modular config system (styczeń 2026)
# Warstwa 1: CORE - zawsze włączona
# =============================================================================

[[ $- != *i* ]] && return  # Tylko shell interaktywny

export LAYERED_INIT_DONE=1

# Safe boot flag
export LAYERED_SAFEBOOT=0
[[ -f "$HOME/.layered_safe" ]] && export LAYERED_SAFEBOOT=1

# Podstawowa historia (zawsze potrzebna)
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt appendhistory sharehistory incappendhistory histignorealldups histreduceblanks

# Core ENV (PATH, TERM, edytory itp.)
[[ -f "$HOME/.config/layered/core/core.zsh" ]] && source "$HOME/.config/layered/core/core.zsh"

# Tryby i profile (immutable/full/safe, poziom3+ itp.)
[[ -f "$HOME/.config/layered/core/modes.zsh" ]] && source "$HOME/.config/layered/core/modes.zsh"
[[ -f "$HOME/.config/layered/core/profiles.zsh" ]] && source "$HOME/.config/layered/core/profiles.zsh"

# Minimalne aliasy + nawigacja
[[ -f "$HOME/.config/layered/core/aliases.zsh" ]] && source "$HOME/.config/layered/core/aliases.zsh"

# Rollback + snapshot (bezpieczeństwo configu)
[[ -f "$HOME/.config/layered/core/rollback.zsh" ]] && source "$HOME/.config/layered/core/rollback.zsh"

# Backup/Restore system
[[ -f "$HOME/.config/layered/core/backup.zsh" ]] && source "$HOME/.config/layered/core/backup.zsh"

# Auto-update system
[[ -f "$HOME/.config/layered/core/auto_update.zsh" ]] && source "$HOME/.config/layered/core/auto_update.zsh"

# Create snapshot on start (tylko jeśli nie ma błędów)
if q_snapshot 2>/dev/null; then
  echo "✅ Snapshot utworzony"
else
  echo "⚠️ Problem z snapshot - kontynuuję"
fi

# =============================================================================
# Warstwa 2 + 3 - tylko w normalnym trybie (nie safe boot)
# =============================================================================

if [[ $LAYERED_SAFEBOOT -eq 1 ]]; then
  echo "🧪 Layered ZSH SAFE BOOT ACTIVE (tylko core)"
else
  # Warstwa 2 - SECURITY & AUDIT (ochrona przed błędami)
  [[ -f "$HOME/.config/layered/security/security_guard.zsh" ]] && source "$HOME/.config/layered/security/security_guard.zsh"
  [[ -f "$HOME/.config/layered/security/history_engine.zsh" ]] && source "$HOME/.config/layered/security/history_engine.zsh"
  [[ -f "$HOME/.config/layered/security/audit.zsh" ]] && source "$HOME/.config/layered/security/audit.zsh"
  [[ -f "$HOME/.config/layered/security/immutable.zsh" ]] && source "$HOME/.config/layered/security/immutable.zsh"
  [[ -f "$HOME/.config/layered/security/integrity.zsh" ]] && source "$HOME/.config/layered/security/integrity.zsh"

  # Warstwa 3 - PRODUCTIVITY & AI (główna wartość dodana)
  [[ -f "$HOME/.config/layered/productivity/ai_core.zsh" ]] && source "$HOME/.config/layered/productivity/ai_core.zsh"
  [[ -f "$HOME/.config/layered/productivity/ai-cache.zsh" ]] && source "$HOME/.config/layered/productivity/ai-cache.zsh"
  [[ -f "$HOME/.config/layered/productivity/ai.zsh" ]] && source "$HOME/.config/layered/productivity/ai.zsh"
  [[ -f "$HOME/.config/layered/productivity/plugins.zsh" ]] && source "$HOME/.config/layered/productivity/plugins.zsh"
  [[ -f "$HOME/.config/layered/productivity/visuals.zsh" ]] && source "$HOME/.config/layered/productivity/visuals.zsh"

  # Monitoring termiczny zostaje (działa w tle)
  [[ -f "$HOME/.config/layered/productivity/monitoring.zsh" ]] && source "$HOME/.config/layered/productivity/monitoring.zsh"

  echo "⚡ Layered ZSH ACTIVE (core + security + productivity + AI)"
fi
