#!/bin/sh

/bin/find $HOME/Wallpapers/ -maxdepth 1 -type f | /bin/grep -E "[0-9]" | /bin/shuf -n 1| xargs /bin/swww img --transition-type wipe --transition-angle 50 --transition-step 90
