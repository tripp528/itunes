#!/opt/homebrew/bin/bash

# Function to find and list duplicates by track (same track, same file type, same directory, with a number appended to the end)
find_duplicates() {
    local root_dir="$1"

    # dry run by default, see if false is passed as second argument
    local dry_run="${2:-true}"

    # Dry run to list duplicate files
    for i in {1..9}; do
        find "$root_directory" -type f -name "* $i.*" | while read -r file; do
            original_file="${file% $i*}.${file##*.}"
            
            if [ -e "$original_file" ]; then
                echo "Duplicate: $file"
                echo " Original: $original_file"
                if [ "$dry_run" == false ]; then
                    mv "$file" "$file".bak
                fi
            fi
        done
    done
}


# Function to find and list duplicates by track with different file types
find_track_duplicates() {
    local root_directory="$1"
    local valid_file_types=("mp3" "m4a" "flac" "wav" "ogg" "wma" "aac" "aiff" "alac" "dsd")

    # Create an associative array to store file information
    declare -A file_info

    # Build a list of files with their metadata
    total_files=$(find "$root_directory" -type f -print0 | grep -c -z .)
    progress_counter=0
    while IFS= read -r -d $'\0' file; do
        file_extension="${file##*.}"

        # Check if the file type is valid
        if [[ ! " ${valid_file_types[@]} " =~ " $file_extension " ]]; then
            continue
        fi

        file_size=$(stat -f%z "$file")

        # Use the full file path as the key and store a tuple as the value
        file_info["$file"]="$file_size"

        # Update the progress indicator
        ((progress_counter++))
        percentage=$((progress_counter * 100 / total_files))
        echo -ne "Metadata Progress: $percentage% ($progress_counter/$total_files)\r"
    done < <(find "$root_directory" -type f -print0)

    echo "Metadata collection complete!"

    # set up a new progress counter and total files based on the number of files in the associative array
    total_files=${#file_info[@]}
    progress_counter=0

    # Iterate through the list of files and find duplicates
    for file in "${!file_info[@]}"; do
        file_name="${file##*/}"
        file_size=${file_info["$file"]}

        # Find other files with the same track information and valid file types
        for other_file in "${!file_info[@]}"; do
            other_file_name="${other_file##*/}"
            other_file_size=${file_info["$other_file_name"]}

            # check if they are the same file (i.e. same file name same directory)
            if [ "$file" == "$other_file" ]; then
                continue
            fi

            # check if they are in different directories (i.e. different albums, should keep both)
            if [ "${file%/*}" != "${other_file%/*}" ]; then
                continue
            fi

            if [ "${file_name%.*}" == "${other_file_name%.*}" ]; then
                # get bigger file and smaller file
                if [ "$file_size" -gt "$other_file_size" ]; then
                    bigger_file="$file"
                    smaller_file="$other_file"
                else
                    bigger_file="$other_file"
                    smaller_file="$file"
                fi

                echo "Duplicate: $smaller_file"
                echo " Original: $bigger_file"

                if [ "$dry_run" == false ]; then
                    mv "$smaller_file" "$smaller_file".bak
                fi

                # remove from associative array
                unset file_info["$smaller_file"]

                # break out of inner loop if smaller_file is file
                if [ "$file" == "$smaller_file" ]; then
                    break
                else
                    continue
                fi
            fi
        done

        # Update the progress indicator
        ((progress_counter++))
        echo -ne "Scan Progress: $progress_counter/$total_files\r"
    done
}


# Specify the root directory of your music collection
music="/Users/tripp/Music/merged-itunes-media/Music"
voice_memos="/Users/tripp/Music/merged-itunes-media/Voice Memos"

# list of directories 
directories=(
    "/Users/tripp/Music/merged-itunes-media/Music"
    "/Users/tripp/Music/merged-itunes-media/Voice Memos"
)

# dry run by default, see if false is passed as second argument
dry_run="${1:-true}"

# echo find_duplicates "$voice_memos" "$dry_run"
# find_duplicates "$voice_memos" "$dry_run"
# echo find_duplicates "$music" "$dry_run"
# find_duplicates "$music" "$dry_run"
# echo find_track_duplicates "$voice_memos" "$dry_run"
# find_track_duplicates "$voice_memos" "$dry_run"
# echo find_track_duplicates "$music" "$dry_run"
# find_track_duplicates "$music" "$dry_run"

echo remove_duplicates_in_second_dir "$voice_memos" "$music" "$dry_run"
remove_duplicates_in_second_dir "$voice_memos" "$music" "$dry_run"
