#!/bin/bash

## @file
## @author Jens Tirsvad Nielsen
## @brief Command with ssh
## @details
## **Execute commands over ssh**

## @brief string basepath of this script
declare -g -r TCLI_SSH_SCRIPTDIR="$(dirname "$(realpath "${BASH_SOURCE}")")"

## @brief string IP address to conect server over ssh
declare -g TCLI_SSH_IP

## @brief interger IP port to conect server over ssh
declare -g -i TCLI_SSH_PORT

type -t tcli_logger_init >/dev/null || . ${TCLI_SSH_SCRIPTDIR}/vendor/Linux.Logger/src/Logger/run.sh

## @fn tcli_serversetup_serverrootCmd()
## @brief Connect server and an execute command as root
## @param Shell command
## @return true or false of command success
## @details
tcli_ssh_serverrootCmd_no_warning() {
	TCLI_SERVERSETUP_TERMINAL_OUTPUT=$(ssh -p $TCLI_SSH_PORT root@$TCLI_SSH_IP $@)
	if [ ! $? -eq 0 ]; then
		printf "Command executed but failed: ssh -p $TCLI_SSH_PORT root@$TCLI_SSH_IP %s\n" "$*" >&3
		return 1
	fi
	printf "Command executed: ssh -p $TCLI_SSH_PORT root@$TCLI_SSH_IP %s\n" "$*" >&3
}

## @fn tcli_ssh_serverrootCmd()
## @brief Connect server and an execute command as root
## @param Shell command
## @return true or false of command success
## @details
## 
## It will make a warning if it return false
tcli_ssh_serverrootCmd() {
	tcli_ssh_serverrootCmd_no_warning $@
	if [ ! $? -eq 0 ]; then
		tcli_logger_infoscreenwarn
		return 1
	fi
}