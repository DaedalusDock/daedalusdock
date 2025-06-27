/obj/item/reagent_containers/hypospray/medipen/stimpak
	name = "stimpak"
	desc = "A handheld delivery system for medicine, used to rapidly heal physical damage to the body."
	icon = 'icons/fallout/objects/medicine/drugs.dmi'
	icon_state = "stimpakpen"
	volume = 10
	amount_per_transfer_from_this = 10
	list_reagents = list(/datum/reagent/medicine/stimpak = 10)

/obj/item/reagent_containers/hypospray/medipen/stimpak/on_reagent_change(changetype)
	update_icon()

/obj/item/reagent_containers/hypospray/medipen/stimpak/update_overlays()
	. = ..()
	var/mutable_appearance/stimpak_overlay = mutable_appearance('icons/obj/reagentfillings.dmi', "stimfilling", color = mix_color_from_reagents(reagents.reagent_list))
	if(reagents.total_volume)
		. += stimpak_overlay

/obj/item/reagent_containers/hypospray/medipen/stimpak/custom
	desc = "A handheld delivery system for medicine, this particular one will deliver a tailored cocktail."
	list_reagents = null

/obj/item/reagent_containers/hypospray/medipen/stimpak/imitation
	desc = "A handheld delivery system for medicine. This one is filled with ground up flower juice, but hey, whatever gets you moving, right?"
	list_reagents = list(/datum/reagent/medicine/stimpak/imitation = 10)

/obj/item/reagent_containers/hypospray/medipen/stimpak/super
	name = "super stimpak"
	desc = "The super version comes in a hypodermic, but with an additional vial containing more powerful drugs than the basic model and a leather belt to strap the needle to the injured limb."
	icon_state = "superstimpakpen"
	amount_per_transfer_from_this = 10
	list_reagents = list(/datum/reagent/medicine/stimpak/super_stimpak = 10)

/obj/item/reagent_containers/hypospray/medipen/stimpak/super/custom
	desc = "The super version comes in a hypodermic, but with an additional vial to inject more drugs than the basic model and a leather belt to strap the needle to a limb. This particular one will deliver a tailored cocktail."
	volume = 20
	amount_per_transfer_from_this = 20
	list_reagents = null

/obj/item/reagent_containers/hypospray/medipen/medx
	name = "Med-X"
	desc = "A short-lasting shot of Med-X applied via hypodermic needle."
	icon = 'icons/fallout/objects/medicine/drugs.dmi'
	icon_state = "medx"
	volume = 15
	amount_per_transfer_from_this = 5
	list_reagents = list(/datum/reagent/medicine/medx = 15)

/obj/item/reagent_containers/hypospray/medipen/psycho
	name = "Psycho"
	desc = "Contains Psycho, a drug that makes the user hit harder and shrug off slight stuns, but causes slight brain damage and carries a risk of addiction."
	icon = 'icons/fallout/objects/medicine/drugs.dmi'
	icon_state = "psychopen"
	volume = 10
	amount_per_transfer_from_this = 10
	list_reagents = list(/datum/reagent/drug/psycho = 10)

/obj/item/hypospray/mkii/Initialize()
	. = ..()
	if(!spawnwithvial)
		update_icon()
		return
	if(start_vial)
		vial = new start_vial
	update_icon()

/obj/item/hypospray/mkii/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/hypospray/mkii/update_icon_state()
	icon_state = "[initial(icon_state)][vial ? "" : "-e"]"
