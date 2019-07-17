#!/bin/bash
pkill mysqld
pkill httpd
pkill vsftpd
sleep 7
/usr/sbin/httpd -D BACKGROUND -f /etc/httpd/conf/httpd.conf
/usr/sbin/mysqld --defaults-file=/etc/my.cnf --user=mysql &
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
