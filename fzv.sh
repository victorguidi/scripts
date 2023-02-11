#!/bin/sh
# This script will use fzf to select a file and then open it in nvim

# Select the folder to search in
folder=$(find ~/ -type d | fzf-tmux --reverse --multi -p --preview "exa {}" --border --height 100%) || exit

# Select the file to open
file=$(find "$folder" -type f | fzf-tmux --reverse --multi -p --preview "cat {}" --border --height 100%) || exit

# Open the file in nvim
nvim "$file"
