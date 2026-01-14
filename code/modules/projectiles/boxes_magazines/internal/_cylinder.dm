/obj/item/ammo_box/magazine/internal/cylinder
	name = "revolver cylinder"
	ammo_type = /obj/item/ammo_casing/a357
	caliber = CALIBER_357
	max_ammo = 7

	load_sound = 'sound/weapons/gun/revolver/load_bullet.ogg'

/obj/item/ammo_box/magazine/internal/cylinder/get_round(keep = 0)
	rotate()

	var/b = stored_ammo[1]
	if(!keep)
		stored_ammo[1] = null

	return b

/obj/item/ammo_box/magazine/internal/cylinder/is_full(spent_is_empty = FALSE)
	if(spent_is_empty)
		return !get_empty_chamber_index(TRUE)

	return !(null in stored_ammo)

/obj/item/ammo_box/magazine/internal/cylinder/proc/rotate()
	var/b = stored_ammo[1]
	stored_ammo.Cut(1,2)
	stored_ammo.Insert(0, b)

/obj/item/ammo_box/magazine/internal/cylinder/proc/spin()
	for(var/i in 1 to rand(0, max_ammo*2))
		rotate()

/obj/item/ammo_box/magazine/internal/cylinder/ammo_list(drop_list = FALSE)
	var/list/L = list()
	for(var/i=1 to stored_ammo.len)
		var/obj/item/ammo_casing/bullet = stored_ammo[i]
		if(bullet)
			L.Add(bullet)
			if(drop_list)//We have to maintain the list size, to emulate a cylinder
				stored_ammo[i] = null
	return L

/obj/item/ammo_box/magazine/internal/cylinder/give_round(obj/item/ammo_casing/R, replace_spent = FALSE)
	if(!R || !(caliber ? (caliber == R.caliber) : (ammo_type == R.type)))
		return FALSE

	var/usable_index = get_empty_chamber_index(replace_spent)
	if(!usable_index)
		return FALSE

	var/obj/item/ammo_casing/bullet = stored_ammo[usable_index]
	stored_ammo[usable_index] = R
	R.forceMove(src)

	if(bullet)
		bullet?.forceMove(drop_location())
	return TRUE

/// Returns an index of an empty chamber. Spent casings are counted if include_spent is true.
/obj/item/ammo_box/magazine/internal/cylinder/proc/get_empty_chamber_index(include_spent = FALSE)
	for(var/i in 1 to length(stored_ammo))
		var/obj/item/ammo_casing/bullet = stored_ammo[i]
		if(!bullet)
			return i

		if(include_spent && !bullet.loaded_projectile)
			return i

/obj/item/ammo_box/magazine/internal/cylinder/top_off(load_type, starting=FALSE)
	if(starting) // nulls don't exist when we're starting off
		return ..()

	if(!load_type)
		load_type = ammo_type

	for(var/i in 1 to max_ammo)
		if(!give_round(new load_type(src)))
			break
	update_appearance()

/obj/item/ammo_box/magazine/internal/cylinder/load_from_ammo_box(obj/item/ammo_box/other_box, mob/user, silent = FALSE, replace_spent = FALSE)
	if((locate(/obj/item/ammo_casing) in stored_ammo)) // Has any casings, use the slow manual feeding.
		return ..()

	var/used_load_delay = load_delay
	if(istype(user, /mob/living))
		var/mob/living/living_user = user
		// Double at 3, half at 18.
		used_load_delay *= living_user.stats.get_skill_as_scalar(/datum/rpg_skill/fine_motor, 2, inverse = TRUE)

	if(!do_after(user, src, used_load_delay, DO_IGNORE_USER_LOC_CHANGE|DO_PUBLIC, interaction_key = "load_round", display = other_box))
		return FALSE

	if((locate(/obj/item/ammo_casing) in stored_ammo)) // Rerun the above check, just in case.
		return ..()

	var/obj/item/ammo_casing/to_feed
	var/num_loaded = 0
	while((to_feed = locate(/obj/item/ammo_casing,  other_box.stored_ammo)) && (null in stored_ammo))
		if(!give_round(to_feed))
			break

		other_box.stored_ammo -= to_feed
		num_loaded++

	after_load_round(other_box, user, silent)
	return num_loaded
