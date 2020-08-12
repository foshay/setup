#!/bin/bash

while getopts ":u:e:c" opt; do
	case $opt in
		u)
		git config --global user.name $OPTARG
		;;
		e)
		git config --global user.email $OPTARG
		#ssh-keygen -t rsa -b 4096 -C $OPTARG -N ''
		;;
		c)
		cp .tmux.conf ~/
		cp -r .vim ~/
		cp .vimrc ~/
		git config --global core.editor vim
		exit 0
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
    python3-setuptools
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
	openjdk-8-jre
    openjdk-8-jdk
    tmux
    ubuntu-make
	vim
	zlib1g-dev
	yasm
	pkg-config
	libgmp-dev
    libmp3-dev
    libmpc-dev
	libpcap-dev
	libz2-dev
	libnss-dev
	libkrb5-dev
    qtdeclarative5-dev
)
log "Installing new packages via apt"
sudo -E apt-get install -y ${packagelist[@]}

cp .tmux.conf ~/
cp -r .vim ~/
cp .vimrc ~/
git config --global core.editor vim

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
sudo snap install --classic code
cd ~/
mkdir CTF
cd ~/CTF
git clone https://github.com/zardus/ctf-tools.git
git clone https://github.com/Ganapati/RsaCtfTool.git
pip3 install -r "RsaCtfTool/requirements.txt"
mkdir Applications
echo ---
cat ~/.ssh/id_rsa.pub
