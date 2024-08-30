#!/usr/bin/env bash
set -e

cp /install/dnf/dnf.conf /etc/dnf/
microdnf -y update
microdnf -y install shadow-utils procps tar findutils openssl which
