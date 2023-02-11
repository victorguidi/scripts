#!/bin/sh
# This script will curl a random movie from the IMDB top 250 list
# and display it in a notification

# A random number between 1 and 250
randomNumber=$(shuf -i 1-100 -n 1)

# Get the movie title from the IMDB top 250 list
movieTitle=$(curl -s "https://www.imdb.com/search/title/?count=100&title_type=feature,tv_series" | grep -oP '(?<=img alt=")[^"]*' | sed -n "$randomNumber"p)

# Display the movie title in a notification
notify-send "Random Movie" "$movieTitle"
