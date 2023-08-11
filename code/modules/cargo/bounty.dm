/datum/bounty
	var/name
	var/description
	var/reward = 1000 // In credits.
	var/claimed = FALSE
	var/high_priority = FALSE

/datum/bounty/proc/can_claim()
	return !claimed

/// Called when the claim button is clicked. Override to provide fancy rewards.
/datum/bounty/proc/claim()
	if(can_claim())
		var/datum/bank_account/D = SSeconomy.station_master
		if(D)
			D.adjust_money(reward * SSeconomy.bounty_modifier)
		claimed = TRUE

/// If an item sent in the cargo shuttle can satisfy the bounty.
/datum/bounty/proc/applies_to(obj/O)
	return FALSE

/// Called when an object is shipped on the cargo shuttle.
/datum/bounty/proc/ship(obj/O)
	return

/** Returns a new bounty of random type, but does not add it to GLOB.bounties_list.
 *
 * *Guided determines what specific catagory of bounty should be chosen.
 */
/proc/random_bounty(guided = 0)
	var/bounty_num
	if(guided && (guided != CIV_JOB_RANDOM))
		bounty_num = guided
	else
		bounty_num = rand(1,11)
	switch(bounty_num)
		if(CIV_JOB_BASIC)
			var/subtype = pick(subtypesof(/datum/bounty/item/assistant))
			return new subtype
		if(CIV_JOB_ROBO)
			var/subtype = pick(subtypesof(/datum/bounty/item/mech))
			return new subtype
		if(CIV_JOB_CHEF)
			var/subtype = pick(subtypesof(/datum/bounty/item/chef))
			return new subtype
		if(CIV_JOB_SEC)
			var/subtype = pick(subtypesof(/datum/bounty/item/security))
			return new subtype
		if(CIV_JOB_DRINK)
			if(rand(2) == 1)
				return new /datum/bounty/reagent/simple_drink
			return new /datum/bounty/reagent/complex_drink
		if(CIV_JOB_CHEM)
			if(rand(2) == 1)
				return new /datum/bounty/reagent/chemical_simple
			return new /datum/bounty/reagent/chemical_complex
		if(CIV_JOB_VIRO)
			var/subtype = pick(subtypesof(/datum/bounty/virus))
			return new subtype
		if(CIV_JOB_ENG)
			var/subtype = pick(subtypesof(/datum/bounty/item/engineering))
			return new subtype
		if(CIV_JOB_MINE)
			var/subtype = pick(subtypesof(/datum/bounty/item/mining))
			return new subtype
		if(CIV_JOB_MED)
			var/subtype = pick(subtypesof(/datum/bounty/item/medical))
			return new subtype
		if(CIV_JOB_GROW)
			var/subtype = pick(subtypesof(/datum/bounty/item/botany))
			return new subtype

	stack_trace("Tried to return a null bounty! Replacing with assistant.")
	var/subtype = pick(subtypesof(/datum/bounty/item/assistant))
	return new subtype

