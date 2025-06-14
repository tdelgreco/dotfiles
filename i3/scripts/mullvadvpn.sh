#!/bin/bash

status=$(mullvad status | awk '{print $1}' | head -n 1)

if [[ $status == "Disconnected" ]];
then
    mullvad connect
else
    mullvad disconnect
fi
