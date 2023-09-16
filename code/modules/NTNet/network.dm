/// A network should NEVER be deleted. Only the station network is still used, and deleting that causes a lot of problems.
/datum/ntnet/Destroy(force=FALSE)
	if(force)
		stack_trace("WHICH ONE OF YOU IDIOTS DELETED A /datum/ntnet, [GLOB.AdminProcCaller ? "THE FUCK ARE YOU DOING [GLOB.AdminProcCaller]?": "BECAUSE I DON'T FUCKING KNOW."]")
		return ..()
	stack_trace("Attempted to delete a /datum/ntnet. This isn't okay.")
	return QDEL_HINT_LETMELIVE

/datum/ntnet/station_root
	var/list/available_station_software = list()
	var/list/available_antag_software = list()
	var/list/chat_channels = list()
	var/list/fileservers = list()

	// These only affect wireless. LAN (consoles) are unaffected since it would be possible to create scenario where someone turns off NTNet, and is unable to turn it back on since it refuses connections
	var/setting_softwaredownload = TRUE
	var/setting_peertopeer = TRUE
	var/setting_communication = TRUE
	var/setting_systemcontrol = TRUE
	var/setting_disabled = FALSE // Setting to 1 will disable all wireless, independently on relays status.

	var/intrusion_detection_enabled = TRUE // Whether the IDS warning system is enabled
	var/intrusion_detection_alarm = FALSE // Set when there is an IDS warning due to malicious (antag) software.

// If new NTNet datum is spawned, it replaces the old one.
/datum/ntnet/station_root/New(root_name)
	. = ..()
	SSnetworks.add_log("NTNet logging system activated for [root_name]")

// Checks whether NTNet operates. If parameter is passed checks whether specific function is enabled.
/datum/ntnet/station_root/proc/check_function(specific_action = 0)
	if(!SSnetworks.relays || !SSnetworks.relays.len) // No relays found. NTNet is down
		return FALSE

	// Check all relays. If we have at least one working relay, network is up.
	if(!SSnetworks.check_relay_operation())
		return FALSE

	if(setting_disabled)
		return FALSE

	switch(specific_action)
		if(NTNET_SOFTWAREDOWNLOAD)
			return setting_softwaredownload
		if(NTNET_PEERTOPEER)
			return setting_peertopeer
		if(NTNET_COMMUNICATION)
			return setting_communication
		if(NTNET_SYSTEMCONTROL)
			return setting_systemcontrol
	return TRUE

// Builds lists that contain downloadable software.
/datum/ntnet/station_root/proc/build_software_lists()
	available_station_software = list()
	available_antag_software = list()
	for(var/F in typesof(/datum/computer_file/program))
		var/datum/computer_file/program/prog = new F
		// Invalid type (shouldn't be possible but just in case), invalid filetype (not executable program) or invalid filename (unset program)
		if(!prog || prog.filename == "UnknownProgram" || prog.filetype != "PRG")
			continue
		// Check whether the program should be available for station/antag download, if yes, add it to lists.
		if(prog.available_on_ntnet)
			available_station_software.Add(prog)
		if(prog.available_on_syndinet)
			available_antag_software.Add(prog)

// Attempts to find a downloadable file according to filename var
/datum/ntnet/station_root/proc/find_ntnet_file_by_name(filename)
	for(var/N in available_station_software)
		var/datum/computer_file/program/P = N
		if(filename == P.filename)
			return P
	for(var/N in available_antag_software)
		var/datum/computer_file/program/P = N
		if(filename == P.filename)
			return P

/datum/ntnet/station_root/proc/get_chat_channel_by_id(id)
	for(var/datum/ntnet_conversation/chan in chat_channels)
		if(chan.id == id)
			return chan

// Resets the IDS alarm
/datum/ntnet/station_root/proc/resetIDS()
	intrusion_detection_alarm = FALSE

/datum/ntnet/station_root/proc/toggleIDS()
	resetIDS()
	intrusion_detection_enabled = !intrusion_detection_enabled


/datum/ntnet/station_root/proc/toggle_function(function)
	if(!function)
		return
	function = text2num(function)
	switch(function)
		if(NTNET_SOFTWAREDOWNLOAD)
			setting_softwaredownload = !setting_softwaredownload
			SSnetworks.add_log("Configuration Updated. Wireless network firewall now [setting_softwaredownload ? "allows" : "disallows"] connection to software repositories.")
		if(NTNET_PEERTOPEER)
			setting_peertopeer = !setting_peertopeer
			SSnetworks.add_log("Configuration Updated. Wireless network firewall now [setting_peertopeer ? "allows" : "disallows"] peer to peer network traffic.")
		if(NTNET_COMMUNICATION)
			setting_communication = !setting_communication
			SSnetworks.add_log("Configuration Updated. Wireless network firewall now [setting_communication ? "allows" : "disallows"] instant messaging and similar communication services.")
		if(NTNET_SYSTEMCONTROL)
			setting_systemcontrol = !setting_systemcontrol
			SSnetworks.add_log("Configuration Updated. Wireless network firewall now [setting_systemcontrol ? "allows" : "disallows"] remote control of station's systems.")
