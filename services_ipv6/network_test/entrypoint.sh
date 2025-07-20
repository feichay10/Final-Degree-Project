#!/bin/bash

# Forzar resolución DNS al arranque
echo "nameserver 2001:db8:1234:0102::132" > /etc/resolv.conf
echo "nameserver 2001:db8:1234:0102::133" >> /etc/resolv.conf

# Quedarse activo
exec bash
