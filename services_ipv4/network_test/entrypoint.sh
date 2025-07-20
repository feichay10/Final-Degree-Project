#!/bin/bash

# Forzar resolución DNS al arranque
echo "nameserver 192.168.1.133" > /etc/resolv.conf
echo "nameserver 192.168.1.134" >> /etc/resolv.conf

# Quedarse activo
exec bash
