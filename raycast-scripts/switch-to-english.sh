#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Switch to English
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🇺🇸

# Documentation:
# @raycast.description Switch to English language
# @raycast.author Evgenii

keyboardSwitcher select "U.S." &>/dev/null
echo "English"
