#!/usr/bin/env bash
set -euo pipefail

LAB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CHROMA_DATA_DIR="${CHROMA_DATA_DIR:-$LAB_DIR/services/chroma/data}"
UV_CACHE_DIR="${UV_CACHE_DIR:-$LAB_DIR/services/chroma/uv-cache}"
CHROMA_HOST="${CHROMA_HOST:-127.0.0.1}"
CHROMA_PORT="${CHROMA_PORT:-8100}"
CHROMA_PACKAGE="${CHROMA_PACKAGE:-chromadb>=1,<2}"

if [[ "${1:-}" == "--help" ]]; then
  cat <<'HELP'
Start ChromaDB for the Odysseus lab.

Usage:
  bash scripts/start-chromadb.sh

Environment overrides:
  CHROMA_HOST=127.0.0.1
  CHROMA_PORT=8100
  CHROMA_DATA_DIR=/path/to/data
  CHROMA_PACKAGE='chromadb>=1,<2'

Run this from inside:
  cd /Users/drg/nix-darwin-config/labs/odysseus
  nix develop
HELP
  exit 0
fi

mkdir -p "$CHROMA_DATA_DIR" "$UV_CACHE_DIR"
export UV_CACHE_DIR

echo "Starting ChromaDB"
echo "  host: $CHROMA_HOST"
echo "  port: $CHROMA_PORT"
echo "  data: $CHROMA_DATA_DIR"
echo "  package: $CHROMA_PACKAGE"

exec uvx --from "$CHROMA_PACKAGE" chroma run \
  --host "$CHROMA_HOST" \
  --port "$CHROMA_PORT" \
  --path "$CHROMA_DATA_DIR"
