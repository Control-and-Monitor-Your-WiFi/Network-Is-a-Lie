#!/bin/bash
sudo simple_switch_grpc -i 0@veth0 -i 1@veth1 /root/bmv2/bin/myprog.json --log-console -- --cpu-port 255 --grpc-server-addr 127.0.0.1:50051