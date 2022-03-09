#/bin/bash

echo "insert mduranti lxplus password"
ssh -f -N -n -D9999 -o TCPKeepAlive=yes -o ServerAliveInterval=15 mduranti@lxplus.cern.ch
echo "SSH tunnel created"
. tsocks on
echo "socksified everything to the SOCKS proxy."
echo "Remember to use IPs and not domanin names"
