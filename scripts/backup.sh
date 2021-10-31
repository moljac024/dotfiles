#!/bin/bash
#------------------------------
# Backup script
#------------------------------
# Configuration
#------------------------------
BACKUPS_ROOT_DEFAULT="$HOME/backup"
#------------------------------

set -o nounset

if [[ $EUID = 0 ]]; then
    echo "Ooops, you're running this as root! You better not!"
    exit 1
fi

read -d '' RESTORE_SCRIPT <<-"_EOF_"
#!/bin/bash
#------------------------------
# Backup restore script
#------------------------------
# Configuration
#------------------------------
RESTORE_TO_DEFAULT="$HOME"
#------------------------------

set -o nounset

if [[ $EUID = 0 ]]; then
    echo "Ooops, you're running this as root! You better not!"
    exit 1
fi

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

RESTORE_FROM=$SCRIPT_DIR
RESTORE_TO=${1:-$RESTORE_TO_DEFAULT}

if [[ ! -d $RESTORE_TO ]]; then
    mkdir -p $RESTORE_TO
fi

cd $RESTORE_FROM
for f in *.tar.gz; do
    tar -xzvf "$f" --directory $RESTORE_TO
done

exit 0
_EOF_

BACKUPS_ROOT=${1:-$BACKUPS_ROOT_DEFAULT}

BACKUP_DIR=$BACKUPS_ROOT/$(date +"%F-%H%M%S")

if [[ ! -d $BACKUP_DIR ]]; then
    mkdir -p $BACKUP_DIR
fi

echo "$RESTORE_SCRIPT" > $BACKUP_DIR/restore.sh
chmod u+x $BACKUP_DIR/restore.sh

backupCredentials () {
    echo "Backing up credentials.."
    cd "$HOME"
    tar -czf "$BACKUP_DIR"/credentials.tar.gz \
        .ssh/ \
        &> /dev/null
}

backupDotfiles () {
    echo "Backing up dotfiles.."
    cd "$HOME"
    tar -czf "$BACKUP_DIR"/dotfiles.tar.gz \
        dotfiles/ \
        &> /dev/null
}

backupWorkData () {
    echo "Backing up work files.."
    cd "$HOME"
    tar -czf "$BACKUP_DIR"/work.tar.gz \
        .npmrc \
        .config/git \
        .config/tmuxinator \
        projects/ \
        workspaces/ \
        &> /dev/null
}

backupCredentials &&\
backupDotfiles &&\
backupWorkData &&\

exit 0
