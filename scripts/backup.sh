#!/bin/bash
#------------------------------
# Backup script
#------------------------------
# Configuration
#------------------------------
backups_root="$HOME/backup"
#------------------------------

set -o nounset

backup_dir=$backups_root/$(date +"%F-%H%M%S")

if [[ ! -d $backup_dir ]]; then
    mkdir -p $backup_dir
fi

if [[ $EUID = 0 ]]; then
    echo "Ooops, you're running this as root! You better not!"
    exit 1
fi

backupCredentials () {
    echo "Backing up credentials.."
    cd "$HOME"
    tar -czf "$backup_dir"/credentials.tar.gz \
        .ssh/ \
        .aws/ \
        .azure/ \
        &> /dev/null
}

backupWorkData () {
    echo "Backing up work files.."
    cd "$HOME"
    tar -czf "$backup_dir"/work.tar.gz \
        .config/tmuxinator \
        projects/ \
        workspaces/ \
        &> /dev/null
}

backupCredentials &&\
backupWorkData &&\

exit 0
