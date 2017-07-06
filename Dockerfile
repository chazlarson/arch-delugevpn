FROM binhex/arch-openvpn
MAINTAINER chazlarson

# additional files
##################

# add supervisor conf file for app
ADD build/*.conf /etc/supervisor/conf.d/

# add bash scripts to install app
ADD build/root/*.sh /root/

# add bash script to setup iptables
ADD run/root/*.sh /root/

# add bash script to run deluge
ADD run/nobody/*.sh /home/nobody/

# add python script to configure deluge
ADD run/nobody/*.py /home/nobody/

# add pre-configured config files for deluge
ADD config/nobody/ /home/nobody/

# install app
#############

# make executable and run bash scripts to install app
RUN chmod +x /root/*.sh /home/nobody/*.sh /home/nobody/*.py && \
	/bin/bash /root/install.sh

# echo -------------------------------------------
# echo sickbeard_mp4_automator SETUP BEGINS
# echo -------------------------------------------

# echo -------------------------------------------
# echo CREATING /home/nobody/.cache DIRECTORY
# echo -------------------------------------------

# mkdir /home/nobody/.cache/pip
# mkdir /home/nobody/.cache/pip/http
# mkdir /home/nobody/.cache/Python-Eggs

# echo -------------------------------------------
# echo FIXING PRIVS: /home/nobody/.cache DIRECTORY
# echo -------------------------------------------

# chown -R root:root /home/nobody/.cache
# chmod -R a+r /home/nobody/.cache/
# chmod -R a+w /home/nobody/.cache/

# echo -------------------------------------------
# echo CREATING /opt DIRECTORY
# echo -------------------------------------------
# mkdir /opt
# cd /opt
# echo -------------------------------------------
# echo RUNNING apk update
# echo -------------------------------------------
# apk update
echo -------------------------------------------
echo RUNNING pacman -S --noconfirm git
echo -------------------------------------------
pacman -S --noconfirm git
echo -------------------------------------------
echo RUNNING pacman -S --noconfirm go
echo -------------------------------------------
pacman -S --noconfirm go
echo -------------------------------------------
echo RUNNING pacman -S --noconfirm openssh
echo -------------------------------------------
pacman -S --noconfirm openssh

echo -------------------------------------------
echo git clone sickbeard_mp4_automator
echo -------------------------------------------
git clone https://github.com/mdhiggins/sickbeard_mp4_automator.git

echo -------------------------------------------
echo retrieve preset settings
echo -------------------------------------------
cp /config/autoProcess.ini sickbeard_mp4_automator

echo -------------------------------------------
# echo chmod a+w sickbeard_mp4_automator
# echo -------------------------------------------
# chmod a+w sickbeard_mp4_automator

# echo -------------------------------------------
# echo RUNNING pacman -S --noconfirm python
# echo -------------------------------------------
# pacman -S --noconfirm python

# echo -------------------------------------------
# echo RUNNING pacman -S --noconfirm python2-setuptools
# echo -------------------------------------------
# pacman -S --noconfirm python2-setuptools

# echo -------------------------------------------
# echo RETRIEVING get-pip.py
# echo -------------------------------------------
# curl -f -O https://bootstrap.pypa.io/get-pip.py

# echo -------------------------------------------
# echo RUNNING python get-pip.py
# echo -------------------------------------------
# python get-pip.py

# echo -------------------------------------------
# echo RUNNING apk add nano ffmpeg python-dev
# echo                 musl-dev libffi-dev
# echo                 openssl-dev
# echo -------------------------------------------
# pacman -S --noconfirm nano
# pacman -S --noconfirm ffmpeg
# pacman -S --noconfirm base-devel
# pacman -S --noconfirm python-dev
# pacman -S --noconfirm musl-dev
# pacman -S --noconfirm libffi-dev
# pacman -S --noconfirm openssl-dev

# echo -------------------------------------------
# echo RUNNING pip install requests
# echo -------------------------------------------
# pip install requests

# echo -------------------------------------------
# echo RUNNING pip install requests[security]
# echo -------------------------------------------
# pip install requests[security]

# echo -------------------------------------------
# echo RUNNING pip install requests-cache
# echo -------------------------------------------
# pip install requests-cache

# echo -------------------------------------------
# echo RUNNING pip install babelfish
# echo -------------------------------------------
# pip install babelfish

# echo -------------------------------------------
# echo RUNNING pip install "guessit<2"
# echo -------------------------------------------
# pip install "guessit<2"

# echo -------------------------------------------
# echo RUNNING pip install "subliminal<2"
# echo -------------------------------------------
# pip install "subliminal<2"

# echo -------------------------------------------
# echo RUNNING pip install stevedore==1.19.1
# echo -------------------------------------------
# pip install stevedore==1.19.1

# echo -------------------------------------------
# echo RUNNING pip install python-dateutil
# echo -------------------------------------------
# pip install python-dateutil

# echo -------------------------------------------
# echo RUNNING pip install qtfaststart
# echo -------------------------------------------
# pip install qtfaststart

# chown -R root:root sickbeard_mp4_automator
# chmod -R a+w sickbeard_mp4_automator

# echo -------------------------------------------
# echo sickbeard_mp4_automator SETUP COMPLETE
# echo -------------------------------------------

# docker settings
#################

# map /config to host defined config path (used to store configuration from app)
VOLUME /config

# map /data to host defined data path (used to store data from app)
VOLUME /data

# expose port for deluge webui
EXPOSE 8112

# expose port for privoxy
EXPOSE 8118

# expose port for deluge daemon (used in conjunction with LAN_NETWORK env var)
EXPOSE 58846

# expose port for deluge incoming port (used only if VPN_ENABLED=no)
EXPOSE 58946
EXPOSE 58946/udp

# set permissions
#################

# run script to set uid, gid and permissions
CMD ["/bin/bash", "/root/init.sh"]
