#!/bin/bash
pwd=`dirname $0`

read -e -p "Target directory: " -i "/var/www/html" dir
dir=${dir:-"/var/www/html"}

read -e -p "Database Name: " -i "wordpress" db
db=${db:-"wordpress"}
read -e -p "Database Username: " -i "dbuser" user
user=${user:-"dbuser"}
read -e -p "Password User: " -i "Aa1234" pass
pass=${pass:-"Aa1234"}

if [ ! -d "$dir" ]; then
	sudo mkdir -p $dir
fi
Q1="CREATE DATABASE $db;"
Q2="CREATE USER '$user'@'localhost' IDENTIFIED BY '$pass';"
Q3="GRANT ALL ON $db.* TO '$user'@'localhost' IDENTIFIED BY '$pass';"
Q4="FLUSH PRIVILEGES;"
SQL=${Q1}${Q2}${Q3}${Q4}

`mysql -u root -p -e "$SQL"`

cd $dir
sudo wget http://wordpress.org/latest.zip
sudo unzip latest.zip > /dev/null
sudo cp /sync.php sync.php 
sudo rm -rf 

sudo mv wordpress 
sudo cp sync.php /sync.php 
sudo chown -R www-data:www-data $dir
sudo chmod -R 775 $dir

u=$SUDO_USER
if [ -z $u ]; then
	u=$USER
fi

if !(groups $u | grep >/dev/null www-data); then
	sudo adduser $u www-data
fi
clear
echo ""
echo "Database Name: $db"
echo "Database Username: $user"
echo "Database User Password: $pass"
echo "وردپرس با موفقیت نصب شد"
echo ""
