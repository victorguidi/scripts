#!/bin/bash
# This script is used to either stop or stop and delete a docker container
# This script will use fzf to select the container to stop or delete

while true; do

    # Get the list of running containers
    containers=$(docker ps --format "{{.Names}}")

    # Use fzf to select the container to stop or delete
    container=$(echo "$containers" | fzf-tmux --reverse --multi --border --prompt="Select container to stop or delete: ")

    # If the user presses ctrl+c, exit the script
    if [ $? -ne 0 ]; then
        exit 0
    fi

    # Ask the user if they want to stop or delete the container
    read -p "Do you want to stop or delete the container? [s/d] " action

    # If the user presses ctrl+c, exit the script
    if [ $? -ne 0 ]; then
        exit 0
    fi

    # If the user wants to stop the container, stop it
    if [ "$action" = "s" ]; then
        docker stop "$container"
    # If the user wants to delete the container, delete it
    elif [ "$action" = "d" ]; then
        docker stop "$container"
        docker rm "$container"
    fi
done
