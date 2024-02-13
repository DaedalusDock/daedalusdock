/datum/forensics
	/// The object we belong to
	var/atom/parent
	/// A k:v list of fingerprint : amount
	var/list/fingerprints
	/// A k:v list of dna : blood_type
	var/list/blood_DNA
	/// A k:v list of fibers : amount
	var/list/fibers

	/// A k:v list of ckey : thing. For admins.
	var/list/admin_log

/datum/forensics/New(parent)
	src.parent = parent

/datum/forensics/proc/add_blood_DNA(list/dna) //list(dna_enzymes = type)
	if(!length(dna))
		return

	LAZYINITLIST(blood_DNA)
	for(var/dna_hash in dna)
		blood_DNA[dna_hash] = dna[dna_hash]

	check_blood()
	return TRUE

/// Adds the fingerprint of M to our fingerprint list
/datum/forensics/proc/add_fingerprint(mob/living/M, ignoregloves = FALSE)
	if(!isliving(M))
		if(!iscameramob(M))
			return
		if(isaicamera(M))
			var/mob/camera/ai_eye/ai_camera = M
			if(!ai_camera.ai)
				return
			M = ai_camera.ai

	log_touch(M)

	if(!ishuman(M))
		return

	var/mob/living/carbon/human/H = M
	add_fibers(H)
	var/obj/item/gloves = H.gloves

	if(gloves) //Check if the gloves (if any) hide fingerprints
		if(!(gloves.body_parts_covered & HANDS) || HAS_TRAIT(gloves, TRAIT_FINGERPRINT_PASSTHROUGH) || HAS_TRAIT(H, TRAIT_FINGERPRINT_PASSTHROUGH))
			ignoregloves = TRUE

		if(!ignoregloves)
			H.gloves.add_fingerprint(H, TRUE) //ignoregloves = 1 to avoid infinite loop.
			return

	LAZYINITLIST(fingerprints)
	var/full_print = md5(H.dna.unique_identity)
	fingerprints[full_print]++
	return TRUE

/// Adds the fibers of M to our fiber list.
/datum/forensics/proc/add_fibers(mob/living/carbon/human/M)
	LAZYINITLIST(fibers)

	var/fibertext
	var/item_multiplier = isitem(src)? 1.2 : 1

	if(M.wear_suit)
		fibertext = M.wear_suit.get_fibers()
		if(fibertext && prob(10*item_multiplier))
			fibers[fibertext]++
			. = TRUE

		if(!(M.wear_suit.body_parts_covered & CHEST) && M.w_uniform)
			fibertext = M.w_uniform.get_fibers()
			if(fibertext && prob(12*item_multiplier)) //Wearing a suit means less of the uniform exposed.
				fibers[fibertext]++
				. = TRUE

		if(!(M.wear_suit.body_parts_covered & HANDS) && M.gloves)
			fibertext = M.gloves.get_fibers()
			if(fibertext && prob(20*item_multiplier))
				fibers[fibertext]++
				. = TRUE

	else if(M.w_uniform)
		fibertext = M.w_uniform.get_fibers()
		if(fibertext && prob(15*item_multiplier))
			fibers[fibertext]++
			. = TRUE

		if(!(M.w_uniform.body_parts_covered & HANDS) && M.gloves)
			fibertext = M.gloves.get_fibers()
			if(fibertext && prob(20*item_multiplier))
				fibers[fibertext]++
				. = TRUE

	else if(M.gloves)
		fibertext = M.gloves.get_fibers()
		if(fibertext && prob(20*item_multiplier))
			fibers[fiber_text]++
			. = TRUE

	return .

/// For admins. Logs when mobs players with this thing.
/datum/forensics/proc/log_touch(mob/M)
	if(!isliving(M))
		if(!iscameramob(M))
			return
		if(isaicamera(M))
			var/mob/camera/ai_eye/ai_camera = M
			if(!ai_camera.ai)
				return
			M = ai_camera.ai

	if(!M.key)
		return

	var/hasgloves = ""
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.gloves)
			hasgloves = "(gloves)"

	var/current_time = time_stamp()

	if(!LAZYACCESS(admin_log, M.ckey))
		LAZYSET(admin_log, M.ckey, "First: \[[current_time]\] \"[M.real_name]\"[hasgloves]. Ckey: [M.ckey]")
	else
		var/laststamppos = findtext(LAZYACCESS(admin_log, M.ckey), "\nLast: ")
		if(laststamppos)
			LAZYSET(admin_log, M.key, copytext(admin_log[M.ckey], 1, laststamppos))
		admin_log[M.key] += "\nLast: \[[current_time]\] \"[M.real_name]\"[hasgloves]. Ckey: [M.ckey]" //made sure to be existing by if(!LAZYACCESS);else

	parent.fingerprintslast = M.ckey
	return TRUE

/// Add a list of fingerprints
/datum/forensics/proc/add_fingerprint_list(list/_fingerprints)
	if(!length(_fingerprints))
		return

	LAZYINITLIST(fingerprints)
	for(var/print in _fingerprints) //We use an associative list, make sure we don't just merge a non-associative list into ours.
		fingerprints[print] += _fingerprints[print]
	return TRUE

/// Adds a list of fibers.
/datum/forensics/proc/add_fiber_list(list/_fibertext) //list(text)
	if(!length(_fibertext))
		return

	LAZYINITLIST(fibers)

	for(var/fiber in _fibertext) //We use an associative list, make sure we don't just merge a non-associative list into ours.
		fibers[fiber] += _fibertext[fiber]
	return TRUE

/// see [datum/forensics/proc/log_touch]
/datum/forensics/proc/log_touch_list(list/_hiddenprints)
	if(!length(_hiddenprints))
		return

	LAZYINITLIST(admin_log)
	for(var/i in _hiddenprints) //We use an associative list, make sure we don't just merge a non-associative list into ours.
		admin_log[i] = _hiddenprints[i]
	return TRUE

/// Adds blood to our parent object if we have any
/datum/forensics/proc/check_blood()
	if(!isitem(parent))
		return
	if(!length(blood_DNA))
		return

	parent.AddElement(/datum/element/decal/blood)

/// Called by [atom/proc/wash].
/datum/forensics/proc/wash(clean_types)
	if(clean_types & CLEAN_TYPE_FINGERPRINTS)
		wipe_fingerprints()
		. ||= TRUE

	if(clean_types & CLEAN_TYPE_BLOOD)
		wipe_blood_DNA()
		. ||= TRUE

	if(clean_types & CLEAN_TYPE_FIBERS)
		wipe_fibers()
		. ||= TRUE

/// Clear fingerprints list.
/datum/forensics/proc/wipe_fingerprints()
	LAZYNULL(fingerprints)
	return TRUE

/// Clear blood dna list.
/datum/forensics/proc/wipe_blood_DNA()
	LAZYNULL(blood_DNA)
	return TRUE

/// Clear fibers list.
/datum/forensics/proc/wipe_fibers()
	LAZYNULL(fibers)
	return TRUE

/// Delete all non-admin evidence
/datum/forensics/proc/remove_evidence()
	wipe_fingerprints()
	wipe_blood_DNA()
	wipe_fibers()
