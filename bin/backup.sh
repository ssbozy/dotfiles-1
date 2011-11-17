#!/usr/bin/env bash


date=`date`
LOCATION=$1
echo "Running backup.sh at $1"


if [[ "$LOCATION" == "work" ]]; then
    hostname="moobox.netomat.net"
    dest_docs="/media/MooDrive/pavel/backup/index/"
    dest_projects="/media/MooDrive/pavel/backup/projects/"
    dest_images="/media/MooDrive/pavel/backup/images/"
    dest_camera="/media/MooDrive/pavel/backup/camera/"
    dest_porn=""
    dest_mirrors=""
elif [[ "$LOCATION" == "home" ]]; then
    hostname="192.168.0.100"
    dest_docs="/media/asimov/index/"
    dest_projects="/media/asimov/projects/"
    dest_images="/media/asimov/images/"
    dest_camera="/media/niven/camera/"
    dest_porn="/media/niven/porn/"
    dest_mirrors="/media/asimov/Downloads/mirror/"
else
    echo "Invalid location specified."
fi





# Backup documents
if [[ "$dest_docs" != "" ]]; then
    rsync -a -r -z -v -u -h --delete --progress \
        ~/Documents/  \
        $hostname:$dest_docs
else
    echo "No destination for documents"
fi

# Backup projects
if [[ "$dest_projects" != "" ]]; then
    rsync -a -r -z -v -u -h --delete --progress \
        --exclude=*.vdi \
        ~/projects/  \
        $hostname:$dest_projects
else
    echo "No destination for projects"
fi

# Backup images
if [[ "$dest_images" != "" ]]; then
    rsync -a -r -z -v -u -h --delete --progress \
        ~/images/  \
        $hostname:$dest_images
else
    echo "No destination for images"
fi

# Backup camera
if [[ "$dest_camera" != "" ]]; then
    rsync -a -r -z -v -u -h --progress \
        ~/camera/  \
        $hostname:$dest_camera
else
    echo "No destination for camera"
fi

# Backup porn
if [[ "$dest_porn" != "" ]]; then
    rsync -a -r -z -v -u -h --delete --progress \
        ~/porn/  \
        $hostname:$dest_porn
else
    echo "No destination for porn"
fi

# Backup mirrors
if [[ "$dest_mirrors" != "" ]]; then
    rsync -a -r -z -v -u -h --delete --progress \
        ~/Downloads/mirrors/  \
        $hostname:$dest_mirrors
else
    echo "No destination for mirrors"
fi
