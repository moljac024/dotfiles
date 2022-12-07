#!/bin/bash
#------------------------------
# Backup script
#------------------------------
# Configuration
#------------------------------
BACKUPS_ROOT_DEFAULT="$HOME/backup"
#------------------------------
set -u

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

echo "$RESTORE_SCRIPT" > $BACKUP_DIR/restore_files.sh
chmod u+x $BACKUP_DIR/restore_files.sh

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

backupTools () {
    echo "Backing up tools.."
    cd "$HOME"
    tar -czf "$BACKUP_DIR"/tools.tar.gz \
        .local/bin/ \
        .volta \
        .asdf \
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
        &> /dev/null
}


generateFlathubInstallScript () {
    echo "#!/bin/sh"
    echo ""
    echo "# Install user flatpaks"
    flatpak list --user --app --columns=origin,ref | \
    awk '{print "flatpak install --assumeyes --user "$1" "$2""}'
    echo ""
    echo "# Install system flatpaks"
    flatpak list --system --app --columns=origin,ref | \
    awk '{print "flatpak install --assumeyes --system "$1" "$2""}'
}

backupFlatpakApps () {
    echo "Backing up list of installed flatpak apps.."
    generateFlathubInstallScript > $BACKUP_DIR/install_apps.sh
    chmod u+x $BACKUP_DIR/install_apps.sh
}

backupCredentials &&\
backupDotfiles &&\
backupTools &&\
backupWorkData &&\
backupFlatpakApps &&\

exit 0
