#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "🔍 Validating CSS (via build)..."
bun run build:drop-in

echo "🔍 Type checking TypeScript..."
bun tsc --noEmit -p packages/drop-in
bun tsc --noEmit -p packages/website

echo "✅ Lint complete!"