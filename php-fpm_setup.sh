#!/bin/bash

OK="[   OK   ] -"
CHANGED="[   CHANGED   ] -"

# check if the php-fpm packages are installed
package=php-fpm
if [ `rpm -qa | grep -i $package -c` -eq 0 ]; then
	echo "$CHANGED $package is not installed, installing.."
	yum install -y -q $package
else
	echo "$OK $package is installed"
fi

package=php-gd
if [ `rpm -qa | grep -i $package -c` -eq 0 ]; then
        echo "$CHANGED $package is not installed, installing.."
        yum install -y -q $package
else
        echo "$OK $package is installed"
fi

package=php-xml
if [ `rpm -qa | grep -i $package -c` -eq 0 ]; then
        echo "$CHANGED $package is not installed, installing.."
        yum install -y -q $package
else
        echo "$OK $package is installed"
fi

file=/etc/php-fpm.d/www.conf
url=https://raw.githubusercontent.com/weirdbricks/scripts/master/www.conf
if [ `grep "listen = 127.0.0.1:9000" /etc/php-fpm.d/www.conf -c` -ne 1 ]; then
	echo "$CHANGED $file is not correct, getting a new one.."
	curl -s $url -o $file
else
	echo "$OK $file is correct!"
fi
