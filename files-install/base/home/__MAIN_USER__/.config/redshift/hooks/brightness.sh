#!/bin/sh

brightness_day="40"
brightness_night="10"
brightness_transition="25"
fade_time=5000

case $1 in
    period-changed)
        case $3 in
            night)
                xbacklight -set $brightness_night -time $fade_time
                ;;
            transition)
                xbacklight -set $brightness_transition -time $fade_time
                ;;
            daytime)
                xbacklight -set $brightness_day -time $fade_time
                ;;
        esac
        ;;
esac
