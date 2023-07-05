
/mob/living/carbon/human/canBeHandcuffed()
	if(num_hands < 2)
		return FALSE
	return TRUE


//gets assignment from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_assignment(if_no_id = "No id", if_no_job = "No job", hand_first = TRUE)
	var/obj/item/card/id/id = get_idcard(hand_first)
	if(id)
		. = id.assignment
	else
		var/obj/item/modular_computer/pda = wear_id
		if(istype(pda))
			. = pda.saved_job
		else
			return if_no_id
	if(!.)
		return if_no_job

//gets name from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_authentification_name(if_no_id = "Unknown")
	var/obj/item/card/id/id = get_idcard(FALSE)
	if(id)
		return id.registered_name
	var/obj/item/modular_computer/pda = wear_id
	if(istype(pda))
		return pda.saved_identification
	return if_no_id

//repurposed proc. Now it combines get_id_name() and get_face_name() to determine a mob's name variable. Made into a separate proc as it'll be useful elsewhere
/mob/living/carbon/human/get_visible_name()
	var/face_name = get_face_name("")
	var/id_name = get_id_name("")
	if(name_override)
		return name_override
	if(face_name)
		if(id_name && (id_name != face_name))
			return "[face_name] (as [id_name])"
		return face_name
	if(id_name)
		return id_name
	return "Unknown"

//Returns "Unknown" if facially disfigured and real_name if not. Useful for setting name when Fluacided or when updating a human's name variable
/mob/living/carbon/human/proc/get_face_name(if_no_face="Unknown")
	if( wear_mask && (wear_mask.flags_inv&HIDEFACE) ) //Wearing a mask which hides our face, use id-name if possible
		return if_no_face
	if( head && (head.flags_inv&HIDEFACE) )
		return if_no_face //Likewise for hats
	var/obj/item/bodypart/O = get_bodypart(BODY_ZONE_HEAD)
	if( !O || (HAS_TRAIT(src, TRAIT_DISFIGURED)) || (O.brutestate+O.burnstate)>2 || cloneloss>50 || !real_name || HAS_TRAIT(src, TRAIT_INVISIBLE_MAN)) //disfigured. use id-name if possible
		return if_no_face
	return real_name

//gets name from ID or PDA itself, ID inside PDA doesn't matter
//Useful when player is being seen by other mobs
/mob/living/carbon/human/proc/get_id_name(if_no_id = "Unknown")
	var/obj/item/storage/wallet/wallet = wear_id
	var/obj/item/modular_computer/tablet/pda/pda = wear_id
	var/obj/item/card/id/id = wear_id
	if(istype(wallet))
		id = wallet.front_id
	if(istype(id))
		. = id.registered_name
	else if(istype(pda))
		var/obj/item/computer_hardware/card_slot/card_slot = pda.all_components[MC_CARD]
		if(card_slot?.stored_card)
			. = card_slot.stored_card.registered_name
	if(!.)
		. = if_no_id //to prevent null-names making the mob unclickable
	return

/mob/living/carbon/human/get_idcard(hand_first = TRUE)
	. = ..()
	if(. && hand_first)
		return
	//Check inventory slots
	return (wear_id?.GetID() || belt?.GetID())

/mob/living/carbon/human/reagent_check(datum/reagent/R, delta_time, times_fired)
	return dna.species.handle_chemicals(R, src, delta_time, times_fired)
	// if it returns 0, it will run the usual on_mob_life for that reagent. otherwise, it will stop after running handle_chemicals for the species.


/mob/living/carbon/human/can_track(mob/living/user)
	if(istype(head, /obj/item/clothing/head))
		var/obj/item/clothing/head/hat = head
		if(hat.blockTracking)
			return 0

	return ..()

/mob/living/carbon/human/can_use_guns(obj/item/G)
	. = ..()
	if(G.trigger_guard == TRIGGER_GUARD_NORMAL)
		if(check_chunky_fingers())
			balloon_alert(src, "fingers are too big!")
			return FALSE
	if(HAS_TRAIT(src, TRAIT_NOGUNS))
		to_chat(src, span_warning("You can't bring yourself to use a ranged weapon!"))
		return FALSE

/mob/living/carbon/human/proc/check_chunky_fingers()
	if(HAS_TRAIT_NOT_FROM(src, TRAIT_CHUNKYFINGERS, RIGHT_ARM_TRAIT) && HAS_TRAIT_NOT_FROM(src, TRAIT_CHUNKYFINGERS, LEFT_ARM_TRAIT))
		return TRUE
	return (active_hand_index % 2) ? HAS_TRAIT_FROM(src, TRAIT_CHUNKYFINGERS, LEFT_ARM_TRAIT) : HAS_TRAIT_FROM(src, TRAIT_CHUNKYFINGERS, RIGHT_ARM_TRAIT)

/mob/living/carbon/human/get_policy_keywords()
	. = ..()
	. += "[dna.species.type]"

///Returns death message for mob examine text
/mob/living/carbon/human/proc/generate_death_examine_text()
	var/mob/dead/observer/ghost = get_ghost(TRUE, TRUE)
	var/t_He = p_they(TRUE)
	var/t_his = p_their()
	var/t_is = p_are()
	//This checks to see if the body is revivable
	if(key || !getorgan(/obj/item/organ/brain) || ghost?.can_reenter_corpse)
		return span_deadsay("[t_He] [t_is] limp and unresponsive; there are no signs of life...")
	else
		return span_deadsay("[t_He] [t_is] limp and unresponsive; there are no signs of life and [t_his] soul has departed...")

///copies over clothing preferences like underwear to another human
/mob/living/carbon/human/proc/copy_clothing_prefs(mob/living/carbon/human/destination)
	destination.underwear = underwear
	destination.underwear_color = underwear_color
	destination.undershirt = undershirt
	destination.socks = socks
	destination.jumpsuit_style = jumpsuit_style


/// Fully randomizes everything according to the given flags.
/mob/living/carbon/human/proc/randomize_human_appearance(flags = ALL)
	var/datum/preferences/preferences = new

	for (var/datum/preference/preference as anything in get_preferences_in_priority_order())
		if(istype(preference, /datum/preference/name/real_name) && !(flags & RANDOMIZE_NAME))
			continue
		if(istype(preference, /datum/preference/choiced/species) && !(flags & RANDOMIZE_SPECIES))
			continue

		if (preference.is_randomizable())
			preference.apply_to_human(src, preference.create_random_value(preferences))

/mob/living/carbon/human/can_smell(intensity)
	var/turf/T = get_turf(src)
	if(!T)
		return FALSE
	if(stat != CONSCIOUS || failed_last_breath || wear_mask || (head && (head?.permeability_coefficient < 1)) || !T.unsafe_return_air()?.total_moles)
		return FALSE

	if(!(intensity > last_smell_intensity) && !COOLDOWN_FINISHED(src, smell_time))
		return FALSE

	return TRUE


