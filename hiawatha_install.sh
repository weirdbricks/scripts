#!/bin/bash

OK="[   OK   ] -"
CHANGED="[   CHANGED   ] -"

# check if hiawatha is installed
if [ `rpm -qa | grep -i hiawatha -c` -eq 0 ]; then
	echo "$CHANGED Hiawatha is not installed, installing.."
	yum -y -q install http://anku.ecualinux.com/6/x86_64/hiawatha-10.0-ecualinux.2.el6.x86_64.rpm
else
	echo "$OK Hiawatha is installed"
fi

# set hiawatha to start on boot
if [ `chkconfig --list hiawatha | grep on -c` -eq 0 ]; then
	echo "$CHANGED Hiawatha is now set to start on boot"
	chkconfig hiawatha on
else
        echo "$OK Hiawatha is already set to start on boot"
fi

# add a hiwatha user
id hiawatha &>/dev/null
if [ $? -ne 0 ]; then
        echo "$CHANGED Adding the hiwatha user"
	useradd -s /sbin/nologin -M hiawatha &>/dev/null
else
        echo "$OK The hiawatha user is already in place"
fi
