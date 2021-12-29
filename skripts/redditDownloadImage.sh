#! /bin/bash

images_location="$HOME/Wallpapers/"
amount_of_numbers_in_name=5

create_name (){

    size=${#1}

    zeros_to_add=$((amount_of_numbers_in_name - size))

    new_file_name=$1".png"

    for (( i = 1 ; i <= zeros_to_add ; i++))
    do
    new_file_name="0"$new_file_name
    done

    echo "$new_file_name"

}

link="$(rofi -P "Insert link" -dmenu -theme "$HOME/.config/rofi/wideInput.rasi")"

if [ ${#link} -gt 5 ]
then
    file_name="$(echo $link | awk -F "/" '{print $NF}')"
    number_of_files="$(find "$images_location" -maxdepth 1 -type f | wc -l)"

    number_of_files_size=${#number_of_files}
    zeros_to_add=$((amount_of_numbers_in_name - number_of_files_size))

    new_file_name=$((number_of_files + 1))".png"

    declare -a images=()

    # Parse images full path into only number. /home/jakub/Wallpapers/001.png becomes 001.
    for entry in "$images_location"*
    do
    string_name=$(echo "$entry" | awk -F'[/.]' '{print $5}')
    images+=($((10#$string_name)))

    done

    # Sort ascending
    declare -a images_sorted=()
    images_sorted+=($(sort -nk1 <(printf "%d\n" "${images[@]}")))

    echo $images_sorted

    length=${#images_sorted[@]}

    # Get first free number
    if [ $length -lt 2 ];
    then
        new_file_name=$(create_name 2)
        echo $new_file_name
    else
        for (( i=1; i<${length}; i++ ));
        do

        previous_element=${images_sorted[i - 1]}
        current_element=${images_sorted[i]}

        if [[ $(($previous_element + 1)) -ne $current_element ]];
        then
            new_file_name=$(create_name $((i+1)))
            break
        fi
        done
    fi

    printf "New file name %s\n" $new_file_name

    yes="1.Yes"
    no="2.No"
    cancel="3.Cancel"
    options="$yes\n$no\n$cancel"

    answer="$(echo -e $options | rofi -P "Do you want to scale image" -dmenu -theme "$HOME/.config/rofi/dmenu.rasi" )"

    if [ $answer = $yes ] || [ $answer = $no ]
    then

        /bin/wget -P $images_location $link

        if [ $answer = $yes ]
        then
            /bin/convert $images_location$file_name -resize 1920x1080\>\! $images_location$new_file_name
        elif [ $answer = $no ]
        then
            cp $images_location$file_name $images_location$new_file_name
        fi

        rm $images_location$file_name
        notify-send "Reddit image downloader" "Image succeffully downloaded"
    else
    notify-send "Reddit image downloader" "Image saving was aborted"
    fi
fi
