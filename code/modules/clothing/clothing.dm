#define MOTH_EATING_CLOTHING_DAMAGE 15

/obj/item/clothing
	name = "clothing"
	resistance_flags = FLAMMABLE
	max_integrity = 200
	integrity_failure = 0.4

	stamina_damage = 0
	stamina_cost = 0
	stamina_critical_chance = 0

	/// An alternative name to be used for fibers, forensics stuffs
	var/fiber_name = ""
	var/damaged_clothes = CLOTHING_PRISTINE //similar to machine's BROKEN stat and structure's broken var

	///What level of bright light protection item has.
	var/flash_protect = FLASH_PROTECTION_NONE
	var/tint = 0 //Sets the item's level of visual impairment tint, normally set to the same as flash_protect
	var/up = 0 //but separated to allow items to protect but not impair vision, like space helmets
	var/visor_flags = 0 //flags that are added/removed when an item is adjusted up/down
	var/visor_flags_inv = 0 //same as visor_flags, but for flags_inv
	var/visor_flags_cover = 0 //same as above, but for flags_cover
//what to toggle when toggled with weldingvisortoggle()
	var/visor_vars_to_toggle = VISOR_FLASHPROTECT | VISOR_TINT | VISOR_VISIONFLAGS | VISOR_DARKNESSVIEW | VISOR_INVISVIEW
	lefthand_file = 'icons/mob/inhands/clothing_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing_righthand.dmi'
	var/alt_desc = null
	var/toggle_message = null
	var/alt_toggle_message = null
	var/toggle_cooldown = null
	var/cooldown = 0

	/// Flags for clothing
	var/clothing_flags = NONE

	var/can_be_bloody = TRUE

	/// What items can be consumed to repair this clothing (must by an /obj/item/stack)
	var/repairable_by = /obj/item/stack/sheet/cloth

	//Var modification - PLEASE be careful with this I know who you are and where you live
	var/list/user_vars_to_edit //VARNAME = VARVALUE eg: "name" = "butts"
	var/list/user_vars_remembered //Auto built by the above + dropped() + equipped()

	/// Trait modification, lazylist of traits to add/take away, on equipment/drop in the correct slot
	var/list/clothing_traits

	// Fallback clothing system
	/// Needs to follow this syntax: either a `list()` with the x and y coordinates of the pixel you want to get the colour from, or a hexcolour. Colour one replaces red, two replaces blue, and three replaces green in the icon state.
	var/list/fallback_colors[3]
	/// Needs to be a RGB-greyscale format icon state in all species' fallback icon files.
	var/fallback_icon_state

	var/pocket_storage_component_path

	/// How much clothing damage has been dealt to each of the limbs of the clothing, assuming it covers more than one limb
	var/list/damage_by_parts
	/// How much integrity is in a specific limb before that limb is disabled (for use in [/obj/item/clothing/proc/take_damage_zone], and only if we cover multiple zones.) Set to 0 to disable shredding.
	var/limb_integrity = 0
	/// How many zones (body parts, not precise) we have disabled so far, for naming purposes
	var/zones_disabled

	/// A lazily initiated "food" version of the clothing for moths
	var/obj/item/food/clothing/moth_snack

/obj/item/clothing/Initialize(mapload)
	if(clothing_flags & VOICEBOX_TOGGLABLE)
		actions_types += /datum/action/item_action/toggle_voice_box
	. = ..()
	AddElement(/datum/element/venue_price, FOOD_PRICE_CHEAP)
	if(ispath(pocket_storage_component_path))
		LoadComponent(pocket_storage_component_path)
	if(can_be_bloody && ((body_parts_covered & FEET) || (flags_inv & HIDESHOES)))
		LoadComponent(/datum/component/bloodysoles)
	if(!icon_state)
		item_flags |= ABSTRACT

//This code is cursed, moths are cursed, and someday I will destroy it. but today is not that day.
/obj/item/food/clothing
	name = "temporary moth clothing snack item"
	desc = "If you're reading this it means I messed up. This is related to moths eating clothes and I didn't know a better way to do it than making a new food object. <--- stinky idiot wrote this"
	bite_consumption = 1
	// sigh, ok, so it's not ACTUALLY infinite nutrition. this is so you can eat clothes more than...once.
	// bite_consumption limits how much you actually get, and the take_damage in after eat makes sure you can't abuse this.
	// ...maybe this was a mistake after all.
	food_reagents = list(/datum/reagent/consumable/nutriment = INFINITY)
	tastes = list("dust" = 1, "lint" = 1)
	foodtypes = CLOTH

	/// A weak reference to the clothing that created us
	var/datum/weakref/clothing

