#!/bin/bash

status=$(setxkbmap -query | awk '$0 ~ /layout/ {print $2}')

if [[ $status == "de" ]];
then
        setxkbmap -layout us
else
        setxkbmap -layout de
fi
