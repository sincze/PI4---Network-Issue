#!/bin/sh

############################################################################################################
##                                                                                                        ##
## BASH Scripting                                                                                         ##
##                                                                                                        ##
## @category Home_Automation                                                                              ##
## @link     https://github.com/raspberrypi/linux/issues/3034                                             ##
##                                                                                                        ##
## @author   ChuckNorrison (https://github.com/ChuckNorrison)                                             ##
## @author   Sándor Incze                                                                                 ##
## @license  GNU GPLv3                                                                                    ##
## @link     https://github.com/sincze/Domoticz                                                           ##
##                                                                                                        ##
## Sometimes the Raspberry Pi 4 with a USB 3.0 SSD connected to it loses it's IP                          ##
## As such it was not reachable anymore. Luckily his scripts helps                                        ##
## Since implementation no issues again                                                                   ##
##                                                                                                        ##
## usage:    Download the script and save it in a directory                                               ##
##           sudo chmod +x check_network.sh                                                               ##
##                                                                                                        ##
##           sudo nano /etc/crontab                                                                       ##
##           * * * * *   root    /usr/bin/nice -n20 /home/pi/scripts/check_network.sh  2>&1 >> /dev/null  ##
############################################################################################################


logPath=/var/log
logFile=check_network.log

ping1_target=8.8.8.8
ping2_target=1.1.1.1

# Function to check 2 different sources if they are available.
pingcheck ()
{
   ping -q -c 4 $ping1_target > /dev/null
   if [ $? -eq 0 ]; then
      echo "Connectivity check successful"
   else
      ping -q -c 4 $ping2_target > /dev/null
      if [ $? -eq 0 ]; then
        echo "Connectivity check successful"
      else
        echo "Connectivity check failed"
        exit
     fi
   fi
}




find "$logPath/" -type f -size +512k -name "$logFile" -exec rm -rf {} \;
if [ ! -f "$logPath/$logFile" ]; then
  echo "`date`: Create new logfile: $logPath/$logFile"
  touch "$logPath/$logFile"
fi

OUTCOME=$(pingcheck)

if [ "$OUTCOME" = "Connectivity check successful" ]; then
  echo "`date`: Connectivity check successful"
  OUTPUT=$(systemctl is-active --quiet dhcpcd.service && echo Service is Running)
#  echo Found $OUTPUT
  if [ "$OUTPUT" = "Service is Running" ];
  then
     echo "`date`: DHCPD Service check successful"
  else
     echo "`date`: DHCPD Service check NOT successful"
     sudo systemctl daemon-reload
     sudo systemctl restart dhcpcd
     exit
  fi
else
   echo "`date`: Both Connectivity checks failed"
    sudo dhclient -r; sudo dhclient > /dev/null
    sleep 15
 #  sudo systemctl restart nginx
    sudo systemctl daemon-reload
    sudo systemctl restart dhcpcd
    sudo systemctl restart sshd
    echo "`date`: Connectivity repaired... hopefully"
    exit
fi
