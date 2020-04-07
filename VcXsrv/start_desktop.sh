#!/bin/bash
XSESS="/home/$USER/.xsession.errors"
(
	export LIBGL_ALWAYS_INDIRECT=1
	export RX='[1-9][0-9]*\.[1-9][0-9]*\.[1-9][0-9]*\.[1-9][0-9]*'
	export RS=$(sed -n -e 's/nameserver \('$RX'\).*/\1/p' /etc/resolv.conf)
	export HS=$(cat /etc/hostname)
	export DN="0.0"
	export DISPLAY=$(dig $HS | sed -e '/^[;]/d' -e '/^$/d' -e '/'$RS'/d' -e 's/.*\t\('$RX'\).*/\1:'$DN'/')
	echo DISPLAY is $DISPLAY

	sudo su -c "service dbus start"
	startkde 
) >> $XSESS 2>&1
