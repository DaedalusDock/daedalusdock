//Boxes of ammo
/obj/item/ammo_box
	name = "ammo box (null_reference_exception)"
	desc = "A box of ammo."
	icon = 'icons/obj/guns/ammo.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	inhand_icon_state = "syringe_kit"
	worn_icon_state = "ammobox"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	custom_materials = list(/datum/material/iron = 30000)
	throwforce = 2
	w_class = WEIGHT_CLASS_TINY
	throw_range = 7
	override_notes = TRUE

	///String, used for checking if ammo of different types but still fits can fit inside it; generally used for magazines
	var/caliber

	///list containing the actual ammo within the magazine
	var/list/stored_ammo = list()
	///type that the magazine will be searching for, rejects if not a subtype of
	var/ammo_type = /obj/item/ammo_casing
	///maximum amount of ammo in the magazine
	var/max_ammo = 7

	///Controls how sprites are updated for the ammo box; see defines in combat.dm: AMMO_BOX_ONE_SPRITE; AMMO_BOX_PER_BULLET; AMMO_BOX_FULL_EMPTY
	var/multiple_sprites = AMMO_BOX_ONE_SPRITE
	///For sprite updating, do we use initial(icon_state) or base_icon_state?
	var/multiple_sprite_use_base = FALSE

	///Delay for loading bullets in.
	var/load_delay = 0.5 SECONDS
	///Whether the magazine should start with nothing in it
	var/start_empty = FALSE

	///cost of all the bullets in the magazine/box
	var/list/bullet_cost
	///cost of the materials in the magazine/box itself
	var/list/base_cost

/obj/item/ammo_box/Initialize(mapload)
	. = ..()
	if(!bullet_cost)
		base_cost = SSmaterials.FindOrCreateMaterialCombo(custom_materials, 0.1)
		bullet_cost = SSmaterials.FindOrCreateMaterialCombo(custom_materials, 0.9 / max_ammo)

	if(!start_empty)
		top_off(starting=TRUE)

/**
 * top_off is used to refill the magazine to max, in case you want to increase the size of a magazine with VV then refill it at once
 *
 * Arguments:
 * * load_type - if you want to specify a specific ammo casing type to load, enter the path here, otherwise it'll use the basic [/obj/item/ammo_box/var/ammo_type]. Must be a compatible round
 * * starting - Relevant for revolver cylinders, if FALSE then we mind the nulls that represent the empty cylinders (since those nulls don't exist yet if we haven't initialized when this is TRUE)
 */
/obj/item/ammo_box/proc/top_off(load_type, starting=FALSE)
	if(!load_type) //this check comes first so not defining an argument means we just go with default ammo
		load_type = ammo_type

	var/obj/item/ammo_casing/round_check = load_type
	if(!starting && !(caliber ? (caliber == initial(round_check.caliber)) : (ammo_type == load_type)))
		stack_trace("Tried loading unsupported ammocasing type [load_type] into ammo box [type].")
		return

	for(var/i in max(1, stored_ammo.len + 1) to max_ammo)
		stored_ammo += new round_check(src)
	update_ammo_count()

///gets a round from the magazine, if keep is TRUE the round will stay in the gun
/obj/item/ammo_box/proc/get_round(keep = FALSE)
	if (!stored_ammo.len)
		return null
	else
		var/b = stored_ammo[stored_ammo.len]
		stored_ammo -= b
		if (keep)
			stored_ammo.Insert(1,b)
		return b

///puts a round into the magazine
/obj/item/ammo_box/proc/give_round(obj/item/ammo_casing/R, replace_spent = 0)
	// Boxes don't have a caliber type, magazines do. Not sure if it's intended or not, but if we fail to find a caliber, then we fall back to ammo_type.
	if(!R || !(caliber ? (caliber == R.caliber) : (ammo_type == R.type)))
		return FALSE

	if (stored_ammo.len < max_ammo)
		stored_ammo += R
		R.forceMove(src)
		return TRUE

	//for accessibles magazines (e.g internal ones) when full, start replacing spent ammo
	else if(replace_spent)
		for(var/obj/item/ammo_casing/AC in stored_ammo)
			if(!AC.loaded_projectile)//found a spent ammo
				stored_ammo -= AC
				AC.forceMove(get_turf(src.loc))

				stored_ammo += R
				R.forceMove(src)
				return TRUE
	return FALSE

///Whether or not the box can be loaded, used in overrides
/obj/item/ammo_box/proc/can_load(mob/user)
	return TRUE

/obj/item/ammo_box/attackby(obj/item/A, mob/user, params)
	return attempt_load_round(A, user)

