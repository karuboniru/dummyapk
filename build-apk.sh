#!/bin/bash

# Android APK Builder Script for Dummy URI Handler
# Builds the Android APK using Podman with proper SELinux workarounds

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Dummy URI Handler APK Builder ===${NC}"

# Check if Podman is installed
if ! command -v podman &> /dev/null; then
    echo -e "${RED}Podman is not installed. Please install Podman first.${NC}"
    echo -e "${YELLOW}On Fedora: sudo dnf install podman${NC}"
    echo -e "${YELLOW}On Ubuntu: sudo apt install podman${NC}"
    exit 1
fi

# Check if we're in the project directory
if [ ! -f "build.gradle" ] || [ ! -f "settings.gradle" ]; then
    echo -e "${RED}Please run this script from the project root directory.${NC}"
    exit 1
fi

# Clean previous builds
echo -e "${YELLOW}Cleaning previous builds...${NC}"
rm -rf app/build/ 2>/dev/null || true

# Build using thyrlian/android-sdk container with SELinux workaround
echo -e "${GREEN}Building APK using Android SDK container...${NC}"
echo -e "${YELLOW}This may take several minutes on first run...${NC}"

podman run --security-opt label=disable --rm \
    -v "$(pwd)":/project \
    -w /project \
    docker.io/thyrlian/android-sdk \
    ./gradlew assembleDebug

# Check if build was successful
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ APK built successfully!${NC}"

    # Display APK info
    if [ -f "app/build/outputs/apk/debug/app-debug.apk" ]; then
        APK_SIZE=$(du -h app/build/outputs/apk/debug/app-debug.apk | cut -f1)
        echo -e "${GREEN}APK location: app/build/outputs/apk/debug/app-debug.apk${NC}"
        echo -e "${GREEN}APK size: $APK_SIZE${NC}"

        # Show basic APK info
        echo -e "${BLUE}APK Contents:${NC}"
        ls -la app/build/outputs/apk/debug/
    fi
else
    echo -e "${RED}❌ APK build failed!${NC}"
    exit 1
fi

echo -e "${BLUE}=== Build Summary ===${NC}"
echo -e "${GREEN}Build completed successfully!${NC}"
echo -e "${YELLOW}To install on Android device:${NC}"
echo -e "  adb install app/build/outputs/apk/debug/app-debug.apk"
echo -e ""
echo -e "${YELLOW}To test URI handling:${NC}"
echo -e "  adb shell am start -d \"weixin://example.com/test\" -a android.intent.action.VIEW"
echo -e "  adb shell am start -d \"weixin://\" -a android.intent.action.VIEW"
echo -e ""
echo -e "${GREEN}The app will handle weixin:// URIs and display them in the interface.${NC}"
