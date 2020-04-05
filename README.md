# WSL2 - X11
## What
Here are some scripts that make it easy, to make Linux X11 applications in `WSL2`, run on an `X11 Server` running natively on `Windows 10`. (Microsoft Windows 10, version 2004 ie 20H1)

## The problem
After the upgrade to the `WSL2`, the Linux X11 appkications cannot connect to the X11 Windows Server, using
**DISPLAY=:0.0** or **DISPLAY=localhost:0.0**.

This was caused from the fact that `WSL2` is based on containers, and for that reason each installed distribution is running under **Hyper-V** as a diffenent host, so it is not on **localhost**.

The solutions that were proposed had to do with the use of the dynamic **IP** that was assigned to the host, but they didn't work.

## The solution
After some experimenting, it was clear, that the host was given **two IPs**.
One from an **172.*.*.* network** that was from **the Container/WSL side** and
one fron an **192.168.*.* network** that was from **the Host/Windows side**.

In order for the **X server**, that was running on **the Host/Windows side**, to accept the connection,
the **DISPLAY** had to be **an IP** from the **the Host/Windows side**.

Actually the solution is 
```bash
export DISPLAY=$(ipconfig.exe | grep IPv4 | cut -d: -f2 | sed -n -e '/^ 172/d' -e 's/ \([0-9\.]*\).*/\1:0.0/p')
```

## The automation
For the time being the files work with the **[VcXsrv Windows X Server](https://sourceforge.net/projects/vcxsrv/)**
and launch a **[kde desktop](https://kde.org/)**. The installed Distro is a **[Debian/GNU Linux](https://www.debian.org/)**
