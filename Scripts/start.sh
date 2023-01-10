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
if pgrep -f $jar_file &> /dev/null 2>&1;
then
	printf "It seems a server is already running.\n"

	if [ $session_exists = 0 ];
	then
	  	printf "${COLOR_RED}The TMUX session ${tmux_session} was not found.${COLOR_RESET}\n"
	else
		# Attach to already created session
		# tmux attach-session -t $tmux_session
		printf "The TMUX session ${tmux_session} exists.\n"
	fi
else
	# Start or attach to the session and start the server
	if [ $session_exists = 0 ];
	then
		tmux new -s $tmux_session -d
	fi
	# Loop while with "&& break" -> will restart if exit 1 (crash), stop gracefully if exit code 0
	tmux send-keys -t $tmux_session "clear && cd ${server_path} && while true; do java -Xmx${mem_max}M -Xms${mem_min}M -jar ${jar_file} nogui && break; done" Enter
	# tmux attach-session -t $tmux_session
	printf "Server starting on the TMUX session ${tmux_session}.\n"
fi
