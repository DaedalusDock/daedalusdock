/obj/structure/statue
	name = "statue"
	desc = "Placeholder. Yell at Firecage if you SOMEHOW see this."
	icon = 'icons/obj/statue.dmi'
	icon_state = ""
	density = TRUE
	anchored = FALSE
	max_integrity = 100
	can_atmos_pass = CANPASS_DENSITY
	material_modifier = 0.5
	material_flags = MATERIAL_EFFECTS | MATERIAL_AFFECT_STATISTICS
	blocks_emissive = EMISSIVE_BLOCK_UNIQUE
	abstract_type = /obj/structure/statue
	/// Beauty component mood modifier
	var/impressiveness = 15
	/// Art component subtype added to this statue
	var/art_type = /datum/element/art
	/// Can this statue be created by hand?
	var/can_be_carved = TRUE

/obj/structure/statue/Initialize(mapload)
	. = ..()
	AddElement(art_type, impressiveness)
	AddElement(/datum/element/beauty, impressiveness * 75)
	AddComponent(/datum/component/simple_rotation)

/obj/structure/statue/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	if(flags_1 & NODECONSTRUCT_1)
		return FALSE
	default_unfasten_wrench(user, tool)
	return ITEM_INTERACT_SUCCESS

/obj/structure/statue/attackby(obj/item/W, mob/living/user, params)
	add_fingerprint(user)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(W.tool_behaviour == TOOL_WELDER)
			if(!W.tool_start_check(user, amount=0))
				return FALSE

			user.visible_message(span_notice("[user] is slicing apart the [name]."), \
								span_notice("You are slicing apart the [name]..."))
			if(W.use_tool(src, user, 40, volume=50))
				user.visible_message(span_notice("[user] slices apart the [name]."), \
									span_notice("You slice apart the [name]!"))
				deconstruct(TRUE)
			return
	return ..()

/obj/structure/statue/AltClick(mob/user)
	return ..() // This hotkey is BLACKLISTED since it's used by /datum/component/simple_rotation

/obj/structure/statue/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		var/amount_mod = disassembled ? 0 : -2
		for(var/mat in custom_materials)
			var/datum/material/custom_material = GET_MATERIAL_REF(mat)
			var/amount = max(0,round(custom_materials[mat]/MINERAL_MATERIAL_AMOUNT) + amount_mod)
			if(amount > 0)
				new custom_material.sheet_type(drop_location(),amount)
	qdel(src)

//////////////////////////////////////STATUES/////////////////////////////////////////////////////////////
////////////////////////uranium///////////////////////////////////

TYPEINFO_DEF(/obj/structure/statue/uranium)
	default_materials = list(/datum/material/uranium=MINERAL_MATERIAL_AMOUNT*5)

/obj/structure/statue/uranium
	max_integrity = 300
	light_outer_range = 2
	impressiveness = 25 // radiation makes an impression
	abstract_type = /obj/structure/statue/uranium

/obj/structure/statue/uranium/nuke
	name = "statue of a nuclear fission explosive"
	desc = "This is a grand statue of a Nuclear Explosive. It has a sickening green colour."
	icon_state = "nuke"

/obj/structure/statue/uranium/eng
	name = "Statue of an engineer"
	desc = "This statue has a sickening green colour."
	icon_state = "eng"

////////////////////////////plasma///////////////////////////////////////////////////////////////////////

TYPEINFO_DEF(/obj/structure/statue/plasma)
	default_materials = list(/datum/material/plasma=MINERAL_MATERIAL_AMOUNT*5)

/obj/structure/statue/plasma
	max_integrity = 200
	impressiveness = 20
	desc = "This statue is suitably made from plasma."
	abstract_type = /obj/structure/statue/plasma

/obj/structure/statue/plasma/scientist
	name = "statue of a scientist"
	icon_state = "sci"

/obj/structure/statue/plasma/xeno
	name = "statue of a xenomorph"
	icon_state = "xeno"

//////////////////////gold///////////////////////////////////////

TYPEINFO_DEF(/obj/structure/statue/gold)
	default_materials = list(/datum/material/gold=MINERAL_MATERIAL_AMOUNT*5)

/obj/structure/statue/gold
	max_integrity = 300
	impressiveness = 25
	desc = "This is a highly valuable statue made from gold."
	abstract_type = /obj/structure/statue/gold

/obj/structure/statue/gold/hos
	name = "statue of the security marshal"
	icon_state = "hos"

/obj/structure/statue/gold/hop
	name = "statue of the head of personnel"
	icon_state = "hop"

