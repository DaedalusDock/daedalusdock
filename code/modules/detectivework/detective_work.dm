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
		var/old = 0
		if(M.gloves && istype(M.gloves, /obj/item/clothing))
			var/obj/item/clothing/gloves/G = M.gloves
			old = length(G.return_blood_DNA())

			if(G.transfer_blood > 1) //bloodied gloves transfer blood to touched objects
				if(add_blood_DNA(G.return_blood_DNA()) && length(G.return_blood_DNA()) > old) //only reduces the bloodiness of our gloves if the item wasn't already bloody
					G.transfer_blood--

		else if(M.blood_in_hands > 1)
			old = length(M.return_blood_DNA())
			if(add_blood_DNA(M.return_blood_DNA()) && length(M.return_blood_DNA()) > old)
				M.blood_in_hands--

	if(isnull(forensics))
		create_forensics()
	forensics.add_fibers(M)

/// For admins. Logs when mobs players with this thing.
/atom/proc/log_touch(mob/M)
	if(isnull(forensics))
		create_forensics()

	forensics.log_touch(M)

/// Add a list of fingerprints
/atom/proc/add_fingerprint_list(list/fingerprints)
	if(isnull(forensics))
		create_forensics()

	forensics.add_fingerprint_list(fingerprints)

/// Add a list of fibers
/atom/proc/add_fiber_list(list/fibertext)
	if(isnull(forensics))
		create_forensics()
	forensics.add_fiber_list(fibertext)

/// Add a list of residues
/atom/proc/add_gunshot_residue(residue)
	if(isnull(forensics))
		create_forensics()
	forensics.add_gunshot_residue(residue)

/atom/proc/log_touch_list(list/hiddenprints)
	if(isnull(forensics))
		create_forensics()

	forensics.log_touch_list(hiddenprints)

/atom/proc/add_trace_DNA(list/dna)
	if(isnull(forensics))
		create_forensics()

	forensics.add_trace_DNA(dna)

/atom/proc/add_blood_DNA(list/dna) //ASSOC LIST DNA = BLOODTYPE
	return FALSE

/obj/add_blood_DNA(list/dna)
	if(!length(dna))
		return

	if(isnull(forensics))
		create_forensics()

	forensics.add_blood_DNA(dna)
	return TRUE

/obj/item/clothing/gloves/add_blood_DNA(list/blood_dna, list/datum/disease/diseases)
	. = ..()
	transfer_blood = rand(2, 4)

/turf/add_blood_DNA(list/blood_dna, list/datum/disease/diseases)
	var/obj/effect/decal/cleanable/blood/splatter/B = locate() in src
	if(!B)
		B = new /obj/effect/decal/cleanable/blood/splatter(src, diseases)

	if(!QDELETED(B))
		B.add_blood_DNA(blood_dna) //give blood info to the blood decal.
		return TRUE //we bloodied the floor

/mob/living/carbon/human/add_blood_DNA(list/blood_dna, list/datum/disease/diseases)
	if(wear_suit)
		wear_suit.add_blood_DNA(blood_dna)
		update_worn_oversuit()

	else if(w_uniform)
		w_uniform.add_blood_DNA(blood_dna)
		update_worn_undersuit()

	if(gloves)
		var/obj/item/clothing/gloves/G = gloves
		G.add_blood_DNA(blood_dna)

	else if(length(blood_dna))
		if(isnull(forensics))
			create_forensics()
		forensics.add_blood_DNA(blood_dna)

	update_worn_gloves() //handles bloody hands overlays and updating
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
