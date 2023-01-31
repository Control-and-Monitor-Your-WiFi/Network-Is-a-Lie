#!/usr/bin/env python3
import argparse
import os
import sys
from time import sleep

import json
import grpc

from scapy.all import *

# Import P4Runtime lib from parent dir
sys.path.append('..')

import p4runtime_lib.bmv2
import p4runtime_lib.helper
from p4runtime_lib.simple_controller import *
from p4runtime_lib.convert import decodeNum
from p4runtime_lib.error_utils import printGrpcError
from p4runtime_lib.switch import ShutdownAllSwitchConnections

# ------------------------------------ #
# L'objectif est d'afficher l'addr mac #
# a chaque packet eth qui passe        #
# ------------------------------------ #









# ================    
#  Main function 
# ================
def main(runtime_conf_file):
    
    with open(runtime_conf_file, 'r') as sw_conf_file:
        sw_conf = json_load_byteified(sw_conf_file)
    workdir = '.'
    try:
        check_switch_conf(sw_conf=sw_conf, workdir=workdir)
    except ConfException as e:
        error("While parsing input runtime configuration: %s" % str(e))
        return
    
    print('Using P4Info file %s' % sw_conf['p4info'])
    p4info_file_path = os.path.join(workdir, sw_conf['p4info'])
    print('Using BMv2 json file %s' % sw_conf['bmv2_json'])
    bmv2_file_path = os.path.join(workdir, sw_conf['bmv2_json'])
    
    # Instantiate a P4Runtime helper from the p4info file
    p4info_helper = p4runtime_lib.helper.P4InfoHelper(p4info_file_path)

    try:
        # Create a switch connection object for s1;
        # this is backed by a P4Runtime gRPC connection.
        # Also, dump all P4Runtime messages sent to switch to given txt files.
        sw = p4runtime_lib.bmv2.Bmv2SwitchConnection(
            name='s1',
            address='127.0.0.1:50051',
            device_id=0,
            proto_dump_file='logs/s1-p4runtime-requests.txt')

        # Send master arbitration update message to establish this controller as
        # master (required by P4Runtime before performing any other write operation)
        sw.MasterArbitrationUpdate()

        # Install the P4 program (bmv2_json_file_path) on the switch 
        sw.SetForwardingPipelineConfig(p4info=p4info_helper.p4info,
                                       bmv2_json_file_path=bmv2_file_path)
        print("Installed P4 Program using SetForwardingPipelineConfig on s1")

        # To add table, multicast groups and clone session entries,
        # we rely on p4runtime_lib.simple_controller
        
        # Waiting for packetIn packets from the switch
        while True:
            packetin = sw.PacketIn()
            if packetin.WhichOneof('update') == 'packet':
                print("Received Packet-in")
                raw_packet = packetin.packet.payload
                scapy_pkt = Ether(raw_packet)
                ether_type = scapy_pkt.type
                eth_src = scapy_pkt.src
                # if packet is IPv4 or ARP
                print("Packet ether type", hex(ether_type),"by",eth_src)
                
    except KeyboardInterrupt:
        print(" Shutting down.")
    except grpc.RpcError as e:
        printGrpcError(e)

    ShutdownAllSwitchConnections()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='P4Runtime Controller')
    parser.add_argument("-c", '--runtime-conf-file',
                        help="path to input runtime configuration file (JSON)",
                        type=str, action="store", required=True)
    args = parser.parse_args()

    if not os.path.exists(args.runtime_conf_file):
        parser.print_help()
        print("\nRuntime conf file not found: %s\n" % args.runtime_conf_file)
        parser.exit(1)
    
    main(args.runtime_conf_file)
