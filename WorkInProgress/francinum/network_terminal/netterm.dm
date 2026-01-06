//Move to code\__DEFINES\packetnet.dm once ready
#define NETCLASS_DATA_TERMINAL "PNET_DTERM"

///Helper for status line calls
#define STATLINE displaybuffer[25]

/* A basic network terminal, also used to help define the 'standard' exchange format.
 * {"enc":"text","payload":user_payload} - standard text exchange
 *
 */

/obj/machinery/dterm
	name = "DataStation 3000"
	desc = "A cheap clone of the classic ThinkDos 100, by Nanotrasen."

	net_class = NETCLASS_DATE_TERMINAL
	network_flags = NETWORK_FLAGS_STANDARD_CONNECTION

	///Terminal display buffer
	var/list/displaybuffer

/obj/machinery/dterm/Initialize(mapload)
	. = ..()
	//We're going for 80x25 here. Line 25 (counting down) is reserved for local status.
	displaybuffer = list(25)

#undef STATLINE
