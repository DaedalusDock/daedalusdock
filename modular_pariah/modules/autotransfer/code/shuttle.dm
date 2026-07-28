/datum/controller/subsystem/shuttle
	var/endvote_passed = FALSE

/datum/controller/subsystem/shuttle/proc/autoEnd()
	if(EMERGENCY_IDLE_OR_RECALLED)
		SSshuttle.doRequestEvac(silent = TRUE)
		priority_announce("The shift has come to an end and the shuttle called. [SSsecurity_level.current_level == SEC_LEVEL_RED ? "Red Alert state confirmed: Dispatching priority shuttle. " : "" ]It will arrive in [emergency.timeLeft(600)] minutes.", FLAVOR_CENTCOM_NAME, sound_type = ANNOUNCER_SHUTTLECALLED)
		log_game("Round end vote passed. Shuttle has been auto-called.")
		message_admins("Round end vote passed. Shuttle has been auto-called.")

	emergency_no_recall = TRUE
	endvote_passed = TRUE

	var/datum/signal/packet = new(null, packetv2(payload = list(PKT_ARG_CMD = NET_COMMAND_UPDATE)))
	comms_dish_relay_packet(packet)
