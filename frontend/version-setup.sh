#!/bin/bash
set -euo pipefail

# Version management script for Android builds
# This script handles version bumping and environment synchronization

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"

# Function to load environment variables from .env
load_env() {
    if [ -f "$ROOT_DIR/.env" ]; then
        echo "📋 Loading environment variables from .env..."
        export $(grep -v '^#' "$ROOT_DIR/.env" | xargs)
        echo "📋 Loaded APP_VERSION_NAME=${APP_VERSION_NAME:-1.0}"
        echo "📋 Loaded APP_VERSION_CODE=${APP_VERSION_CODE:-1}"
    else
        echo "⚠️ .env file not found, using default version 1.0"
        export APP_VERSION_NAME="1.0"
        export APP_VERSION_CODE="1"
    fi
}

# Function to bump version
bump_version() {
    local bump_type="${1:-patch}"
    echo "📦 Auto-bumping $bump_type version..."
    npm run version:bump:"$bump_type"
}

# Function to sync version from package.json to environment
sync_version() {
    echo "🔄 Syncing version from package.json..."
    npm run version:env
}

# Main execution based on arguments
COMMAND="${1:-sync}"

case "$COMMAND" in
    "bump"|"bump-patch")
        bump_version "patch"
        sync_version
        load_env
        ;;
    "bump-minor")
        bump_version "minor"
        sync_version
        load_env
        ;;
    "bump-major")
        bump_version "major"
        sync_version
        load_env
        ;;
    "sync")
        sync_version
        load_env
        ;;
    "load")
        load_env
        ;;
    *)
        echo "Usage: $0 [command]"
        echo "Commands:"
        echo "  bump         - Bump patch version and sync"
        echo "  bump-minor   - Bump minor version and sync"
        echo "  bump-major   - Bump major version and sync"
        echo "  sync         - Sync version from package.json to environment"
        echo "  load         - Load environment variables from .env"
        exit 1
        ;;
esac
