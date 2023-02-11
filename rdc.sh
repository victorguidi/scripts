#!/bin/sh

# This Script will use fzf to select a container and then run it

containers=$(docker ps -a --format "{{.Names}}")

container=$(echo "$containers" | fzf-tmux --reverse --multi --border --prompt="Select a Container") || exit

docker start "$container"
