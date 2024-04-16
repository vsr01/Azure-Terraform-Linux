#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./gen-ssh-key.sh [key_path]

KEY_PATH="${1:-$HOME/.ssh/azure-dev-vm}"

if [[ -f "$KEY_PATH" || -f "${KEY_PATH}.pub" ]]; then
  echo "Key already exists at $KEY_PATH or ${KEY_PATH}.pub" >&2
  exit 1
fi

mkdir -p "$(dirname "$KEY_PATH")"
ssh-keygen -t ed25519 -f "$KEY_PATH" -N ""

echo "Generated:"
echo "  Private key: $KEY_PATH"
echo "  Public key:  ${KEY_PATH}.pub"

