#!/bin/bash
#set -x
#If you know what you're doing just add/edit whatever iptables options you want here
IPT="/sbin/iptables"
IPT_IN="-I INPUT 1 -s "
IPT_OUT="-I OUTPUT 1 -d "
IPT_FORWARD="-I FORWARD 1 -d " #For now assuming a gateway forwarder not a  proper router. 
#change DROP to REJECT if you want a RST sent instead of a silent drop
J=" -j DROP"
function yesno() {
if [ $# -le 0 ];then
        echo "Error,yesno called without an argument."
        exit
fi

while true
do
	echo "$@"'? [Y/N]'
	read answer
	if [ "$answer" = "y" ] || [ "$answer" = "Y" ];then
		return 0
	elif [ "$answer" = "n" ] || [ "$answer" = "N" ];then
		return 1
	else
		echo "Please choose Y or N"
	fi
done
}
function block() {
if [ $# -le 0 ];then
	echo "Error,Block called without an argument."
	exit
fi

while read subnet
do
	$IPT $IPT_IN $subnet $J &&
	$IPT $IPT_OUT $subnet $J &&
	$IPT $IPT_FORWARD $subnet $J &&
	echo "[$1] Blocked $subnet."

done < "./subnets_$1_latest.txt"
}

##Main

#For now I'm  taking the simple approach here
backup="backup_`date '+%s'`"
iptables-save > $PWD"/$backup"
echo "Your current iptables rules have been backed up to $PWD/$backup"
orgs=(google facebook twitter linkedin cloudflare) 

for org in ${orgs[*]}
do
	yesno "Do you want to block $org"
	if [ $? = 0 ];then
		block "$org"
	fi
done

echo "All done."
echo "Remember, your old iptables rules have been backed up to $PWD/$backup"
echo "To restore your old rules, run 'iptables-restore < $PWD/$backup' without quotes."
echo "Please refer to the README file for instructions on how to fine tune firefox and chrome to work well with these blocks."
