#!/bin/bash

# Próbáljuk meg futtatni a 'janus --version' parancsot
if janus --version >/dev/null 2>&1; then
    echo "Janus is installed and working."
    janus --version  # Opcionális: kiírja a Janus verzióját
    exit 0
else
    echo "Janus is not installed or not in PATH."
    exit 1
fi