/obj/structure/statue/gold/cmo
	name = "statue of the medical director"
	icon_state = "cmo"

/obj/structure/statue/gold/ce
	name = "statue of the chief engineer"
	icon_state = "ce"

/obj/structure/statue/gold/rd
	name = "statue of the research director"
	icon_state = "rd"

//////////////////////////silver///////////////////////////////////////

TYPEINFO_DEF(/obj/structure/statue/silver)
	default_materials = list(/datum/material/silver=MINERAL_MATERIAL_AMOUNT*5)

/obj/structure/statue/silver
	max_integrity = 300
	impressiveness = 25
	desc = "This is a valuable statue made from silver."
	abstract_type = /obj/structure/statue/silver

/obj/structure/statue/silver/md
	name = "statue of a medical officer"
	icon_state = "md"

/obj/structure/statue/silver/janitor
	name = "statue of a janitor"
	icon_state = "jani"

/obj/structure/statue/silver/sec
	name = "statue of a security officer"
	icon_state = "sec"

/obj/structure/statue/silver/secborg
	name = "statue of a security cyborg"
	icon_state = "secborg"

/obj/structure/statue/silver/medborg
	name = "statue of a medical cyborg"
	icon_state = "medborg"

/////////////////////////diamond/////////////////////////////////////////

TYPEINFO_DEF(/obj/structure/statue/diamond)
	default_materials = list(/datum/material/diamond=MINERAL_MATERIAL_AMOUNT*5)

/obj/structure/statue/diamond
	max_integrity = 1000
	impressiveness = 50
	desc = "This is a very expensive diamond statue."
	abstract_type = /obj/structure/statue/diamond

/obj/structure/statue/diamond/captain
	name = "statue of THE captain."
	icon_state = "cap"

/obj/structure/statue/diamond/ai1
	name = "statue of the AI hologram."
	icon_state = "ai1"

/obj/structure/statue/diamond/ai2
	name = "statue of the AI core."
	icon_state = "ai2"

////////////////////////bananium///////////////////////////////////////

TYPEINFO_DEF(/obj/structure/statue/bananium)
	default_materials = list(/datum/material/bananium=MINERAL_MATERIAL_AMOUNT*5)

/obj/structure/statue/bananium
	max_integrity = 300
	impressiveness = 50
	desc = "A bananium statue with a small engraving:'HOOOOOOONK'."
	abstract_type = /obj/structure/statue/bananium

/obj/structure/statue/bananium/clown
	name = "statue of a clown"
	icon_state = "clown"

/////////////////////sandstone/////////////////////////////////////////

TYPEINFO_DEF(/obj/structure/statue/sandstone)
	default_materials = list(/datum/material/sandstone=MINERAL_MATERIAL_AMOUNT*5)

/obj/structure/statue/sandstone
	max_integrity = 50
	impressiveness = 15
	abstract_type = /obj/structure/statue/sandstone

/obj/structure/statue/sandstone/assistant
	name = "statue of an assistant"
	desc = "A cheap statue of sandstone for a greyshirt."
	icon_state = "assist"


/obj/structure/statue/sandstone/venus //call me when we add marble i guess
	name = "statue of a pure maiden"
	desc = "An ancient marble statue. The subject is depicted with a floor-length braid and is wielding a toolbox. By Jove, it's easily the most gorgeous depiction of a woman you've ever seen. The artist must truly be a master of his craft. Shame about the broken arm, though."
	icon = 'icons/obj/statuelarge.dmi'
	icon_state = "venus"

/////////////////////snow/////////////////////////////////////////

TYPEINFO_DEF(/obj/structure/statue/snow)
	default_materials = list(/datum/material/snow=MINERAL_MATERIAL_AMOUNT*5)

/obj/structure/statue/snow
	max_integrity = 50
	abstract_type = /obj/structure/statue/snow

/obj/structure/statue/snow/snowman
	name = "snowman"
	desc = "Several lumps of snow put together to form a snowman."
	icon_state = "snowman"

/obj/structure/statue/snow/snowlegion
	name = "snowlegion"
	desc = "Looks like that weird kid with the tiger plushie has been round here again."
	icon_state = "snowlegion"

///////////////////////////////bronze///////////////////////////////////

TYPEINFO_DEF(/obj/structure/statue/bronze)
	default_materials = list(/datum/material/bronze=MINERAL_MATERIAL_AMOUNT*5)

/obj/structure/statue/bronze
	abstract_type = /obj/structure/statue/bronze

