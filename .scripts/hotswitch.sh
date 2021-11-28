

# setting up new mode for my HDMI
xrandr --newmode "1920x1080" 148.5 1920 2008 2052 2200 1080 1089 1095 1125 +hsync +vsync
xrandr --addmode HDMI-1 1920x1080

# default monitor is eDP1
MONITOR=eDP1

# functions to switch from eDP1 to HDMI and vice versa
function ActivateHDMI {
    echo "Switching to HDMI-1"
    #xrandr --output HDMI1 --mode 1920x1080 --dpi 160 --output eDP1 --mode 1920x1080 --right-of HDMI1
    xrandr --output HDMI-1 --auto --right-of eDP-1
    MONITOR=HDMI-1
}
function DeactivateHDMI {
    echo "Switching to eDP1"
    xrandr --output HDMI-1 --off --output eDP-1 --auto
    MONITOR=eDP-1
}

# functions to check if HDMI is connected and in use
function HDMIActive {
    [ $MONITOR = "HDMI-1" ]
}
function HDMIConnected {
    ! xrandr | grep "^HDMI-1" | grep disconnected
}

# actual script
while true
do
    if ! HDMIActive && HDMIConnected
    then
        ActivateHDMI
    fi

    if HDMIActive && ! HDMIConnected
    then
        DeactivateHDMI
    fi

    sleep 1s
done
