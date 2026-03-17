#!/usr/bin/env bash

# Default language
DEFAULT_LANG="en"

# Handle Sonarr Test event
if [[ "${sonarr_eventtype:-}" == "Test" ]]; then
  echo "Sonarr script test successful."
  exit 0
fi

# Exit on error
set -euo pipefail

# Sonarr environment variables
SOURCE_ROOT="${sonarr_episodefile_sourcefolder}"
SOURCE_FILE="${sonarr_episodefile_sourcepath}"
TARGET_FILE="${sonarr_episodefile_path}"

# Validate variables
if [[ -z "${SOURCE_ROOT:-}" || -z "${SOURCE_FILE:-}" || -z "${TARGET_FILE:-}" ]]; then
  echo "Missing required Sonarr environment variables."
  exit 1
fi

if [[ ! -d "$SOURCE_ROOT" ]]; then
  echo "Source folder does not exist: $SOURCE_ROOT"
  exit 1
fi

TARGET_DIR="$(dirname "$TARGET_FILE")"
BASENAME="$(basename "$SOURCE_FILE")"
TARGET_BASENAME="$(basename "$TARGET_FILE")"
NAME_NO_EXT="${BASENAME%.*}"
TARGET_NAME_NO_EXT="${TARGET_BASENAME%.*}"

echo -e "Source: $SOURCE_ROOT \nTarget: $TARGET_DIR \nBase name: $NAME_NO_EXT"

# Function to process files (Sound or Sub)
process_files() {
  local ext="$1"

  find "$SOURCE_ROOT" -type f -name "${NAME_NO_EXT}.${ext}" | while read -r file; do

    # Parent folder name (e.g. "Sound [MC-Ent]")
    folder_name="$(basename "$(dirname "$file")")"

    # Remove leading "Sound " or "Sub "
    tag="${folder_name#Sound }"
    tag="${tag#Sub }"

    # Clean whitespace
    tag="$(echo "$tag" | xargs)"

    # Build filename
    if [[ -n "$tag" ]]; then
      target_file="${TARGET_DIR}/${TARGET_NAME_NO_EXT}.${tag}.${DEFAULT_LANG}.${ext}"
    else
      target_file="${TARGET_DIR}/${TARGET_NAME_NO_EXT}.${DEFAULT_LANG}.${ext}"
    fi

    if [[ -e "$target_file" ]]; then
      echo "Skipping (exists): $target_file"
      continue
    fi

    echo "Linking:"
    echo "  $file"
    echo "-> $target_file"

    if ! ln "$file" "$target_file" 2>/dev/null; then
      echo "Symlink failed, copying instead."
      cp -p "$file" "$target_file"
    fi

  done
}

# Process audio
process_files "mka"
process_files "mp3"
# Process subtitles
process_files "srt"
process_files "ass"

echo "All done."

exit 0