/obj/item/food/clothing/MakeEdible()
	AddComponent(/datum/component/edible,\
		initial_reagents = food_reagents,\
		food_flags = food_flags,\
		foodtypes = foodtypes,\
		volume = max_volume,\
		eat_time = eat_time,\
		tastes = tastes,\
		eatverbs = eatverbs,\
		bite_consumption = bite_consumption,\
		microwaved_type = microwaved_type,\
		junkiness = junkiness,\
		after_eat = CALLBACK(src, PROC_REF(after_eat)))

/obj/item/food/clothing/proc/after_eat(mob/eater)
	var/obj/item/clothing/resolved_clothing = clothing.resolve()
	if (resolved_clothing)
		resolved_clothing.take_damage(MOTH_EATING_CLOTHING_DAMAGE, sound_effect = FALSE, damage_flag = BOMB, armor_penetration = 100) //This leaves clothing shreds.
	else
		qdel(src)

/obj/item/clothing/attack(mob/living/M, mob/living/user, params)
	if(user.combat_mode || !ismoth(M))
		return ..()
	if(isnull(moth_snack))
		moth_snack = new
		moth_snack.name = name
		moth_snack.clothing = WEAKREF(src)
	moth_snack.attack(M, user, params)

/obj/item/clothing/attackby(obj/item/W, mob/user, params)
	if(!istype(W, repairable_by))
		return ..()

	switch(damaged_clothes)
		if(CLOTHING_PRISTINE)
			return..()
		if(CLOTHING_DAMAGED)
			var/obj/item/stack/cloth_repair = W
			cloth_repair.use(1)
			repair(user, params)
			return TRUE
		if(CLOTHING_SHREDDED)
			var/obj/item/stack/cloth_repair = W
			if(cloth_repair.amount < 3)
				to_chat(user, span_warning("You require 3 [cloth_repair.name] to repair [src]."))
				return TRUE
			to_chat(user, span_notice("You begin fixing the damage to [src] with [cloth_repair]..."))
			if(!do_after(user, src, 6 SECONDS) || !cloth_repair.use(3))
				return TRUE
			repair(user, params)
			return TRUE

	return ..()

/obj/item/clothing/get_mechanics_info()
	. = ..()
	var/pronoun = gender == PLURAL ? "They" : "It"
	var/pronoun_s = p_s()

	var/static/list/armor_to_descriptive_term = list(
		BLUNT = "blunt force",
		SLASH = "cutting",
		PUNCTURE = "puncturing",
		LASER = "lasers",
		ENERGY = "energy",
		BOMB = "explosions",
		BIO = "biohazards",
	)

	var/list/armor_info = list()
	for(var/armor_type in armor_to_descriptive_term)
		var/armor_value = returnArmor().getRating(armor_type)
		if(!armor_value)
			continue

		switch(armor_value)
			if(1 to 20)
				. += "[FOURSPACES]- [pronoun] barely protect[pronoun_s] against [armor_to_descriptive_term[armor_type]]."
			if(21 to 30)
				. += "[FOURSPACES]- [pronoun] provide[pronoun_s] a very small defense against [armor_to_descriptive_term[armor_type]]."
			if(31 to 40)
				. += "[FOURSPACES]- [pronoun] offers a small amount of protection against [armor_to_descriptive_term[armor_type]]."
			if(41 to 50)
				. += "[FOURSPACES]- [pronoun] offers a moderate defense against [armor_to_descriptive_term[armor_type]]."
			if(51 to 60)
				. += "[FOURSPACES]- [pronoun] provide[pronoun_s] a strong defense against [armor_to_descriptive_term[armor_type]]."
			if(61 to 70)
				. += "[FOURSPACES]- [pronoun] is very strong against [armor_to_descriptive_term[armor_type]]."
			if(71 to 80)
				. += "[FOURSPACES]- [gender == PLURAL ? "These provide" : "It provides"] a very robust defense against [armor_to_descriptive_term[armor_type]]."
			if(81 to 100)
				. += "[FOURSPACES]- Wearing [gender == PLURAL ? "these" : "it"] would make you nigh-invulerable against [armor_to_descriptive_term[armor_type]]."

	if(length(armor_info))
		(.):Insert(1, "Armor Information")
		(.):Insert(2, jointext(armor_info, ""))

	if(!isnull(min_cold_protection_temperature) && min_cold_protection_temperature >= SPACE_SUIT_MIN_TEMP_PROTECT)
		. += "- [pronoun] provide[pronoun_s] very good protection against very cold temperatures."

	switch (max_heat_protection_temperature)
		if (400 to 1000)
			. += "- [pronoun] offer[pronoun_s] the wearer limited protection from fire."
		if (1001 to 1600)
			. += "- [pronoun] offer[pronoun_s] the wearer some protection from fire."
		if (1601 to 35000)
			. += "- [pronoun] offer[pronoun_s] the wearer robust protection from fire."

