#!/bin/bash

# exit script if return code != 0
set -e

# install sickbeard converter stuff

# mkdir /home/nobody/.cache/pip
# mkdir /home/nobody/.cache/pip/http
# mkdir /home/nobody/.cache/Python-Eggs
# 
# chown -R root:root /home/nobody/.cache
# chmod -R a+r /home/nobody/.cache/
# chmod -R a+w /home/nobody/.cache/

pacman -S --noconfirm git
pacman -S --noconfirm go
pacman -S --noconfirm openssh
pacman -S --noconfirm python
pacman -S --noconfirm nano
pacman -S --noconfirm ffmpeg
pacman -S --noconfirm base-devel

# mkdir /opt
cd /opt

git clone https://github.com/mdhiggins/sickbeard_mp4_automator.git

cp /home/nobody/sbmp4/autoProcess.ini sickbeard_mp4_automator

chmod a+w sickbeard_mp4_automator

pacman -S --noconfirm python2-setuptools
curl -f -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py

pip install requests
pip install requests[security]
pip install requests-cache
pip install babelfish
pip install "guessit<2"
pip install "subliminal<2"
pip install stevedore==1.19.1
pip install python-dateutil
pip install qtfaststart

chown -R root:root sickbeard_mp4_automator
chmod -R a+w sickbeard_mp4_automator

# cleanup
yes|pacman -Scc
rm -rf /usr/share/locale/*
rm -rf /usr/share/man/*
rm -rf /usr/share/gtk-doc/*
rm -rf /tmp/*
rm -rf /opt/get-pip.py
