
//Everything in here is non functional clipboard shit to be used later. Don't judge me.

//Salvageable object code snipet
/*
/obj/structure/thing
	var/list/salvage_items = list(
		SALVAGE_TIER_1 = list(
			/obj/item/thing,
			/obj/item/other_thing
		),
		SALVAGE_TIER_2 = list(
			/obj/item/other_other_thing,
			etc
		)
	)

/proc/get_salvage(obj/structure/salvaged_structure, obj/item/salvage_tool)
	var/list/loot = list()
	switch(salvage_tool.salvage_power)
		if(SALVAGE_POWER_AWFUL)
			for(var/I in 1 to 2)
				loot += pick(salvaged_structure.salvage_items[SALVAGE_TIER_1])
			for(var/I in 0 to 1)
				loot += pick(salvaged_structure.salvage_items[SALVAGE_TIER_2])
		if(SALVAGE_POWER_LOW)
			for(var/I in 1 to 3)
				loot += pick(salvaged_structure.salvage_items[SALVAGE_TIER_1])
			for(var/I in 1 to 2)
				loot += pick(salvaged_structure.salvage_items[SALVAGE_TIER_2])

	for(var/salvage_item in loot)
		new salvage_item(get_turf(salvaged_structure))
*/

//Old salvageable code snipet, unused, for reference.
/*
/obj/structure/salvage/terminal/welder_act(mob/living/user, obj/item/tool)
	to_chat(user, span_userdanger("You begin to cut open the side panel..."))
	if(tool.salvage_power == SALVAGE_POWER_AWFUL)
		to_chat(user, span_userdanger("Your cutter is not strong enough to pierce the side panel!"))
		return(null)
	else
		do_after(user, 10,)
		to_chat(user, span_notice("You successfully remove the sidepanel with the cutter."))
		progress = 1
*/


///FUCK:tm:

/*
/obj/structure/salvage/proc/get_salvage(obj/structure/salvage/salvaged_structure, obj/item/salvage_tool)
	var/list/loot = list()
	switch(salvage_tool.salvage_power)
		if(SALVAGE_POWER_NONE)
			to_chat(/mob/user,span_notice)
			return null
		if(SALVAGE_POWER_AWFUL)
			for(var/I in 1 to 2)
				loot += pick(salvaged_structure.salvage_items[SALVAGE_TIER1])
			for(var/I in 1 to 2)
				loot += pick(salvaged_structure.salvage_items[SALVAGE_TIER2])

	for(var/salvage_item in loot)
		new salvage_item(loc)


	var/list/salvage_items = list(
		SALVAGE_TIER1 = list(
			/obj/item/salvage/tier1
		),
		SALVAGE_TIER2 = list(
			/obj/item/salvage/tier2
		),
		SALVAGE_TIER3 = list(
			/obj/item/salvage/tier3
		),
		SALVAGE_TIER4 = list(
			/obj/item/salvage/tier4
		),
		SALVAGE_TIER5 = list(
			/obj/item/salvage/tier5
		))

*/
