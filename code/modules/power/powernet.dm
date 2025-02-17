////////////////////////////////////////////
// POWERNET DATUM
// each contiguous network of cables & nodes
/////////////////////////////////////
/datum/powernet
	var/number // unique id
	var/list/cables = list() // all cables & junctions
	var/list/nodes = list() // all connected machines
	var/list/data_nodes = list() // all connected network equipment

	///The packet queue.
	var/list/next_packet_queue = list()
	/// Only SSpackets should be touching this.
	var/list/current_packet_queue = list()

	/// The current load on the power net.
	var/load = 0
	/// The current amount of power in the network
	var/avail = 0
	/// The amount of power gathered this tick. Will become avail on reset()
	var/newavail = 0

	/// The amount of power visible to power consoles. This is a smoothed out value, so it is not 100% correct.
	var/viewavail = 0
	/// The amount of load visible to power consoles. This is a smoothed out value, so it is not 100% correct.
	var/viewload = 0

	/// The amount of excess power from the LAST tick, typically avail - load. SMES units will subtract from this as they store the power.
	var/netexcess = 0
	/// Load applied outside of machine processing, "between" ticks of power.
	var/delayedload = 0

/datum/powernet/New()
	SSmachines.powernets += src

/datum/powernet/Destroy()
	//Go away references, you suck!
	for(var/obj/structure/cable/C in cables)
		cables -= C
		C.powernet = null
	for(var/obj/machinery/power/M in nodes)
		nodes -= M
		M.powernet = null

	SSmachines.powernets -= src
	SSpackets.queued_networks -= src
	return ..()

/// Returns TRUE if there are no cables and no nodes belonging to the network.
/datum/powernet/proc/is_empty()
	return !cables.len && !nodes.len

//remove a cable from the current powernet
//if the powernet is then empty, delete it
//Warning : this proc DON'T check if the cable exists
/datum/powernet/proc/remove_cable(obj/structure/cable/C)
	cables -= C
	C.powernet = null
	if(is_empty())//the powernet is now empty...
		qdel(src)///... delete it

//add a cable to the current powernet
//Warning : this proc DON'T check if the cable exists
/datum/powernet/proc/add_cable(obj/structure/cable/C)
	if(C.powernet)// if C already has a powernet...
		if(C.powernet == src)
			return
		else
			C.powernet.remove_cable(C) //..remove it
	C.powernet = src
	cables +=C

//remove a power machine from the current powernet
//if the powernet is then empty, delete it
//Warning : this proc DON'T check if the machine exists
/datum/powernet/proc/remove_machine(obj/machinery/power/M)
	nodes -= M
	data_nodes -= M
	M.powernet = null
	if(is_empty())//the powernet is now empty...
		qdel(src)///... delete it


//add a power machine to the current powernet
//Warning : this proc DON'T check if the machine exists
/datum/powernet/proc/add_machine(obj/machinery/power/M)
	if(M.powernet)// if M already has a powernet...
		if(M.powernet == src)
			return
		else
			M.disconnect_from_network()//..remove it
	M.powernet = src
	if(M.network_flags & NETWORK_FLAG_POWERNET_DATANODE)
		data_nodes[M] = M
	nodes[M] = M

/// Cycles the powernet's status, called by SSmachines, do not manually call.
/datum/powernet/proc/reset()
	//see if there's a surplus of power remaining in the powernet and stores unused power in the SMES
	netexcess = avail - load

	if(netexcess > 100 && length(nodes)) // if there was excess power last cycle
		for(var/obj/machinery/power/smes/S in nodes) // find the SMESes in the network
			S.restore() // and restore some of the power that was used

	// update power consoles
	viewavail = QUESTIONABLE_FLOOR(0.8 * viewavail + 0.2 * avail)
	viewload = QUESTIONABLE_FLOOR(0.8 * viewload + 0.2 * load)

	// reset the powernet
	load = delayedload
	delayedload = 0
	avail = newavail
	newavail = 0

/datum/powernet/proc/get_electrocute_damage()
	if(avail >= 1000)
		return clamp(20 + ROUND(avail/25000, 1), 20, 195) + rand(-5,5)
	else
		return 0

////////////////////////////////////////////////
// Data Passing
///////////////////////////////////////////////
// AKA: Honey, it's time to bloat powernet code again!


/// Pass a signal through a powernet to all connected data equipment.
// SSpackets does this for us!
// We just need to inform them we have something to deal with.
/datum/powernet/proc/queue_signal(datum/signal/signal)
	next_packet_queue += signal
	SSpackets.queued_networks |= src
