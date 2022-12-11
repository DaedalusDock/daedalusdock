//I promise that this isn't just 100% stolen from goon. Honest~ -Francinum

/obj/machinery/power/data_terminal
	name = "data terminal"
	icon_state = "dterm"
	network_flags = NETWORK_FLAG_POWERNET_DATANODE
	layer = LOW_OBJ_LAYER
	var/obj/machinery/connected_machine // Whatever machine that got built over us, We proxy it's packets back and forth.

/obj/machinery/power/data_terminal/Initialize(mapload)
	. = ..()
	connect_to_network()
	AddElement(/datum/element/undertile, TRAIT_T_RAY_VISIBLE)

/obj/machinery/power/data_terminal/receive_signal(datum/signal/signal)
	SHOULD_CALL_PARENT(FALSE) //We *ARE* the signal poster.
	if(!powernet) //Did we somehow receive a signal without a powernet?
		return //*shrug*
	if(signal.transmission_method != TRANSMISSION_WIRE)
		CRASH("Data terminal received a non-wire data packet")
	if(connected_machine)
		connected_machine.receive_signal(signal)

/obj/machinery/power/data_terminal/post_signal(datum/signal/signal)
	SHOULD_CALL_PARENT(FALSE) //We *ARE* the signal poster.
	if(!powernet || !signal)
		return //What do you expect me to transmit on, the fucking air?
	if(signal.author.resolve() != connected_machine)
		CRASH("Data terminal was told to pass a signal from something other than it's master machine?")
	signal.transmission_method = TRANSMISSION_WIRE
	//Fuck you, we're the author now bitch.
	signal.author = WEAKREF(src)
	powernet.queue_signal(signal)

/// Our connected machine moved. Disconnect and complain at them!
/obj/machinery/power/data_terminal/proc/tear_out(datum/source)
	SIGNAL_HANDLER
	do_sparks(10, FALSE, src)
	visible_message(span_warning("As [connected_machine] moves, \the [src] violently sparks as it disconnects from the network!")) //Good job fuckface

	connected_machine = null

#error Refactor this so that the data terminal deals with connection/disconnection. Just because goon does it doesn't make it okay. It's generally a sign it's a ""soulful"" idea.
