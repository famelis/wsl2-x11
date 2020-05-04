#!/bin/bash

export NAME="debian"
export WSL_DISTRIBUTION="Debian"
# Uncomment next if systemd is used via genie
# export GENIE="genie -c"

# X server settings
export DISPLAY_NUMBER="0.0"
export XSRV="C:\\Program Files\\VcXsrv"
WSL_XSRV=$(wslpath "$XSRV")

WHOME=$(wslpath $(cmd.exe /C "echo %USERPROFILE%") | sed 's/\r//')
TMP="$$"
mkdir -p "$TMP" && cd $TMP

# This is the file that starts the X clients
# Modify this to meet your needs
# It is placed in $HOME
cat >start_$NAME.sh <<+EOF
#!/bin/bash
(
	export LIBGL_ALWAYS_INDIRECT=1
	export DISPLAY_NUMBER="$DISPLAY_NUMBER"
	export DISPLAY=\$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}'):\$DISPLAY_NUMBER

	sudo su -c "service dbus start"
	startkde
) >> $HOME/.xsession.errors 2>&1
+EOF

# Start using bat
cat >start_$NAME.bat <<+EOF
@echo off
wsl -d $WSL_DISTRIBUTION $GENIE $HOME/start_$NAME.sh
+EOF

# xlaunch file
cat >$NAME.xlaunch <<+EOF
<?xml version="1.0" encoding="UTF-8"?>
<XLaunch 
	WindowMode="Windowed" 
	Display="-1" 
	Wgl="True" 
	DisableAC="True" 
	Clipboard="True" 
	ClipboardPrimary="True" 
	ClientMode="StartProgram" 
	LocalClient="True" 
	LocalProgram="start_$NAME.bat" 
	RemoteProgram="xterm" RemotePassword="" PrivateKey="" RemoteHost="" RemoteUser="" 
	XDMCPHost="" XDMCPBroadcast="False" XDMCPIndirect="False" XDMCPTerminate="False"
	ExtraParams="" 
/>
+EOF

# xlaunch bat file
cat >launch_$NAME.bat <<+EOF
@ECHO OFF
CD "$XSRV"
.\\xlaunch.exe -run $NAME.xlaunch
+EOF

# xlaunch sh file
cat >launch_$NAME.sh <<+EOF
#!/bin/bash
cd "$WSL_XSRV"
cmd.exe /c "xlaunch.exe -run $NAME.xlaunch"
+EOF

chmod +x *.sh
test -f "$HOME/start_$NAME.sh" && {
	echo "Moving $HOME/start_$NAME.sh to $HOME/start_$NAME.sh.old"
	mv $HOME/start_$NAME.sh $HOME/start_$NAME.sh.old
}
mv start_$NAME.sh launch_$NAME.sh "$HOME"
mv launch_$NAME.bat "$WHOME"
mv start_$NAME.bat $NAME.xlaunch "$WSL_XSRV"
cd ..
rm -rf "$TMP"
