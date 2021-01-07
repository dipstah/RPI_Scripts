#!/bin/bash
###################################################################
#Script Name    : send_startup_notify.sh
#Description  : send pushove notification when system boots up. 
# script is meant to be run as a cron job. added sleep so that we have time for netowrk/DNS to become available. 
#
# @reboot /home/pi/scripts/send_startup_notify.sh &
#
#https://github.com/dipstah/RPI_Scripts
#
#Author         :Mike White
#Email          :dipstah@dippydawg.net
###################################################################

# POST an HTTPS request API https://pushover.net/api
pushover_api="https://api.pushover.net/1/messages.json"

# (required) - your application's API token
pushover_token="TOKENHERE"

# (required) - the user/group key (not e-mail address) of your user (or you)
pushover_user="USERTOKENHERE"

#pushover priority https://pushover.net/api#priority
priority="0"

#pushover sound to play https://pushover.net/api#sounds
sound="updown"

DTTM=$(date +"%m-%d-%Y %r")
TITLE="System Bootup"
MESSAGE="`uname -n` boot up at $DTTM"

sleep 10s

send=`curl -s -F "token=$pushover_token" -F "user=$pushover_user" -F "title=$TITLE" -F "message=$MESSAGE" -F "priority=$priority" -F "sound=$sound" -F "html=1" $pushover_api`

