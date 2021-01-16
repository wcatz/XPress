#!/bin/bash
# Author: Wayne Cataldo
# URL: http://JenneysGarage.com

# ~~~~~~~~~~  Environment Setup ~~~~~~~~~~ #

# Text color variables

txtrst="\e[0m"      # Text reset

def="\e[1;34m"	    # default 		   blue
warn="\e[1;31m"     # warning		   red
info="\e[1;34m" 	# info             blue
q="\e[1;32m"		# questions        green
inp="\e[1;36m"	    # input variables  magenta
echo -e "\e[0;40m"  # background black
  clear

# ~~~~~~~~~~ Intro ~~~~~~~~~~ #
echo -e "$info 
Your virtual appliance setup is nearly finished.
We are now going to add a new administrator to the system.
Please choose a new username and a strong password.
Xpress users administrative privilages will be removed.\033[0m"
if [ $(id -u) -eq 0 ]; then
  read -p "Enter your new username:" username
  echo ""
read -e -s -r -p "Enter new password:" password
  echo ""
read -e -s -r -p "Re-Enter password:" pass2
  if [ $password != $pass2 ] ; then
echo -e "\033[1;31;40m Passwords do not match. Starting over\033[0m"
sleep 1
bash first_login.sh
  else
  egrep "^$username" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
  echo -e "\033[1;31;40m $username already exists! starting over\033[0m"
  sleep 1
bash first_login.sh
  else
pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
  sudo useradd -p $pass $username -m -s /bin/bash 
  sudo usermod -aG sudo $username
		#sudo usermod -aG www-data $username
[ $? -eq 0 ] && echo -e "\033[1;32;40m user $username succesfully created\033[0m" || echo -e "\033[1;31;40m Failed to add new user!\033[0m"
deluser xpress sudo
echo -e "\033[1;32;40m 
  $username you will be logged out momentarily please log 
  back in with your new credentials\033[0m"
  sleep 5
	 
  fi 
  fi
  else
echo -e "\033[1;31;40m Only root may add a user to the system\033[0m"
  fi