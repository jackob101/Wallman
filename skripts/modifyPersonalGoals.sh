#! /bin/bash

file_location="$HOME/.personalGoals"

function add_new_entry {
    new_entry="$(rofi -p "Insert new goal" -dmenu)"
    echo $new_entry >> $file_location
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


option_one="Add new entry"
option_two="Remove entry"

choosen_option="$(echo -e "$option_one\n$option_two" | rofi -dmenu)"

if [[ $choosen_option = $option_one ]]
then
    echo "This is first option"
    add_new_entry

elif [[ $choosen_option = $option_two ]]
then
    echo "this is option two"
    remove_entry
fi
    


