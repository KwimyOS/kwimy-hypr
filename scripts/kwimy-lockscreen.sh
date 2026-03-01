#!/usr/bin/env bash

hyprctl dispatch dpms off
pgrep -x hyprlock >/dev/null || hyprlock
