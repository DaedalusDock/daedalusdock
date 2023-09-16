/*
 * Actually equip our mob with our job outfit and our loadout items.
 * Loadout items override the pre-existing item in the corresponding slot of the job outfit.
 * Some job items are preserved after being overridden - belt items, ear items, and glasses.
 * The rest of the slots, the items are overridden completely and deleted.
 *
 * Plasmamen are snowflaked to not have any envirosuit pieces removed just in case.
 * Their loadout items for those slots will be added to their backpack on spawn.
 *
 * outfit - the job outfit we're equipping
 * visuals_only - whether we call special equipped procs, or if we just look like we equipped it
 * preference_source - the preferences of the thing we're equipping
 */
/mob/living/carbon/human/proc/equip_outfit_and_loadout(datum/outfit/outfit, datum/preferences/preference_source, visuals_only = FALSE, datum/job/equipping_job)
	var/datum/outfit/equipped_outfit

	if(ispath(outfit))
		equipped_outfit = new outfit()
	else if(istype(outfit))
		equipped_outfit = outfit
	else
		CRASH("Outfit passed to equip_outfit_and_loadout was neither a path nor an instantiated type!")

	if (!preference_source)
		equipOutfit(equipped_outfit, visuals_only)
		return FALSE

	var/override_preference = preference_source.read_preference(/datum/preference/choiced/loadout_override_preference)
	var/list/loadout = preference_source.read_preference(/datum/preference/blob/loadout)

	if(!length(loadout))
		equipOutfit(equipped_outfit, visuals_only)
		return FALSE

	if(override_preference == LOADOUT_OVERRIDE_CASE && !visuals_only)
		var/obj/item/storage/briefcase/empty/briefcase = new(loc)

		for(var/datum/loadout_entry/entry as anything in loadout)
			var/datum/loadout_item/item = locate(entry.path) in GLOB.loadout_items
			if(item.restricted_roles && equipping_job && !(equipping_job.title in item.restricted_roles))
				if(client)
					to_chat(src, span_warning("You were unable to get a loadout item ([entry.custom_name]) due to job restrictions!"))
				continue

			briefcase.contents += entry.get_spawned_item()

		briefcase.name = "[preference_source.read_preference(/datum/preference/name/real_name)]'s travel suitcase"

		if(!put_in_hands(briefcase))
			qdel(briefcase)
			to_chat(src, span_warning("Your hands were full, your suitcase has been discarded!"))
	else
		var/list/items_to_return = list()
		for(var/datum/loadout_entry/entry as anything in loadout)
			var/datum/loadout_item/item = locate(entry.path) in GLOB.loadout_items
			if(item.restricted_roles && equipping_job && !(equipping_job.title in item.restricted_roles))
				if(client)
					to_chat(src, span_warning("You were unable to get a loadout item ([entry.custom_name]) due to job restrictions!"))
				continue

			var/returned_item = item.insert_path_into_outfit(equipped_outfit, src, visuals_only)
			if(visuals_only && item.category == LOADOUT_CATEGORY_BACKPACK)
				loadout -= entry
			if(returned_item)
				items_to_return += returned_item

		if(override_preference == LOADOUT_OVERRIDE_BACKPACK && !visuals_only)
			if(!equipped_outfit.back && length(items_to_return))
				equipped_outfit.back = /obj/item/storage/backpack

			if(!islist(equipped_outfit.backpack_contents))
				equipped_outfit.backpack_contents = list()

			for(var/obj/item/I as anything in items_to_return)
				equipped_outfit.backpack_contents[I] = 1

	equipOutfit(equipped_outfit, visuals_only)

	if(!(override_preference == LOADOUT_OVERRIDE_CASE && visuals_only))
		var/list/mob_contents
		if(override_preference == LOADOUT_OVERRIDE_CASE)
			var/obj/item/storage/briefcase/empty/our_case = locate() in held_items
			mob_contents = our_case.contents

		mob_contents ||= get_all_contents()

		var/slots = NONE
		for(var/datum/loadout_entry/entry as anything in loadout)
			var/datum/loadout_item/LI = locate(entry.path) in GLOB.loadout_items
			var/obj/item/I = locate(LI.path) in mob_contents
			if(!I)
				stack_trace("Could not find [LI.type] in [src]'s equipped items! Pref: [override_preference] | Visuals Only? [visuals_only ? "YES" : "NO"]")
				continue
			LI.on_equip(src, I, entry, visuals_only)
			slots |= I.slot_flags

		update_clothing(slots)

	return TRUE


/obj/item/storage/briefcase/empty/PopulateContents()
	return
