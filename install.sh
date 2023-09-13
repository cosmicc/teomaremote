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
ln -sf /usr/bin/speedtest /home/tsadmin/speedtest
ln -sf /usr/bin/mtr /home/tsadmin/mtr
ln -sf /usr/bin/netcat /home/tsadmin/netcat
ln -sf /usr/bin/nmap /home/tsadmin/nmap
ln -sf /usr/bin/tcpdump /home/tsadmin/tcpdump
ln -sf /usr/bin/tshark /home/tsadmin/tshark
mkdir -p /home/tsadmin/shared
if [ "$update_flag" = false ]; then
  wget -O /home/tsadmin/datto_install.sh https://concord.centrastage.net/csm/profile/downloadLinuxAgent/62781f38-0597-436e-870c-9e31e99a211e
  chmod +x /home/tsadmin/datto_install.sh
fi
chsh -s $(which fish) tsadmin
sudo cp smb.conf /etc/samba/smb.conf
sudo cp motd /etc
cp connect_wifi.sh /home/tsadmin
cp config.fish /home/tsadmin/.config/fish
cp enable_share.sh /home/tsadmin
cp update_tsadmin_smb_pw.sh /home/tsadmin
cp arp_logrotate.conf /home/tsadmin
chmod +x /home/tsadmin/update_tsadmin_smb_pw.sh
chmod +x /home/tsadmin/enable_share.sh
chmod +x /home/tsadmin/connect_wifi.sh
cd /home/tsadmin
if [ "$update_flag" = false ]; then
  sudo -u tsadmin git clone https://github.com/rfmoz/tuptime.git
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
cd /home/tsadmin/tuptime
sudo -u tsadmin git config pull.rebase false
sudo -u tsadmin git pull
sudo systemctl stop nmbd
sudo systemctl stop smbd
sudo systemctl disable nmbd
sudo systemctl disable smbd

# Download the powershell '.tar.gz' archive
sudo -u tsadmin curl -L -o /tmp/powershell.tar.gz https://github.com/PowerShell/PowerShell/releases/download/v7.3.6/powershell-7.3.6-linux-arm64.tar.gz

# Create the target folder where powershell will be placed
sudo mkdir -p /opt/microsoft/powershell/7

# Expand powershell to the target folder
sudo tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7

# Set execute permissions
sudo chmod +x /opt/microsoft/powershell/7/pwsh

# Create the symbolic link that points to pwsh
sudo ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh

sudo ln -s /usr/bin/pwsh /usr/bin/powershell

sudo apt autoremove -y

sudo echo "if \$programname == 'arpwatch' and $msg contains 'sent bad hardware format' then ~" >> /etc/rsyslog.conf
sudo echo "if \$programname == 'arpwatch' and $msg contains 'execl: /usr/lib/sendmail: No such file or directory' then ~" >> /etc/rsyslog.conf
sudo echo "if \$programname == 'arpwatch' and $msg contains 'reaper' then ~" >> /etc/rsyslog.conf
sudo echo "if \$programname == 'arpwatch' then /home/tsadmin/arpwatch.log" >> /etc/rsyslog.conf
sudo echo "if \$programname == 'arpwatch' then ~" >> /etc/rsyslog.conf

touch /home/tsadmin/arpwatch.log
chmod 666 /home/tsadmin/arpwatch.log

ln -s /var/lib/arpwatch /home/tsadmin/arpwatch_macs

sudo systemctl enable arpwatch
sudo systemctl restart arpwatch
sudo systemctl restart rsyslog 
