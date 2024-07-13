#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <path_to_library.xml>"
    exit 1
fi

xmlFilePath="$1"

# Check if the file exists
if [ ! -f "$xmlFilePath" ]; then
    echo "Error: XML file not found at $xmlFilePath"
    exit 1
fi

# Define system playlist names to exclude
system_playlists=("Library" "Music" "TV Shows" "Movies" "Podcasts" "Audiobooks")

# Extract playlist names
playlist_names=$(xmllint --xpath "//key[text()='Playlists']/following-sibling::array/dict[key[text()='Name' and string()]]/string/text()" "$xmlFilePath")

# Loop through playlists, excluding system playlists, and print song names
IFS=$'\n'
for playlist in $playlist_names; do
    # Check if the playlist is not a system playlist
    if [[ ! " ${system_playlists[@]} " =~ " ${playlist} " ]]; then
        echo "Playlist: $playlist"
        song_ids=$(xmllint --xpath "//key[text()='Playlists']/following-sibling::array/dict[key='Name' and string='$playlist']/array/dict[key='Playlist Items']/array/dict/key[text()='Track ID']/following-sibling::integer/text()" "$xmlFilePath")
        
        # Fetch and print song names using the retrieved song IDs
        for song_id in $song_ids; do
            song_name=$(xmllint --xpath "//key[text()='Tracks']/following-sibling::dict/key[text()='$song_id']/following-sibling::dict/key[text()='Name']/following-sibling::string/text()" "$xmlFilePath")
            echo "Song ID: $song_id, Song Name: $song_name"
        done

        echo
    fi
done
