#!/bin/bash

# Imports
source config.sh
source colors.sh

function close_tmux_session(){
	while pgrep -f $jar_file &> /dev/null 2>&1;
	do
		sleep 1;
	done
	# tmux send-keys -t $tmux_session "logout" Enter
}

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

function send_keys(){
	assert_tmux_session_exists
	tmux send-keys -t $tmux_session "$1" Enter
}

# Check if the server is already running and the tmux session exists
assert_server_running
assert_tmux_session_exists

# Ask the delay to the user
printf "Please enter the delay (min) for stopping the server [5]:\n"
read delay
delay=${delay:-5}

while ! [[ "$delay" =~ ^[1-9][0-9]{0,1}$|^100$|^0$ ]]
do
	echo "Integers between 0 and 100 only"
	read delay
	delay=${delay:-5}
done

# Sends a message to players
for((i=$delay;i>0;--i)) do
	assert_server_running
	if [ "$i" = "$delay" ] || [ "$i" = 60 ] || [ "$i" = 30 ] || [ "$i" = 10 ] || [ "$i" = 5 ] || [ "$i" = 1 ];
	then
		echo "Server closes in ${i} min."
		send_keys "msg @a Le server s'arrêtera dans ${i} min."
	else
		assert_tmux_session_exists
	fi
	sleep 1m
done

# Stop the server
send_keys "stop"

# Wait for the server to stop in the backgroud before closing the tmux session
#close_tmux_session &

# Attach to already created session to monitor the progression
#assert_tmux_session_exists
#tmux attach-session -t $tmux_session

echo 'Stopping the server ...'
close_tmux_session

# Check server not running
assert_server_not_running

# Create backup and delete old backup
echo 'Creating backup ...'
today=$(date +"%Y-%m-%d")
cd ${server_path}
zip -q -r ${backup_path}${level_name}_${today}.zip ${level_name}/ ${level_name}_nether/ ${level_name}_the_end/ || (printf "${COLOR_RED}Error when creating backup.${COLOR_RESET}\n" && exit 1)
echo "Backup created."

# Delete old backup
echo 'Deleting old backup ...'
deleteday=$(date -d '10 days ago' +'%Y-%m-%d')
rm -f "${backup_path}${level_name}_${deleteday}.zip")

# Send backup to gdrive
echo 'Sending backup to gdrive ...'
rclone copyto ${backup_path}${level_name}_${today}.zip gdrive:Minecraft/${level_name}.zip