/obj/structure/statue/bronze/marx
	name = "\improper Karl Marx bust"
	desc = "A bust depicting a certain 19th century economist. You get the feeling a specter is haunting the station."
	icon_state = "marx"
	art_type = /datum/element/art/rev

///////////Elder Atmosian///////////////////////////////////////////

TYPEINFO_DEF(/obj/structure/statue/elder_atmosian)
	default_materials = list(/datum/material/metalhydrogen = MINERAL_MATERIAL_AMOUNT*10)

/obj/structure/statue/elder_atmosian
	name = "Elder Atmosian"
	desc = "A statue of an Elder Atmosian, capable of bending the laws of thermodynamics to their will."
	icon_state = "eng"
	max_integrity = 1000
	impressiveness = 100
	can_be_carved = FALSE //Created by a crafting recipe instead of the standard system.

TYPEINFO_DEF(/obj/item/chisel)
	default_materials = list(/datum/material/iron=75)

/obj/item/chisel
	name = "chisel"
	desc = "Breaking and making art since 4000 BC. This one uses advanced technology to allow the creation of lifelike moving statues."
	icon = 'icons/obj/statue.dmi'
	icon_state = "chisel"
	inhand_icon_state = "screwdriver_nuke"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	force = 5
	w_class = WEIGHT_CLASS_TINY
	throwforce = 5
	throw_range = 5
	attack_verb_continuous = list("stabs")
	attack_verb_simple = list("stab")
	hitsound = 'sound/weapons/bladeslice.ogg'
	usesound = list('sound/items/screwdriver.ogg', 'sound/items/screwdriver2.ogg')
	drop_sound = 'sound/items/handling/screwdriver_drop.ogg'
	pickup_sound = 'sound/items/handling/screwdriver_pickup.ogg'
	sharpness = SHARP_POINTY
	tool_behaviour = TOOL_RUSTSCRAPER
	toolspeed = 3 // You're gonna have a bad time

	/// Block we're currently carving in
	var/obj/structure/carving_block/prepared_block
	/// If tracked user moves we stop sculpting
	var/mob/living/tracked_user
	/// Currently sculpting
	var/sculpting = FALSE

/obj/item/chisel/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/eyestab)
	//deals 200 damage to statues, meaning you can actually kill one in ~250 hits
	AddElement(/datum/element/bane, /mob/living/simple_animal/hostile/statue, damage_multiplier = 40)

/obj/item/chisel/Destroy()
	prepared_block = null
	tracked_user = null
	return ..()

/*
Hit the block to start
Point with the chisel at the target to choose what to sculpt or hit block to choose from preset statue types.
Hit block again to start sculpting.
Moving interrupts
*/
/obj/item/chisel/pre_attack(atom/A, mob/living/user, params)
	. = ..()
	if(sculpting)
		return
	if(istype(A,/obj/structure/carving_block))
		if(A == prepared_block && (prepared_block.current_target || prepared_block.current_preset_type))
			start_sculpting(user)
		else if(!prepared_block)
			set_block(A,user)
		else if(A == prepared_block)
			show_generic_statues_prompt(user)
		return TRUE
	else if(prepared_block) //We're aiming at something next to us with block prepared
		prepared_block.set_target(A,user)
		return TRUE

// We aim at something distant.
/obj/item/chisel/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	var/atom/target = interacting_with // Yes i am supremely lazy

	if(!sculpting && prepared_block && ismovable(target) && prepared_block.completion == 0)
		prepared_block.set_target(target,user)
		return ITEM_INTERACT_SUCCESS

/obj/item/chisel/proc/start_sculpting(mob/living/user)
	to_chat(user,span_notice("You start sculpting [prepared_block]."),type=MESSAGE_TYPE_INFO)
	sculpting = TRUE
	//How long whole process takes
	var/sculpting_time = 30 SECONDS
	//Single interruptible progress period
	var/sculpting_period = round(sculpting_time / world.icon_size) //this is just so it reveals pixels line by line for each.
	var/interrupted = FALSE
	var/remaining_time = sculpting_time - (prepared_block.completion * sculpting_time)

	var/datum/progressbar/total_progress_bar = new(user, sculpting_time, prepared_block )
	while(remaining_time > 0 && !interrupted)
		if(do_after(user, prepared_block, sculpting_period, progress = FALSE))
			remaining_time -= sculpting_period
			prepared_block.set_completion((sculpting_time - remaining_time)/sculpting_time)
			total_progress_bar.update(sculpting_time - remaining_time)
		else
			interrupted = TRUE
	total_progress_bar.end_progress()
	if(!interrupted && !QDELETED(prepared_block))
		prepared_block.create_statue()
		to_chat(user,span_notice("The statue is finished!"),type=MESSAGE_TYPE_INFO)
	break_sculpting()

