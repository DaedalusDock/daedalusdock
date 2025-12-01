#define ALERT_DELAY 50 SECONDS

TYPEINFO_DEF(/obj/machinery/newscaster)
	default_armor = list(BLUNT = 50, PUNCTURE = 0, SLASH = 90, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 50, ACID = 30)

/obj/machinery/newscaster
	name = "newscaster"
	desc = "A standard newsfeed handler for use in commercial space stations. All the news you absolutely have no use for, in one place!"
	icon = 'icons/obj/terminals.dmi'
	icon_state = "newscaster_off"
	base_icon_state = "newscaster"
	verb_say = "beeps"
	verb_ask = "beeps"
	verb_exclaim = "beeps"
	max_integrity = 200
	integrity_failure = 0.25
	zmm_flags = ZMM_MANGLE_PLANES

	///How much paper is contained within the newscaster?
	var/paper_remaining = 0

	var/alert = FALSE

	var/datum/newspanel/ui_holder

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/newscaster, 30)

/obj/machinery/newscaster/Initialize(mapload, ndir, building)
	. = ..()
	GLOB.allCasters += src
	GLOB.allbountyboards += src

	ui_holder = new
	ui_holder.parent = src

	update_appearance()

/obj/machinery/newscaster/Destroy()
	GLOB.allCasters -= src
	GLOB.allbountyboards -= src
	QDEL_NULL(ui_holder)
	return ..()

/obj/machinery/newscaster/update_appearance(updates=ALL)
	. = ..()
	if(machine_stat & (NOPOWER|BROKEN))
		set_light(0)
		return
	set_light(l_outer_range = 1.4, l_power = 0.7,l_color = "#34D352") // green light

/obj/machinery/newscaster/update_overlays()
	. = ..()

	if(!(machine_stat & (NOPOWER|BROKEN)))
		var/state = "[base_icon_state]_[length(GLOB.news_network.wanted_issues) ? "wanted" : "normal"]"
		. += mutable_appearance(icon, state)
		. += emissive_appearance(icon, state, alpha = 90)

		if(length(GLOB.news_network.wanted_issues) && alert)
			. += mutable_appearance(icon, "[base_icon_state]_alert")
			. += emissive_appearance(icon, "[base_icon_state]_alert", alpha = 90)

	var/hp_percent = atom_integrity * 100 / max_integrity
	switch(hp_percent)
		if(75 to 100)
			return
		if(50 to 75)
			. += "crack1"
			. += emissive_blocker(icon, "crack1", alpha = src.alpha)
		if(25 to 50)
			. += "crack2"
			. += emissive_blocker(icon, "crack2", alpha = src.alpha)
		else
			. += "crack3"
			. += emissive_blocker(icon, "crack3", alpha = src.alpha)

/obj/machinery/newscaster/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui_holder.ui_interact(arglist(args))

/obj/machinery/newscaster/attackby(obj/item/I, mob/living/user, params)
	if(I.tool_behaviour == TOOL_WRENCH)
		to_chat(user, span_notice("You start [anchored ? "un" : ""]securing [name]..."))
		I.play_tool_sound(src)
		if(I.use_tool(src, user, 60))
			playsound(loc, 'sound/items/deconstruct.ogg', 50, TRUE)
			if(machine_stat & BROKEN)
				to_chat(user, span_warning("The broken remains of [src] fall on the ground."))
				new /obj/item/stack/sheet/iron(loc, 5)
				new /obj/item/shard(loc)
				new /obj/item/shard(loc)
			else
				to_chat(user, span_notice("You [anchored ? "un" : ""]secure [name]."))
				new /obj/item/wallframe/newscaster(loc)
			qdel(src)
	else if(I.tool_behaviour == TOOL_WELDER && !user.combat_mode)
		if(machine_stat & BROKEN)
			if(!I.tool_start_check(user, amount=0))
				return
			user.visible_message(span_notice("[user] is repairing [src]."), \
							span_notice("You begin repairing [src]..."), \
							span_hear("You hear welding."))
			if(I.use_tool(src, user, 40, volume=50))
				if(!(machine_stat & BROKEN))
					return
				to_chat(user, span_notice("You repair [src]."))
				atom_integrity = max_integrity
				set_machine_stat(machine_stat & ~BROKEN)
				update_appearance()
		else
			to_chat(user, span_notice("[src] does not need repairs."))

	else if(istype(I, /obj/item/paper))
		if(!user.temporarilyRemoveItemFromInventory(I))
			return
		else
			paper_remaining ++
			to_chat(user, span_notice("You insert the [I] into \the [src]! It now holds [paper_remaining] sheets of paper."))
			qdel(I)
			return
	return ..()

/obj/machinery/newscaster/play_attack_sound(damage, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(machine_stat & BROKEN)
				playsound(loc, 'sound/effects/hit_on_shattered_glass.ogg', 100, TRUE)
			else
				playsound(loc, 'sound/effects/glasshit.ogg', 90, TRUE)
		if(BURN)
			playsound(src.loc, 'sound/items/welder.ogg', 100, TRUE)


/obj/machinery/newscaster/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/stack/sheet/iron(loc, 2)
		new /obj/item/shard(loc)
		new /obj/item/shard(loc)
	qdel(src)

/obj/machinery/newscaster/atom_break(damage_flag)
	. = ..()
	if(.)
		playsound(loc, 'sound/effects/glassbr3.ogg', 100, TRUE)


/obj/machinery/newscaster/attack_paw(mob/living/user, list/modifiers)
	if(!user.combat_mode)
		to_chat(user, span_warning("The newscaster controls are far too complicated for your tiny brain!"))
	else
		take_damage(5, BRUTE, BLUNT)

/obj/machinery/newscaster/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	update_appearance()

/**
 * This clears alerts on the newscaster from a new message being published and updates the newscaster's appearance.
 */
/obj/machinery/newscaster/proc/remove_alert()
	alert = FALSE
	update_appearance()

/**
 * When a new feed message is made that will alert all newscasters, this causes the newscasters to sent out a spoken message as well as create a sound.
 */
/obj/machinery/newscaster/proc/news_alert(channel, update_alert = TRUE)
	if(channel)
		if(update_alert)
			say("Breaking news from [channel]!")
			playsound(loc, 'sound/machines/twobeep_high.ogg', 75, TRUE)

		alert = TRUE
		update_appearance()
		addtimer(CALLBACK(src, PROC_REF(remove_alert)), ALERT_DELAY, TIMER_UNIQUE|TIMER_OVERRIDE)

	else if(!channel && update_alert)
		say("Attention! Wanted issue distributed!")
		playsound(loc, 'sound/machines/warning-buzzer.ogg', 75, TRUE)

TYPEINFO_DEF(/obj/item/wallframe/newscaster)
	default_materials = list(/datum/material/iron=14000, /datum/material/glass=8000)

/obj/item/wallframe/newscaster
	name = "newscaster frame"
	desc = "Used to build newscasters, just secure to the wall."
	icon_state = "newscaster"
	result_path = /obj/machinery/newscaster
	pixel_shift = 30

#undef ALERT_DELAY
