//Items for nuke theft, supermatter theft traitor objective


// STEALING THE NUKE

//the nuke core - objective item
/obj/item/nuke_core
	name = "plutonium core"
	desc = "Extremely radioactive. Wear goggles."
	icon = 'icons/obj/nuke_tools.dmi'
	icon_state = "plutonium_core"
	inhand_icon_state = "plutoniumcore"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	var/pulse = 0
	var/cooldown = 0
	var/pulseicon = "plutonium_core_pulse"

/obj/item/nuke_core/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/nuke_core/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/nuke_core/attackby(obj/item/nuke_core_container/container, mob/user)
	if(istype(container))
		container.load(src, user)
	else
		return ..()

/obj/item/nuke_core/process()
	if(cooldown < world.time - 60)
		cooldown = world.time
		flick(pulseicon, src)
		radiation_pulse(src, max_range = 2, threshold = RAD_EXTREME_INSULATION)

/obj/item/nuke_core/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is rubbing [src] against [user.p_them()]self! It looks like [user.p_theyre()] trying to commit suicide!"))
	return (TOXLOSS)

//nuke core box, for carrying the core
/obj/item/nuke_core_container
	name = "nuke core container"
	desc = "Solid container for radioactive objects."
	icon = 'icons/obj/nuke_tools.dmi'
	icon_state = "core_container_empty"
	inhand_icon_state = "tile"
	lefthand_file = 'icons/mob/inhands/misc/tiles_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/tiles_righthand.dmi'
	var/obj/item/nuke_core/core

/obj/item/nuke_core_container/Destroy()
	QDEL_NULL(core)
	return ..()

/obj/item/nuke_core_container/proc/load(obj/item/nuke_core/ncore, mob/user)
	if(core || !istype(ncore))
		return FALSE
	ncore.forceMove(src)
	core = ncore
	icon_state = "core_container_loaded"
	to_chat(user, span_warning("Container is sealing..."))
	addtimer(CALLBACK(src, PROC_REF(seal)), 50)
	return TRUE

/obj/item/nuke_core_container/proc/seal()
	if(istype(core))
		STOP_PROCESSING(SSobj, core)
		icon_state = "core_container_sealed"
		playsound(src, 'sound/items/deconstruct.ogg', 60, TRUE)
		if(equipped_to)
			to_chat(equipped_to, span_warning("[src] is permanently sealed, [core]'s radiation is contained."))

/obj/item/nuke_core_container/attackby(obj/item/nuke_core/core, mob/user)
	if(istype(core))
		if(!user.temporarilyRemoveItemFromInventory(core))
			to_chat(user, span_warning("The [core] is stuck to your hand!"))
			return
		else
			load(core, user)
	else
		return ..()

//snowflake screwdriver, works as a key to start nuke theft, traitor only
/obj/item/screwdriver/nuke
	name = "screwdriver"
	desc = "A screwdriver with an ultra thin tip that's carefully designed to boost screwing speed."
	icon = 'icons/obj/nuke_tools.dmi'
	icon_state = "screwdriver_nuke"
	inhand_icon_state = "screwdriver_nuke"
	toolspeed = 0.5
	random_color = FALSE
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null

/obj/item/screwdriver/nuke/get_belt_overlay()
	return mutable_appearance('icons/obj/clothing/belt_overlays.dmi', "screwdriver_nuke")

/obj/item/paper/guides/antag/nuke_instructions
	info = "How to break into a Nanotrasen self-destruct terminal and remove its plutonium core:<br>\
	<ul>\
	<li>Use a screwdriver with a very thin tip (provided) to unscrew the terminal's front panel</li>\
	<li>Dislodge and remove the front panel with a crowbar</li>\
	<li>Cut the inner metal plate with a welding tool</li>\
	<li>Pry off the inner plate with a crowbar to expose the radioactive core</li>\
	<li>Use the core container to remove the plutonium core; the container will take some time to seal</li>\
	<li>???</li>\
	</ul>"

/obj/item/paper/guides/antag/hdd_extraction
	info = "<h1>Source Code Theft & You - The Idiot's Guide to Crippling Nanotrasen Research & Development</h1><br>\
	Rumour has it that Nanotrasen are using their R&D Servers to create something awful! They've codenamed it Project Goon, whatever that means.<br>\
	This cannot be allowed to stand. Below is all our intel for stealing their source code and crippling their research efforts:<br>\
	<ul>\
	<li>Locate the physical R&D Server mainframes. Intel suggests these are stored in specially cooled rooms deep within their Science department.</li>\
	<li>Nanotrasen is a corporation not known for subtlety in design. You should be able to identify the master server by any distinctive markings.</li>\
	<li>Tools are on-site procurement. Screwdriver, crowbar and wirecutters should be all you need to do the job.<li>\
	<li>The front panel screws are hidden in recesses behind stickers. Easily removed once you know they're there.</li>\
	<li>You'll probably find the hard drive in secure housing. You may need to pry it loose with a crowbar, shouldn't do too much damage.</li>\
	<li>Finally, carefully cut all of the hard drive's connecting wires. Don't rush this, snipping the wrong wire could wipe all data!</li>\
	</ul>\
	Removing this drive is guaranteed to cripple research efforts regardless of what data is contained on it.<br>\
	The thing's probably hardwired. No putting it back once you've extracted it. The crew are likely to be as mad as bees if they find out!<br>\
	Survive the shift and extract the hard drive safely.<br>\
	Succeed and you will receive a coveted green highlight on your record for this assignment. Fail us and red's the last colour you'll ever see.<br>\
	Do not disappoint us.<br>"

/obj/item/computer_hardware/hard_drive/cluster
	name = "cluster hard disk drive"
	desc = "A large storage cluster consisting of multiple HDDs for usage in dedicated storage systems."
	power_usage = 500
	max_capacity = 2048
	icon_state = "harddisk"
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/computer_hardware/hard_drive/cluster/hdd_theft
	name = "r&d server hard disk drive"
	desc = "For some reason, people really seem to want to steal this. The source code on this drive is probably used for something awful!"
	icon = 'icons/obj/nuke_tools.dmi'
	icon_state = "something_awful"
	max_capacity = 512
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
