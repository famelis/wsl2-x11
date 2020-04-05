#!/bin/bash
sed -e 's;\$HOME;'$HOME';' start.skel > start.bat
cp start_desktop.sh $HOME
