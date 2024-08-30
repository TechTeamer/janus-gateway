#!/usr/bin/env bash
set -e

cp install/dnf/dnf.conf /etc/dnf/
cp install/yum/CentOS.repo /etc/yum.repos.d/
cp install/yum/RPM-GPG-KEY-centosofficial /etc/pki/rpm-gpg/

microdnf -y clean all
rpm -e --nodeps openssl-fips-provider

microdnf -y update
microdnf -y install libconfig jansson

if [ "$1" != "" ];then
  rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm || echo "Already installed? Continue..."
  rpm -Uvh https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-9.noarch.rpm || echo "Already installed? Continue..."

  microdnf -y install $@
fi

# USAGE:
# Step 1: Add this to your Dockerfile:
#   RUN --mount=type=bind,target=/install/,source=/install sh -x /install/install-janus-runtime-env.sh
# Step 2: COPY necessary files from janus buildstage...
