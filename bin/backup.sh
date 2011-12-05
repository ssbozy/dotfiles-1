#!/usr/bin/env bash


date=`date`
LOCATION=$1
echo -e "\n\nRunning backup.sh at $date to $LOCATION"

hostname=""
dest_docs=""
dest_projects=""
dest_images=""
dest_camera=""
dest_porn=""
dest_mirror=""

# disabling auto-deletion since I plan on nuking ~/Documents - and running backup before it's restored
# would severely fuck me.
AND_delete="" # change to --delete to delete stuff


if [[ "$LOCATION" == "work" ]]; then
    hostname="moobox.netomat.net"
    dest_docs="/media/MooDrive/pavel/backup/index/"
    dest_projects="/media/MooDrive/pavel/backup/projects/"
    dest_images="/media/MooDrive/pavel/backup/images/"
    dest_pictures="/media/MooDrive/pavel/backup/pictures/"
    dest_camera="/media/MooDrive/pavel/backup/camera/"
    dest_porn=""
    dest_mirror=""

    # Make sure that the truecrypt volume is mounted.
    if ssh moobox.netomat.net "ls /media/MooDrive/pavel/backup/mounted 2>/dev/null"; then 
        echo -e "\n\nTrueCrypt volume mounted, continuing with backup.";
    else
        echo -e "\n\nTrueCrypt volume not mounted; aborting backup script.";
        exit 2;
    fi


elif [[ "$LOCATION" == "home" ]]; then
    hostname="192.168.0.100"
    dest_docs="/media/asimov/index/"
    dest_projects="/media/asimov/projects/"
    dest_images="/media/asimov/images/"
    dest_camera="/media/niven/camera/"
    dest_pictures="/media/niven/pictures/"
    dest_porn="/media/niven/porn/"
    dest_mirror="/media/asimov/Downloads/mirror/"
else
    echo -e "\n\nInvalid location specified.";
    exit 1;
fi


# Backup documents
if [[ "$dest_docs" != "" ]]; then
    echo -e "\n\nBacking up documents."
    rsync -a -r -z -v -u -h $AND_delete --progress \
        ~/Documents/  \
        --exclude=netomat/mobilityserver \
        --exclude=netomat/csmobility \
        --exclude=netomat/nycgo \
        $hostname:$dest_docs
else
    echo -e "\n\nNo destination for documents"
fi

# Backup projects
if [[ "$dest_projects" != "" ]]; then
    echo -e "\n\nBacking up projects."
    rsync -a -r -z -v -u -h $AND_delete --progress \
        --exclude=*.vdi \
        ~/projects/  \
        $hostname:$dest_projects
else
    echo -e "\n\nNo destination for projects"
fi

# Backup images
if [[ "$dest_images" != "" ]]; then
    echo -e "\n\nBacking up images."
    rsync -a -r -z -v -u -h $AND_delete --progress \
        ~/images/  \
        $hostname:$dest_images
else
    echo -e "\n\nNo destination for images"
fi

# Backup pictures
if [[ "$dest_pictures" != "" ]]; then
    echo -e "\n\nBacking up pictures."
    rsync -a -r -z -v -u -h $AND_delete --progress \
        --exclude="iPhoto Library/*" \
        ~/Pictures/  \
        $hostname:$dest_pictures
else
    echo -e "\n\nNo destination for pictures"
fi

# Backup camera
if [[ "$dest_camera" != "" ]]; then
    echo -e "\n\nBacking up camera."
    rsync -a -r -z -v -u -h --progress \
        ~/camera/  \
        $hostname:$dest_camera
else
    echo -e "\n\nNo destination for camera"
fi

# Backup porn
if [[ "$dest_porn" != "" ]]; then
    echo -e "\n\nBacking up porn."
    rsync -a -r -z -v -u -h $AND_delete --progress \
        ~/porn/  \
        $hostname:$dest_porn
else
    echo -e "\n\nNo destination for porn"
fi

# Backup mirrors
if [[ "$dest_mirror" != "" ]]; then
    echo -e "\n\nBacking up mirrors."
    rsync -a -r -z -v -u -h $AND_delete --progress \
        ~/Downloads/mirror/  \
        $hostname:$dest_mirror
else
    echo -e "\n\nNo destination for mirrors"
fi
