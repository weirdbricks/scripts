#!/bin/bash

OK="[   OK   ] -"
CHANGED="[   CHANGED   ] -"

# check if the php-fpm packages are installed
package=unzip
if [ `rpm -qa | grep -i $package -c` -eq 0 ]; then
	echo "$CHANGED $package is not installed, installing.."
	yum install -y -q $package
else
	echo "$OK $package is installed"
fi

# check if the directory /var/www/domain1 doesn't exist
directory=/var/www/domain1
if [ ! -d $directory ]; then
        echo "$CHANGED Creating directory $directory"
        mkdir $directory
else
        echo "$OK directory $directory already exists"
fi

# check who the owner is for a directory
directory=/var/lib/php/
expected_owner=hiawatha
expected_group=hiawatha
current_ownership=`stat -c%U_%G $directory`
if [ ! "$current_ownership" == $expected_owner\_$expected_group ]; then
	echo "$CHANGED ownership for directory: $directory to user:$expected_owner,group:$expected_group"
	chown -R $expected_owner:$expected_group $directory
else
	echo "$OK ownership for directory: $directory is already set to user:$expected_owner,group:$expected_group"
fi

# download nibbleblog from my mirror so you don't have to deal with sourceforge.net shenanigans
url=http://lampros.chaidas.com/projectfiles/nibbleblog-v4.0.2-markdown.zip
file=/tmp/nibbleblog-v4.0.2-markdown.zip
if [ ! -f $file ]; then
   echo "$CHANGED File $file doesn't exist..adding.."
   curl -s $url -o $file
else
   echo "$OK File $file exists"
fi

directory=/var/www/domain1
if [ `ls -A $directory | wc -l` -eq 0 ]; then
	echo "$CHANGED echo $directory is empty"
	unzip -q $file -d $directory/ 
	mv /var/www/domain1/nibbleblog-markdown/* $directory/
	rm -r -f $directory/nibbleblog-markdown/
else
	echo "$OK $directory is not empty"
fi

# check who the owner is for a directory
directory=/var/www/domain1
expected_owner=hiawatha
expected_group=hiawatha
current_ownership=`stat -c%U_%G $directory`
if [ ! "$current_ownership" == $expected_owner\_$expected_group ]; then
        echo "$CHANGED ownership for directory: $directory to user:$expected_owner,group:$expected_group"
        chown -R $expected_owner:$expected_group $directory
else
        echo "$OK ownership for directory: $directory is already set to user:$expected_owner,group:$expected_group"
fi