/// Set the clothing's integrity back to 100%, remove all damage to bodyparts, and generally fix it up
/obj/item/clothing/proc/repair(mob/user, params)
	update_clothes_damaged_state(CLOTHING_PRISTINE)
	atom_integrity = max_integrity
	name = initial(name) // remove "tattered" or "shredded" if there's a prefix
	body_parts_covered = initial(body_parts_covered)
	slot_flags = initial(slot_flags)
	damage_by_parts = null
	if(user)
		UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
		to_chat(user, span_notice("You fix the damage on [src]."))
	update_appearance()

/**
 * take_damage_zone() is used for dealing damage to specific bodyparts on a worn piece of clothing, meant to be called from [/obj/item/bodypart/proc/check_woundings_mods]
 *
 * This proc only matters when a bodypart that this clothing is covering is harmed by a direct attack (being on fire or in space need not apply), and only if this clothing covers
 * more than one bodypart to begin with. No point in tracking damage by zone for a hat, and I'm not cruel enough to let you fully break them in a few shots.
 * Also if limb_integrity is 0, then this clothing doesn't have bodypart damage enabled so skip it.
 *
 * Arguments:
 * * def_zone: The bodypart zone in question
 * * damage_amount: Incoming damage
 * * damage_type: BRUTE or BURN
 * * armor_penetration: If the attack had armor_penetration
 */
/obj/item/clothing/proc/take_damage_zone(def_zone, damage_amount, damage_type, armor_penetration)
	if(!def_zone || !limb_integrity || (initial(body_parts_covered) in GLOB.bitflags)) // the second check sees if we only cover one bodypart anyway and don't need to bother with this
		return
	var/list/covered_limbs = cover_flags2body_zones(body_parts_covered) // what do we actually cover?
	if(!(def_zone in covered_limbs))
		return

	var/damage_dealt = take_damage(damage_amount * 0.1, damage_type, armor_penetration, FALSE) * 10 // only deal 10% of the damage to the general integrity damage, then multiply it by 10 so we know how much to deal to limb
	LAZYINITLIST(damage_by_parts)
	damage_by_parts[def_zone] += damage_dealt
	if(damage_by_parts[def_zone] > limb_integrity)
		disable_zone(def_zone, damage_type)

/**
 * disable_zone() is used to disable a given bodypart's protection on our clothing item, mainly from [/obj/item/clothing/proc/take_damage_zone]
 *
 * This proc disables all protection on the specified bodypart for this piece of clothing: it'll be as if it doesn't cover it at all anymore (because it won't!)
 * If every possible bodypart has been disabled on the clothing, we put it out of commission entirely and mark it as shredded, whereby it will have to be repaired in
 * order to equip it again. Also note we only consider it damaged if there's more than one bodypart disabled.
 *
 * Arguments:
 * * def_zone: The bodypart zone we're disabling
 * * damage_type: Only really relevant for the verb for describing the breaking, and maybe atom_destruction()
 */
