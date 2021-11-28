xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto

exec $(get_session "$1")
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

xset r rate 200 80
#exec ~/.scripts/startup_background.sh
if [[ -f /usr/bin/prime-offload ]]; then
    /usr/bin/prime-offload
fi

exec i3
if [[ -f /usr/bin/prime-switch ]]; then
    sudo /usr/bin/prime-switch
fi


