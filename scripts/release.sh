#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
error() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

success() {
    echo -e "${GREEN}$1${NC}"
}

warn() {
    echo -e "${YELLOW}$1${NC}"
}

info() {
    echo "$1"
}

newline() {
    echo ""
}

step() {
    newline
    echo "$1"
}

success "🚀 drop-in-css Release Script"
newline

# Check if logged in
if ! npm whoami &>/dev/null; then
    error "Not logged in to npm; run 'npm login' first."
fi

# Check we're on master
BRANCH=$(git branch --show-current)
if [[ "$BRANCH" != "master" ]]; then
    error "Must be on master branch (currently on $BRANCH)."
fi

# Check for uncommitted changes
if [[ -n $(git status --porcelain) ]]; then
    error "Working directory has uncommitted changes."
fi

# Check we're up to date with remote
git fetch origin "$BRANCH" --quiet
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse "origin/$BRANCH")
if [[ "$LOCAL" != "$REMOTE" ]]; then
    error "Local branch is not up to date with origin/$BRANCH; pull first."
fi

# Get current version from package
CURRENT_VERSION=$(jq -r '.version' packages/drop-in-css/package.json)
warn "Current version: $CURRENT_VERSION"

# Parse version components
IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"

# Calculate bump options
PATCH_VERSION="$MAJOR.$MINOR.$((PATCH + 1))"
MINOR_VERSION="$MAJOR.$((MINOR + 1)).0"
MAJOR_VERSION="$((MAJOR + 1)).0.0"

# Prompt for version
newline
echo "Select version bump:"
success "  1) Patch: $PATCH_VERSION (default)"
warn "  2) Minor: $MINOR_VERSION"
echo -e "  3) Major: ${RED}$MAJOR_VERSION${NC}"
echo "  4) Custom"
newline
read -p "Choice [1]: " CHOICE
CHOICE=${CHOICE:-1}

case $CHOICE in
    1) NEW_VERSION=$PATCH_VERSION ;;
    2) NEW_VERSION=$MINOR_VERSION ;;
    3) NEW_VERSION=$MAJOR_VERSION ;;
    4)
        read -p "Enter custom version: " NEW_VERSION
        if [[ ! $NEW_VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            error "Invalid version format (expected x.y.z)"
        fi
        ;;
    *) error "Invalid choice" ;;
esac

newline
success "Releasing version: $NEW_VERSION"
read -p "Continue? [Y/n]: " CONFIRM
CONFIRM=${CONFIRM:-Y}
if [[ ! $CONFIRM =~ ^[Yy]$ ]]; then
    info "Aborted."
    exit 0
fi

# Update versions
step "📝 Updating version in package.json files..."
jq ".version = \"$NEW_VERSION\"" packages/drop-in-css/package.json > tmp.json && mv tmp.json packages/drop-in-css/package.json
jq ".version = \"$NEW_VERSION\"" package.json > tmp.json && mv tmp.json package.json

# Build
step "🔨 Building..."
./scripts/build.sh

# Run lint
step "🔍 Running lint..."
./scripts/lint.sh

# Dry run publish
step "📦 Dry run npm publish..."
cd packages/drop-in-css
npm publish --dry-run
cd ../..

# Commit and tag
step "📌 Creating commit and tag..."
git add -A
git commit -m "release: v$NEW_VERSION"
git tag -a "v$NEW_VERSION" -m "Release v$NEW_VERSION"

# Local publish
step "🔐 Publishing (you may be prompted for 2FA)..."
cd packages/drop-in-css
npm publish --access public
cd ../..

step "🚀 Pushing to origin..."
git push origin "$BRANCH"
git push origin "v$NEW_VERSION"

newline
success "✅ Release v$NEW_VERSION published!"
