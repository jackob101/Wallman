#!/bin/sh 

grep -w bind $HOME/.config/hypr/hyprland.conf | awk -F= '{print $2}' |awk -F, \
'{command = "";
 split($1, mod_key, " ");
 keybind = mod_key[1];
 for (i = 2; i <= length(mod_key); i++)
         { keybind = keybind " + " mod_key[i] };
 keybind = keybind " +" $2;
 for (i = 3; i <= NF - 1; i++)
         {command = command " " $i};
 split($NF, last_entry, "#");
 command = command " " last_entry[1];
 gsub(/^[ \t]+|[ \t]+$/, "", command);
 command = "<"command">";
 description = "";
 if(length(last_entry)==2) {
         gsub(/^[ \t]+|[ \t]+$/, "", last_entry[2]);
         description = last_entry[2];
 } else
         {description = "__________"};
 print description "  ----  <" keybind ">"}' \
 | rofi -dmenu -theme $HOME/.config/rofi/launcher/dmenu_search.rasi 
