#!/bin/bash

# Run iOS - quick launch with full reset and clean build
# Usage: ./run-ios.sh [simulator_name]

SIMULATOR_NAME="${1:-iPhone 15 Pro}"
echo "🚀 Running iOS: $SIMULATOR_NAME"
echo "=========================="

# Run full reset script
./ios-reset-clean.sh "$SIMULATOR_NAME"
