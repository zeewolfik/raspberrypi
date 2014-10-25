# **************************************************************************
# HyperStake installer
# hyperstaked + HyperStake-qt + desktop icon + themes + bootstrap blockchain
# Maintained by : ZeeWolf | github.com/zeewolfik
# **************************************************************************

showtime() {
	h=$(($1 / 360))
	m=$(($1 % 3600 / 60))
	s=$(($1 % 60))
	printf "%02d:%02d:%02d\n" $h $m $s
}

# remember time of script start
start=`date +%s`

# install dependencies
echo "*** Installing dependencies..."
sudo apt-get update && sudo apt-get install -y libboost1.50-dev libboost-filesystem1.50-dev libboost-system1.50-dev libboost-program-options1.50-dev libboost-thread1.50-dev libssl-dev libdb5.1++-dev libminiupnpc-dev

# fetch HyperStake binaries and decompress
echo "*** Installing HyperStake binaries..."
cd ~ && mkdir -p ~/cryptos && cd ~/cryptos && wget https://github.com/presstab/HyperStake/releases/download/v1.0.6/hyperstake-qt-1.0.6-armhf-linux.tar.gz && tar -xvzf hyperstake-qt-1.0.6-armhf-linux.tar.gz

# create config file - randomize password and lower checkblocks to 200 - faster startup
echo "*** Creating configuration file..."
mkdir ~/.HyperStake
echo "rpcuser=hyperstakecrew
rpcpassword=$(cat /dev/urandom | tr -cd '[:alnum:]' | head -c32)
rpcallowip=127.0.0.1
gen=0
server=1
daemon=1
listen=1
# Number of last blocks to check on startup (default:2500), 100 ~= 2.5h backwards
checkblocks=100" >> ~/.HyperStake/HyperStake.conf

# create desktop shortcut for HyperStake-Qt
wget https://raw.githubusercontent.com/presstab/HyperStake/master/src/qt/res/icons/hyperstake-128.png -O ~/.HyperStake/icon.png
echo "[Desktop Entry]
Name=HyperStake
Type=Application
Comment=Faster than light!
Categories=Application
Exec=/home/pi/cryptos/hyperstake-1.0.6-armhf-linux/HyperStake-qt
Icon=/home/pi/.HyperStake/icon.png
Terminal=false
StartupNotify=true" >> ~/Desktop/hyperstake.desktop

#install themes
cd  ~/cryptos/hyperstake-1.0.6-armhf-linux && wget https://github.com/presstab/HyperStake/releases/download/v1.0.6.6/themes.zip -O themes.zip && unzip themes.zip && rm themes.zip

# download blockchain bootstrap
echo "*** Installing blockchain..."
wget https://www.dropbox.com/s/cjdj337wm1hzfv7/bootstrap.zip
# remove old files and logs if any
rm -rf database blk* *.log
# unpack bootstrap
unzip bootstrap.zip -d ~/.HyperStake
# remove zip to save space
rm bootstrap.zip

# time of finish
end=`date +%s`
# calculate difference
runtime=$((end-start))

cd  ~/cryptos/hyperstake-1.0.6-armhf-linux
echo "Done. Installation took $(showtime $runtime)"

BLUE='\e[0;34m'
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[0;33m'
NC='\e[0m'      #No color

echo
echo -e "Run daemon with ${GREEN}./hyperstaked${NC} or clicking on ${GREEN}HyperStake icon on Desktop${NC}"
echo "Bootstrapping will take some time (few hours) - server will not respond to commands while bootstrapping"
echo "You can monitor progress of importing blocks with"
echo
echo -e "${GREEN}watch tail ~/.HyperStake/debug.log${NC}"
echo
echo "Example commands:"
echo
echo -e "${GREEN}./hyperstaked getinfo${NC} - to get information"
echo -e "${GREEN}./hyperstaked getbalance${NC} - to get wallet balance"
echo -e "${GREEN}./hyperstaked listtransactions${NC} - to show last transaction"
echo -e "${GREEN}./hyperstaked stop${NC} - to stop daemon"
echo
echo -e "${YELLOW}Happy staking!${NC}"
echo
