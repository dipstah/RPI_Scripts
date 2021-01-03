#!/bin/bash
###################################################################
#Script Name	: watchdogInstall.sh
#Description    :install watchdog package and update config files. 
#                monitor for bcm2835_wdt crash
#https://github.com/dipstah/RetroPie-Toolkit
#
#Author         :Mike White
#Email         	:dipstah@dippydawg.net
###################################################################
#ask for IP address to router
echo please enter the IP address to the router.
read ipaddress

#install packages
sudo apt-get install watchdog chkconfig
sudo update-rc.d watchdog defaults

#update config files
sudo sed -i "s|#watchdog-device|watchdog-device|g" /etc/watchdog.conf
sudo sed -i "s|#max-load-1|max-load-1|g" /etc/watchdog.conf
sudo sed -i "1 i\ping                   = $ipaddress" /etc/watchdog.conf
sudo sed -i '/watchdog-device/a watchdog-timeout = 15' /etc/watchdog.conf

echo bcm2835_wdt | sudo tee -a /etc/modules
echo bcm2835_wdt | sudo tee /etc/modules-load.d/bcm2835_wdt.conf

#start service
chkconfig watchdog on
sudo /etc/init.d/watchdog start
