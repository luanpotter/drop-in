#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

FIX_MODE=false
if [[ "${1:-}" == "--fix" ]]; then
  FIX_MODE=true
fi

echo "🔍 Checking formatting with Prettier..."
if $FIX_MODE; then
  bun prettier --write .
else
  bun prettier --check .
fi

echo "🔍 Linting CSS with Stylelint..."
if $FIX_MODE; then
  bun stylelint "packages/**/*.css" --fix --ignore-pattern "**/dist/**"
else
  bun stylelint "packages/**/*.css" --ignore-pattern "**/dist/**"
fi

echo "🔍 Linting HTML with HTMLHint..."
bun htmlhint "packages/website/public/**/*.html"

echo "🔍 Type checking TypeScript..."
bun tsc --noEmit -p packages/drop-in
bun tsc --noEmit -p packages/website

echo "🔍 Validating CSS build..."
bun run build:drop-in

echo "✅ All checks passed!"