/obj/item/clothing/proc/disable_zone(def_zone, damage_type)
	var/list/covered_limbs = cover_flags2body_zones(body_parts_covered)
	if(!(def_zone in covered_limbs))
		return

	var/zone_name = parse_zone(def_zone)
	var/break_verb = ((damage_type == BRUTE) ? "torn" : "burned")

	if(iscarbon(loc))
		var/mob/living/carbon/C = loc
		C.visible_message(span_danger("The [zone_name] on [C]'s [src.name] is [break_verb] away!"), span_userdanger("The [zone_name] on your [src.name] is [break_verb] away!"), vision_distance = COMBAT_MESSAGE_RANGE)
		RegisterSignal(C, COMSIG_MOVABLE_MOVED, PROC_REF(bristle), override = TRUE)

	zones_disabled++
	for(var/i in body_zone2cover_flags(def_zone))
		body_parts_covered &= ~i

	if(body_parts_covered == NONE) // if there are no more parts to break then the whole thing is kaput
		atom_destruction((damage_type == BRUTE ? BLUNT : LASER)) // melee/laser is good enough since this only procs from direct attacks anyway and not from fire/bombs
		return

	switch(zones_disabled)
		if(1)
			name = "damaged [initial(name)]"
		if(2)
			name = "mangy [initial(name)]"
		if(3 to INFINITY) // take better care of your shit, dude
			name = "tattered [initial(name)]"

	update_clothes_damaged_state(CLOTHING_DAMAGED)
	update_appearance()

/obj/item/clothing/Destroy()
	user_vars_remembered = null //Oh god somebody put REFERENCES in here? not to worry, we'll clean it up
	QDEL_NULL(moth_snack)
	return ..()

/obj/item/clothing/unequipped(mob/living/user)
	..()
	if(!istype(user))
		return

	UnregisterSignal(user, COMSIG_MOVABLE_MOVED)

	for(var/trait in clothing_traits)
		REMOVE_CLOTHING_TRAIT(user, trait)

	if(LAZYLEN(user_vars_remembered))
		for(var/variable in user_vars_remembered)
			if(variable in user.vars)
				if(user.vars[variable] == user_vars_to_edit[variable]) //Is it still what we set it to? (if not we best not change it)
					user.vars[variable] = user_vars_remembered[variable]
		user_vars_remembered = initial(user_vars_remembered) // Effectively this sets it to null.

/obj/item/clothing/equipped(mob/living/user, slot)
	. = ..()
	if (!istype(user))
		return
	if(slot_flags & slot) //Was equipped to a valid slot for this item?
		if(iscarbon(user) && LAZYLEN(zones_disabled))
			RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(bristle), override = TRUE)

		for(var/trait in clothing_traits)
			ADD_CLOTHING_TRAIT(user, trait)

		if (LAZYLEN(user_vars_to_edit))
			for(var/variable in user_vars_to_edit)
				if(variable in user.vars)
					LAZYSET(user_vars_remembered, variable, user.vars[variable])
					user.vv_edit_var(variable, user_vars_to_edit[variable])

/obj/item/clothing/examine(mob/user)
	. = ..()
	if(damaged_clothes == CLOTHING_SHREDDED)
		. += span_warning("<b>[p_theyre(TRUE)] completely shredded and require[p_s()] mending before [p_they()] can be worn again!</b>")
		return

	for(var/zone in damage_by_parts)
		var/pct_damage_part = damage_by_parts[zone] / limb_integrity * 100
		var/zone_name = parse_zone(zone)
		switch(pct_damage_part)
			if(100 to INFINITY)
				. += span_warning("<b>The [zone_name] is useless and requires mending!</b>")
			if(60 to 99)
				. += span_warning("The [zone_name] is heavily shredded!")
			if(30 to 59)
				. += span_danger("The [zone_name] is partially shredded.")

/**
 * Inserts a trait (or multiple traits) into the clothing traits list
 *
 * If worn, then we will also give the wearer the trait as if equipped
 *
 * This is so you can add clothing traits without worrying about needing to equip or unequip them to gain effects
 */
/obj/item/clothing/proc/attach_clothing_traits(trait_or_traits)
	if(!islist(trait_or_traits))
		trait_or_traits = list(trait_or_traits)

	LAZYOR(clothing_traits, trait_or_traits)
	var/mob/wearer = loc
	if(istype(wearer) && (wearer.get_slot_by_item(src) & slot_flags))
		for(var/new_trait in trait_or_traits)
			ADD_CLOTHING_TRAIT(wearer, new_trait)

/**
 * Removes a trait (or multiple traits) from the clothing traits list
 *
 * If worn, then we will also remove the trait from the wearer as if unequipped
 *
 * This is so you can add clothing traits without worrying about needing to equip or unequip them to gain effects
 */
/obj/item/clothing/proc/detach_clothing_traits(trait_or_traits)
	if(!islist(trait_or_traits))
		trait_or_traits = list(trait_or_traits)

	LAZYREMOVE(clothing_traits, trait_or_traits)
	var/mob/wearer = loc
	if(istype(wearer))
		for(var/new_trait in trait_or_traits)
			REMOVE_CLOTHING_TRAIT(wearer, new_trait)

