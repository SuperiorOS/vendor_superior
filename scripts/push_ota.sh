#!/bin/bash

# Constants
VERSION="Fifteen"
BASE_URL="https://master.dl.sourceforge.net/project/superioros"
OTA_REPO_URL="https://github.com/SuperiorOS/OTA"
OTA_FOLDER="OTA"
SF_HOST="frs.sourceforge.net"
PROJECT="superioros"  # SourceForge project name

# Colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'

# Function to extract properties from build.prop
extract_property() {
    grep "^$1=" "$BUILD_PROP" | cut -d'=' -f2
}

# Check if arguments are provided
if [[ -z "$1" || -z "$2" ]]; then
    echo -e "${RED}Usage: $0 <file_to_upload> <path_to_target_files_zip>${RESET}"
    exit 1
fi

FILE_PATH="$1"
TARGET_ZIP="$2"

# Validate the upload file
if [[ ! -f "$FILE_PATH" ]]; then
    echo -e "${RED}Error: File '$FILE_PATH' not found!${RESET}"
    exit 1
fi

# Validate the target zip file
if [[ ! -f "$TARGET_ZIP" ]]; then
    echo -e "${RED}Error: Target files ZIP '$TARGET_ZIP' not found!${RESET}"
    exit 1
fi

# Retrieve SourceForge username from Git config
USERNAME=$(git config --global sf.username)
if [[ -z "$USERNAME" ]]; then
    echo -e "${RED}Error: SourceForge username not set in Git config.${RESET}"
    echo -e "${YELLOW}Use 'git config --global sf.username <username>' to set it.${RESET}"
    exit 1
fi

# Temporary directory for extraction
TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

# Extract the build.prop file from the SYSTEM directory
echo -e "${BLUE}Extracting build.prop from the target ZIP...${RESET}"
unzip -q "$TARGET_ZIP" "SYSTEM/build.prop" -d "$TMP_DIR"
if [[ $? -ne 0 ]]; then
    echo -e "${RED}Error: Failed to extract 'SYSTEM/build.prop' from '$TARGET_ZIP'.${RESET}"
    exit 1
fi

BUILD_PROP="$TMP_DIR/SYSTEM/build.prop"

# Validate the existence of the build.prop file
if [[ ! -f "$BUILD_PROP" ]]; then
    echo -e "${RED}Error: build.prop file not found in 'SYSTEM/' inside the ZIP.${RESET}"
    exit 1
fi

# Extract properties from build.prop
DATETIME=$(extract_property "ro.build.date.utc")
ROMTYPE=$(extract_property "ro.superior.releasetype")
DEVICE=$(extract_property "ro.lineage.device")

# Set SourceForge remote path
REMOTE_PATH="/home/frs/project/$PROJECT/$DEVICE"

# Upload the file to SourceForge
echo -e "${CYAN}Uploading file to SourceForge...${RESET}"
scp -o StrictHostKeyChecking=no "$FILE_PATH" "$USERNAME@$SF_HOST:$REMOTE_PATH"
if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}File uploaded successfully to $REMOTE_PATH.${RESET}"
else
    echo -e "${RED}Error: File upload failed.${RESET}"
    exit 1
fi

# Remove the OTA folder if it exists, and clone the repository
if [[ -d "$OTA_FOLDER" ]]; then
    echo -e "${YELLOW}OTA folder exists. Removing it...${RESET}"
    rm -rf "$OTA_FOLDER"
fi

echo -e "${CYAN}Cloning the OTA repository...${RESET}"
git clone "$OTA_REPO_URL" "$OTA_FOLDER"

# Get the size and sha1sum of the FILE_PATH
SIZE=$(stat -c%s "$FILE_PATH")
FILE_ID=$(sha1sum "$FILE_PATH" | awk '{print $1}')

# Generate the JSON
JSON=$(cat <<EOF
{
  "response": [
    {
      "datetime": $DATETIME,
      "filename": "$(basename "$FILE_PATH")",
      "id": "$FILE_ID",
      "romtype": "$ROMTYPE",
      "size": $SIZE,
      "url": "$BASE_URL/$DEVICE/$(basename "$FILE_PATH")",
      "version": "$VERSION"
    }
  ]
}
EOF
)

# Output the JSON
OUTPUT_FILE="$OTA_FOLDER/${DEVICE}.json"
echo "$JSON" > "$OUTPUT_FILE"
echo -e "${GREEN}JSON generated and saved to $OUTPUT_FILE.${RESET}"

# Determine commit message based on filename
if [[ "$FILE_PATH" == *delta* ]]; then
    COMMIT_MESSAGE="Add Delta OTA update for $DEVICE"
elif [[ "$FILE_PATH" == *fullota* ]]; then
    COMMIT_MESSAGE="Add Full OTA update for $DEVICE"
else
    COMMIT_MESSAGE="Add OTA update for $DEVICE"
fi

# Push the changes to the OTA repository
echo -e "${CYAN}Pushing changes to the OTA repository...${RESET}"
cd "$OTA_FOLDER"
git add "${DEVICE}.json"
git commit -m "$COMMIT_MESSAGE"
git push
if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}OTA repository updated successfully.${RESET}"
else
    echo -e "${RED}Error: Failed to push changes to OTA repository.${RESET}"
    exit 1
fi
