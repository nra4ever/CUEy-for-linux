#!/bin/bash
VER=2.0
SUDO=''
if (( $EUID != 0 )); then
    SUDO='sudo'
fi
echo "####################"
echo "## CUEy Installer ##"
echo "####################"
source /etc/os-release
if [ $ID = "ubuntu" ]; then
	echo "Detected Ubuntu ($PRETTY_NAME)."
	PKG="apt-get install -y"
elif [[ $ID_LIKE = "ubuntu" ]]; then
	echo "Detected Ubuntu-like ($PRETTY_NAME)."
	PKG="apt-get install -y"
elif [ $ID = "elementary" ]; then
	echo "Detected elementaryOS ($PRETTY_NAME)."
	PKG="apt-get install -y"
elif [ $ID = "linuxmint" ]; then
	echo "Detected Linux Mint ($PRETTY_NAME)."
	PKG="apt-get install -y"
elif [ $ID = "debian" ]; then
	echo "Detected Debian ($PRETTY_NAME)."
	PKG="apt-get install -y"
elif [[ $ID_LIKE = "debian" ]]; then 
	echo "Detected Debian-like ($PRETTY_NAME)."
	PKG="apt-get install -y"
elif [ $ID = "fedora" ]; then
	echo "Detected Fedora ($PRETTY_NAME)."
	PKG="yum install -y"
elif [ $ID = "centos" ]; then
	echo "Detected CentOS ($PRETTY_NAME)."
	PKG="yum install -y"
elif [ $ID = "antergos" ]; then
	echo "Detected Antergos ($PRETTY_NAME)."
	PKG="pacman -S"
elif [ $ID = "manjaro" ]; then
	echo "Detected Manjaro ($PRETTY_NAME)."
	PKG="pacman -S"
elif [ $ID = "opensuse" ] || [$ID_LIKE = "suse"]; then
	echo "Detected SUSE ($PRETTY_NAME)."
	PKG="zypper install"
else
	echo "Could not determine Linux distribution."
	PKG=5
fi
echo "Installing CUEy in /opt/CUEy."
$SUDO mkdir /opt/CUEy
$SUDO cp -R $PWD/bin/* /opt/CUEy/
$SUDO chmod 755 /opt/CUEy/icon.ico
echo "Creating links in /usr/bin."
$SUDO ln -s /opt/CUEy/Launch-CUEy /usr/bin/CUEy
$SUDO ln -s /opt/CUEy/Launch-CUEy-Batch /usr/bin/CUEyBatch
$SUDO cp $PWD/cuey.png /usr/share/icons/hicolor/256x256/apps/cuey.png
$SUDO chmod 755 /usr/share/icons/hicolor/256x256/apps/cuey.png
echo "Creating entry in application menu."
$SUDO cp $PWD/CUEy.desktop /usr/share/applications/
$SUDO chmod 755 /usr/share/applications/CUEy.desktop
echo "Completed CUEy install, checking for flac."
if ! [ -x "$(command -v flac)" ]; then
	echo 'Flac is not installed!'
	if ! [ $PKG == 5 ]; then
		echo "Attempting to install flac."
		$SUDO $PKG flac
		if ! [ -x "$(command -v flac)" ]; then
			echo "Flac installation was not successful, please attempt manually."
		else
			echo "Flac installation completed successfully."
		fi
	else 
		echo "Automatic installation of flac was not attempted as this script could not identify"
		echo "which Linux distribution you are using. Please install the 'flac' package with your distribution's package manager."
	fi
else
	echo "Flac already installed."
fi
echo "Install complete."

