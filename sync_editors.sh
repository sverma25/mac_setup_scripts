#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
EDITOR_DIR="$SCRIPT_DIR/editor"
BACKUP_DIR="$HOME/.config-backups/editor-sync/$(date +%Y%m%d-%H%M%S)"

install_editor() {
  local name="$1"
  local user_dir="$2"
  local cli="$3"
  local extensions="$4"

  if [ ! -x "$cli" ]; then
    echo "$name is not installed; skipping it."
    return
  fi

  mkdir -p "$user_dir"

  local filename
  for filename in settings.json keybindings.json; do
    local source="$EDITOR_DIR/$filename"
    local target="$user_dir/$filename"

    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
      continue
    fi

    if [ -e "$target" ] || [ -L "$target" ]; then
      mkdir -p "$BACKUP_DIR/$name"
      mv "$target" "$BACKUP_DIR/$name/$filename"
    fi

    ln -s "$source" "$target"
  done

  local failures=0
  local extension
  while IFS= read -r extension; do
    [ -n "$extension" ] || continue
    "$cli" --install-extension "$extension" >/dev/null 2>&1 || failures=$((failures + 1))
  done < "$extensions"

  if [ "$failures" -eq 0 ]; then
    echo "$name settings and extensions installed."
  else
    echo "$name settings installed; $failures extensions were unavailable."
  fi
}

install_editor \
  "Cursor" \
  "$HOME/Library/Application Support/Cursor/User" \
  "/Applications/Cursor.app/Contents/Resources/app/bin/cursor" \
  "$EDITOR_DIR/extensions.cursor.txt"

install_editor \
  "VS Code" \
  "$HOME/Library/Application Support/Code/User" \
  "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" \
  "$EDITOR_DIR/extensions.vscode.txt"

echo "Editor setup complete. Reload VS Code and Cursor if they are open."
