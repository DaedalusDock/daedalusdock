/atom/proc/return_fingerprints()
	RETURN_TYPE(/list)
	return forensics?.fingerprints

/atom/proc/return_touch_log()
	RETURN_TYPE(/list)
	return forensics?.admin_log

/atom/proc/return_blood_DNA()
	RETURN_TYPE(/list)
	return forensics?.blood_DNA

/atom/proc/blood_DNA_length()
	RETURN_TYPE(/list)
	return length(forensics?.blood_DNA)

/atom/proc/return_fibers()
	RETURN_TYPE(/list)
	return forensics?.fibers

/atom/proc/return_gunshot_residue()
	RETURN_TYPE(/list)
	return forensics?.gunshot_residue

/atom/proc/return_trace_DNA()
	RETURN_TYPE(/list)
	return forensics?.trace_DNA

/atom/proc/remove_evidence()
	RETURN_TYPE(/list)
	return forensics?.remove_evidence()

/// Adds the fingerprint of M to our fingerprint list. Ignoregloves will ignore any gloves they may be wearing.
/atom/proc/add_fingerprint(mob/M, ignoregloves = FALSE)
	if (QDELING(src))
		return

	if(isnull(forensics))
		create_forensics()

	forensics.add_fingerprint(M, ignoregloves)

/// Adds the fibers of M to our fiber list.
/atom/proc/add_fibers(mob/living/carbon/human/M)
	if(istype(M))
		if(M.gloves && istype(M.gloves, /obj/item/clothing))
			var/obj/item/clothing/gloves/G = M.gloves

			if(G.transfer_blood > 1 && add_blood_DNA(G.return_blood_DNA())) //bloodied gloves transfer blood to touched objects
				G.transfer_blood--

		else if(M.blood_in_hands > 1 && add_blood_DNA(M.return_blood_DNA()))
			M.blood_in_hands--

	if(isnull(forensics))
		create_forensics()
	forensics.add_fibers(M)

/// For admins. Logs when mobs players with this thing.
/atom/proc/log_touch(mob/M)
	if (QDELING(src))
		return

	if(isnull(forensics))
		create_forensics()

	forensics.log_touch(M)

/// Add a list of fingerprints
/atom/proc/add_fingerprint_list(list/fingerprints)
	if (QDELING(src))
		return

	if(isnull(forensics))
		create_forensics()

	forensics.add_fingerprint_list(fingerprints)

/// Add a list of fibers
/atom/proc/add_fiber_list(list/fibertext)
	if (QDELING(src))
		return

	if(isnull(forensics))
		create_forensics()
	forensics.add_fiber_list(fibertext)

/// Add a list of residues
/atom/proc/add_gunshot_residue(residue)
	if (QDELING(src))
		return

	if(isnull(forensics))
		create_forensics()
	forensics.add_gunshot_residue(residue)

/atom/proc/log_touch_list(list/hiddenprints)
	if (QDELING(src))
		return

	if(isnull(forensics))
		create_forensics()

	forensics.log_touch_list(hiddenprints)

/atom/proc/add_trace_DNA(list/dna)
	if (QDELING(src))
		return

	if(isnull(forensics))
		create_forensics()

	forensics.add_trace_DNA(dna)

/// Returns TRUE if new blood dna was added.
/atom/proc/add_blood_DNA(list/dna) //ASSOC LIST DNA = BLOODTYPE
	return FALSE

/obj/add_blood_DNA(list/dna)
	if(!length(dna))
		return

	if(isnull(forensics))
		create_forensics()

	return forensics.add_blood_DNA(dna)

/obj/item/clothing/gloves/add_blood_DNA(list/blood_dna, list/datum/pathogen/diseases)
	. = ..()
	transfer_blood = rand(2, 4)

/turf/add_blood_DNA(list/blood_dna, list/datum/pathogen/diseases)
	var/obj/effect/decal/cleanable/blood/splatter/B = locate() in src
	if(!B)
		B = new /obj/effect/decal/cleanable/blood/splatter(src, diseases)

	if(!QDELETED(B))
		return B.add_blood_DNA(blood_dna) //give blood info to the blood decal.

/mob/living/carbon/human/add_blood_DNA(list/blood_dna, list/datum/pathogen/diseases)
	return add_blood_DNA_to_items(blood_dna)

