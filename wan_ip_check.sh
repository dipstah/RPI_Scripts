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
TITLE="Public IP address has changed"
ip_file="/home/pi/scripts/wan_ip/wan_ip.txt"

WAN_IP=`curl ifconfig.me/ip`

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
     ~/scripts/pushover/pushover.py "$TITLE" "$MESSAGE" "1"
   fi

done < "$ip_file"
