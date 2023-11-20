// Since the APC uses a data-enabled terminal, instead of a data terminal,
// it's going to have to handle networking a little bit differently.

//All of these have to be reimplimented to ideate terminal instead of netjack

/obj/machinery/power/apc/post_signal(datum/signal/sending_signal, preserve_s_addr)
	if(isnull(terminal) || isnull(sending_signal)) //nullcheck for sanic speed
		return //You need a pipe and something to send down it, though.
	if(!preserve_s_addr)
		sending_signal.data["s_addr"] = src.net_id
	sending_signal.transmission_method = TRANSMISSION_WIRE
	sending_signal.author = WEAKREF(src) // Override the sending signal author.
	src.terminal.post_signal(sending_signal)

/obj/machinery/power/apc/receive_signal(datum/signal/signal)
	. = ..()
	if(. == RECEIVE_SIGNAL_FINISHED)
		return //Ping packet handled.
