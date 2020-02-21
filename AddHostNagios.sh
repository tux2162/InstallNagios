#!/bin/bash
Host=$(whiptail --title "Host:NAME Nagios" --inputbox "Name du Host à ajouter" 10 60 3>&1 1>&2 2>&3)
IP=$(whiptail --title "Host:IP Nagios" --inputbox "IP a ajouter " 10 60 3>&1 1>&2 2>&3)

echo "define host {
host_name $Host
address $IP
max_check_attempts 3
}" >> /usr/local/nagios/etc/objects/localhost.cfg

echo "----------------------------"

/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
systemctl restart nagios

