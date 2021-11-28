#!/bin/bash

export bgr=""
export brightness=50%
export time=`date +%H`

export str=(`ls ~/.scripts/bg/*`)  
export max_num_of_images=${#str[*]}


imgs_num=$(($RANDOM % $max_num_of_images))
export imgs_path="${str[$imgs_num]}"



if [[ $time -ge 6 && $time -lt 17  ]]; 
then
	brightness=80%
else
	brightness=40%
fi
echo $imgs_path
feh --bg-fill ${imgs_path}
brightnessctl s $brightness
source ~/.config/polybar/cuts/scripts/pywal.sh $imgs_path
picom --config ~/.config/picom/picom.conf
