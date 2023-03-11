#!/bin/bash

set -e
SCNAME=${0##*/}

show_help()
{
	echo "Usage: $SCNAME [nameserver] [address]"
	echo "Example: $SCNAME example.com 127.0.0.1"
}

if [ -z "$1" -o -z "$2" -o $# -lt 2 ]
then
	show_help
	exit 1
fi 1>&2

if [ "${UID:-$(id -u)}" != 0 ]
then
	echo "Err: to do so root access is required"
	exit 1
elif [ -e /etc/bind ]
then
	if [ ! -w /etc/bind ]; then
		echo "Err: this problem is unknown, are you really using root access?"
		exit 1
	fi
else
	echo "Err: can't go on! make sure bind9 is installed!"
	echo "     or reinstall bind9 by deleting it then install."
	exit 1
fi 1>&2

mkdir -p /var/lib/bind

reverse_text()
{
	local result line
	while read -r line
	do
		result="$line${result:+.$result}"
	done < <(tr '.' '\n' <<< "$@")
	echo "$result"
}

cat >> /etc/bind/named.conf.local << EOF
zone "$1" {
	type master;
	file "/var/lib/bind/db.$1";
};

zone "`reverse_text $2`.in-addr.arpa" {
	type master;
	file "/var/lib/bind/db.$2";
};

EOF

# db.local
sed -e "s/localhost/ns1.$1/g" /etc/bind/db.empty \
| sed "s/root.ns1.$1/root.$1/g" > /var/lib/bind/db.$1
echo "ns1	IN	A	$2" >> /var/lib/bind/db.$1
echo "$1.	IN	A	$2" >> /var/lib/bind/db.$1

# db.127
sed -e "s/localhost/ns1.$1/g" /etc/bind/db.0 \
| sed "s/root.ns1.$1/root.$1/g" > /var/lib/bind/db.$2
echo "1	IN	PTR	$1." >> /var/lib/bind/db.$2

systemctl restart bind9
