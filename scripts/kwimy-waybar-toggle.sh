#!/bin/bash

if systemctl --user is-active --quiet waybar; then
    systemctl --user stop waybar
else
    systemctl --user start waybar
fi
