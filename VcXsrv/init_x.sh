#!/bin/bash
# cd is needed because cmd.exe cannot handle wsl paths
cd "/mnt/c/Program Files/VcXsrv"
cmd.exe /c "xlaunch.exe -run config.xlaunch"
