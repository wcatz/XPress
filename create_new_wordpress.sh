#!/bin/bash
# Author: Wayne Cataldo
# Credit to Seb Dangerfield
# URL: http://sebdangerfield.me.uk
# Modified: http://jenneysgarage.com, http://maximize-seo.com

SED=`which sed`
NGINX_SITES_ENABLED='/etc/nginx/sites-enabled'
NGINX_CONFIG='/etc/nginx/sites-available'
CURRENT_DIR=`dirname $0`
WEB_DIR='/var/www'

let done=0
while [ $done -eq 0 ]; do
  read -e -r -p "New domain name:" DOMAIN
  echo ""
  read -e -r -p "Retype new domain name:" DOMAIN2
  if [[ "$DOMAIN" == "$DOMAIN2" ]]; then
  let done=1
  ###################################
  # check the domain is roughly valid!
PATTERN="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,6}$"
if [[ "$DOMAIN" =~ $PATTERN ]]; then
	DOMAIN=`echo $DOMAIN | tr '[A-Z]' '[a-z]'`
	echo "Creating hosting for:" $DOMAIN
else
	echo "invalid domain name"
	
	/opt/jenneysgarage/bin/xpress_menu.sh
	exit 1
	
fi
  
SITE_DIR=`echo $DOMAIN`

	echo -e "\033[1;32;40m Creating new server block and installing WordPress for: $DOMAIN\033[0m"
	sleep 1

# copy the virtual host template
CONFIG=$NGINX_CONFIG/$DOMAIN.conf
sudo cp $CURRENT_DIR/wordpress_vhost.template $CONFIG
sudo $SED -i "s/DOMAIN/$DOMAIN/g" $CONFIG
sudo $SED -i "s!ROOT!$WEB_DIR/$SITE_DIR!g" $CONFIG

# create symlink to sites enabled
sudo ln -s $CONFIG $NGINX_SITES_ENABLED/$DOMAIN.conf

# reload Nginx
sudo /etc/init.d/nginx reload

# create web root folders and symlink logs
sudo mkdir -p $WEB_DIR/$SITE_DIR $WEB_DIR/$SITE_DIR/logs/
sudo mkdir -p $WEB_DIR/$SITE_DIR $WEB_DIR/$SITE_DIR/htdocs/
sudo ln -s /var/log/nginx/$DOMAIN.access.log $WEB_DIR/$SITE_DIR/logs/access.log
sudo ln -s /var/log/nginx/$DOMAIN.error.log $WEB_DIR/$SITE_DIR/logs/error.log

# download latest version of WordPress and extract it
sudo wget http://wordpress.org/latest.tar.gz
sudo tar -xvf latest.tar.gz
sudo chown -R $USER:www-data /home/$USER/wordpress/

# adds nginx-helper, sftp update support and APC object cache backend to WordPress
sudo cp -R /opt/jenneysgarage/bin/nginx-helper /home/$USER/wordpress/wp-content/plugins
sudo cp -R /opt/jenneysgarage/bin/ssh-sftp-updater-support /home/$USER/wordpress/wp-content/plugins
sudo cp /opt/jenneysgarage/bin/object-cache.php /home/$USER/wordpress/wp-content/

# copy it all to web root and reset permisions
sudo cp -R /home/$USER/wordpress/* $WEB_DIR/$SITE_DIR/htdocs/
# sudo chown -R root:root /etc/nginx/

# symlink to phpmyadmin
sudo ln -sf /usr/share/phpmyadmin $WEB_DIR/$SITE_DIR/htdocs

# copy apc.php to htdocs
sudo cp /usr/share/doc/php-apc/apc.php $WEB_DIR/$SITE_DIR/htdocs

# remove leftovers
sudo rm -rf wordpress
sudo rm -rf latest.tar.gz

# set permissions to allow wp-config creation and create uploads folder and make it writable
sudo find $WEB_DIR/$SITE_DIR/htdocs  \( -type d -exec chmod -v 755 '{}' \; \) \
                                  -o \( -type f -exec chmod -v 644 '{}' \; \)
sudo chmod 755 $WEB_DIR/$SITE_DIR/
sudo mkdir -p $WEB_DIR/$SITE_DIR $WEB_DIR/$SITE_DIR/htdocs/wp-content/uploads/
sudo chmod 775 $WEB_DIR/$SITE_DIR/htdocs/wp-content/uploads
sudo chown -R $USER:www-data $WEB_DIR/$SITE_DIR/
sudo chmod 775 $WEB_DIR/$SITE_DIR/htdocs/
sudo chmod 775 $WEB_DIR/$SITE_DIR/htdocs/wp-content/
	else
	echo -e "\033[1;31;40m Domains do not match, please try again.\033[0m"
  fi
  clear
  echo -e "\033[1;32;40m Please open your browser and go to www.$DOMAIN/phpmyadmin
  to create a MySQL database for $DOMAIN\033[0m"
  sleep 10
done
	else

	echo -e "\033[1;31;40m invalid domain name\033[0m"
fi