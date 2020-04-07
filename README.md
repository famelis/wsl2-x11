# WSL2 - X11
Here are some scripts that make it possible and easy, to make Linux X11 applications in `WSL2` run on an `X11 Server` running natively on `Windows 10`. (Microsoft Windows 10, version 2004 ie 20H1)

## The problem
After the upgrade to the `WSL2`, the Linux X11 applications cannot connect to the X11 Windows Server, using
**DISPLAY=:0.0** or **DISPLAY=localhost:0.0**.

This was caused from the fact that `WSL2` is based on containers, and for that reason each installed distribution is running under **Hyper-V** as a diffenent host, so it is not on **localhost**.

The solutions that were proposed (for example in [WSL/issues/4793](https://github.com/microsoft/WSL/issues/4793#issuecomment-577232999), [WSL/issues/4619](https://github.com/microsoft/WSL/issues/4619) ) had to do with the use of the **dynamic IP** that was assigned to the host, but they didn't work, maybe because it was assumed that the IP was the same as the IP of the nameserver that was stored in /etc/resolv.conf .

After some experimentation, I noticed that a second IP was assined to the host. 
The name server was from a `192.168.*.*` network and this one was from a `172.*.*.*` network.
I thought that they were one for the Host/Windows side and the other for the Container/WSL side, but
after some time, (maybe after changing some Windows programs?) the IPs were from two different `192.168.*.*` networks.
So it was clear that I could not rely on the networks and tried to find the external IP by asking the name server.
The answer was a little bit tricky, because the Container/WSL was refered with the name server's IP and the second one.
So I had do remove from the answer the Ip of the name server.

Also I have to mention that
 - (a) The IP is from the network that the Wifi Dhcp server is giving IPs.
 - (b) The name of the Container/WSL is the same with the name of the Host/Windows, so actually that seems to be the correct question to the name server. 
 - (c) If you happen to have installed a second Linux, (eg a Debian and an Ubuntu), then both of them are given the same name and the same IP. I need to try to find out how will it be possible to have different names and IPs.

## The solution
For the time being, the solution to find the **DISPLAY** is 
```bash
export RX='[1-9][0-9]*\.[1-9][0-9]*\.[1-9][0-9]*\.[1-9][0-9]*'
export RS=$(sed -n -e 's/nameserver \('$RX'\).*/\1/p' /etc/resolv.conf)
export HS=$(cat /etc/hostname)
export DN="0.0"
export DISPLAY=$(dig $HS | sed -e '/^[;]/d' -e '/^$/d' -e '/'$RS'/d' -e 's/.*\t\('$RX'\).*/\1:'$DN'/')
```

## The automation
For the time being the files work with the **[VcXsrv Windows X Server](https://sourceforge.net/projects/vcxsrv/)**
and launch a **[kde desktop](https://kde.org/)**. The installed Distro is a **[Debian/GNU Linux](https://www.debian.org/)**

## How to use
+ Install **WSL2** and the **Debian** distribution. 
+ Update Debian and install kde-desktop, net-tools, dbus, dnsutils etc.
+ If you prefer another desktop environment, you will have to change the **start_desktop.sh** after next step.
+ Install **[VcXsrv Windows X Server](https://sourceforge.net/projects/vcxsrv/)** in the default directory (In windows **"C:\Program Files\VcXsrv"**, in WSL **"/mnt/c/Program Files/VcXsrv"**)
+ Put the, supplied here, **VcXsrv** directory, in your windows HOME directory, (in windows **"C:\Users\\&lt;yourUserName>"**, in WSL **"/mnt/c/Users/&lt;yourUserName>"**)
+ In WSL after **cd "/mnt/c/Users/&lt;yourUserName>/VcXsrv"** run **"bash ./1_wsl_prepare_files.sh"**
+ In Administrator's Powershell after **cd "C:\Users\\&lt;yourUserName>\VcXsrv"** run **".\2_admin_copy_files.bat"**
+ After the above you can run either **"bash init_x.sh"** in WSL or **".\init_x.bat"** in Administrator's Powershell to see the windowed Desktop Environment to appear (fingers crossed...)
+ If you want the windowed Desktop Environment to be started when your login then create a symlink (short-cut) of the **"init_x.bat"**, cut it, go to your Startup directory. (Win-X -> Run -> shell:startup) and paste it there. The same shortcut can be placed in the desktop for easy access.
+ In order to be able to run x11 apps (eg xterm) from the WSL Debian terminal, which is out of the Desktop, place at the begining of your **.bashrc** the following
```bash
export RX='[1-9][0-9]*\.[1-9][0-9]*\.[1-9][0-9]*\.[1-9][0-9]*'
export RS=$(sed -n -e 's/nameserver \('$RX'\).*/\1/p' /etc/resolv.conf)
export HS=$(cat /etc/hostname)
export DN="0.0"
export DISPLAY=$(dig $HS | sed -e '/^[;]/d' -e '/^$/d' -e '/'$RS'/d' -e 's/.*\t\('$RX'\).*/\1:'$DN'/')
```