/obj/item/ammo_box/attack_self(mob/user)
	var/obj/item/ammo_casing/A = get_round()
	if(!A)
		return

	A.forceMove(drop_location())
	if(!user.is_holding(src) || !user.put_in_hands(A)) //incase they're using TK
		A.bounce_away(FALSE, NONE)
	playsound(src, 'sound/weapons/gun/general/mag_bullet_insert.ogg', 60, TRUE)
	to_chat(user, span_notice("You remove a round from [src]!"))
	update_ammo_count()

/// Attempts to load a given item into this ammo box
/obj/item/ammo_box/proc/attempt_load_round(obj/item/I, mob/user, silent = FALSE, replace_spent = FALSE)
	var/num_loaded = 0
	if(!can_load(user))
		return FALSE

	if(istype(I, /obj/item/ammo_box))
		var/obj/item/ammo_box/AM = I
		for(var/obj/item/ammo_casing/AC in AM.stored_ammo)
			if(user && load_delay && !do_after(user, src, load_delay, DO_IGNORE_USER_LOC_CHANGE, FALSE, interaction_key = "load_round"))
				break

			var/did_load = give_round(AC, replace_spent)
			if(!did_load)
				break

			AM.stored_ammo -= AC
			num_loaded++
			if(!silent)
				user?.visible_message(
					span_notice("[user] loads a round into [src]."),
					vision_distance = COMBAT_MESSAGE_RANGE,
				)
				playsound(src, 'sound/weapons/gun/general/mag_bullet_insert.ogg', 60, TRUE)
			update_ammo_count()
			AM.update_ammo_count()

	if(isammocasing(I))
		var/obj/item/ammo_casing/AC = I
		if(give_round(AC, replace_spent))
			user.transferItemToLoc(AC, src, TRUE)
			num_loaded++
			if(!silent)
				playsound(src, 'sound/weapons/gun/general/mag_bullet_insert.ogg', 60, TRUE)
			update_ammo_count()

	return num_loaded

/// Updates the materials and appearance of this ammo box
/obj/item/ammo_box/proc/update_ammo_count()
	update_custom_materials()
	update_appearance()

/obj/item/ammo_box/examine(mob/user)
	. = ..()
	. += span_notice(get_ammo_desc())

/obj/item/ammo_box/update_icon_state()
	var/shells_left = LAZYLEN(stored_ammo)
	switch(multiple_sprites)
		if(AMMO_BOX_PER_BULLET)
			icon_state = "[multiple_sprite_use_base ? base_icon_state : initial(icon_state)]-[shells_left]"
		if(AMMO_BOX_FULL_EMPTY)
			icon_state = "[multiple_sprite_use_base ? base_icon_state : initial(icon_state)]-[shells_left ? "[max_ammo]" : "0"]"
	return ..()

/// Updates the amount of material in this ammo box according to how many bullets are left in it.
/obj/item/ammo_box/proc/update_custom_materials()
	var/temp_materials = custom_materials.Copy()
	for(var/material in bullet_cost)
		temp_materials[material] = (bullet_cost[material] * stored_ammo.len) + base_cost[material]
	set_custom_materials(temp_materials)

/// Returns a string that describes the amount of ammo in the magazine.
/obj/item/ammo_box/proc/get_ammo_desc(exact)
	if(exact)
		return "There are [ammo_count(TRUE)] rounds in [src]."

	var/ammo_count = ammo_count(TRUE)
	if(ammo_count == 1)
		return "There is one round left."

	var/ammo_percent = ceil(((ammo_count / max_ammo) * 100))

	switch(ammo_percent)
		if(0)
			return "It is empty."
		if(1 to 20)
			return "It rattles when you shake it."
		if(21 to 40)
			return "It is running low on rounds."
		if(41 to 69)
			return "It is about half full."
		if(70 to 99)
			return "It is mostly full."
		if(100)
			return "It is fully loaded."

///Count of number of bullets in the magazine
/obj/item/ammo_box/proc/ammo_count(countempties = TRUE)
	var/boolets = 0
	for(var/obj/item/ammo_casing/bullet in stored_ammo)
		if(bullet && (bullet.loaded_projectile || countempties))
			boolets++
	return boolets

///list of every bullet in the magazine
/obj/item/ammo_box/magazine/proc/ammo_list(drop_list = FALSE)
	var/list/L = stored_ammo.Copy()
	if(drop_list)
		stored_ammo.Cut()
	return L

///drops the entire contents of the magazine on the floor
/obj/item/ammo_box/magazine/proc/empty_magazine()
	var/turf_mag = get_turf(src)
	for(var/obj/item/ammo in stored_ammo)
		ammo.forceMove(turf_mag)
		stored_ammo -= ammo

/obj/item/ammo_box/magazine/handle_atom_del(atom/A)
	stored_ammo -= A
	update_ammo_count()
