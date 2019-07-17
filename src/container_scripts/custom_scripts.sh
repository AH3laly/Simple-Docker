#!/bin/bash

workingDirectory=/simple-docker


### Create Profile Script
echo "echo" > /etc/profile.d/simple-docker.sh
echo "echo" >> /etc/profile.d/simple-docker.sh
echo "echo Welcome to $arg_container_name" >> /etc/profile.d/simple-docker.sh
echo "echo To get login information run cat /simple-docker/login.txt" >> /etc/profile.d/simple-docker.sh
echo "echo" >> /etc/profile.d/simple-docker.sh
echo "echo" >> /etc/profile.d/simple-docker.sh
chown root:root /etc/profile.d/simple-docker.sh
chmod 755 /etc/profile.d/simple-docker.sh


### Create Dev User ###
echo > $workingDirectory/login.txt
mkdir -p /var/www/html
useradd dev -d /var/www
chown dev:dev /var/www/html -R
chmod 755 /var/www/html -R
chmod g+s /var/www/html -R

devPassword=$(openssl rand 14 -base64 | md5sum  | cut -c 1-25)
echo -n $devPassword | passwd dev --stdin

### Configure HTTPD ###
pkill httpd
sleep 3
httpd -D BACKGROUND -f /etc/httpd/conf/httpd.conf
echo "##" HTTP Server "##" >> $workingDirectory/login.txt
echo URL: [Docker Server Hostname or IP Address]/$arg_container_name >> $workingDirectory/login.txt
echo  >> $workingDirectory/login.txt
echo  >> $workingDirectory/login.txt


### Configure Mysql Server ###

pkill mysqld
sleep 3
rm -rf /var/lib/mysql/* /var/lib/mysql/*.* /var/log/mysql*
mysqld --initialize
chown mysql:mysql /var/lib/mysql/ /var/log/mysqld.log -R
/usr/sbin/mysqld --defaults-file=/etc/my.cnf --user=mysql &
sleep 3
echo $(cat /var/log/mysqld.log | grep "temporary password" | awk -F 'root@localhost: ' '{print $2}')  > $workingDirectory/temppassword
mysql -u root -p$(cat $workingDirectory/temppassword) -e "SET password for 'root'@'localhost' = '$devPassword'" --connect-expired-password
#mysql -u root -p$(cat $workingDirectory/temppassword) -e "SET password for 'root'@'localhost' = '$(cat $workingDirectory/newpassword)'" --connect-expired-password
echo "##" Mysql Server "##"  >> $workingDirectory/login.txt
echo Host: localhost >> $workingDirectory/login.txt
echo User: root >> $workingDirectory/login.txt
#echo Pass: $(cat $workingDirectory/newpassword) >> $workingDirectory/login.txt
echo Pass: $devPassword >> $workingDirectory/login.txt
echo >>  $workingDirectory/login.txt
echo >>  $workingDirectory/login.txt
rm -f $workingDirectory/temppassword


### Configure VSFTPD ###
pkill vsftpd
sleep 2
echo pasv_promiscuous=YES >> /etc/vsftpd/vsftpd.conf
echo "##" FTP Server "##"  >> $workingDirectory/login.txt

echo IP: [Docker Server Hostname or IP Address] >> $workingDirectory/login.txt

if [ "$arg_ftp_port" != "" ]
then
    echo Port: $arg_ftp_port  >> $workingDirectory/login.txt
fi

echo User: dev >> $workingDirectory/login.txt
echo Pass: $devPassword >> $workingDirectory/login.txt
echo >>  $workingDirectory/login.txt
echo >>  $workingDirectory/login.txt
/usr/sbin/vsftpd  /etc/vsftpd/vsftpd.conf

