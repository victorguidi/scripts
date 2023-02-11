#!/bin/bash
# This script will use fzf to select a docker image and start a new container with it.

images=$(docker images --format "{{.Repository}}:{{.Tag}}")

image=$(echo "$images" | fzf-tmux --reverse --multi --border --prompt="Select an Image") || exit

read -p "Container name: " name

docker run -d --name "$name" "$image"

