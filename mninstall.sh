#!/bin/bash

PORT=31357
RPCPORT=31358
CONF_DIR=~/.jericoin
COINTAR='https://github.com/JericoinProject/JericoinCore/releases/download/v1.0.4/Jericoin-Linux.tar.gz'

cd ~
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}$0 must be run as root.${NC}"
   exit 1
fi

function configure_systemd {
  cat << EOF > /etc/systemd/system/jericoin.service
[Unit]
Description=Jericoin Service
After=network.target
[Service]
User=root
Group=root
Type=forking
ExecStart=/usr/local/bin/jericoind
ExecStop=-/usr/local/bin/jericoin-cli stop
Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=5
[Install]
WantedBy=multi-user.target
EOF
  systemctl daemon-reload
  sleep 2
  systemctl enable jericoin.service
  systemctl start jericoin.service
}

echo ""
echo ""
DOSETUP="y"

if [ $DOSETUP = "y" ]  
then
  sudo apt-get update
  sudo apt install git zip unzip curl -y
  
  cd /usr/local/bin/
  wget $COINTAR
  tar -xvf *.tar.gz
  chmod +x jericoin*
  rm jericoin-qt jericoin-tx *.tar.gz
  
  mkdir -p $CONF_DIR
  cd $CONF_DIR
  wget https://github.com/JericoinProject/JericoinCore/releases/download/v1.0.4/Jericoin-Snapshot-v1.0.4.zip
  unzip Jericoin-Snapshot-v1.0.4.zip
  rm Jericoin-Snapshot-v1.0.4.zip

fi

 IP=$(curl -s4 api.ipify.org)
 echo ""
 echo "Configure your masternodes now!"
 echo "Detecting IP address:$IP"
 echo ""
 echo "Enter masternode private key"
 read PRIVKEY
 
  echo "rpcuser=user"`shuf -i 100000-10000000 -n 1` >> jericoin.conf_TEMP
  echo "rpcpassword=pass"`shuf -i 100000-10000000 -n 1` >> jericoin.conf_TEMP
  echo "rpcallowip=127.0.0.1" >> jericoin.conf_TEMP
  echo "rpcport=$RPCPORT" >> jericoin.conf_TEMP
  echo "listen=1" >> jericoin.conf_TEMP
  echo "server=1" >> jericoin.conf_TEMP
  echo "daemon=1" >> jericoin.conf_TEMP
  echo "maxconnections=600" >> jericoin.conf_TEMP
  echo "masternode=1" >> jericoin.conf_TEMP
  echo "dbcache=20" >> jericoin.conf_TEMP
  echo "maxorphantx=5" >> jericoin.conf_TEMP
  echo "" >> jericoin.conf_TEMP
  echo "port=$PORT" >> jericoin.conf_TEMP
  echo "externalip=$IP:$PORT" >> jericoin.conf_TEMP
  echo "masternodeaddr=$IP:$PORT" >> jericoin.conf_TEMP
  echo "masternodeprivkey=$PRIVKEY" >> jericoin.conf_TEMP
  mv jericoin.conf_TEMP jericoin.conf
  cd
  echo ""
  echo -e "Your ip is ${GREEN}$IP:$PORT${NC}"

	## Config Systemctl
	configure_systemd
  
echo ""
echo "Commands:"
echo -e "Start Jericoin Service: ${GREEN}systemctl start jericoin${NC}"
echo -e "Check Jericoin Status Service: ${GREEN}systemctl status jericoin${NC}"
echo -e "Stop Jericoin Service: ${GREEN}systemctl stop jericoin${NC}"
echo -e "Check Masternode Status: ${GREEN}jericoin-cli getmasternodestatus${NC}"

echo ""
echo -e "${GREEN}Jericoin Masternode Installation Done!${NC}"
exec bash
exit
