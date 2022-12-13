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



// Dataterminal connection/disconnect return values

/// Successfully connected.
#define NETJACK_CONNECT_SUCCESS 0

/// Connection rejected, Already connected to a machine
#define NETJACK_CONNECT_CONFLICT 1

/// Connection rejected, Not sharing a turf (???)
#define NETJACK_CONNECT_NOTSAMETURF 2
