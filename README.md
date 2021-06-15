**NTP Server aims to be a stratum 1 level**, with:
* RaspberyPi 2
* GPS module with PPS output
* Kernel PPS module usage into NTP server
* based on Debian 8 (creation of projet on June 26, 2016 : ok, it's a long time ago... but still working :-) )

** Image & Video in docs directory **

So, GPS module is connected like:
* TX pin on the RX serial console of the rpi
* PPS pin plug on the GPIO 18

LED display parts are connected like:
* RED led on the GPIO 5
* YELLOW led on the GPIO 13
* GREEN led on the GPIO 26
* =>GPIO are configured as pull-down mode for those pins.

To install, you have to:
* Create a basic debian image on a SDCard
* insert into and start your Rpi
* configure your network, I suggest you to set it in static
* update and install git
* clone the repo
* add pps-rules
* add specific conf from cmdline
* add specific conf from config.txt
* add module
* link rc.local
* apply iptables rules v4 and v6 (for now, I blocked all ipv6, but I know I'll have to change that)
* add symlink
* remove ntpd
* download ntp sources, then compile/install with configure-ntpd.sh => this is to add PPS kernel support
* install ntp.conf
* reboot and check : when you're GPS is synchronised (cat /dev/gps0 and check RMC/GGA frame), you should have a cross in front of 127.127.20.0 and a 'o' in front of 127.127.22.0

** LICENCE **
You can use, and/or modify freely, BUT, you have to share here any changes (through an issue and/or a push request). You're not allowed to use for commercial purposes in any way.

Keywords:
ntp gps pps server stratum 0 1 raspberry pi gpio ntpd linux
