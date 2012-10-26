rmmod ip6_tunnel
rmmod ipip
rmmod sit
modprobe tunnel4
modprobe tunnel6
insmod ./ip6_tunnel.ko
insmod ./sit.ko
insmod ./ipip.ko
rmmod udpencap
insmod ./udpencap.ko
ifconfig tunl0 up
ifconfig sit0 up
ifconfig ip6tnl0 up