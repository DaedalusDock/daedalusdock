/obj/machinery/test_equipment/wired
	name = "Development Dataset"
	icon = 'icons/obj/terminals.dmi'
	icon_state = "fax0"
	desc = "A piece of test equipment for data networks. You should probably call a coder if you see this!"
	var/obj/machinery/power/data_terminal/transmission_terminal //Parasitize the data terminal.

// This equipment is *incredibly* basic, and there's probably a subtype of machinery that you should use instead.
// I should probably remove this before pushing, but if not, here it is!

/obj/machinery/test_equipment/wired/CtrlClick(mob/user)
	. = ..()
	reconnect_dataterm()

/obj/machinery/test_equipment/wired/say_emphasis(input)
	//Fuck off and don't decorate debug text
	return input

/obj/machinery/test_equipment/wired/proc/reconnect_dataterm()
	var/new_transmission_terminal = locate(/obj/machinery/power/data_terminal) in get_turf(src)
	if(transmission_terminal == new_transmission_terminal)
		say("Already linked to detected terminal. Aborting.")
		return
	transmission_terminal?.connected_machine = null //Disconnect from the old one, if it exists.
	transmission_terminal = new_transmission_terminal
	if(new_transmission_terminal)
		say("Found terminal, Ref \[\ref[transmission_terminal]].")
		transmission_terminal.connected_machine = src
	else
		say("No terminal found.")

/obj/machinery/test_equipment/wired/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(!transmission_terminal)
		say("No network connection established!")
	var/jsonified_text = input(user, "Input signal as JSON") as message|null
	if(!jsonified_text)
		return
	var/list/datablob = json_decode(jsonified_text)
	var/datum/signal/pretransmission_signal = new(src, datablob) //This is split out for debugging reasons.
	transmission_terminal.post_signal(pretransmission_signal)

/obj/machinery/test_equipment/wired/receive_signal(datum/signal/signal)
	SHOULD_CALL_PARENT(FALSE) //This is a dev tool go fuck yourself
	var/signal_data = signal.data
	say("[json_encode(signal_data)]")
