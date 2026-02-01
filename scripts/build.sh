#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "📦 Building drop-in CSS library..."
bun run --filter drop-in build

echo "🌐 Building website..."
bun run --filter @drop-in/website build

echo "✅ Build complete!"