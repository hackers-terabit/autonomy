#!/bin/bash
ASN="15169" # GOOGLE
if [ $# -ge 1 ]; then
	if [ "$1" = "-b" ];then
		block="iptables"
	elif [ ${#1} -ge 1 ];then
		ASN="$1"
	fi
	if [ "$2" = "-b" ];then
		block="iptables"
	elif [ ${#2} -ge 1 ];then
		ASN="$2"
	fi
fi

echo "[*] Looking up route-server.ip.att.net for IPV4 subnets belonging to Autonomous system $ASN" 1>&2
whois -h whois.cymru.com "AS$ASN"
echo "[*] No need to attempt to login,this script logins in automatically." 1>&2
sleep 3
sshpass -prviews ssh -o StrictHostkeyChecking=no rviews@route-server.ip.att.net "show route aspath-regex \".*$ASN.*\"  active-path table inet.0" | grep from  | awk '{print $1}' |
while read subnet;
do
	if [ "$block" = "iptables" ];then
		/sbin/iptables -I INPUT 1 -s "$subnet" -j DROP &&
		/sbin/iptables -I OUTPUT 1 -d "$subnet" -j DROP
		echo "[!] Placed an INPUT+OUTPUT block in place for Autonomous System $ASN subnet $subnet" 1>&2
	else
		echo "$subnet"
	fi
done
