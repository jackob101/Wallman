#!/usr/bin/env bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

#Path to style
theme="bmenu"
dir="$HOME/.config/rofi"

#exec command
rofi -no-lazy-grab -show drun -modi drun -theme $dir/"$theme"
