#!/bin/bash

echo '';
echo '===================';
echo `date +%d/%m/%Y\ %H:%M:%S`;
echo '===================';

tmux_session="Minecraft"
base_path="/home/baptiste/Minecraft/"
server_path="${base_path}Server/"
backup_path="${base_path}Backups/"

# Server config
jar_file="pufferfish-paperclip-1.19.3-R0.1-SNAPSHOT-reobf.jar"
mem_min="1024"
mem_max="3072"
level_name="Basile"
