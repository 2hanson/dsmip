ip addr add 159.226.39.212/16 dev eth0
ip route add 192.168.0.0/24 via 10.21.5.144 dev eth0
ip route add 192.168.1.0/24 via 10.21.5.144 dev eth0
ip route add 192.168.95.0/24 via 10.21.5.144 dev eth0
ip -6 route add 2001:cc0:2026:4::/64 via 2001:cc0:2026:e00:4637:e6ff:fe5d:f7de dev eth0
ip -6 route add 2001:cc0:2026:5::/64 via 2001:cc0:2026:e00:4637:e6ff:fe5d:f7de dev eth0
echo "1" > /proc/sys/net/ipv6/conf/all/forwarding
echo "1" > /proc/sys/net/ipv4/ip_forward
ip -6 route add default via fe80::3a22:d6ff:febf:1b00 dev eth0
