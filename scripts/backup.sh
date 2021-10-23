#!/bin/bash
#------------------------------
# Backup script
#------------------------------
# Configuration
#------------------------------
backupDir="$HOME/backup"
#------------------------------

set -o nounset

if [[ ! -d $backupDir ]]; then
    mkdir -p $backupDir
fi

if [[ $EUID = 0 ]]; then
    echo "Ooops, you're running this as root! You better not!"
    exit 1
fi

backupSsh () {
    echo "Backing up ssh files.."
    cd "$HOME"
    tar -czf "$backupDir"/ssh.tar.gz \
        .ssh/ \
        &> /dev/null
}

backupProjects () {
    echo "Backing up project files.."
    cd "$HOME"
    tar -czf "$backupDir"/projects.tar.gz \
        projects/ \
        workspaces/ \
        &> /dev/null
}

backupSsh &&\
backupProjects &&\

exit 0
