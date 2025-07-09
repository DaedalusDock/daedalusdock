/obj/item/storage/pill_bottle/chem_tin/
	name = "chem tin"
	desc = "A branded tin made to hold ingestable chems."

/datum/storage/pill_botle/chem_tin/New()
	set_holdable(list(
	/obj/item/reagent_containers/pill,
	/obj/item/reagent_containers/syringe,
	/obj/item/dice
	))

/datum/storage/pill_bottle/chem_tin
	open_sound = 'sound/storage/pillbottle.ogg'
	close_sound = null
	rustle_sound = null
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	can_hold = typecacheof(list(/obj/item/reagent_containers/pill, /obj/item/reagent_containers/syringe, /obj/item/dice))

/obj/item/storage/pill_bottle/chem_tin/mentats
	name = "Mentats"
	icon = 'modular_fallout/master_files/icons/fallout/objects/medicine/drugs.dmi'
	icon_state = "pill_canister_mentats"
	desc = "Contains pills used to increase intelligence and perception."

/obj/item/storage/pill_bottle/chem_tin/mentats/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/pill/mentat(src)

/obj/item/storage/pill_bottle/chem_tin/fixer
	name = "Fixer"
	icon = 'modular_fallout/master_files/icons/fallout/objects/medicine/drugs.dmi'
	icon_state = "pill_canister_fixer"
	desc = "Contains pills used to treat addiction and overdose on other chems."

/obj/item/storage/pill_bottle/chem_tin/fixer/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/pill/fixer(src)

/obj/item/storage/pill_bottle/chem_tin/radx
	name = "Rad-X"
	icon = 'modular_fallout/master_files/icons/fallout/objects/medicine/drugs.dmi'
	icon_state = "pill_canister_radx"
	desc = "Contains pills used to treat and prevent radiation and minor toxin damage."

/obj/item/storage/pill_bottle/chem_tin/radx/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/pill/radx(src)

/obj/item/storage/pill_bottle/chem_tin/buffout
	name = "Buffout"
	icon = 'modular_fallout/master_files/icons/fallout/objects/medicine/drugs.dmi'
	icon_state = "pill_canister_buffout"
	desc = "Contains pills used to increase muscle mass."

/obj/item/storage/pill_bottle/chem_tin/buffout/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/pill/buffout(src)
