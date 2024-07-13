#!/bin/bash


xmlFilePath="$1"

osascript <<EOD
    tell application "Music"
        set playlistFile to (POSIX file "$xmlFilePath") as alias
        set newPlaylist to import playlist from playlistFile
    end tell
EOD