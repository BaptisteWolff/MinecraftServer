#!/bin/bash

# Imports
source config.sh
source colors.sh

function assert_server_running(){
	if ! pgrep -f $jar_file &> /dev/null 2>&1;
	then
		printf "${COLOR_RED}No running server found !${COLOR_RESET}\n"
		exit 1
	fi
}

function assert_server_not_running(){
	if pgrep -f $jar_file &> /dev/null 2>&1;
	then
		printf "${COLOR_RED}The server is running !${COLOR_RESET}\n"
		exit 1
	fi
}


function assert_tmux_session_exists(){
	tmux has-session -t $tmux_session 2>/dev/null
	if [ $? != 0 ];
	then
	  	printf "${COLOR_RED}The TMUX session ${tmux_session} was not found.\nUnnable to continue.${COLOR_RESET}\n"
	  	exit 1
	fi
}

# Check server running
assert_server_running
assert_tmux_session_exists

# Stops the server
echo "10" | bash stop.sh

# Check server not running
assert_server_not_running

# Create backup
today=$(date +"%Y-%m-%d")
zip -r ${backup_path}${level_name}_${today}.zip ${server_path}${level_name}/

# Delete old backup
deleteday=$(date -d '30 days ago' +'%Y-%m-%d')
rm -f "${backup_path}${level_name}_${deleteday}.zip"

# Schedule sleep and restart server
sudo rtcwake -m mem -t $(date +%s -d '07:59') && bash start.sh
