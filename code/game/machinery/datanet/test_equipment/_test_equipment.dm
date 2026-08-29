//Shared behaviour between generic datanet test equipment

/obj/machinery/test_equipment
	name = "Generic Test Equipment"

	allow_speech_emphasis = FALSE //No fucking with my debug output


/obj/machinery/test_equipment/receive_signal(datum/signal/signal)
	SHOULD_CALL_PARENT(FALSE) //This is a dev tool go fuck yourself
	var/signal_data = signal.data
	say("[json_encode(signal_data)]")
