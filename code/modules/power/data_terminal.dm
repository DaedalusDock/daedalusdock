//I promise that this isn't just 100% stolen from goon. Honest~ -Francinum

/obj/machinery/power/data_terminal
	name = "data terminal"
	icon_state = "dterm"
	use_data = TRUE
	layer = LOW_OBJ_LAYER
	var/obj/machinery/connected_machine // Whatever machine that got built over us, We proxy it's packets back and forth.

/obj/machinery/power/data_terminal/Initialize(mapload)
	. = ..()
	connect_to_network()
	AddElement(/datum/element/undertile, TRAIT_T_RAY_VISIBLE)

/obj/machinery/power/data_terminal/receive_signal(datum/signal/signal)
	if(!powernet) //Did we somehow receive a signal without a powernet?
		return //*shrug*
	if(signal.transmission_method != TRANSMISSION_WIRE)
		CRASH("Data terminal received a non-wire data packet")
	if(connected_machine)
		connected_machine.receive_signal(signal) //TODO: Verify the machine hasn't grown legs and walked away!

/obj/machinery/power/data_terminal/proc/post_signal(datum/signal/signal)
	if(!powernet || !signal)
		return //What do you expect me to transmit on, the fucking air?
	if(signal.author.resolve() != connected_machine)
		CRASH("Data terminal was told to pass a signal from something other than it's master machine?")
	signal.transmission_method = TRANSMISSION_WIRE
	//Fuck you, we're the author now bitch.
	signal.author = WEAKREF(src)
	powernet.queue_signal(signal)
