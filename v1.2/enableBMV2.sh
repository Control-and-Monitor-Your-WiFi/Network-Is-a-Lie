#!/bin/bash
systemctl stop t4p4s.service
systemctl disable t4p4s.service
systemctl enable bmv2.service
systemctl stop bmv2.service

echo "BMV2 enable"