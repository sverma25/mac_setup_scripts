#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
EDITOR_CONFIG_DIR="$SCRIPT_DIR/editor"
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"
VSCODE_CLI="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
CURSOR_CLI="/Applications/Cursor.app/Contents/Resources/app/bin/cursor"

usage() {
  cat <<'EOF'
Usage: ./sync_editors.sh <command> [editor]

Commands:
  bootstrap              Link shared settings and install saved extensions.
  link                   Link both editors to the shared settings files.
  snapshot cursor|vscode Capture settings and extensions from one editor.
  install-extensions     Install each editor's saved extension manifest.
  status                 Show link targets and extension counts.
EOF
}

require_file() {
  if [ ! -f "$1" ]; then
    echo "Missing required file: $1" >&2
    exit 1
  fi
}

editor_values() {
  case "$1" in
    cursor)
      EDITOR_NAME="Cursor"
      EDITOR_USER_DIR="$CURSOR_USER_DIR"
      EDITOR_CLI="$CURSOR_CLI"
      EDITOR_EXTENSIONS="$EDITOR_CONFIG_DIR/extensions.cursor.txt"
      ;;
    vscode)
      EDITOR_NAME="VS Code"
      EDITOR_USER_DIR="$VSCODE_USER_DIR"
      EDITOR_CLI="$VSCODE_CLI"
      EDITOR_EXTENSIONS="$EDITOR_CONFIG_DIR/extensions.vscode.txt"
      ;;
    *)
      echo "Unknown editor: $1" >&2
      usage
      exit 1
      ;;
  esac
}

link_editor() {
  editor_values "$1"
  mkdir -p "$EDITOR_USER_DIR"

  local backup_dir=""
  local filename
  for filename in settings.json keybindings.json; do
    local source_path="$EDITOR_CONFIG_DIR/$filename"
    local target_path="$EDITOR_USER_DIR/$filename"
    require_file "$source_path"

    if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]; then
      echo "$EDITOR_NAME: $filename is already linked"
      continue
    fi

    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
      if [ -z "$backup_dir" ]; then
        backup_dir="$HOME/.config-backups/editor-sync/$(date +%Y%m%d-%H%M%S)/$1"
        mkdir -p "$backup_dir"
      fi
      mv "$target_path" "$backup_dir/$filename"
      echo "$EDITOR_NAME: backed up $filename to $backup_dir"
    fi

    ln -s "$source_path" "$target_path"
    echo "$EDITOR_NAME: linked $filename"
  done
}

snapshot_editor() {
  editor_values "$1"
  mkdir -p "$EDITOR_CONFIG_DIR"

  local filename
  for filename in settings.json keybindings.json; do
    local source_path="$EDITOR_USER_DIR/$filename"
    local target_path="$EDITOR_CONFIG_DIR/$filename"
    require_file "$source_path"

    if [ -L "$source_path" ] && [ "$(readlink "$source_path")" = "$target_path" ]; then
      echo "$EDITOR_NAME: $filename already updates the shared file directly"
    else
      cp -p "$source_path" "$target_path"
      echo "$EDITOR_NAME: captured $filename"
    fi
  done

  if [ -x "$EDITOR_CLI" ]; then
    "$EDITOR_CLI" --list-extensions 2>/dev/null | sort -u > "$EDITOR_EXTENSIONS"
    echo "$EDITOR_NAME: refreshed $(basename "$EDITOR_EXTENSIONS")"
  else
    echo "$EDITOR_NAME CLI not found; extension manifest was not changed" >&2
  fi
}

install_editor_extensions() {
  editor_values "$1"
  require_file "$EDITOR_EXTENSIONS"

  if [ ! -x "$EDITOR_CLI" ]; then
    echo "$EDITOR_NAME CLI not found at $EDITOR_CLI" >&2
    return 1
  fi

  local failed=0
  local extension_id
  while IFS= read -r extension_id; do
    [ -n "$extension_id" ] || continue
    if ! "$EDITOR_CLI" --install-extension "$extension_id"; then
      echo "$EDITOR_NAME: could not install $extension_id" >&2
      failed=1
    fi
  done < "$EDITOR_EXTENSIONS"

  return "$failed"
}

show_status() {
  local editor
  for editor in cursor vscode; do
    editor_values "$editor"
    echo "$EDITOR_NAME"
    for filename in settings.json keybindings.json; do
      local target_path="$EDITOR_USER_DIR/$filename"
      if [ -L "$target_path" ]; then
        echo "  $filename -> $(readlink "$target_path")"
      elif [ -e "$target_path" ]; then
        echo "  $filename is a regular file"
      else
        echo "  $filename is missing"
      fi
    done

    if [ -x "$EDITOR_CLI" ]; then
      local count
      count=$("$EDITOR_CLI" --list-extensions 2>/dev/null | sort -u | wc -l | tr -d ' ')
      echo "  installed extensions: $count"
    fi
  done
}

command_name="${1:-}"
case "$command_name" in
  bootstrap)
    link_editor cursor
    link_editor vscode
    install_editor_extensions cursor || true
    install_editor_extensions vscode || true
    ;;
  link)
    link_editor cursor
    link_editor vscode
    ;;
  snapshot)
    [ "$#" -eq 2 ] || { usage; exit 1; }
    snapshot_editor "$2"
    ;;
  install-extensions)
    install_editor_extensions cursor || true
    install_editor_extensions vscode || true
    ;;
  status)
    show_status
    ;;
  *)
    usage
    exit 1
    ;;
esac
