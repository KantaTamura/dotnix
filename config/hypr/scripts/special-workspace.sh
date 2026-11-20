#!/bin/bash

# ┌──────────────────────────────────────────────────┐
# │ special workspace                                │
# └──────────────────────────────────────────────────┘

sleep 1

# "special:mail" workspace
# - thunderbird
hyprctl dispatch togglespecialworkspace "mail"
hyprctl dispatch exec thunderbird
sleep 2

# "special:music" workspace
# - spotify
hyprctl dispatch togglespecialworkspace "music"
hyprctl dispatch exec spotify-launcher
sleep 2

# "special:monitor" workspace
hyprctl dispatch togglespecialworkspace "monitor"
hyprctl dispatch exec "footclient -e btop"
sleep 2

# "special:notes" workspace
hyprctl dispatch togglespecialworkspace "notes"
hyprctl dispatch exec obsidian
sleep 2

# "special:comms" workspace
# - Slack
# - Discord
hyprctl dispatch togglespecialworkspace "comms"
hyprctl dispatch exec slack
hyprctl dispatch exec discord
sleep 5

# return to the base workspace
hyprctl dispatch togglespecialworkspace "comms"
