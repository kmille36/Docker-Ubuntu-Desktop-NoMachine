#!/usr/bin/bash
# initilize users, accounts,...
groupadd -r $USER -g $GID \
&& useradd -u $UID -r -g $USER -d /home/$USER -s /bin/bash -c "$USER" $USER \
&& adduser $USER sudo \
&& mkdir -p /home/$USER \
&& chown -R $USER:$USER /home/$USER \
&& echo $USER':'$PASSWORD | chpasswd

# Add my own public key to NX
if [ -z "$NX_PUBLICKEY" ]
then
	# skip
	true
else
	HOME="/home/$USER"
	sudo -u $USER mkdir -p $HOME/.nx/config/ \
	&& sudo -u $USER touch $HOME/.nx/config/authorized.crt \
	&& sudo -u $USER chmod 0600 $HOME/.nx/config/authorized.crt \
	&& sudo -u $USER echo "$NX_PUBLICKEY" | tr -d '"' >> $HOME/.nx/config/authorized.crt
fi

# run crontab
/usr/sbin/cron &

# starting nxserver
/etc/NX/nxserver --startup
tail -f /usr/NX/var/log/nxserver.log

