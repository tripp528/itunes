#!/bin/bash

osascript <<EOD
tell application "Music"
    set protectedPlaylists to {"Library", "Music", "Music Videos", "Recently Added", "Recently Played", "Top 25 Most Played"}
    
    set allPlaylists to name of every playlist
    repeat with aPlaylist in allPlaylists
        if aPlaylist is not in protectedPlaylists then
            delete playlist aPlaylist
        end if
    end repeat
end tell
EOD