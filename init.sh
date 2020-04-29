#!/bin/bash

while getopts ":u:e:" opt; do
	case $opt in
		u)
		git config --global user.name $OPTARG
		;;
		e) 
		git config --global user.email $OPTARG
		ssh-keygen -t rsa -b 4096 -C $OPTARG -N ''

		;;
		*) echo 'error' >&2
			exit 1
	esac
done

# usage: log(msg)
function log() {
	date=$(date +"%F %T")
	echo "[*] ${date} ${1}"
}

export DEBIAN_FRONTEND=noninteractive

log "Enabling 32-bit packages"
sudo dpkg --add-architecture i386

log "Updating system packages"
sudo -E apt update && sudo apt upgrade -y

packagelist=(
	build-essential
	libssl-dev
	python3
	python3-pip
	wireshark
	ruby
	gdb
	curl
	forensics-extra
	net-tools
	libc:i386
	libncurses5:i386
	libstdc++6:i386
	lib32z1
    	tmux
	vim
	zlib1g-dev
	yasm
	pkg-config
	libgmp-dev
	libpcap-dev
	libz2-dev
	libnss-dev
	libkrb5-dev
)
log "Installing new packages via apt"
sudo -E apt-get install -y ${packagelist[@]}

cp .tmux.conf ~/
cp -r .vim ~/
cp .vimrc ~/

log "Upgrading pip"
pip3 install --upgrade pip

#log "Creating virtualenv"
#python3 -m pip install  virtualenv
#python3 -m virtualenv ~/pyenv
#source ~/pyenv/bin/activate

log "Installing pwntools"
# install python3 tools
python3 -m pip install pwntools

log "Installing pip packages"
python3 -m pip install Pillow scapy pycrypto ImageHash

# because python dependences are a pain in the ass
# Also adds to path
#log "Adding venv to .bashrc"
#echo "source ~/pyenv/bin/activate" >> ~/.bashrc
echo "alias gdb=\"gdb -q\"" >> ~/.bashrc

# leave virtualenv so pwndbg doesn't break
#deactivate

log "Installing gem packages"
sudo gem install one_gadget

log "Configuring gdb"
git clone https://github.com/pwndbg/pwndbg ~/.pwndbg
cd ~/.pwndbg
chmod +x setup.sh
./setup.sh
sudo snap install john-the-ripper
sudo snap install --classic code
mkdir CTF
git clone https://github.com/zardus/ctf-tools.git ~/CTF
git config --global core.editor vim
echo ---
cat ~/.ssh/id_rsa.pub
