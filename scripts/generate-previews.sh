#!/usr/bin/env bash
set -euo pipefail

OUTPUT_DIR="docs/images"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)
      OUTPUT_DIR="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

swift run PreviewSnapshotGenerator --output "$OUTPUT_DIR"
