#!/bin/bash
# Author: Wayne Cataldo
# URL: http://JenneysGarage.com
# Let's change the user's password
echo -e "\033[1;34;40m 
Thank you for choosing my XPress WordPress/Nginx appliance. 
This first boot script will walk you through...\033[0m"
echo -e "\033[1;32;40m
1) Changing default users password.
2) Regenerating ssh keys.
3) Setting a new MySQL root password.
4) Adding a new user to the server.\033[0m"
echo -e "\033[1;34;40m
Please use strong passwords and write them down
somewhere or email them to yourself.
Be prepared to enter several passwords carefully
until this part is done.\033[0m"
echo -e "\033[1;34;40m 
Start by entering the default users password\033[0m"
echo -e "\033[1;36;40m 
xpress\033[0m"
passwd
   # Regenerate ssh keys
   echo -e "\033[1;34;40m 
Enter the new password a third time to regenerate ssh keys.\033[0m"
	sudo rm /etc/ssh/ssh_host*key*
	sudo dpkg-reconfigure -fnoninteractive -pcritical openssh-server
	sleep 1

# Now change the mysql password
echo -e "\033[1;34;40m 
We now need you to specify a new MySQL root password.
You will need this password to access phpMyAdmin 
and connect WordPress to MySQL. Make this a unique strong
password for security reasons.\033[0m"
let done=0
while [ $done -eq 0 ]; do
  read -e -s -r -p "New mysql root password:" PASS1
  echo ""
  read -e -s -r -p "Retype mysql root password:" PASS2
  if [[ "$PASS1" == "$PASS2" ]]; then
    let done=1
    #perform the actual change assuming that our initial password is default
    mysqladmin -u root --password='root' password $PASS1
  else
    echo "The 2 passwords did not match, please try again."
  fi
done

sudo /opt/jenneysgarage/bin/first_login.sh