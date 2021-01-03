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

#install packages
sudo apt-get install watchdog chkconfig

#update config files
sudo sed -i "s|#watchdog-device|watchdog-device|g" /etc/watchdog.conf
sudo sed -i "s|#max-load-1|max-load-1|g" /etc/watchdog.conf

echo bcm2835_wdt | sudo tee -a /etc/modules
echo bcm2835_wdt | sudo tee /etc/modules-load.d/bcm2835_wdt.conf

#start service
chkconfig watchdog on
sudo /etc/init.d/watchdog start
