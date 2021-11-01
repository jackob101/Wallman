for number in 1 2 3
do
	notify-send -t 1000000 -i "$HOME/Wallpapers/001.png"  -u critical "I guess this is title" "Notyfikacja normal nr: $number" 
	notify-send -t 1000000 -i "$HOME/Wallpapers/001.png"  -u normal "I guess this is title" "Notyfikacja normal nr: $number" 
done
exit 0
	
