// Clickable stat() button.
/obj/effect/statclick
	name = "Initializing..."
	blocks_emissive = NONE
	var/target

INITIALIZE_IMMEDIATE(/obj/effect/statclick)

/obj/effect/statclick/Initialize(mapload, text, target)
	. = ..()
	name = text
	src.target = target
	if(istype(target, /datum)) //Harddel man bad
		RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(cleanup))

/obj/effect/statclick/Destroy()
	target = null
	return ..()

/obj/effect/statclick/proc/cleanup()
	SIGNAL_HANDLER
	qdel(src)

/obj/effect/statclick/proc/update(text)
	name = text
	return src

/obj/effect/statclick/debug
	var/class

/obj/effect/statclick/debug/Click()
	if(!usr.client.holder || !target)
		return
	if(!class)
		if(istype(target, /datum/controller/subsystem))
			class = "subsystem"
		else if(istype(target, /datum/controller))
			class = "controller"
		else if(istype(target, /datum))
			class = "datum"
		else
			class = "unknown"

	usr.client.debug_variables(target)
	message_admins("Admin [key_name_admin(usr)] is debugging the [target] [class].")


// Debug verbs.
/client/proc/restart_controller(controller in list("Master", "Failsafe"))
	set category = "Debug"
	set name = "Restart Controller"
	set desc = "Restart one of the various periodic loop controllers for the game (be careful!)"

	if(!holder)
		return
	switch(controller)
		if("Master")
			Recreate_MC()
			SSblackbox.record_feedback("tally", "admin_verb", 1, "Restart Master Controller")
		if("Failsafe")
			new /datum/controller/failsafe()
			SSblackbox.record_feedback("tally", "admin_verb", 1, "Restart Failsafe Controller")

	message_admins("Admin [key_name_admin(usr)] has restarted the [controller] controller.")

/client/proc/debug_controller()
	set category = "Debug"
	set name = "Debug Controller"
	set desc = "Debug the various periodic loop controllers for the game (be careful!)"

	if(!holder)
		return

	var/list/controllers = list()
	var/list/controller_choices = list()

	for (var/datum/controller/controller in world)
		if (istype(controller, /datum/controller/subsystem))
			continue
		controllers["[controller] (controller.type)"] = controller //we use an associated list to ensure clients can't hold references to controllers
		controller_choices += "[controller] (controller.type)"

	var/datum/controller/controller_string = input("Select controller to debug", "Debug Controller") as null|anything in controller_choices
	var/datum/controller/controller = controllers[controller_string]

	if (!istype(controller))
		return
	debug_variables(controller)

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Restart Failsafe Controller")
	message_admins("Admin [key_name_admin(usr)] is debugging the [controller] controller.")

/client/proc/set_title_music()
	set category = "Admin.Fun"
	set name = "Change Title Music"
	set desc = "Set the login music"

	if(!check_rights(R_ADMIN) || !SSticker.initialized)
		return

	var/list/music_jsons = SSticker.get_music_jsons()
	var/list/name2json = list()
	for(var/json in music_jsons)
		name2json[json["name"]] = json

	var/list/selection = input(usr, "Select a track to play", "Change Title Music") as null|anything in name2json
	if(isnull(selection))
		return
	selection = name2json[selection]
	SSticker.set_login_music(selection)
	log_admin("[key_name_admin(usr)] changed the title music to [selection["name"]] ([selection["file"]])")
	message_admins("[key_name_admin(usr)] changed the title music to [selection["name"]] ([selection["file"]])")
