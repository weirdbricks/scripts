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
