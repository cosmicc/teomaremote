#!/bin/bash

sudo apt update
sudo apt-get -y dist-upgrade
sudo apt-get -y  install mtr speedtest-cli wavemon traceroute arping netcat nmap tcpdump tshark wireguard snmp snmp-mibs-downloader fish git ntp vim colordiff wakeonlan atop nfs-common samba samba-common-bin
ln -s /usr/bin/speedtest ~/speedtest
ln -s /usr/bin/mtr ~/mtr
ln -s /usr/bin/netcat ~/netcat
ln -s /usr/bin/nmap ~/nmap
ln -s /usr/bin/tcpdump ~/tcpdump
ln -s /usr/bin/tshark ~/tshark
mkdir /home/tsadmin/shared
sudo smbpasswd -a tsadmin
wget -O ~/datto_install.sh https://concord.centrastage.net/csm/profile/downloadLinuxAgent/62781f38-0597-436e-870c-9e31e99a211e
chmod +x ~/datto_install.sh
chsh -s $(which fish)
sudo cp smb.conf /etc/samba/smb.conf
cp connect_wifi.sh ~
cp config.fish ~/.config/fish
chmod +x ~/connect_wifi.sh
cd ~
git clone https://github.com/rfmoz/tuptime.git
cd tuptime
chmod +x tuptime-install.sh
sudo bash tuptime-install.sh
sudo nano /etc/ntp.conf
sudo systemctl enable ntp
sudo systemctl start ntp

sudo raspi-config
sudo systemctl restart smbd
echo "Restart device"
