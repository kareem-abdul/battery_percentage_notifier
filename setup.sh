#!/bin/bash

setup() {
	local path=$(getPath);
	cd $path
	chmod +x ./notifier.sh
	(crontab -u $(whoami) -l 2>/dev/null 2>/dev/null | grep -v "$path"; echo "@reboot ${path}/notifier.sh") | crontab -u $(whoami) -
}

getPath() {
	local relative_path="`dirname \"$0\"`"
	local absolute_path="`(cd \"$relative_path\" && pwd)`"
	if [ -z "$absolute_path" ]; then
		# error; for some reason the path is not accessible
		exit 1
	fi
	echo $absolute_path
}
setup
