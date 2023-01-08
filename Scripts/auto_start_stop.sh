#!/bin/bash

# Imports
source config.sh

# Stops the server
echo "10" | bash server_stop.sh

# Create backup
today=$(date +"%Y-%m-%d")
zip -r ${backup_path}${level_name}_${today}.zip ${server_path}${level_name}/

# Delete old backup
deleteday=$(date -d '30 days ago' +'%Y-%m-%d')
rm -f "${backup_path}${level_name}_${deleteday}.zip"
