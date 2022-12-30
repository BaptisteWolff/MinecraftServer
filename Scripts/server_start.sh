#!/bin/bash

# Imports
source config.sh
source colors.sh

# Check if the server is already running
if pgrep -f minecraft &> /dev/null 2>&1;
then
	printf "It seems a server is already running.\n"

	# Check if the session exists, discarding output
	# We can check $? for the exit status (zero for success, non-zero for failure)
	tmux has-session -t $tmux_session 2>/dev/null

	if [ $? != 0 ];
	then
	  	printf "${COLOR_RED}The TMUX session ${tmux_session} was not found.${COLOR_RESET}\n"
	else
		# Attach to already created session
		tmux attach-session -t $tmux_session
	fi
else
	# Start or attach to the session and start the server
	tmux new -A -s $tmux_session
	tmux send-keys -t $tmux_session "clear && cd ${server_path} && java -Xmx${mem_max}M -Xms${mem_min}M -jar minecraft_server.1.19.3.jar nogui" Enter
fi
