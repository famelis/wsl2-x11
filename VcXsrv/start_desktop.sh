#!/bin/bash
XSESS="/home/$USER/.xsession.errors"
(
	export LIBGL_ALWAYS_INDIRECT=1
	export DISPLAY=$(ipconfig.exe | grep IPv4 | cut -d: -f2 | sed -n -e '/^ 172/d' -e 's/ \([0-9\.]*\).*/\1:0.0/p')
	echo DISPLAY is $DISPLAY

	sudo su -c "service dbus start"
	startkde 
) >> $XSESS 2>&1
