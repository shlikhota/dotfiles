#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Switch to Russian
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🇷🇺

# Documentation:
# @raycast.description Switch to Russian language
# @raycast.author Evgenii

keyboardSwitcher select "Russian" &>/dev/null
echo "Russian"
