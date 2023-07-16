#!/usr/bin/env bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

#Path to style
theme="style.rasi"
dir="$HOME/.config/rofi/launcher"

#exec command
rofi  -no-lazy-grab -show drun -p "Application name" -theme $dir/"$theme"
