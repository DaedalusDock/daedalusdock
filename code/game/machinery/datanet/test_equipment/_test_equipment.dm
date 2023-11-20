//Shared behaviour between generic datanet test equipment

/obj/machinery/test_equipment
	name = "Generic Test Equipment"


/obj/machinery/test_equipment/receive_signal(datum/signal/signal)
	SHOULD_CALL_PARENT(FALSE) //This is a dev tool go fuck yourself
	var/signal_data = signal.data
	say("[json_encode(signal_data)]")

/obj/machinery/test_equipment/say_emphasis(input)
	//Fuck off and don't decorate debug text
	return input
