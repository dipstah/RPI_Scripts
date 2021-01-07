# RPI_Scripts

Various scripts for Raspberry Pi. 

Startup = Scripts that run at startup
  send_startup_notify.sh - send pushover notification on bootup. Script is ran as a cron job.

wan_ip
  wan_ip_check.sh - script that sends pushover notification when wan ip chanages. meant to run as a cron job
  
watchdog 
  install_watchdog.sh - script to install watchdog and modify config files to reboot pi
