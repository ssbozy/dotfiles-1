#!/usr/bin/env bash

function print_standard() {
    echo -e "\033[0m$1\033[0m"
}
function print_green() {
    echo -e "\033[0;32m$1\033[0m"
}
function print_red() {
    echo -e "\033[0;31m$1\033[0m"
}
function print_yellow() {
    echo -e "\033[0;33m$1\033[0m"
}
function control_c() {
    print_red "Quitting backup."
    exit
}


trap control_c SIGINT

date=`date`
LOCATION=$1
print_standard "Running backup.sh at $date to $LOCATION"

if [[ -d ~/Library/Application\ Support/MobileSync/Backup/ ]]; then
    messagedb=3d0d7e5fb2ce288813306e4d4636395e047a3d28
    messagedir=~/Documents/iphone_messages
    # Copy iPhone sms sqlite databases to ~/Docs, but only if the file has changed
    # TODO this assumes only a single file in backups!
    find ~/Library/Application\ Support/MobileSync/Backup/ -iname $messagedb -exec cp {} /tmp/$messagedb \;
    if [[ -e $messagedir/$messagedb ]]; then
        # A recent backup exists
        if ! diff $messagedir/$messagedb /tmp/$messagedb > /dev/null; then
            # Files are different; make a copy.
            print_green "Backing up new copy of iPhone SMS database."
            cd /tmp/ && tar -czf $messagedir/$messagedb.`date +%Y%m%d.%H%M`.tar.gz /tmp/$messagedb
            mv /tmp/$messagedb $messagedir/
        else
            print_green "Files are identical, not backing up iPhone SMS database."
        fi
    else
        # There are no backups in ~/Documents yet
        print_green "Backing up iPhone SMS database."
        cd /tmp/ && tar -czf $messagedir/$messagedb.`date +%Y%m%d.%H%M`.tar.gz /tmp/$messagedb
        mv /tmp/$messagedb $messagedir/
    fi
fi

hostname=""
dest_docs=""
dest_projects=""
dest_images=""
dest_pictures=""
dest_camera=""
dest_itunes=""
dest_porn=""
dest_mirror=""
dest_logs=""

# disabling auto-deletion since I plan on nuking ~/Documents - and running backup before it's restored
# would severely fuck me.
OPT_DELETE="" # change to --delete to delete stuff
OPT_DRYRUN="" # Change to -n to only do a dry run, leave blank otherwise


if [[ "$LOCATION" == "work" ]]; then
    hostname="moobox.netomat.net"
    dest_logs="/Users/pavel/Documents/irclogs/bip-logs"
    dest_docs="/media/MooDrive/pavel/backup/index/"
    dest_projects="/media/MooDrive/pavel/backup/projects/"
    dest_images="/media/MooDrive/pavel/backup/images/"
    dest_pictures="/media/MooDrive/pavel/backup/pictures/"
    dest_camera="/media/MooDrive/pavel/backup/camera/"
    dest_itunes="/media/MooDrive/pavel/Yonkpod/YonkLibrary/"
    dest_porn=""
    dest_mirror=""

    # Make sure that the truecrypt volume is mounted.
    if ssh moobox.netomat.net "ls /media/MooDrive/pavel/backup/mounted 2>/dev/null"; then 
        print_green "TrueCrypt volume mounted.";
    else
        print_yellow "TrueCrypt volume not mounted - only certain folders will be backed up.";
        dest_docs=""
        dest_projects=""
        dest_images=""
        dest_pictures=""
        dest_camera=""
    fi

elif [[ "$LOCATION" == "home" ]]; then
    dest_logs="/Users/pavel/Documents/irclogs/bip-logs"
    hostname="192.168.1.100"
    dest_docs="/media/asimov/index/"
    dest_projects="/media/asimov/projects/"
    dest_images="/media/asimov/images/"
    dest_camera="/media/niven/camera/"
    dest_pictures="/media/niven/pictures/"
    dest_itunes="/media/asimov/Yonkpod/YonkLibrary/"
    dest_porn="/media/niven/porn/"
    dest_mirror="/media/asimov/Downloads/mirror/"

else
    print_red "Invalid location specified.";
    exit 1;
fi

