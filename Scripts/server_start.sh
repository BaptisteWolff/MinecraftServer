#!/bin/bash

# Imports
source config.sh
source colors.sh

# Check if the tmux session exists
session_exists=0

tmux has-session -t $tmux_session 2>/dev/null
if [ $? = 0 ];
then
  	session_exists=1
fi

# Check if the server is already running
if pgrep -f minecraft &> /dev/null 2>&1;
then
	printf "It seems a server is already running.\n"

	if [ $session_exists = 0 ];
	then
	  	printf "${COLOR_RED}The TMUX session ${tmux_session} was not found.${COLOR_RESET}\n"
	else
		# Attach to already created session
		tmux attach-session -t $tmux_session
	fi
else
	# Start or attach to the session and start the server
	if [ $session_exists = 0 ];
	then
		tmux new -s $tmux_session -d
	fi
	tmux send-keys -t $tmux_session "clear && cd ${server_path} && java -Xmx${mem_max}M -Xms${mem_min}M -jar minecraft_server.1.19.3.jar nogui" Enter
	tmux attach-session -t $tmux_session
fi
