#Script qui install nagios pour un DEBIAN en 10.3
#https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-10.3.0-amd64-netinst.iso
/usr/sbin/useradd -m nagios
/usr/sbin/groupadd nagcmd
/usr/sbin/usermod -a -G nagcmd nagios
/usr/sbin/usermod -a -G nagcmd www-data


mkdir /home/nagios/downloads
cd /home/nagios/downloads

wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.2.tar.gz

tar -zxvf nagios-4.4.2.tar.gz

apt-get install -y  apache2 php php-gd php-imap php-curl 
apt-get install -y  libxml-libxml-perl libnet-snmp-perl libperl-dev libnumber-format-perl libconfig-inifiles-perl libdatetime-perl libnet-dns-perl
apt-get install -y libpng-dev libjpeg-dev libgd-dev
apt-get install gcc make autoconf libc6 unzip

cd /home/nagios/downloads/nagios-4.4.2
./configure --with-httpd-conf=/etc/apache2/sites-enabled --with-command-group=nagcmd
make all
make install
ls -lrtha /usr/local/nagios
make install-daemoninit
make install-commandmode
make install-config
make install-webconf
/usr/sbin/a2enmod rewrite
/usr/sbin/a2enmod cgi
htpasswd -cb /usr/local/nagios/etc/htpasswd.users nagiosadmin pass
systemctl restart apache2
systemctl start nagios
ps -edf | grep nagios

clear
echo "installation des plugins"

apt install -y libldap2-dev
apt install -y smbclient
cd /home/nagios/downloads
wget https://nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz
tar -zxvf nagios-plugins-2.2.1.tar.gz
cd /home/nagios/downloads/nagios-plugins-2.2.1/
./configure --with-nagios-user=nagios --with-nagios-group=nagcmd
make
make install
ls -lrtha /usr/local/nagios/libexec
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
systemctl restart  nagios
