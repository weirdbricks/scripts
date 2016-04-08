#!/bin/bash

OK="[   OK   ] -"
CHANGED="[   CHANGED   ] -"

# check if the directory /etc/hiawatha/conf.d doesn't exist
if [ ! -d "/etc/hiawatha/conf.d" ]; then
        echo "$CHANGED Creating directory /etc/hiawatha/conf.d"
        mkdir /etc/hiawatha/conf.d
else
        echo "$OK directory /etc/hiawatha/conf.d already exists"
fi

# check if /etc/hiawatha/hiawatha.conf has an Include statement
if [ `grep Include /etc/hiawatha/hiawatha.conf -c` -eq 0 ]; then
        echo "$CHANGED Adding Include /etc/hiawatha/conf.d"
        echo "Include /etc/hiawatha/conf.d" >> /etc/hiawatha/hiawatha.conf
else
        echo "$OK /etc/hiawatha/hiawatha.conf already has an Include statement"
fi

# check if the /etc/hiawatha/conf.d/nibbleblog.conf exists
file=/etc/hiawatha/conf.d/nibbleblog.conf
if [ ! -f $file ]; then
   echo "$CHANGED File $file doesn't exist..adding.."
   curl -s https://raw.githubusercontent.com/weirdbricks/scripts/master/nibbleblog.conf -o $file
else
   echo "$OK File $file exists"
fi
