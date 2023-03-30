// We'll need to shove shit here eventually.
// ayy we did

// Special network IDs

/// Broadcast Ping
#define NETID_PING "ping"

// -----
// Standard Commands
/// Replying to a ping packet.
#define NETCMD_PINGREPLY "ping_reply"
// "Network Connection" control messages.
#define NETCMD_CONNECT "net_connect"
#define NETCMD_MESSAGE "net_message"
#define NETCMD_DISCONNECT "net_disconnect"
// PDA Text Message
#define NETCMD_PDAMESSAGE "pda_message"

// -----
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

// -----
// Net Classes
/// P2P Phone Station
#define NETCLASS_P2P_PHONE "PNET_VCSTATION"
/// Network-Attached Radio
#define NETCLASS_WIRED_RADIO "PNET_RADIO"


// -----
// Dataterminal connection/disconnect return values

/// Successfully connected.
#define NETJACK_CONNECT_SUCCESS 0

/// Connection rejected, Already connected to a machine
#define NETJACK_CONNECT_CONFLICT 1

/// Connection rejected, Not sharing a turf (???)
#define NETJACK_CONNECT_NOTSAMETURF 2

// -----
// Inviolability flags

/// Packet contains volatile data that prevents it from being safely stored.
#define MAGIC_DATA_MUST_DISCARD (1<<0)

/// Packet contains data that players should never be able to see.
#define MAGIC_DATA_MUST_OBFUSCATE (1<<1)

/// All magic data protection flags at once.
#define MAGIC_DATA_INVIOLABLE (1<<2)-1
