#!/bin/bash

# Check OS
OS=$(uname -s)
ARCH=$(uname -m)

# Define the GitHub repository and API URL
REPO="masoncfrancis/size"
API_URL="https://api.github.com/repos/$REPO/releases/latest"

# Fetch the latest release information
echo "Fetching the latest release information..."
LATEST_RELEASE=$(curl -s $API_URL)

# Extract the tag name and construct the base URL
TAG_NAME=$(echo $LATEST_RELEASE | grep -oP '"tag_name": "\K(.*)(?=")')
BASE_URL="https://github.com/$REPO/releases/download/$TAG_NAME"

# Determine the file to download based on OS and architecture
FILE_NAME=""

case "$OS" in
    "Linux")
        case "$ARCH" in
            "x86_64")
                FILE_NAME="size_linux_amd64_$TAG_NAME"
                ;;
            "arm64")
                FILE_NAME="size_linux_arm64_$TAG_NAME"
                ;;
            "armv5")
                FILE_NAME="size_linux_armv5_$TAG_NAME"
                ;;
            "armv6")
                FILE_NAME="size_linux_armv6_$TAG_NAME"
                ;;
            "armv7")
                FILE_NAME="size_linux_armv7_$TAG_NAME"
                ;;
            "i386")
                FILE_NAME="size_linux_386_$TAG_NAME"
                ;;
            *)
                echo "Unsupported Linux architecture: $ARCH"
                exit 1
                ;;
        esac
        ;;
    "Darwin")
        case "$ARCH" in
            "x86_64")
                FILE_NAME="size_darwin_amd64_$TAG_NAME"
                ;;
            "arm64")
                FILE_NAME="size_darwin_arm64_$TAG_NAME"
                ;;
            *)
                echo "Unsupported macOS architecture: $ARCH"
                exit 1
                ;;
        esac
        ;;
    "FreeBSD")
        case "$ARCH" in
            "x86_64")
                FILE_NAME="size_freebsd_amd64_$TAG_NAME"
                ;;
            "arm")
                FILE_NAME="size_freebsd_arm_$TAG_NAME"
                ;;
            "i386")
                FILE_NAME="size_freebsd_386_$TAG_NAME"
                ;;
            *)
                echo "Unsupported FreeBSD architecture: $ARCH"
                exit 1
                ;;
        esac
        ;;
    *)
        echo "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Construct the full URL
DOWNLOAD_URL="$BASE_URL/$FILE_NAME"

# Download the file
echo "Downloading $FILE_NAME from $DOWNLOAD_URL"
curl -L -o /tmp/$FILE_NAME $DOWNLOAD_URL

# Make the file executable
chmod +x /tmp/$FILE_NAME

# Move the file to a directory in the PATH
sudo mv /tmp/$FILE_NAME /usr/local/bin/size

# Verify installation
if command -v size &> /dev/null; then
    echo "Installation successful. 'size' is now available."
else
    echo "Installation failed."
fi
