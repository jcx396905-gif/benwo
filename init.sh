#!/bin/bash

# =============================================================================
# init.sh - Flutter Project Initialization Script
# =============================================================================
# Run this script at the start of every session to ensure the environment
# is properly set up and the development server is running.
# =============================================================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# =============================================================================
# Environment Configuration - UPDATE THESE PATHS FOR YOUR SYSTEM
# =============================================================================

export FLUTTER_SDK="C:/flutter-sdk"
export ANDROID_SDK="C:/android-sdk"
export PATH="$FLUTTER_SDK/bin:$ANDROID_SDK/platform-tools:$ANDROID_SDK/cmdline-tools/latest/bin:$PATH"

echo -e "${YELLOW}Initializing Flutter project...${NC}"
echo "Flutter SDK: $FLUTTER_SDK"
echo "Android SDK: $ANDROID_SDK"

# Check if Flutter SDK exists
if [ ! -f "$FLUTTER_SDK/bin/flutter.bat" ]; then
    echo -e "${RED}Flutter SDK not found at: $FLUTTER_SDK${NC}"
    echo "Please update FLUTTER_SDK in init.sh to your Flutter SDK path"
    exit 1
fi

# Navigate to Flutter project directory
PROJECT_DIR="E:/ai home/realme/auto-coding-agent-flutter/hello-flutter"

if [ -f "$PROJECT_DIR/pubspec.yaml" ]; then
    cd "$PROJECT_DIR"
    echo "Found existing Flutter project"
else
    echo -e "${YELLOW}Creating new Flutter project...${NC}"
    mkdir -p "$PROJECT_DIR"
    cd "$PROJECT_DIR"
    "$FLUTTER_SDK/bin/flutter.bat" create --org com.benwo --project-name benwo .
    cd ..
fi

# Install dependencies
echo "Installing Flutter dependencies..."
"$FLUTTER_SDK/bin/flutter.bat" pub get

# Verify Flutter environment
echo ""
echo "Verifying Flutter environment..."
"$FLUTTER_SDK/bin/flutter.bat" doctor --android-licenses 2>/dev/null || true
"$FLUTTER_SDK/bin/flutter.bat" doctor

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✓ Initialization complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Ready to continue development."
echo ""
echo "Useful commands:"
echo "  flutter run          - Run the app with hot reload"
echo "  flutter analyze      - Analyze code for issues"
echo "  flutter test         - Run tests"
echo "  flutter build apk   - Build debug APK"
