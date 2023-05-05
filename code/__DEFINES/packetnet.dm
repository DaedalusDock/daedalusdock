// We'll need to shove shit here eventually.
// ayy we did

//network_flags

/// Automatically generate a [/obj/machinery/var/net_id] on initialize.
#define NETWORK_FLAG_GEN_ID (1<<0)

/// Automatically connect to a data terminal at lateinit.
/// Not having this flag and attempting to interact with
/// data_terminals via [/obj/machinery/proc/link_to_jack()] is illegal and will explicitly crash.
#define NETWORK_FLAG_USE_DATATERMINAL (1<<1)

/// Add the machine to [/datum/powernet/var/list/data_nodes]
/// You should have a VERY good reason for this to be set on anything not of type [/obj/machinery/power]
#define NETWORK_FLAG_POWERNET_DATANODE (1<<2)

/// Standard set of network flags, for use by most network-connected equipment.
#define NETWORK_FLAGS_STANDARD_CONNECTION (NETWORK_FLAG_GEN_ID | NETWORK_FLAG_USE_DATATERMINAL)

// Net Classes
#define NETCLASS_P2P_PHONE "PNET_VCSTATION"
#define NETCLASS_APC "PNET_AREAPOWER"

// Packet fields
// not honestly thrilled with having these be defines but kapu wants it that way
// I believe every coder is empowered with a right to footgun by our lord Dennis Ritchie

/// Source (sender) address of a packet
#define PACKET_SOURCE_ADDRESS "s_addr"
/// Destination (receiver) address of a packet
#define PACKET_DESTINATION_ADDRESS "d_addr"
/// Command (type) of a packet
#define PACKET_CMD "command"
/// Network Class of a device, used as part of ping replies.
#define PACKET_NETCLASS "netclass"


// Dataterminal connection/disconnect return values

/// Successfully connected.
#define NETJACK_CONNECT_SUCCESS 0

/// Connection rejected, Already connected to a machine
#define NETJACK_CONNECT_CONFLICT 1

/// Connection rejected, Not sharing a turf (???)
#define NETJACK_CONNECT_NOTSAMETURF 2

// receive_signal return codes

/// Packet fully handled by parent
#define RECEIVE_SIGNAL_FINISHED TRUE
/// Packet needs additional handling
#define RECEIVE_SIGNAL_CONTINUE FALSE

