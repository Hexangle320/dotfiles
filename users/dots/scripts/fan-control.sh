#!/usr/bin/env bash
set_fan_speed_percent() {
    fan_set_value=$1
    echo $fan_set_value

    $(ec_probe write 0x2C $fan_set_value)
    $(ec_probe write 0x2D $fan_set_value)
}


get_fan_speed_percent() {
    left_fan_percent=$(ec_probe read 0x2E)
    right_fan_percent=$(ec_probe read 0x2F)

    echo "Left fan speed in percent: $left_fan_percent"
    echo "Right fan speed in percent: $right_fan_percent"
}


if [[ $(whoami) != "root" ]]; then
    echo "Script must be run as root."
    exit 1
fi


if [[ $1 = set ]]; then
    set_fan_speed_percent $2
else
    echo $(get_fan_speed_percent)
fi

$(sensors | grep temp1 | head -2 | tail -1 | egrep -o '[0-9.]+' | tail -1)