/**
 * Rounds armor_value down to the nearest 10, divides it by 10 and then converts it to Roman numerals.
 *
 * Arguments:
 * * armor_value - Number we're converting
 */
/obj/item/clothing/proc/armor_to_protection_class(armor_value)
	if (armor_value < 0)
		. = "-"
	. += "\Roman[round(abs(armor_value), 10) / 10]"
	return .

/obj/item/clothing/atom_break(damage_flag)
	. = ..()
	update_clothes_damaged_state(CLOTHING_DAMAGED)

	if(isliving(loc)) //It's not important enough to warrant a message if it's not on someone
		var/mob/living/M = loc
		if(src in M.get_equipped_items(FALSE))
			to_chat(M, span_warning("Your [name] start[p_s()] to fall apart!"))
		else
			to_chat(M, span_warning("[src] start[p_s()] to fall apart!"))

//This mostly exists so subtypes can call appriopriate update icon calls on the wearer.
/obj/item/clothing/proc/update_clothes_damaged_state(damaged_state = CLOTHING_DAMAGED)
	damaged_clothes = damaged_state
	update_slot_icon()

/obj/item/clothing/update_overlays()
	. = ..()
	if(!damaged_clothes)
		return

	var/index = "[REF(icon)]-[icon_state]"
	var/static/list/damaged_clothes_icons = list()
	var/icon/damaged_clothes_icon = damaged_clothes_icons[index]
	if(!damaged_clothes_icon)
		damaged_clothes_icon = icon(icon, icon_state, , 1)
		damaged_clothes_icon.Blend("#fff", ICON_ADD) //fills the icon_state with white (except where it's transparent)
		damaged_clothes_icon.Blend(icon('icons/effects/item_damage.dmi', "itemdamaged"), ICON_MULTIPLY) //adds damage effect and the remaining white areas become transparant
		damaged_clothes_icon = fcopy_rsc(damaged_clothes_icon)
		damaged_clothes_icons[index] = damaged_clothes_icon
	. += damaged_clothes_icon

/*
SEE_SELF  // can see self, no matter what
SEE_MOBS  // can see all mobs, no matter what
SEE_OBJS  // can see all objs, no matter what
SEE_TURFS // can see all turfs (and areas), no matter what
SEE_PIXELS// if an object is located on an unlit area, but some of its pixels are
		// in a lit area (via pixel_x,y or smooth movement), can see those pixels
BLIND     // can't see anything
*/

/proc/generate_female_clothing(index, t_color, icon, type)
	var/icon/female_clothing_icon = icon("icon"=icon, "icon_state"=t_color)
	var/female_icon_state = "female[type == FEMALE_UNIFORM_FULL ? "_full" : ((!type || type & FEMALE_UNIFORM_TOP_ONLY) ? "_top" : "")][type & FEMALE_UNIFORM_NO_BREASTS ? "_no_breasts" : ""]"
	var/icon/female_cropping_mask = icon("icon" = 'icons/mob/clothing/under/masking_helpers.dmi', "icon_state" = female_icon_state)
	female_clothing_icon.Blend(female_cropping_mask, ICON_MULTIPLY)
	female_clothing_icon = fcopy_rsc(female_clothing_icon)
	GLOB.female_clothing_icons[index] = female_clothing_icon

/**
 * Generates a 'fallback' sprite from `fallback_colors` and `fallback_icon_state`, then adds it to `GLOB.fallback_clothing_icons`.
 *
 * The fallback sprite is created by getting each colour specified in [fallback_colors],
 * then mapping each of them to the red, green, and blue sections of the sprite specified by [fallback_icon_state].
 *
 * Arguments:
 * * file2use - The normal `icon` for this item.
 * * state2use - The normal `icon_state` for this item.
 * * species_file - The [/datum/species/var/fallback_clothing_path] of the species trying to wear this item.
 * * list_key - The key that this icon will be saved under in the global list. (Either ["path/to/file.dmi-jumpsuit"], or ["#ffe14d-jumpsuit"] if GAGS is used)
 */
