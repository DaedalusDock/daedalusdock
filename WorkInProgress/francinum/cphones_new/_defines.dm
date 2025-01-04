#define NETCLASS_EXCHANGE "PNET_TELEX"
#define NETCLASS_SIPPHONE "PNET_TELSUB"

/// Ping Reply staple for telephone office identification
#define PACKET_FIELD_OFFICE_CODE "office_code"

/// data[command] 2.0
#define PACKET_FIELD_VERB "verb"

/// A high level 'group' of verbs
#define PACKET_FIELD_PROTOCOL "proto"
	#define PACKET_PROTOCOL_SIP "sip"
		#define PACKET_SIP_VERB_REGISTER "register"
		#define PACKET_SIP_VERB_ACKNOWLEDGE "ack"
	#define PACKET_PROTOCOL_RTP "rtp"
