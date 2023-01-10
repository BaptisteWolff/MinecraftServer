#!/bin/bash

# Imports
source config.sh
source colors.sh

function assert_server_not_running(){
	if pgrep -f $jar_file &> /dev/null 2>&1;
	then
		printf "${COLOR_RED}The server is running !${COLOR_RESET}\n"
		exit 1
	fi
}

# Check server not running
assert_server_not_running

# Schedule sleep until 07:55
rtcwake -m mem -t $(date +%s -d '07:55')
