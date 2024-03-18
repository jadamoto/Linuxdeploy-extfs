#!/bin/sh

NC='\033[0m'
RED='\033[1;31m'
GREEN='\033[1;32m'

exit-status() {
		if [ $1 -eq 0 ]; then
			echo ${2/$TARGET_PATH/..} ... done 
		else
			echo ${2/$TARGET_PATH/..} ... fail
		fi
}

# Command mountpoint in Toybox and Busybox don't work with file...

mounted() {
    if [ -f "$2" ] && [ $(stat -c %i "$1") -eq $(stat -c %i "$2") ] || mountpoint -q "$2"; then echo true; fi
	
}

start() {
    if [ ! $(mounted "$1" "$2") ]; then
		mount $3 "$1" "$2"
		exit-status $? "$2"
	else
		echo ${2/$TARGET_PATH/..} ... skip
	fi
}

status() {
    if [ $(mounted "$1" "$2") ]; then
		echo -e $2 [${GREEN}ok${NC}]
	else
		echo -e $2 [${RED}not mounted${NC}]
	fi
}

stop() {
    if [ $(mounted "$1" "$2") ]; then 
		umount $4 "$2"
		exit-status $? "$2"
	else
		echo ${2/$TARGET_PATH/..} ... skip
	fi
}

# Load enviroment variable USER_NAME and TARGET_PATH from Linuxdeploy config profile

source ${0%/*/*}/cli.conf
source ${0%/*/*}/config/$PROFILE.conf

case $1 in
	start|status)
		if [ $1 = start ]; then echo Mounting external file system:; fi
		cat "$TARGET_PATH/etc/extfstab" | while read -r SOURCE TARGET MOUNT_OPT UMOUNT_OPT; do
			if [ ! -z $SOURCE ] && [ ${SOURCE:0:1} != '#' ]; then
				eval $1 "$SOURCE" "$TARGET" "$MOUNT_OPT" "$UMOUNT_OPT"
			fi
		done
		;;
	umount)
		echo Unmounting external file system:
		tac "$TARGET_PATH/etc/extfstab" | while read -r SOURCE TARGET MOUNT_OPT UMOUNT_OPT; do
			if [ ! -z $SOURCE ] && [ ${SOURCE:0:1} != '#' ]; then
				eval stop "$SOURCE" "$TARGET" "$MOUNT_OPT" "$UMOUNT_OPT"
			fi
		done
		;;
esac
