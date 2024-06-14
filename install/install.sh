#!/bin/bash

# Check OS
OS=$(uname -s)
ARCH=$(uname -m)

# Define the download URL and the file name
BASE_URL="https://github.com/masoncfrancis/filesize/releases/download/0.1.0"
FILE_NAME=""

# Determine the file to download based on OS and architecture
case "$OS" in
    "Linux")
        case "$ARCH" in
            "x86_64")
                FILE_NAME="filesize_linux_amd64_v0.1.0"
                ;;
            "arm64")
                FILE_NAME="filesize_linux_arm64_v0.1.0"
                ;;
            "armv5")
                FILE_NAME="filesize_linux_armv5_v0.1.0"
                ;;
            "armv6")
                FILE_NAME="filesize_linux_armv6_v0.1.0"
                ;;
            "armv7")
                FILE_NAME="filesize_linux_armv7_v0.1.0"
                ;;
            "i386")
                FILE_NAME="filesize_linux_386_v0.1.0"
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
                FILE_NAME="filesize_darwin_amd64_v0.1.0"
                ;;
            "arm64")
                FILE_NAME="filesize_darwin_arm64_v0.1.0"
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
                FILE_NAME="filesize_freebsd_amd64_v0.1.0"
                ;;
            "arm")
                FILE_NAME="filesize_freebsd_arm_v0.1.0"
                ;;
            "i386")
                FILE_NAME="filesize_freebsd_386_v0.1.0"
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
sudo mv /tmp/$FILE_NAME /usr/local/bin/filesize

# Verify installation
if command -v filesize &> /dev/null; then
    echo "Installation successful. 'filesize' is now available."
else
    echo "Installation failed."
fi
