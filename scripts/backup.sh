#!/bin/bash
#------------------------------
# Backup script
#------------------------------
# Configuration
#------------------------------
backupsDir="$HOME/backup"
#------------------------------

set -o nounset

backupTo=$backupsDir/$(date +"%F-%H%M%S")

if [[ ! -d $backupTo ]]; then
    mkdir -p $backupTo
fi

if [[ $EUID = 0 ]]; then
    echo "Ooops, you're running this as root! You better not!"
    exit 1
fi

backupSsh () {
    echo "Backing up ssh files.."
    cd "$HOME"
    tar -czf "$backupTo"/ssh.tar.gz \
        .ssh/ \
        &> /dev/null
}

backupProjects () {
    echo "Backing up project files.."
    cd "$HOME"
    tar -czf "$backupTo"/projects.tar.gz \
        projects/ \
        workspaces/ \
        &> /dev/null
}

backupSsh &&\
backupProjects &&\

exit 0
