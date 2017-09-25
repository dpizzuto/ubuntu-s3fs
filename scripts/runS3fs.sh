#!/bin/bash

MOUNTDIR="/home/shared/s3"

echo $AWSACCESSKEYID:$AWSSECRETACCESSKEY > /etc/passwd-s3fs
chmod 600 /etc/passwd-s3fs

mkdir -p $MOUNTDIR
mkdir -p /tmp

s3fs acnmlaas $MOUNTDIR -o use_cache=/tmp -o passwd_file=/etc/passwd-s3fs -o allow_other -o umask=0002
