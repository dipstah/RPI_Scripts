#!/bin/bash
###################################################################
#Script Name    : wan_ip_check.sh
#Description  : send pushove notification when wan ip changes
#
#https://github.com/dipstah/RPI_Scripts
#
#Author         :Mike White
#Email          :dipstah@dippydawg.net
###################################################################

# POST an HTTPS request API https://pushover.net/api
pushover_api="https://api.pushover.net/1/messages.json"

# (required) - your application's API token
pushover_token="a43fznj6izfjiostn1wvjmg73jyze3"

# (required) - the user/group key (not e-mail address) of your user (or you)
pushover_user="u2wAkjLutj1S8qFBif1qZ83ALy7cJk"

#pushover priority https://pushover.net/api#priority
priority="1"

#pushover sound to play https://pushover.net/api#sounds
sound="siren"

ip_file="/home/pi/scripts/wan_ip/wan_ip.txt"

WAN_IP=`curl ifconfig.me/ip`
TITLE="Public IP address has changed"

if [ ! -f "$ip_file" ] ; then
   touch "$ip_file"
   chmod 664 "$ip_file"
   echo $WAN_IP > $ip_file
fi

echo "Public IP address is: $WAN_IP"

while read line
do
   if [ "$line" = "$WAN_IP" ]
   then
      echo "Public IP did not change."
   else
      echo "Public IP has changed. Writing new value..."
      echo "$WAN_IP" > "$ip_file"
      echo "Sending Pushover notification..."
      MESSAGE="Network configuration change warning! The IP address is now $WAN_IP."
   fi

done < "$ip_file"
