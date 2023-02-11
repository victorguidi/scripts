#!/bin/bash

# This script is used to select any file based on the name that will be selected by the user.
# It uses the fzf tool to select the file.
# It also accepts filters like, for example, to select only files with the .txt extension. or only files recently modified.

DIR="$HOME/projects/"
FILE=$(fd . --type f --exclude node_modules --exclude .git | fzf-tmux -d 20 --reverse -p --preview "cat {}")
# If the file is selected, it is opened
if [ -n "$FILE" ]; then
  nvim "$FILE"
else
  echo "No file selected" && exit 1
fi







