#! /bin/bash

file_location="$HOME/.personalGoals"
rofi_bmenu_theme="$HOME/.config/rofi/bmenu"

function add_new_entry {
    new_entry="$(rofi -p "Insert new goal" -dmenu -theme "$HOME/.config/rofi/wideInput")"
    if [[ ${#new_entry} > 4 ]]
    then
	echo $new_entry >> $file_location
    fi
}

function remove_entry {
    selected="$(awk '{ print NR " " $0 }' $file_location | rofi -p "Select option" -dmenu )"
    number="$(echo $selected | awk '{ print $1 }')"
    re='^[0-9]+$'
    if [[ $number =~ $re ]]
    then
	echo "Number"
	sed -i "${number}d" $file_location
    fi

}


option_one="1. Add new entry"
option_two="2. Remove entry"

choosen_option="$(echo -e "$option_one\n$option_two" | rofi -theme $rofi_bmenu_theme -dmenu)"

if [[ $choosen_option = $option_one ]]
then
    add_new_entry

elif [[ $choosen_option = $option_two ]]
then
    remove_entry
fi
    
killall conky
conky -c ~/.config/conky/goals.conkyrc 