/// Adds blood DNA to certain slots the mob is wearing
/mob/living/carbon/human/proc/add_blood_DNA_to_items(
	list/blood_DNA_to_add,
	target_flags = ITEM_SLOT_ICLOTHING|ITEM_SLOT_OCLOTHING|ITEM_SLOT_GLOVES|ITEM_SLOT_HEAD|ITEM_SLOT_MASK,
)
	if(QDELING(src))
		return FALSE

	if(!length(blood_DNA_to_add))
		return FALSE

	// Don't messy up our jumpsuit if we're got a coat
	if((obscured_slots & HIDEJUMPSUIT) || ((target_flags & ITEM_SLOT_OCLOTHING) && (wear_suit?.body_parts_covered & CHEST)))
		target_flags &= ~ITEM_SLOT_ICLOTHING

	var/dirty_hands = !!(target_flags & (ITEM_SLOT_GLOVES|ITEM_SLOT_HANDS))
	var/dirty_feet = !!(target_flags & ITEM_SLOT_FEET)
	var/slots_to_bloody = target_flags & ~check_obscured_slots()
	var/list/all_worn = get_equipped_items()

	for(var/obj/item/thing as anything in all_worn)
		if(thing.slot_flags & slots_to_bloody)
			thing.add_blood_DNA(blood_DNA_to_add)

		if(thing.body_parts_covered & HANDS)
			dirty_hands = FALSE

		if(thing.body_parts_covered & FEET)
			dirty_feet = FALSE

	if(slots_to_bloody & ITEM_SLOT_HANDS)
		for(var/obj/item/thing in held_items)
			thing.add_blood_DNA(blood_DNA_to_add)

	if(dirty_hands || dirty_feet || !length(all_worn))
		if(isnull(forensics))
			create_forensics()
		forensics.add_blood_DNA(blood_DNA_to_add)

		if(dirty_hands)
			blood_in_hands = max(blood_in_hands, rand(2, 4))

	update_clothing(slots_to_bloody)
	return TRUE
/*
 * Transfer all forensic evidence from [src] to [transfer_to].
 */
/atom/proc/transfer_evidence_to(atom/transfer_to)
	transfer_fingerprints_to(transfer_to)
	transfer_fibers_to(transfer_to)
	transfer_gunshot_residue_to(transfer_to)
	transfer_to.add_blood_DNA(return_blood_DNA())
	transfer_to.add_trace_DNA(return_trace_DNA())

/*
 * Transfer all the fingerprints and hidden prints from [src] to [transfer_to].
 */
/atom/proc/transfer_fingerprints_to(atom/transfer_to)
	transfer_to.add_fingerprint_list(return_fingerprints())
	transfer_to.log_touch_list(return_touch_log())
	transfer_to.fingerprintslast = fingerprintslast

/*
 * Transfer all the fibers from [src] to [transfer_to].
 */
/atom/proc/transfer_fibers_to(atom/transfer_to)
	transfer_to.add_fiber_list(return_fibers())

/*
 * Transfer all the gunshot residue from [src] to [transfer_to].
 */
/atom/proc/transfer_gunshot_residue_to(atom/transfer_to)
	transfer_to.add_gunshot_residue(return_gunshot_residue())

/// On examine, players have a chance to find forensic evidence. This can only happen once per object.
/mob/living/carbon/human/proc/forensic_analysis_roll(atom/examined)
	if(!stats.cooldown_finished("examine_forensic_analysis"))
		return

	// Already gotten the good rng on this one
	if(stats.examined_object_weakrefs[WEAKREF(examined)])
		return

	if(examined.return_blood_DNA())
		return // This is kind of obvious

	var/list/fingerprints = examined.return_fingerprints()?.Copy()
	var/list/trace_dna = examined.return_trace_DNA()?.Copy()
	var/list/residue = examined.return_gunshot_residue()

	// Exclude our own prints
	if(length(fingerprints))
		var/obj/item/bodypart/arm/left_arm = get_bodypart(BODY_ZONE_L_ARM)
		var/obj/item/bodypart/arm/right_arm = get_bodypart(BODY_ZONE_R_ARM)

		if(left_arm)
			fingerprints -= get_fingerprints(TRUE, left_arm)
		if(right_arm)
			fingerprints -= get_fingerprints(TRUE, right_arm)

	// Exclude our DNA
	if(length(trace_dna))
		trace_dna -= get_trace_dna()

	// Do nothing if theres no evidence.
	if(!(length(fingerprints) || length(trace_dna) || length(residue)))
		return

	var/datum/roll_result/result = stat_roll(16, /datum/rpg_skill/forensics)

	switch(result.outcome)
		if(FAILURE, CRIT_FAILURE)
			stats.set_cooldown("examine_forensic_analysis", 15 SECONDS)
			return

	result.do_skill_sound(src)
	stats.examined_object_weakrefs[WEAKREF(examined)] = TRUE
	stats.set_cooldown("examine_forensic_analysis", 15 MINUTES)

	// Spawn 0 so this displays *after* the examine block.
	spawn(0)
		if(length(residue))
			to_chat(src, result.create_tooltip("A remnant of past events flashes into your mind, the booming crack of a firearm."))

		else if(length(fingerprints) || length(trace_dna))
			var/text = isitem(examined) ? "someone else has held this item in the past" : "someone else has been here before"
			to_chat(src, result.create_tooltip("Perhaps it is a stray particle of dust, or a smudge on the surface. Whatever it may be, you are certain [text]."))

