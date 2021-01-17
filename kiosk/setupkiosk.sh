#!/bin/bash
###################################################################
#Script Name    : setupKiosk.sh
#Description  :Setup Kiosk on raspberry Pi
# to run script
#  wget -O - https://raw.githubusercontent.com/dipstah/RPI_Scripts/main/kiosk/setupkiosk.sh | bash
# Requirements
# • Raspberry Pi OS Lite
# • fresh image will work best
# • raspberry Pi 3/4
# • SD card
# • display screen touch capible
# • optional keyboard/mouse
# • network access
#https://github.com/dipstah/
#
#Author         :Mike White
#Email          :dipstah@dippydawg.net
###################################################################

home="/home/pi"

function install() {
   printf  "###########  running apt-get update and upgrade ###########\n"
   sudo apt-get update && sudo apt-get upgrade

   #install required packages
   printf "\n###########   Installing required packages  ###########\n"
   sudo apt-get install --no-install-recommends xserver-xorg-video-all \
   xserver-xorg-input-all xserver-xorg-core xinit x11-xserver-utils \
   chromium-browser unclutter

   #get boot configurtion 
   bootcfg=$(sudo raspi-config nonint get_autologin)
   #sudo raspi-config nonint get_autologin
   ##if boot not set to autologin cli set it. 
   if [[ "$bootcfg" == 1 ]]; then
     printf "\nSetting Autologin to CLI\n"
     raspi-config nonint do_boot_behaviour B2
   fi
   printf "\n\n\n\n"
   read -p "Whats the URL to point Chromium to? : " url
   
   #ask for screen resolution default to 1920,180
   printf "\n\n"
   read -p "Whats resolution is your display? default=1920,1080 : " res
   if [[ $res -eq ""]]
   then
      res="1920,1080"
   else
   fi
   
cat > $home/.bash_profile <<EOL
#Start X11 if console 
if [ -z \$DISPLAY ] && [ \$(tty) = /dev/tty1 ]
then
 startx
fi
EOL

cat > $home/.xinitrc <<EOL
#edit .xinitrc
#!/usr/bin/env sh
xset -dpms
xset s off
xset s noblank

unclutter &
chromium-browser $url \\
--window-size=1020,600 \\
--window-position=0,0 \\
--start-fullscreen \\
--kiosk \\
--incognito \\
--noerrdialogs \\
--disable-translate \\
--no-first-run \\
--fast \\
--fast-start \\
--disable-infobars \\
--disable-features=TranslateUI \\
--disk-cache-dir=/dev/null \\
--overscroll-history-navigation=0 \\
--disable-pinch
EOL

   chown pi:pi $home/.bash_profile
   chown pi:pi $home/.xinitrc
   
   printf "\n\n########### script execution complete ###########\n\n"
   #ask to reboot
   while true; do
    read -p "Would you like to reboot now? y/n:" yn
    case $yn in
      [Yy]* ) reboot; break;;
      [Nn]* ) exit;;
      * ) echo "Please answer yes or no.";;
   esac
done

}

if [ `whoami` != root ]; then
    echo Please run this script as root or using sudo
    exit
fi

#Prompt and confirm its ok to proceed.
while true; do
   read -p "This script will setup the PI in kiosk mode. do you wish to preceed? y/n: " yn
   case $yn in
      [Yy]* ) install; break;;
      [Nn]* ) exit;;
      * ) echo "Please answer yes or no.";;
   esac
done

