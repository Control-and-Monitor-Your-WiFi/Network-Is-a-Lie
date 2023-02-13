#!/bin/bash
sudo iptables -t nat -A POSTROUTING -s 192.168.4.0/24 -o eth0 -j MASQUERADE