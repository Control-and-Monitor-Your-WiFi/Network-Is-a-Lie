#include <core.p4>
#include <v1model.p4>

#define PKT_INSTANCE_TYPE_NORMAL 0
#define PKT_INSTANCE_TYPE_INGRESS_CLONE 1

header ethernet_t {
    bit<48> dstAddr;
    bit<48> srcAddr;
    bit<16> etherType;
}

header ipv4_t {
    bit<4>    version;
    bit<4>    ihl;
    bit<6>    dscp;
    bit<2>    ecn;
    bit<16>   totalLen;
    bit<16>   identification;
    bit<3>    flags;
    bit<13>   fragOffset;
    bit<8>    ttl;
    bit<8>    protocol;
    bit<16>   hdrChecksum;
    bit<32> srcAddr;
    bit<32> dstAddr;
}

struct metadata {
    @field_list(1)
    bit<9> ingress_port;
}

struct headers {
    ethernet_t      ethernet;
    ipv4_t          ipv4;
}

parser ParserImpl(packet_in packet, out headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {

    state start {
        transition parse_ethernet;
    }

    state parse_ethernet {
        packet.extract(hdr.ethernet);
        transition accept;
    }

}

control egress(	inout headers hdr, 
		inout metadata meta, 
		inout standard_metadata_t standard_metadata) {
    apply {
		if(standard_metadata.instance_type == PKT_INSTANCE_TYPE_INGRESS_CLONE)
		{
		}
    }
}

struct mac_learn_digest {
    bit<48> srcAddr;
    bit<9>  ingress_port;
}

control ingress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    action forward(bit<9> port) {
        standard_metadata.egress_spec = port;
    }

    action bcast() {
        standard_metadata.mcast_grp = 1;
        clone_preserving_field_list(CloneType.I2E,100,1);
    }

    action mac_learn() {
        digest<mac_learn_digest>((bit<32>)1024, { hdr.ethernet.srcAddr, standard_metadata.ingress_port });
		// meta.ingress_port = standard_metadata.ingress_port;
		clone_preserving_field_list(CloneType.I2E,100,1);
    }

    action drop() {
        mark_to_drop( standard_metadata );
        exit;
    }

    action newEntry() {
        clone_preserving_field_list(CloneType.I2E,100,1);
    }

    action ChangeAddrOut(bit<32> addr)
    {
        hdr.ipv4.srcAddr = addr;
    }

    action ChangeAddrIn(bit<32> addr)
    {
        hdr.ipv4.dstAddr = addr;
    }

    action _nop() {
    }

    table dmac {
        actions = {
            forward;
            bcast;
            drop;
        }
        key = {
            hdr.ethernet.dstAddr: exact;
        }
        default_action = bcast();
        size = 512;
    }

    table smac {
        actions = {
            mac_learn;
            _nop;
            drop;
        }
        key = {
            hdr.ethernet.srcAddr: exact;
        }
        default_action = mac_learn();
        size = 512;
    }

    //Table gérant le contrôle d'accès
    //Si l'adresse mac source n'est pas dans la table, on drop le paquet
    table acl {
        key = {
            hdr.ethernet.srcAddr: exact;
        }
        actions = {
            drop;
            NoAction;
        }
        size = 1024;
        default_action = drop;
    }

    table natOut {// packet sort du reseau
        key = {
            hdr.ethernet.srcAddr: exact;
        }
        actions = {
            newEntry;
            ChangeAddrOut;
        }
        size = 1024;
        default_action = newEntry;
    }

    table natIn {
        key = {
            hdr.ethernet.dstAddr: exact;
        }
        actions = {
            ChangeAddrIn;
            NoAction;
            drop;
        }
        size = 1024;
        default_action = drop;
    }

    apply {
        if (acl.apply().hit){
            if(! natOut.apply().hit)
            {
                if(natIn.apply().hit)
                {
                    smac.apply();
                    dmac.apply();
                }
            }
        }
    }

}

control DeparserImpl(packet_out packet, in headers hdr) {
    apply {
        packet.emit(hdr.ethernet);
        packet.emit(hdr.ipv4);
    }
}

control verifyChecksum(inout headers hdr, inout metadata meta) {
    apply {
    }
}

control computeChecksum(inout headers hdr, inout metadata meta) {
    apply {
        update_checksum(
	        hdr.ipv4.isValid(),
            { hdr.ipv4.version,
	          hdr.ipv4.ihl,
              hdr.ipv4.dscp,
              hdr.ipv4.ecn,
              hdr.ipv4.totalLen,
              hdr.ipv4.identification,
              hdr.ipv4.flags,
              hdr.ipv4.fragOffset,
              hdr.ipv4.ttl,
              hdr.ipv4.protocol,
              hdr.ipv4.srcAddr,
              hdr.ipv4.dstAddr
            },
            hdr.ipv4.hdrChecksum,
            HashAlgorithm.csum16);
    }
}

V1Switch(ParserImpl(), verifyChecksum(), ingress(), egress(), computeChecksum(), DeparserImpl()) main;