/obj/item/chisel/proc/set_block(obj/structure/carving_block/B,mob/living/user)
	prepared_block = B
	tracked_user = user
	RegisterSignal(tracked_user,COMSIG_MOVABLE_MOVED,PROC_REF(break_sculpting))
	to_chat(user,span_notice("You prepare to work on [B]."),type=MESSAGE_TYPE_INFO)

/obj/item/chisel/unequipped(mob/user, silent)
	. = ..()
	break_sculpting()

/obj/item/chisel/proc/break_sculpting()
	SIGNAL_HANDLER
	sculpting = FALSE
	if(prepared_block && prepared_block.completion == 0)
		prepared_block.reset_target()
	prepared_block = null
	if(tracked_user)
		UnregisterSignal(tracked_user,COMSIG_MOVABLE_MOVED)
		tracked_user = null

/obj/item/chisel/proc/show_generic_statues_prompt(mob/living/user)
	var/list/choices = list()
	for(var/statue_path in prepared_block.get_possible_statues())
		var/obj/structure/statue/S = statue_path
		choices[statue_path] = image(icon=initial(S.icon),icon_state=initial(S.icon_state))
	var/choice = show_radial_menu(user, prepared_block , choices, require_near = TRUE)
	if(choice)
		prepared_block.current_preset_type = choice
		var/image/chosen_looks = choices[choice]
		prepared_block.current_target = chosen_looks.appearance
		var/obj/structure/statue/S = choice
		to_chat(user,span_notice("You decide to sculpt [prepared_block] into [initial(S.name)]."),type=MESSAGE_TYPE_INFO)


/obj/structure/carving_block
	name = "block"
	desc = "ready for sculpting."
	icon = 'icons/obj/statue.dmi'
	icon_state = "block"
	material_flags = MATERIAL_EFFECTS | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS | MATERIAL_ADD_PREFIX
	density = TRUE
	material_modifier = 0.5 //50% effectiveness of materials

	/// The thing it will look like - Unmodified resulting statue appearance
	var/current_target
	/// Currently chosen preset statue type
	var/current_preset_type
	//Table of required materials for each non-abstract statue type
	var/static/list/statue_costs
	/// statue completion from 0 to 1.0
	var/completion = 0
	/// Greyscaled target with cutout filter
	var/mutable_appearance/target_appearance_with_filters
	/// HSV color filters parameters
	var/static/list/greyscale_with_value_bump = list(0,0,0, 0,0,0, 0,0,1, 0,0,-0.05)

/obj/structure/carving_block/Destroy()
	current_target = null
	target_appearance_with_filters = null
	return ..()

/obj/structure/carving_block/proc/set_target(atom/movable/target,mob/living/user)
	if(!is_viable_target(target))
		to_chat(user,"You won't be able to carve that.")
		return
	if(istype(target,/obj/structure/statue/custom))
		var/obj/structure/statue/custom/original = target
		current_target = original.content_ma
	else
		current_target = target.appearance
	var/mutable_appearance/ma = current_target
	to_chat(user,span_notice("You decide to sculpt [src] into [ma.name]."),type=MESSAGE_TYPE_INFO)

/obj/structure/carving_block/proc/reset_target()
	current_target = null
	current_preset_type = null
	target_appearance_with_filters = null

/obj/structure/carving_block/update_overlays()
	. = ..()
	if(!target_appearance_with_filters)
		return
	//We're only keeping one instance here that changes in the middle so we have to clone it to avoid managed overlay issues
	var/mutable_appearance/clone = new(target_appearance_with_filters)
	. += clone

/obj/structure/carving_block/proc/is_viable_target(atom/movable/target)
	//Only things on turfs
	if(!isturf(target.loc))
		return FALSE
	//No big icon things
	var/icon/thing_icon = icon(target.icon, target.icon_state)
	if(thing_icon.Height() != world.icon_size || thing_icon.Width() != world.icon_size)
		return FALSE
	return TRUE

/obj/structure/carving_block/proc/create_statue()
	if(current_preset_type)
		var/obj/structure/statue/preset_statue = new current_preset_type(get_turf(src))
		preset_statue.set_custom_materials(custom_materials)
		qdel(src)
	else if(current_target)
		var/obj/structure/statue/custom/new_statue = new(get_turf(src))
		new_statue.set_visuals(current_target)
		new_statue.set_custom_materials(custom_materials)
		var/mutable_appearance/ma = current_target
		new_statue.name = "statue of [ma.name]"
		new_statue.desc = "statue depicting [ma.name]"
		qdel(src)

