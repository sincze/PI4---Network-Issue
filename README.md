PI4---Network-Issue
The Raspberry Pi seems to loose it's Network Connectivity for some reason. This script helped me to keep the Pi connected to the network.

BASH Scripting                                                                                         
                                                                                                        
@category Home_Automation                                                                              
@link     https://github.com/raspberrypi/linux/issues/3034                                             
                                                                                                        
@author   ChuckNorrison (https://github.com/ChuckNorrison)                                             
@author   Sándor Incze                                                                                 
@license  GNU GPLv3                                                                                    
@link     https://github.com/sincze/Domoticz                                                           
                                                                                                        
Sometimes the Raspberry Pi 4 with a USB 3.0 SSD connected to it loses it's IP                          
As such it was not reachable anymore. Luckily his scripts helps                                        
Since implementation no issues again                                                                   
                                                                                                        
usage:    Download the script and save it in a directory                                               
           sudo chmod +x check_network.sh                                                               
                                                                                                        
           sudo nano /etc/crontab                                                                       
           * * * * *   root    /usr/bin/nice -n20 /home/pi/scripts/check_network.sh  2>&1 >> /dev/null  

