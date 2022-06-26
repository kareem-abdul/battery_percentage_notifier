#!/bin/bash

getPath() {
	local relative_path="`dirname \"$0\"`"
	local absolute_path="`(cd \"$relative_path\" && pwd)`"
	if [ -z "$absolute_path" ]; then
		# error; for some reason the path is not accessible
		exit 1
	fi
	echo $absolute_path
}


# check if cron is running
sudo systemctl status cron &> /dev/null || { echo "cron process not running" 1>&2; exit 1; } 

setUp() {
	local path=$(getPath);
	local user=$(whoami);
	local expression="XDG_RUNTIME_DIR=/run/user/$(id -u) ${path}/notifier.sh";
	
	chmod +x $path/notifier.sh;
	# remove existing cronjob
	crontab -l -u $user 2>/dev/null | grep -v "$expression" | crontab -u $user -;
	# add new cronjob
	(crontab -l -u $user 2>/dev/null; echo "* * * * * $expression") | crontab -u $user -;
}


cleanUp() {
	local path=$(getPath);
	crontab -l 2>/dev/null | grep -v "${path}/notifier.sh" | crontab -;
}


if [ "$1" = "-d" -o "$1" = "--delete" ]; then
	cleanUp
else
	setUp
fi


