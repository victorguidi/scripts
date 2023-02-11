#!/bin/sh

# This Script will use dmenu to display a list of all my projects listed on my projects directory and will open the selected folder in vscode

while [ -z "$project" ]; do
    category=$(ls -d ~/projects/* | sed 's/.*\///' | fzf-tmux --reverse -p) && cd ~/projects/$category
    [ -z "$category" ] || project=$(ls -d ~/projects/$category/* | sed 's/.*\///' | fzf-tmux --reverse -p)
    [ -z "$category" ] && [ -z "$project" ] && exit
done

nvim ~/projects/$category/$project

