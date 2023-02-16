#!/bin/bash
mkdir /root/bmv2/examples/myprog
mkdir /root/bmv2/logs

cp -i myprog.p4  /root/bmv2/examples/myprog/myprog.p4
cp -i controllerTest.py /root/bmv2/
cp -i s1-runtime.json /root/bmv2/

# rm -rRf /root/bmv2/p4runtime_lib
cp -i ../p4runtime_lib /root/

#il faut stop t4p4s et bmv2, mais je ne suis pas sur que enable bmv2 soit requis
systemctl stop t4p4s.service
systemctl disable t4p4s.service
systemctl enable bmv2.service
systemctl stop bmv2.service

echo "\n\ncompilation p4" 
cd /root/bmv2/examples/myprog 
sudo p4c-bm2-ss -I /usr/share/p4c/p4include --std p4-16 --p4runtime-files /root/bmv2/bin/myprog.p4info.txt -o /root/bmv2/bin/myprog.json myprog.p4

echo "\n" 
echo "----exec p4" 
echo "sudo simple_switch_grpc -i 0@veth0 -i 1@veth1 /root/bmv2/bin/myprog.json --log-console -- --grpc-server-addr 127.0.0.1:50051"
echo "----exec controller"
echo "cd /root/bmv2"
echo "python3 controllerTest.py -c s1-runtime.json"
