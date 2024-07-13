#!/bin/bash

echo "Hi"


# itunes-media-old-comp-weird-small
# itunes-media-before-importing-old-comp 
# itunes-media-old-comp                  
# itunes-media-old-old-previous

old_comp_weird_small=/Users/tripp/Library/Mobile\ Documents/com~apple~CloudDocs/backup/music-library/itunes-media-old-comp-weird-small
before_importing_old_comp=/Users/tripp/Library/Mobile\ Documents/com~apple~CloudDocs/backup/music-library/itunes-media-before-importing-old-comp
old_comp=/Users/tripp/Library/Mobile\ Documents/com~apple~CloudDocs/backup/music-library/itunes-media-old-comp
old_old_previous=/Users/tripp/Library/Mobile\ Documents/com~apple~CloudDocs/backup/music-library/itunes-media-old-old-previous

merged=/Users/tripp/Music/merged-itunes-media

# Function to copy files and directories
copy_contents() {
    local source_dir="$1"
    local destination_dir="$2"

    # Copy files and directories to $merged
    # -a is archive mode, which preserves permissions, ownership, etc.
    # -v is verbose mode, which prints out each file as it's copied
    # --ignore-existing is a flag that tells rsync to not copy files that already exist in the destination directory
    rsync -av --ignore-existing "$source_dir"/ "$destination_dir"/
}

# Copy contents of each directory to $merged
copy_contents "$old_comp_weird_small" "$merged"
copy_contents "$before_importing_old_comp" "$merged"
copy_contents "$old_comp" "$merged"
copy_contents "$old_old_previous" "$merged"
