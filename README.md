# WSL2 - X11

Here are some scripts to automate the running Linux X11 applications in `WSL2` on the `Windows 10` Host. The applications run on an `X11 Server` running natively on the Windows Host.

## The problem

After the upgrade to the `WSL2`, the Linux X11 applications could not connect to the X11 Windows Server, using **DISPLAY=:0.0** or **DISPLAY=localhost:0.0** due to the fact that `WSL2` is based on containers, and for that reason each installed distribution is running under **Hyper-V** as a diffenent host.

So **localhost** do not refer to the same thing when it is used in the **Container/WSL Host** or the **Windows Host**.

The **Windows Host** has its own IP and the **Container/WSL Host** is assigned a **dynamic IP** by the Windows host in the **'Ethernet adapter vEthernet (WSL)'** network, (see [WSL/issues/4793](https://github.com/microsoft/WSL/issues/4793#issuecomment-577232999), [WSL/issues/4619](https://github.com/microsoft/WSL/issues/4619) ). You can use `ipconfig.exe` to see networks and the IPs.

The **Windows Host** has also at least one IP in the **vEthernet WSL** network. The IP of the `nameserver` that is stored in `/etc/resolv.conf` of the distribution, is one of them. The **Container/WSL Host** can refer to the **Windows Host** with this IP.

If you happen to have installed a second Linux, (eg a Debian and an Ubuntu), then both of them are given the same name and the same IP.

Following is a `bash` fragment to find the **DISPLAY**

```bash
export DISPLAY_NUMBER="0.0"
export DISPLAY=$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}'):$DISPLAY_NUMBER
```

Place the lines at the begining of your **.bashrc**, in order to be able to run x11 apps (eg xterm) from the WSL command line.

## The automation

For the time being the files work with the **[VcXsrv Windows X Server](https://sourceforge.net/projects/vcxsrv/)**
and launch a **[kde desktop](https://kde.org/)**. The installed Distro is a **[Debian/GNU Linux](https://www.debian.org/)**

### Prerequisites

+ Install **WSL2** and the **Debian** distribution.
+ Update Debian and install kde-desktop, net-tools, dbus, dnsutils etc.

+ Install **[VcXsrv Windows X Server](https://sourceforge.net/projects/vcxsrv/)** in the default directory **"C:\Program Files\VcXsrv"**. If you install it in another directory then you have to update the **install_files.sh** below, before the installation.

### Installation

+ Download **[install.bat](https://github.com/famelis/wsl2-x11/raw/master/install.bat)** and **[install_files.sh](https://github.com/famelis/wsl2-x11/raw/master/install_files.sh)**
+ If needed, change **install_files.sh**
  + If **VcXsrv** hasn't been installed in the default directory, then change the **XSRV** variable.
  + If you want to run another desktop environment, change the here document that creates the **start_\<NAME>.sh**, that starts the X clients. After the installation the file is located in WSL home and can be changed later.
  + If you have installed **[arkane-systems/genie](https://github.com/arkane-systems/genie)**, in order to have **systemd** then uncomment the **GENIE** variable
+ Run **install.bat** as Administrator.
+ After the installation there is
  + a file **launch_debian.bat** in your Windows home directory
  + a file **launch_debian.sh"** in your WSL home
  + a file **start_debian.sh"** in your WSL home that starts the X clients.

### How to Auto Start

+ If you want the windowed Desktop Environment to be started when your login then create a symlink (short-cut) of the **"launch_debian.bat"**, cut it, go to your Startup directory. (Win-X -> Run -> shell:startup) and paste it there. The same shortcut can be placed in the desktop for easy access.

Version: 2.0.2
