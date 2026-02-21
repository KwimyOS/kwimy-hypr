#!/usr/bin/env bash

dir="$HOME/.config/rofi/themes"
theme='dynamic'

## Run
rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