/obj/structure/carving_block/proc/set_completion(value)
	if(!current_target)
		return
	if(!target_appearance_with_filters)
		target_appearance_with_filters = new(current_target)
		// KEEP_APART in case carving block gets KEEP_TOGETHER from somewhere like material texture filters.
		target_appearance_with_filters.appearance_flags |= KEEP_TOGETHER | KEEP_APART
		//Doesn't use filter helpers because MAs aren't atoms
		target_appearance_with_filters.filters = filter(type="color",color=greyscale_with_value_bump,space=FILTER_COLOR_HSV)
	completion = value
	var/static/icon/white = icon('icons/effects/alphacolors.dmi', "white")
	switch(value)
		if(0)
			//delete uncovered and reset filters
			remove_filter("partial_uncover")
			target_appearance_with_filters = null
		else
			var/mask_offset = min(world.icon_size,round(completion * world.icon_size))
			remove_filter("partial_uncover")
			add_filter("partial_uncover", 1, alpha_mask_filter(icon = white, y = -mask_offset))
			target_appearance_with_filters.filters = filter(type="alpha",icon=white,y=-mask_offset,flags=MASK_INVERSE)
	update_appearance()


/// Returns a list of preset statues carvable from this block depending on the custom materials
/obj/structure/carving_block/proc/get_possible_statues()
	. = list()
	if(!statue_costs)
		statue_costs = build_statue_cost_table()
	for(var/statue_path in statue_costs)
		var/list/carving_cost = statue_costs[statue_path]
		var/enough_materials = TRUE
		for(var/required_material in carving_cost)
			if(!has_material_type(required_material, TRUE, carving_cost[required_material]))
				enough_materials = FALSE
				break
		if(enough_materials)
			. += statue_path

/obj/structure/carving_block/proc/build_statue_cost_table()
	. = list()
	for(var/obj/structure/statue/statue_type as anything in subtypesof(/obj/structure/statue) - /obj/structure/statue/custom)
		if(isabstract(statue_type))
			continue
		var/obj/structure/statue/S = new statue_type()
		if(!S.icon_state || !S.can_be_carved || !S.custom_materials)
			continue
		.[S.type] = S.custom_materials
		qdel(S)

/obj/structure/statue/custom
	name = "custom statue"
	icon_state = "base"
	obj_flags = CAN_BE_HIT | UNIQUE_RENAME
	appearance_flags = TILE_BOUND | PIXEL_SCALE | KEEP_TOGETHER | LONG_GLIDE //Added keep together in case targets has weird layering
	material_flags = MATERIAL_EFFECTS | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
	/// primary statue overlay
	var/mutable_appearance/content_ma
	var/static/list/greyscale_with_value_bump = list(0,0,0, 0,0,0, 0,0,1, 0,0,-0.05)

/obj/structure/statue/custom/Destroy()
	content_ma = null
	return ..()

/obj/structure/statue/custom/proc/set_visuals(model_appearance)
	if(content_ma)
		QDEL_NULL(content_ma)
	content_ma = new
	content_ma.appearance = model_appearance
	content_ma.pixel_x = 0
	content_ma.pixel_y = 0
	content_ma.alpha = 255

	var/static/list/plane_whitelist = list(FLOAT_PLANE, GAME_PLANE, FLOOR_PLANE)

	/// Ideally we'd have knowledge what we're removing but i'd have to be done on target appearance retrieval
	var/list/overlays_to_remove = list()
	for(var/mutable_appearance/special_overlay as anything in content_ma.overlays)
		if(special_overlay.plane in plane_whitelist)
			continue
		overlays_to_remove += special_overlay
	content_ma.overlays -= overlays_to_remove

	var/list/underlays_to_remove = list()
	for(var/mutable_appearance/special_underlay as anything in content_ma.underlays)
		if(special_underlay.plane in plane_whitelist)
			continue
		underlays_to_remove += special_underlay
	content_ma.underlays -= underlays_to_remove

	content_ma.appearance_flags &= ~KEEP_APART //Don't want this
	content_ma.filters = filter(type="color",color=greyscale_with_value_bump,space=FILTER_COLOR_HSV)
	update_appearance()

/obj/structure/statue/custom/update_overlays()
	. = ..()
	if(content_ma)
		. += content_ma
