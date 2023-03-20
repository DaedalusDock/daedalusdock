/obj/item/mcobject
	name = "mechcomp object"
	icon = 'goon/icons/obj/mechcomp.dmi'

	///Our interface for communicating with other mcobjects
	var/datum/mcinterface/interface
	///The message we're prepared to send
	var/datum/mcmessage/stored_message
	///Configuration options
	var/list/configs
	///Inputs, basically pre-set acts. use MC_ADD_INPUT() to add.
	var/list/inputs

/obj/item/mcobject/Initialize(mapload)
	. = ..()
	interface = new(src)
	RegisterSignal(interface, MCACT_RECEIVE_MESSAGE, PROC_REF(mechcomp_act))
	stored_message = new(MC_BOOL_TRUE)
	configs = list(MC_CFG_UNLINK_ALL, MC_CFG_LINK)
	inputs = list()
	update_icon_state()

/obj/item/mcobject/Destroy(force)
	qdel(interface)
	return ..()

/obj/item/mcobject/update_icon_state()
	. = ..()
	icon_state = anchored ? "u[base_icon_state]" : base_icon_state

/obj/item/mcobject/wrench_act(mob/living/user, obj/item/tool)
	if(default_unfasten_wrench(user, tool))
		on_wrench()

///Called on a successful wrench or unwrench
/obj/item/mcobject/proc/on_wrench()
	SHOULD_CALL_PARENT(TRUE)
	update_icon_state()
	if(!anchored)
		interface.ClearConnections()
	else
		pixel_x = base_pixel_x
		pixel_y = base_pixel_y

/obj/item/mcobject/multitool_act(mob/living/user, obj/item/tool)
	var/datum/component/mclinker/link = tool.GetComponent(/datum/component/mclinker)
	if(link)
		if(!create_link(user, link.target))
			return
		qdel(link)
		return

	var/action = input("Select a config to modify", "Configure Component", null) as null|anything in configs
	if(!action)
		return

	config_act(user, action, tool)

///A multitool interaction is happening. Let's act on it.
/obj/item/mcobject/proc/config_act(mob/user, action, obj/item/tool)
	SHOULD_CALL_PARENT(TRUE)
	switch(action)
		if(MC_CFG_UNLINK_ALL)
			interface.ClearConnections()
			to_chat(user, span_notice("You remove all connections from [src]."))
			return

		if(MC_CFG_LINK)
			if(!tool)
				CRASH("Something tried to create a multitool linker without a multitool.")
			if(!anchored)
				to_chat(user, span_warning("You cannot link an unsecured device!"))
				return
			tool.AddComponent(/datum/component/mclinker, src)
			to_chat(user, span_notice("You prepare to link [src] with another device."))
			return

/obj/item/mcobject/proc/create_link(mob/user, obj/item/mcobject/target)
	SHOULD_CALL_PARENT(TRUE)

	if(!anchored)
		to_chat(user, span_warning("You cannot link an unsecured device!"))
		return

	if(src == target)
		to_chat(user, span_warning("You cannot link a device to itself!"))
		return

	if(get_dist(src, target) > MC_LINK_RANGE)
		to_chat(user, span_warning("Those devices are too far apart to be linked!"))
		return

	var/list/options = inputs.Copy()

	for(var/thing in interface.trigger_inputs)
		options -= interface.trigger_inputs[thing]

	if(!length(options))
		to_chat(user, span_warning("[src] has no more inputs available!"))
		return

	var/choice = input(user, "Link Input", "Configure Component") as null|anything in options
	if(!choice)
		return

	to_chat(user, span_notice("You link [target] to [src]."))
	interface.AddTriggerInput(target.interface, choice)

	return TRUE

///Relay our stored_message to all of our outputs
/obj/item/mcobject/proc/fire_stored_message()
	SHOULD_CALL_PARENT(TRUE)
	//interface.Send(stored_message)

///Send out the pre-made commands to our outputs
/obj/item/mcobject/proc/trigger()
	interface.SendOutputActs()

/obj/item/mcobject/proc/mechcomp_act(datum/mcmessage/act)
	SHOULD_NOT_SLEEP(TRUE)
