/proc/set_security_level(level, crew_set = TRUE)
	// switch(level)
	// 	if("green")
	// 		level = SEC_LEVEL_GREEN
	// 	if("blue")
	// 		level = SEC_LEVEL_BLUE
	// 	if("red")
	// 		level = SEC_LEVEL_RED
	// 	if("delta")
	// 		level = SEC_LEVEL_DELTA

	// //Will not be announced if you try to set to the same level as it already is
	// if(level >= SEC_LEVEL_GREEN && level <= SEC_LEVEL_DELTA && level != SSsecurity_level.current_level)
	// 	switch(level)
	// 		if(SEC_LEVEL_GREEN)
	// 			minor_announce(CONFIG_GET(string/alert_green), "Attention! Security level lowered to green:")
	// 			if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
	// 				if(SSsecurity_level.current_level >= SEC_LEVEL_RED)
	// 					SSshuttle.emergency.modTimer(4)
	// 				else
	// 					SSshuttle.emergency.modTimer(2)
	// 		if(SEC_LEVEL_BLUE)
	// 			if(SSsecurity_level.current_level < SEC_LEVEL_BLUE)
	// 				minor_announce(CONFIG_GET(string/alert_blue_upto), "Attention! Security level elevated to blue:",1)
	// 				if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
	// 					SSshuttle.emergency.modTimer(0.5)
	// 			else
	// 				minor_announce(CONFIG_GET(string/alert_blue_downto), "Attention! Security level lowered to blue:")
	// 				if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
	// 					SSshuttle.emergency.modTimer(2)
	// 		if(SEC_LEVEL_RED)
	// 			if(SSsecurity_level.current_level < SEC_LEVEL_RED)
	// 				minor_announce(CONFIG_GET(string/alert_red_upto), "Attention! Code red!",1)
	// 				if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
	// 					if(SSsecurity_level.current_level == SEC_LEVEL_GREEN)
	// 						SSshuttle.emergency.modTimer(0.25)
	// 					else
	// 						SSshuttle.emergency.modTimer(0.5)
	// 			else
	// 				minor_announce(CONFIG_GET(string/alert_red_downto), "Attention! Code red!")
	// 		if(SEC_LEVEL_DELTA)
	// 			minor_announce(CONFIG_GET(string/alert_delta), "Attention! Delta security level reached!",1)
	// 			if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
	// 				if(SSsecurity_level.current_level == SEC_LEVEL_GREEN)
	// 					SSshuttle.emergency.modTimer(0.25)
	// 				else if(SSsecurity_level.current_level == SEC_LEVEL_BLUE)
	// 					SSshuttle.emergency.modTimer(0.5)
	if(istext(level))
		var/nltext = level
		level = SSsecurity_level.possible_levels[level] //Pull the datum by ID
		if(isnull(level))
			CRASH("Attempted to set invalid security level [nltext].")
	SSsecurity_level.set_level(level, crew_set)

/proc/get_security_level()
	. = SSsecurity_level?.current_level
	if(!.) //Checked too early, Throw.
		CRASH("Attempted to retrieve a null security level")
