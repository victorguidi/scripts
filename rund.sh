#!/bin/bash
# This script will work as my docker "hub" it will:
# 1. Build docker images
# 2. Run docker containers
# 3. Stop docker containers
# 4. Remove docker containers
# 5. Get docker container logs
# 6. Get docker container status
# 7. Get docker container IP
# It will use fzf to search, list and select containers that I will be working on.

while true; do
    # Printf the menu adding color to the selected option and the menu title.
    # The menu will be displayed using fzf.

    printf "Dockers Menu - Select an option:    
    1. Build docker images
    2. Run docker containers
    3. Stop docker containers
    4. Remove docker containers
    5. Get docker container logs
    6. Get docker container status
    7. Get docker container IP
    8. Exit
    "

    # Read the user input
    read -p -r "Enter your choice: " choice

    # If the user press Esc or Ctrl+C, exit the script
    if [[ $choice == "" ]]; then
        exit 0
    fi

    # Check the user input
    case $choice in
        1)
            # Build docker images
            # List the directories in the /home/username folder using fzf
            dir=$(find -d ~/* | fzf-tmux --height 40% --reverse --border --prompt="Select a directory: ")

            # Use fzf to select the dockerfile
            # The dockerfile can be in any folder in the selected directory, but the name should be Dockerfile
            dockerfile=$(find "$dir"/ -name "Dockerfile" | fzf-tmux --reverse --border --preview 'cat {}' --prompt="Select a dockerfile: ")

            # Prompt for the name of the image
            read -e -p -r $'  \e[1mEnter the name of the image: \e[0m' image_name

            # Build the image passing the image name and the directory of the dockerfile with the dockerfile name
            docker build -t "$image_name" "$dir" -f "$dockerfile"
            ;;
        2)
            # Run docker containers
            # Use fzf to search for docker images
            image=$(docker images | fzf-tmux --reverse --border --prompt='Select an image: ' | awk '{print $1}')

            # Check if there is already a container with that image
            if [ -z "$(docker container ls --all --filter ancestor="$image" -q)" ]; then
                # If there is no container with that image, run a new container

                # Prompt for infos about the container, like name, port, volume, etc.
                read -e -p -r $'  \e[1mEnter the name of the container: \e[0m' name
                read -e -p -r $'  \e[1mEnter the port number: \e[0m' port

                # Run the container
                # If the container name is not empty, use it, otherwise use a random name
                # If the container port is not empty, use it, otherwise use a random port

                docker run -d --name="$name" -p "$port":80 "$image"

            else
                # If there is a container with that image, start it
                # Prompt to see if the user wants to start the container
                read -e -p -r$'  \e[1mThere is already a container with that image, do you want to start it? [y/n]: \e[0m' start
                if [ "$start" == "y" ]; then
                    # Start the container
                    docker start $(docker container ls --all --filter ancestor=$image -q)
                else 
                    # If the user doesn't want to start the container, exit
                    exit
                fi
            fi
            ;;
        3)  
            # Stop docker containers
            # Use fzf to search for docker containers
            container=$(docker ps -a | fzf-tmux --reverse --border --prompt='Select a container: ')
            
            # Stop the container
            docker stop $container
            ;;

        4)
            # Remove docker containers or images
            # Prompt to see if the user wants to remove a container or an image
            read -e -p $'  \e[1mDo you want to remove a container or an image? [c/i]: \e[0m' remove

            if [ $remove == "c" ]; then
                # Remove a container
                # Use fzf to search for docker containers
                container=$(docker ps -a | fzf-tmux --reverse --border --prompt='Select a container: ')

                # Remove the container
                docker rm $container
            else
                # Remove an image
                # Use fzf to search for docker images
                image=$(docker images | fzf-tmux --reverse --border --prompt='Select an image: ' | awk '{print $1}')

                # Remove the image
                docker rmi $image
            fi
            ;;
        5)
            # Get docker container logs
            # Use fzf to search for docker containers
            container=$(docker ps -a | fzf-tmux --reverse --border --prompt='Select a container: ')

            # Get the logs
            # If the container is running, use the --follow option to follow the logs
            # If the container is not running, use the --tail option to get the last 100 lines of the logs
            # If the container is not running and the logs are empty, show a message
            # If the container is not running and the logs are not empty, show the logs

            if [ "$(docker inspect -f '{{.State.Running}}' $container)" = "true" ]; then
                docker logs --follow $container
            else
                if [ "$(docker logs --tail 100 $container)" = "" ]; then
                    echo "The container is not running and the logs are empty"
                else
                    docker logs --tail 100 $container
                fi
            fi
            ;;
        6)
            # Get docker container status
            # Use fzf to search for docker containers
            container=$(docker ps -a | fzf-tmux --reverse --border --prompt='Select a container: ')

            # Get the status
            docker inspect -f '{{.State.Running}}' $container
            ;;
        7)
            # Get docker container IP
            # Use fzf to search for docker containers
            container=$(docker ps -a | fzf-tmux --reverse --border --prompt='Select a container: ')
            docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container
            ;;
        8)
            # Exit
            echo "Exiting..."
            exit 0
            ;;
        *)
            # Invalid input
            echo "Invalid input..."
            ;;
    esac

done
