#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/.dotfiles"
NVIM_SRC="$DOTFILES/nvim/.config/nvim"

NVIM_DEST="$HOME/.config/nvim"

NO_SYMLINK=false
DRY_RUN=false

usage() {
  cat <<EOF
Install script for remote development (no stow required)

Usage: $(basename "$0") [options]

Options:
  -h, --help         Show this help message
  -ns, --no-symlink  Copy files instead of symlinking
  --dry-run          Print actions without executing
EOF
}

run() {
    if $DRY_RUN; then
        echo "[dry-run] $*"
    else 
        "$@"
    fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    -ns|--no-symlink) NO_SYMLINK=true ;;
    --dry-run) DRY_RUN=true ;;
    *) echo "Unknown option: $1"; usage; exit 1 ;;
  esac
  shift
done

echo "Installing dotfiles:"
echo "  Symlinks: $([[ $NO_SYMLINK == true ]] && echo no || echo yes)"
echo "  Dry run : $DRY_RUN"

read -rp "Continue? [Y/n] " reply
[[ -z $reply || $reply =~ ^[Yy]$ ]] || { echo "Aborted."; exit 1; }

mkdir -p "$HOME/.config"

if $NO_SYMLINK; then
  echo "Copying files..."
  run cp -r "$NVIM_SRC" "$NVIM_DEST"
else
  echo "Creating symlinks..."
  run ln -sf "$NVIM_SRC" "$NVIM_DEST"
fi

echo "Done ;)"

