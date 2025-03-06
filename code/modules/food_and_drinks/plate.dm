/obj/item/plate
	name = "plate"
	desc = "Holds food, powerful. Good for morale when you're not eating your spaghetti off of a desk."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "plate"
	w_class = WEIGHT_CLASS_BULKY //No backpack.

	///How many things fit on this plate?
	var/max_items = 8
	///The offset from side to side the food items can have on the plate
	var/max_x_offset = 4
	///The max height offset the food can reach on the plate
	var/max_height_offset = 5
	///Offset of where the click is calculated from, due to how food is positioned in their DMIs.
	var/placement_offset = -15

	/// Armor required to not stun
	var/armor_to_block_stun = 10

/obj/item/plate/attackby(obj/item/I, mob/user, params)
	if(!can_accept_item(I, user))
		return

	var/list/modifiers = params2list(params)
	//Center the icon where the user clicked.
	if(!LAZYACCESS(modifiers, ICON_X) || !LAZYACCESS(modifiers, ICON_Y))
		return
	if(user.transferItemToLoc(I, src, silent = FALSE))
		I.pixel_x = clamp(text2num(LAZYACCESS(modifiers, ICON_X)) - 16, -max_x_offset, max_x_offset)
		I.pixel_y = min(text2num(LAZYACCESS(modifiers, ICON_Y)) + placement_offset, max_height_offset)
		to_chat(user, span_notice("You place [I] on [src]."))
		AddToPlate(I, user)
	else
		return ..()

/obj/item/plate/pre_attack(atom/A, mob/living/user, params)
	if(!iscarbon(A))
		return

	if(user.combat_mode && ishuman(A))
		var/mob/living/carbon/human/victim = A
		if(user.zone_selected == BODY_ZONE_HEAD)
			user.do_attack_animation(victim, used_item = src)
			user.visible_message(span_danger("[user] smashes [src] over [victim]'s head."))
			shatter(victim, BODY_ZONE_HEAD)
			return TRUE

	if(!contents.len)
		return

	var/obj/item/object_to_eat = contents[1]
	A.attackby(object_to_eat, user)
	return TRUE //No normal attack

/obj/item/plate/IsContainedAtomAccessible(atom/contained, atom/movable/user)
	return TRUE

///This proc adds the food to viscontents and makes sure it can deregister if this changes.
/obj/item/plate/proc/AddToPlate(obj/item/item_to_plate)
	add_viscontents(item_to_plate)
	RegisterSignal(item_to_plate, COMSIG_MOVABLE_MOVED, PROC_REF(ItemMoved))
	RegisterSignal(item_to_plate, COMSIG_PARENT_QDELETING, PROC_REF(ItemMoved))
	update_appearance()

///This proc cleans up any signals on the item when it is removed from a plate, and ensures it has the correct state again.
/obj/item/plate/proc/ItemRemovedFromPlate(obj/item/removed_item)
	remove_viscontents(removed_item)
	UnregisterSignal(removed_item, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING))

///This proc is called by signals that remove the food from the plate.
/obj/item/plate/proc/ItemMoved(obj/item/moved_item, atom/OldLoc, Dir, Forced)
	SIGNAL_HANDLER
	ItemRemovedFromPlate(moved_item)

/obj/item/plate/proc/can_accept_item(obj/item/I, mob/user)
	if(!IS_EDIBLE(I))
		to_chat(user, span_notice("[src] is made for food, and food alone!"))
		return FALSE
	if(contents.len >= max_items)
		to_chat(user, span_notice("[src] can't fit more items!"))
		return FALSE
	return TRUE

#define PLATE_SHARD_PIECES 5

/obj/item/plate/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(.)
		return

	var/target_zone = throwingdatum.target_zone
	var/mob/thrower = throwingdatum.thrower
	if(ishuman(hit_atom))
		var/mob/living/carbon/human/victim = hit_atom
		var/bodyzone_modifier = GLOB.bodyzone_gurps_mods[target_zone]
		var/roll = SUCCESS

		if(HAS_TRAIT(thrower, TRAIT_PERFECT_ATTACKER) || !ishuman(thrower))
			roll = SUCCESS

		else
			var/mob/living/carbon/human/user = thrower
			roll = user.stat_roll(10, /datum/rpg_skill/skirmish, bodyzone_modifier, -7, src).outcome

		switch(roll)
			if(FAILURE, CRIT_FAILURE)
				target_zone = victim.get_random_valid_zone()

	shatter(hit_atom, target_zone)
	return TRUE

/obj/item/plate/proc/shatter(atom/hit_atom, target_zone = BODY_ZONE_CHEST)
	var/scatter_turf = get_turf(hit_atom)
	var/generator/scatter_gen = generator(GEN_CIRCLE, 0, 48, NORMAL_RAND)

	if((target_zone == BODY_ZONE_HEAD) && ishuman(hit_atom))
		var/mob/living/carbon/human/victim = hit_atom
		var/blocked = victim.run_armor_check(target_zone, BLUNT, silent = TRUE)
		if(blocked < armor_to_block_stun)
			victim.Paralyze(3 SECONDS)
			victim.apply_damage(15, BRUTE, BODY_ZONE_HEAD, blocked, attacking_item = src)
			victim.add_splatter_floor(scatter_turf, prob(90))

	for(var/obj/item/scattered_item as anything in contents)
		ItemRemovedFromPlate(scattered_item)
		scattered_item.forceMove(scatter_turf)
		var/list/scatter_vector = scatter_gen.Rand()
		scattered_item.pixel_x = scatter_vector[1]
		scattered_item.pixel_y = scatter_vector[2]

	for(var/iteration in 1 to PLATE_SHARD_PIECES)
		var/obj/item/plate_shard/shard = new(scatter_turf)
		shard.icon_state = "[shard.base_icon_state][iteration]"
		shard.pixel_x = rand(-4, 4)
		shard.pixel_y = rand(-4, 4)
	playsound(scatter_turf, 'sound/items/ceramic_break.ogg', 60, TRUE)
	qdel(src)

/obj/item/plate/large
	name = "buffet plate"
	desc = "A large plate made for the professional catering industry but also apppreciated by mukbangers and other persons of considerable size and heft."
	icon_state = "plate_large"
	max_items = 12
	max_x_offset = 8
	max_height_offset = 12

/obj/item/plate/small
	name = "appetizer plate"
	desc = "A small plate, perfect for appetizers, desserts or trendy modern cusine."
	icon_state = "plate_small"
	max_items = 4
	max_x_offset = 4
	max_height_offset = 5

/obj/item/plate_shard
	name = "ceramic shard"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "plate_shard1"
	base_icon_state = "plate_shard"
	force = 5
	throwforce = 5
	sharpness = SHARP_EDGED

/obj/item/plate_shard/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/caltrop, min_damage = force, probability = 4)
