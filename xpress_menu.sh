#!/bin/bash
# Author: Wayne Cataldo
# URL: http://JenneysGarage.com

# ~~~~~~~~~~  Environment Setup ~~~~~~~~~~ #

# Text color variables

w="\e[1;0m"         # white (normal)
r="\e[1;31m"        # red
g="\e[1;32m"		# green
o="\e[1;33m" 	    # orange
b="\e[1;34m"	    # blue
p="\e[1;35m"	    # purple
c="\e[1;36m"	    # cyan
echo -e "\e[0;40m"  # background black
clear
while :
  do
clear
 # ~~~~~~~~~~ Intro ~~~~~~~~~~ #
echo -e "$c   _  __  ____                         
  | |/ / / __ \ _____ ___   _____ _____
  |   / / /_/ // ___// _ \ / ___// ___/
 /   | / ____// /   /  __/(__  )(__  ) 
/_/|_|/_/    /_/    \___//____//____/  
                                       "
echo -e "$b ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo -e "$g          X P r e s s - M E N U\033[0m"
echo -e "$b ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\033[0m"
wget http://checkip.dyndns.org/ -O - -o /dev/null | cut -d: -f 2 | cut -d\< -f 1 | awk '{ print "Public IP address = \033[33m" $1 "\033[39m"}' 
/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | tail -f | awk '{ print " Local IP address = \033[32m" $1 "\033[39m"}'
echo " 1) Create a new Nginx server block and install WordPress."
echo " 2) Create a new Nginx server block with a simple html page."
echo " 3) Restart Nginx and php5-fpm."
echo " 4) Set file ownership for sftp."
echo " 5) Update XPress server."
echo " 6) Reboot XPress server."
echo " 7) Poweroff XPress server"
echo " 8) Enable phpMyAdmin login"
echo " 9) Disable phpMyAdmin login"
echo " 0) Exit to console."
echo -n "Please enter option:"
  read -n 1 opt
 ############################

 #########################

case $opt in
  
1) /opt/jenneysgarage/bin/create_new_wordpress.sh;;
2) /opt/jenneysgarage/bin/create_site_simple.sh;;
3) sudo service nginx reload
  sleep 3
  sudo service php5-fpm restart
  sleep 1;;
4) sudo chown -R $USER:www-data /var/www/*;;
5) echo -e "$g ********* Updating system *************\033[0m";
     sudo apt-get update && apt-get upgrade;;
6) sudo reboot;;
7) sudo poweroff;;
8) sudo mv /usr/share/phpmyadmin.off/ /usr/share/phpmyadmin/
  echo -e "$g You may now access phpmyadmin\033[0m";
  sleep 2;;
9) sudo mv /usr/share/phpmyadmin/ /usr/share/phpmyadmin.off/
  echo -e "$r phpMyAdmin is disabled\033[0m";
  sleep 2;;
0) echo "Goodbye $USER";
  sleep 1
  clear
  exit 1;;
*) echo -e "$r Invaild option. Please select an option between 1-8 or 0 to exit.\033[0m";
  echo "Press [enter] key to continue. . .";
read enterKey;;
  esac
  done