/obj/item/clothing/proc/generate_fallback_clothing(file2use, state2use, species_file, list_key)
	var/icon/human_clothing_icon = icon(file2use, state2use) // Default human 'worn' sprite for this item.

	if(greyscale_config_worn && greyscale_colors) // Get the coloured version if it's greyscale.
		human_clothing_icon = icon(SSgreyscale.GetColoredIconByType(greyscale_config_worn, greyscale_colors), state2use)

	if(!fallback_colors || !fallback_icon_state)
		GLOB.fallback_clothing_icons[species_file][list_key] = human_clothing_icon
		return // If no fallback data is set for this item, just use the human version.

	var/icon/final_icon = icon(species_file, fallback_icon_state) // RGB fallback sprite.

	var/list/final_list = list() // List of colours to map onto the RGB sprite.
	for(var/i in 1 to 3)
		if(length(fallback_colors) < i) // If less than 3 colours are specified, fill the remaining indices with black.
			final_list += "#000000"
			continue
		var/color = fallback_colors[i]
		if(islist(color)) // If `color` is a coordinates list, get the colour of the pixel at that location.
			final_list += human_clothing_icon.GetPixel(color[1], color[2]) || "#000000"
		else if(istext(color)) // Otherwise if it's a hex colour, use that instead.
			final_list += color

	final_icon.MapColors(final_list[1], final_list[2], final_list[3])
	final_icon = fcopy_rsc(final_icon)
	GLOB.fallback_clothing_icons[species_file][list_key] = final_icon


/obj/item/clothing/proc/weldingvisortoggle(mob/user) //proc to toggle welding visors on helmets, masks, goggles, etc.
	if(!can_use(user))
		return FALSE

	visor_toggling()

	to_chat(user, span_notice("You adjust \the [src] [up ? "up" : "down"]."))

	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.update_slots_for_item(src, force_obscurity_update = TRUE)
	update_action_buttons()
	return TRUE

/obj/item/clothing/proc/visor_toggling() //handles all the actual toggling of flags
	up = !up
	SEND_SIGNAL(src, COMSIG_CLOTHING_VISOR_TOGGLE, up)
	clothing_flags ^= visor_flags
	flags_inv ^= visor_flags_inv
	flags_cover ^= initial(flags_cover)
	icon_state = "[initial(icon_state)][up ? "up" : ""]"
	if(visor_vars_to_toggle & VISOR_FLASHPROTECT)
		flash_protect ^= initial(flash_protect)
	if(visor_vars_to_toggle & VISOR_TINT)
		tint ^= initial(tint)

	if(iscarbon(loc))
		var/mob/living/carbon/C = loc
		C.update_slots_for_item(src, force_obscurity_update = TRUE)

/obj/item/clothing/proc/can_use(mob/user)
	if(user && ismob(user))
		if(!user.incapacitated())
			return 1
	return 0

/obj/item/clothing/proc/_spawn_shreds()
	new /obj/effect/decal/cleanable/shreds(get_turf(src), name)

/obj/item/clothing/atom_destruction(damage_flag)
	if(damage_flag in list(ACID, FIRE))
		return ..()
	if(damage_flag == BOMB)
		//so the shred survives potential turf change from the explosion.
		addtimer(CALLBACK(src, PROC_REF(_spawn_shreds)), 1)
		deconstruct(FALSE)

	body_parts_covered = NONE
	slot_flags = NONE
	update_clothes_damaged_state(CLOTHING_SHREDDED)
	if(isliving(loc))
		var/mob/living/M = loc
		if(src in M.get_equipped_items(FALSE)) //make sure they were wearing it and not attacking the item in their hands
			M.visible_message(span_danger("[M]'s [src.name] fall[p_s()] off, [p_theyre()] completely shredded!"), span_warning("<b>Your [src.name] fall[p_s()] off, [p_theyre()] completely shredded!</b>"), vision_distance = COMBAT_MESSAGE_RANGE)
			M.dropItemToGround(src)
		else
			M.visible_message(span_danger("[src] fall[p_s()] apart, completely shredded!"), vision_distance = COMBAT_MESSAGE_RANGE)
	name = "shredded [initial(name)]" // change the name -after- the message, not before.
	update_appearance()
	SEND_SIGNAL(src, COMSIG_ATOM_DESTRUCTION, damage_flag)

/// If we're a clothing with at least 1 shredded/disabled zone, give the wearer a periodic heads up letting them know their clothes are damaged
/obj/item/clothing/proc/bristle(mob/living/L)
	SIGNAL_HANDLER

	if(!istype(L))
		return
	if(prob(0.2))
		to_chat(L, span_warning("The damaged threads on your [src.name] chafe!"))

#undef MOTH_EATING_CLOTHING_DAMAGE
