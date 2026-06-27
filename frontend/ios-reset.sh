#!/bin/bash

# Quick iOS Reset - shortcut for ios-reset-clean.sh
# Usage: ./ios-reset.sh [simulator_name]

SIMULATOR_NAME="${1:-iPhone 15 Pro}"
echo "🔄 Quick iOS Reset: $SIMULATOR_NAME"
echo "================================"

# Run full reset script
./ios-reset-clean.sh "$SIMULATOR_NAME"
