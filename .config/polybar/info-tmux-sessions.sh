#!/bin/sh

if sessionlist=$(tmux ls 2> /dev/null); then
    printf "Tmux "

    echo "$sessionlist" | while read -r line; do
        session=$(echo "$line" | cut -d ':' -f 1)

        if echo "$line" | grep -q "(attached)"; then
            status=""
        else
            status=""
        fi

        printf "%s%s " "$status" "$session"
    done

    printf "\n"
else
    printf "\n"
fi
