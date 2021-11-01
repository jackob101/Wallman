#! /bin/bash


listOfConfigs=("$HOME/.Xresources" "$HOME/.bashrc" "$HOME/.config/i3/config" "$HOME/.config/polybar/config.ini" "$HOME/.config/polybar/launch.sh" "$HOME/.config/picom/config" "$HOME/.config/alacritty/alacritty.yml" "$HOME/.config/alacritty/colorScheme.yml" "$HOME/.config/conky/.conkyrc" "$HOME/.config/conky/timev2.conkyrc" "$HOME/.config/rofi/confirm.rasi" "$HOME/.config/rofi/launcher.sh" "$HOME/.config/rofi/launcherStyle.rasi" "$HOME/.config/rofi/message.rasi" "$HOME/.config/rofi/pmenucolors.rasi" "$HOME/.config/rofi/powermenu.sh" "$HOME/.config/rofi/row_square.rasi" "$HOME/.config/dunst/dunstrc" "$HOME/.config/dunst/error.png" "$HOME/.config/dunst/normal.png" "$HOME/.config/dunst/normalGreen.png" "$HOME/.config/rofi/bmenu.rasi" "$HOME/.config/rofi/global.rasi" "$HOME/.config/nvim/" "$HOME/.config/awesome/rc.lua" "$HOME/.config/awesome/configs/" "$HOME/.config/awesome/errors/" "$HOME/.config/awesome/img/" "$HOME/.config/awesome/modules/" "$HOME/.config/awesome/theme.lua" "$HOME/.config/awesome/widgets/")

for value in "${listOfConfigs[@]}";do $(/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME add $value); done
