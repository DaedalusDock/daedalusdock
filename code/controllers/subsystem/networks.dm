SUBSYSTEM_DEF(networks)
	name = "Networks"
	wait = 5
	flags = SS_KEEP_TIMING|SS_NO_FIRE
	init_order = INIT_ORDER_NETWORKS

	var/list/relays = list()
	/// Legacy ntnet lookup for software.
	var/datum/ntnet/station_root/station_network

	// Logs moved here
	// Amount of logs the system tries to keep in memory. Keep below 999 to prevent byond from acting weirdly.
	// High values make displaying logs much laggier.
	var/setting_maxlogcount = 100
	var/list/logs = list()

	/// Random name search for
	/// DO NOT REMOVE NAMES HERE UNLESS YOU KNOW WHAT YOUR DOING
	var/list/used_names = list()

/datum/controller/subsystem/networks/PreInit()
	//We retain this structure for ModComp.
	station_network = new

/datum/controller/subsystem/networks/Initialize()
	station_network.build_software_lists()
	return ..()

/datum/controller/subsystem/networks/proc/check_relay_operation(zlevel=0) //can be expanded later but right now it's true/false.
	for(var/i in relays)
		var/obj/machinery/ntnet_relay/n = i
		if(zlevel && n.z != zlevel)
			continue
		if(n.is_operational)
			return TRUE
	return FALSE

/**
 * Records a message into the station logging system for the network
 *
 * This CAN be read in station by personal so do not use it for game debugging
 * during fire.  At this point data.receiver_id has already been converted if it was a broadcast but
 * is undefined in this function.  It is also dumped to normal logs but remember players can read/intercept
 * these messages
 * Arguments:
 * * log_string - message to log
 * * hardware_id = optional, text, Blindly stapled to the end.
 */
/datum/controller/subsystem/networks/proc/add_log(log_string, hardware_id = null)
	set waitfor = FALSE // so process keeps running
	var/list/log_text = list()
	log_text += "\[[stationtime2text()]\]"

	if(hardware_id)
		log_text += "([hardware_id])"
	else
		log_text += "*SYSTEM*"
	log_text += " - "
	log_text += log_string
	log_string = log_text.Join()

	logs.Add(log_string)
	//log_telecomms("NetLog: [log_string]") // causes runtime on startup humm

	// We have too many logs, remove the oldest entries until we get into the limit
	if(logs.len > setting_maxlogcount)
		logs = logs.Copy(logs.len-setting_maxlogcount,0)


/**
 * Removes all station logs for the current game
 */
/datum/controller/subsystem/networks/proc/purge_logs()
	logs = list()
	add_log("-!- LOGS DELETED BY SYSTEM OPERATOR -!-")

/**
 * Updates the maximum amount of logs and purges those that go beyond that number
 *
 * Shouldn't been needed to be run by players but maybe admins need it?
 * Arguments:
 * * lognumber - new setting_maxlogcount count
 */
/datum/controller/subsystem/networks/proc/update_max_log_count(lognumber)
	if(!lognumber)
		return FALSE
	// Trim the value if necessary
	lognumber = max(MIN_NTNET_LOGS, min(lognumber, MAX_NTNET_LOGS))
	setting_maxlogcount = lognumber
	add_log("Configuration Updated. Now keeping [setting_maxlogcount] logs in system memory.")
