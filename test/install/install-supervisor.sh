#!/usr/bin/env bash
set -e

DOCKER_USER=$1

microdnf -y install python3-pip
pip3 install --no-cache-dir --upgrade pip
pip3 install --no-cache-dir supervisor==4.2.5
mkdir -p /var/log/supervisor

# fix permissions
chown -R $DOCKER_USER:$DOCKER_USER /var/log/supervisor

cp -r /install/supervisor /etc/supervisor

# Fix default permissions of copied folder (on dev laptops other users do not have any rights by default...)
chmod o+rx /etc/supervisor
chmod o+rx /etc/supervisor/conf.d
chmod o+r /etc/supervisor -R
