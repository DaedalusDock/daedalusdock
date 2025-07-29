/obj/item/reagent_containers/pill/patch/jet
	name = "Jet"
	desc = "A highly addictive meta-amphetamine that produces a fast-acting, intense euphoric high on the user."
	icon = 'modular_fallout/master_files/icons/fallout/objects/medicine/drugs.dmi'
	list_reagents = list(/datum/reagent/drug/jet = 10)
	icon_state = "bandaid_jet"
	base_icon_state = "bandaid_jet"

/obj/item/reagent_containers/pill/patch/turbo
	name = "Turbo"
	desc = "A chem that vastly increases the user's reflexes and slows their perception of time."
	icon = 'modular_fallout/master_files/icons/fallout/objects/medicine/drugs.dmi'
	icon_state = "bandaid_turbo"
	base_icon_state = "bandaid_turbo"
	list_reagents = list(/datum/reagent/drug/turbo = 5)

/obj/item/reagent_containers/pill/patch/healingpowder
	name = "Healing Powder"
	desc = "A powder used to heal physical wounds derived from ground broc flowers and xander roots, commonly used by tribals."
	icon = 'modular_fallout/master_files/icons/fallout/objects/medicine/drugs.dmi'
	icon_state = "bandaid_healingpowder"
	base_icon_state = "bandaid_healingpowder"
	list_reagents = list(/datum/reagent/medicine/healing_powder = 10)
	self_delay = 0

/obj/item/reagent_containers/pill/patch/healpoultice
	name = "Healing poultice"
	desc = "A concoction of broc flower, cave fungus, agrave fruit and xander root."
	icon = 'modular_fallout/master_files/icons/fallout/objects/medicine/drugs.dmi'
	list_reagents = list(/datum/reagent/medicine/healing_powder/poultice = 10)
	icon_state = "bandaid_healingpoultice"
	base_icon_state = "bandaid_healingpoultice"
	self_delay = 0

/obj/item/reagent_containers/pill/patch/healingpowder/custom
	name = "Healing Powder"
	desc = "A powder used to heal physical wounds derived from ground broc flowers and xander roots, commonly used by tribals."
	icon = 'modular_fallout/master_files/icons/fallout/objects/medicine/drugs.dmi'
	list_reagents = null
	icon_state = "bandaid_healingpowder"
	base_icon_state = "bandaid_healingpowder"
	self_delay = 0

/obj/item/reagent_containers/pill/patch/bitterdrink
	name = "Bitter drink"
	desc = "A strong herbal healing concoction which enables wounded soldiers and travelers to tend to their wounds without stopping during journeys."
	icon = 'modular_fallout/master_files/icons/fallout/objects/medicine/drugs.dmi'
	icon_state = "bitterdrink"
	base_icon_state = "bitterdrink"
	list_reagents = list(/datum/reagent/medicine/bitter_drink = 15)
	self_delay = 0

/obj/item/reagent_containers/pill/patch/healingpowder/berserker
	name = "Berserker Powder"
	desc = "a combination of psychadelic mushrooms and tribal drugs used by legion berserkers. Induces a trancelike state, allowing them much greater pain resistance. Extremely dangerous, even for those who are trained to use it. It's a really bad idea to use this if you're not a berserker. Even if you are, taking it for too long causes extreme symptoms when the trance ends."
	icon = 'modular_fallout/master_files/icons/fallout/objects/medicine/drugs.dmi'
//	list_reagents = list(/datum/reagent/medicine/berserker_powder = 10)
	icon_state = "bandaid_berserkerpowder"
	base_icon_state = "bandaid_berserkerpowder"
	self_delay = 0
