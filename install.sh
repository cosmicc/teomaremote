#!/bin/bash

update_flag=false

# Loop through the command-line arguments
for arg in "$@"; do
case "$arg" in
-update|--update)
# The '-update' or '--update' switch was provided
update_flag=true
;;
esac
done

if [ "$update_flag" = false ]; then
read -p "Is this the first install and NOT an update? (yes/no): " user_input

# Check the user's input
case "$user_input" in
  [Yy][Ee][Ss]|[Yy])
    # User input is 'yes' or 'YES' or 'y' or 'Y'
    ;;
  [Nn][Oo]|[Nn])
    # User input is 'no' or 'NO' or 'n' or 'N'
    update_flag=true
    ;;
  *)
    echo "Invalid input. Please enter 'yes' or 'no'."
    exit 1
    ;;
esac
fi


sudo apt update
sudo apt-get -y dist-upgrade
sudo apt-get -y  install mtr speedtest-cli wavemon traceroute arping netcat nmap tcpdump tshark wireguard snmp snmp-mibs-downloader fish git ntp vim colordiff wakeonlan atop nfs-common samba samba-common-bin arpwatch
ln -sf /usr/bin/speedtest ~/speedtest
ln -sf /usr/bin/mtr ~/mtr
ln -sf /usr/bin/netcat ~/netcat
ln -sf /usr/bin/nmap ~/nmap
ln -sf /usr/bin/tcpdump ~/tcpdump
ln -sf /usr/bin/tshark ~/tshark
mkdir -p /home/tsadmin/shared
echo -n "tsadmin user "
sudo smbpasswd -a tsadmin
if [ "$update_flag" = false ]; then
  wget -O ~/datto_install.sh https://concord.centrastage.net/csm/profile/downloadLinuxAgent/62781f38-0597-436e-870c-9e31e99a211e
  chmod +x ~/datto_install.sh
fi
chsh -s $(which fish)
sudo cp smb.conf /etc/samba/smb.conf
sudo cp motd /etc
cp connect_wifi.sh ~
cp config.fish ~/.config/fish
cp enable_share.sh ~
chmod +x ~/enable_share.sh
chmod +x ~/connect_wifi.sh
cd ~
if [ "$update_flag" = false ]; then
  git clone https://github.com/rfmoz/tuptime.git
  cd tuptime
  chmod +x tuptime-install.sh
  sudo bash tuptime-install.sh
  sudo nano /etc/ntp.conf
  sudo systemctl enable ntp
  sudo systemctl start ntp
  sudo raspi-config
  git config pull.rebase true
  echo "Restart device"
fi
sudo systemctl stop nmbd
sudo systemctl stop smbd
sudo systemctl disable nmbd
sudo systemctl disable smbd