# Grab the bip logs
if [[ "$dest_logs" != "" && -d $dest_logs ]]; then
    print_green "Backing up bip logs to $dest_logs"
    rsync $OPT_DRYRUN -r --partial --progress -v --exclude='- bip.log' lishin.org:~/.bip/logs ~/Documents/irclogs/bip-logs
    rsync $OPT_DRYRUN -r --partial --progress -v --exclude='- bip.log' moobox.netomat.net:~/.bip/logs ~/Documents/irclogs/bip-logs
else
    print_yellow "Not backing up bip logs to $dest_logs"
fi

# Backup documents
if [[ "$dest_docs" != "" ]]; then
    print_green "Backing up documents to $hostname:$dest_docs"
    rsync $OPT_DRYRUN -a -r -z -v -u -h $OPT_DELETE --progress --partial --timeout=30 \
        ~/Documents/  \
        --exclude="- netomat/mobilityserver/" \
        --exclude="- netomat/csmobility/" \
        --exclude="- netomat/nycgo/" \
        --exclude="- netomat/nycgo-stuff/" \
        --exclude=*.screenflow \
        $hostname:$dest_docs
else
    print_yellow "No destination for documents"
fi

# Backup projects
if [[ "$dest_projects" != "" ]]; then
    print_green "Backing up projects to $hostname:$dest_projects"
    rsync $OPT_DRYRUN -a -r -z -v -u -h $OPT_DELETE --progress --partial --timeout=30 \
        --exclude="- *.vdi" \
        ~/projects/  \
        $hostname:$dest_projects
else
    print_yellow "No destination for projects"
fi

# Backup images
if [[ "$dest_images" != "" ]]; then
    print_green "Backing up images to $hostname:$dest_images"
    rsync $OPT_DRYRUN -a -r -z -v -u -h $OPT_DELETE --progress --partial --timeout=30 \
        --exclude="- \!pf/" \
        ~/images/  \
        $hostname:$dest_images
else
    print_yellow "No destination for images"
fi

# Backup pictures
if [[ "$dest_pictures" != "" ]]; then
    print_green "Backing up pictures to $hostname:$dest_pictures"
    rsync $OPT_DRYRUN -a -r -z -v -u -h $OPT_DELETE --progress --partial --timeout=30 \
        --exclude="- iPhoto Library/" \
        ~/Pictures/  \
        $hostname:$dest_pictures
else
    print_yellow "No destination for pictures"
fi

# Backup iTunes
if [[ "$dest_itunes" != "" ]]; then
    print_green "Backing up iTunes to $hostname:$dest_itunes"
    rsync $OPT_DRYRUN -r -z -v -u -h --delete --progress --partial --timeout=30 \
        ~/Music/iTunes/iTunes\ Media/  \
        $hostname:$dest_itunes
else
    print_yellow "No destination for iTunes"
fi

# Backup camera
if [[ "$dest_camera" != "" ]]; then
    print_green "Backing up camera to $hostname:$dest_camera"
    rsync $OPT_DRYRUN -a -r -z -v -u -h --progress --partial --timeout=30 \
        ~/camera/  \
        $hostname:$dest_camera
else
    print_yellow "No destination for camera"
fi

# Backup porn
if [[ "$dest_porn" != "" && -d ~/porn ]]; then
    print_green "Backing up porn to $hostname:$dest_porn"
    rsync $OPT_DRYRUN -a -r -z -v -u -h --delete --progress --partial --timeout=30 \
        ~/porn/  \
        $hostname:$dest_porn
else
    print_yellow "No destination for porn"
fi

# Backup mirrors
if [[ "$dest_mirror" != "" ]]; then
    print_green "Backing up mirrors to $hostname:$dest_mirror"
    rsync $OPT_DRYRUN -a -r -z -v -u -h --delete --progress --partial --timeout=30 \
        --exclude="- 4ch/" \
        --exclude="- rss/" \
        ~/Downloads/mirror/  \
        $hostname:$dest_mirror

    if [[ -d ~/Downloads/mirror/4ch ]]; then
        # Only sync 4ch if it exists
        print_green "Synching 4ch folder"
        rsync $OPT_DRYRUN -a -r -z -v -u -h --delete --progress --partial --timeout=30 --delete \
            ~/Downloads/mirror/4ch/  \
            $hostname:"$dest_mirror/4ch/"
    else
        print_yellow "Not synching 4ch folder"
    fi

else
    print_yellow "No destination for mirrors"
fi
