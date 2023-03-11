# dnsadd
A simple script to add a domain name server by configuring a bind9 configuration file
    
### How to use it?
The first step that should be done is probably to clone this repository    
```sh
git clone https://github.com/AF753t/dnsadd.git
```
So what?    

After cloning, what you might have to do next is install it or run it directly
```sh
# Install and run
cd dnsadd
install dnsadd.sh /usr/local/bin
dnsadd example.com 192.168.1.1

# Run directly
./dnsadd.sh example.com 192.168.1.1
```
### Here is the easiest way to install this script in my opinion.
```sh
curl -o /usr/local/bin/dnsadd "https://raw.githubusercontent.com/af753t/dnsadd/main/dnsadd.sh"
chmod 755 /usr/local/bin/dnsadd
```
### Need to know
Please note that this script requires root access
and bind9 has been installed.    
Because the working system is to modify the configuration file in `/etc/bind` and `/var/lib/bind`    
and restart the bind9 service.

