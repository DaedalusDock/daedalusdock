#define AUTOEVAC_MESSAGE "Automatically dispatching emergency shuttle due to crew death."

/datum/evacuation_controller/shuttle
	var/emergency_no_recall = FALSE
	var/emergency_call_time

/datum/evacuation_controller/shuttle/evac_allowed()
	return // admin_emergency_no_recall || emergency_no_recall || !emergency

/datum/evacuation_controller/shuttle/get_antag_panel()
	switch(SSevacuation.controller.state)
		if(EVACUATION_IDLE)
			return "<a href='?_src_=holder;[HrefToken()];start_evac=1'>Start Evacuation</a><br>"
		if(EVACUATION_BEGAN)
			var/timeleft = SSshuttle.emergency.timeLeft()
			var/dat = "ETA: <a href='?_src_=holder;[HrefToken()];edit_shuttle_time=1'>[(timeleft / 60) % 60]:[add_leading(num2text(timeleft % 60), 2, "0")]</a><BR>"
			return dat + "<a href='?_src_=holder;[HrefToken()];start_evac=2'>Send Back</a><br>"
		if(EVACUATION_NO_RETURN)
			var/timeleft = SSshuttle.emergency.timeLeft()
			return "ETA: <a href='?_src_=holder;[HrefToken()];edit_shuttle_time=1'>[(timeleft / 60) % 60]:[add_leading(num2text(timeleft % 60), 2, "0")]</a><BR>"
		if(EVACUATION_FINISHED)
			return "Finished<BR>"
