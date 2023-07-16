#!/bin/bash

path=$(find $HOME/Config/ -type d -regex '.*\w*/.config/\w*$' | rofi -dmenu)

cd $path
nvim $path

