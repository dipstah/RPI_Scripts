#!/bin/bash
###################################################################
#Script Name	: setupKiosk.sh
#Description  :Setup Kiosk on raspberry Pi
#                
#https://github.com/dipstah/
#
#Author         :Mike White
#Email         	:dipstah@dippydawg.net
###################################################################


#Install Raspberry Pi OS Lite
#this is a minimal setup for the Kiosk no need for all the other software just x11 and chromium. 


sudo apt-get update -qq

sudo apt-get install --no-install-recommends xserver-xorg-video-all \
  xserver-xorg-input-all xserver-xorg-core xinit x11-xserver-utils \
  chromium-browser unclutter

# Go to: Boot Options > Console Autologin
sudo raspi-config


#edit basg_profile
if [ -z $DISPLAY ] && [ $(tty) = /dev/tty1 ]
then
  startx
fi


#edit .xinitrc
#!/usr/bin/env sh
xset -dpms
xset s off
xset s noblank

unclutter &
chromium-browser https://yourfancywebsite.com \
  --window-size=1920,1080 \
  --window-position=0,0 \
  --start-fullscreen \
  --kiosk \
  --incognito \
  --noerrdialogs \
  --disable-translate \
  --no-first-run \
  --fast \
  --fast-start \
  --disable-infobars \
  --disable-features=TranslateUI \
  --disk-cache-dir=/dev/null \
  --overscroll-history-navigation=0 \
  --disable-pinch
  
