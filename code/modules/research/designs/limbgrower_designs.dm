/////////////////////////////////////
//////////Limb Grower Designs ///////
/////////////////////////////////////

/datum/design/leftarm
	name = "Left Arm"
	id = "l_arm"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 25)
	build_path = /obj/item/bodypart/arm/left
	category = list(SPECIES_HUMAN,SPECIES_LIZARD,SPECIES_MOTH,SPECIES_ETHEREAL)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/rightarm
	name = "Right Arm"
	id = "r_arm"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 25)
	build_path = /obj/item/bodypart/arm/right
	category = list(SPECIES_HUMAN,SPECIES_LIZARD,SPECIES_MOTH,SPECIES_ETHEREAL)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/leftleg
	name = "Left Leg"
	id = "l_leg"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 25)
	build_path = /obj/item/bodypart/leg/left
	category = list(SPECIES_HUMAN,SPECIES_LIZARD,SPECIES_MOTH,SPECIES_ETHEREAL, "digitigrade")
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/rightleg
	name = "Right Leg"
	id = "r_leg"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 25)
	build_path = /obj/item/bodypart/leg/right
	category = list(SPECIES_HUMAN,SPECIES_LIZARD,SPECIES_MOTH,SPECIES_ETHEREAL, "digitigrade")
	mapload_design_flags = DESIGN_LIMBGROWER

//Non-limb limb designs

/datum/design/heart
	name = "Heart"
	id = "heart"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 30)
	build_path = /obj/item/organ/heart
	category = list(SPECIES_HUMAN)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/lungs
	name = "Lungs"
	id = "lungs"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 20)
	build_path = /obj/item/organ/lungs
	category = list(SPECIES_HUMAN)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/liver
	name = "Liver"
	id = "liver"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 20)
	build_path = /obj/item/organ/liver
	category = list(SPECIES_HUMAN)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/stomach
	name = "Stomach"
	id = "stomach"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 15)
	build_path = /obj/item/organ/stomach
	category = list(SPECIES_HUMAN)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/appendix
	name = "Appendix"
	id = "appendix"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 5) //why would you need this
	build_path = /obj/item/organ/appendix
	category = list(SPECIES_HUMAN)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/eyes
	name = "Eyes"
	id = "eyes"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 10)
	build_path = /obj/item/organ/eyes
	category = list(SPECIES_HUMAN)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/ears
	name = "Ears"
	id = "ears"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 10)
	build_path = /obj/item/organ/ears
	category = list(SPECIES_HUMAN)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/tongue
	name = "Tongue"
	id = "tongue"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 10)
	build_path = /obj/item/organ/tongue
	category = list(SPECIES_HUMAN)
	mapload_design_flags = DESIGN_LIMBGROWER

// Grows a fake lizard tail - not usable in lizard wine and other similar recipes.
/datum/design/lizard_tail
	name = "Jinan Tail"
	id = "liztail"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 20)
	build_path = /obj/item/organ/tail/lizard/fake
	category = list(SPECIES_LIZARD)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/lizard_tongue
	name = "Forked Tongue"
	id = "liztongue"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 20)
	build_path = /obj/item/organ/tongue/lizard
	category = list(SPECIES_LIZARD)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/monkey_tail
	name = "Monkey Tail"
	id = "monkeytail"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 20)
	build_path = /obj/item/organ/tail/monkey
	category = list("other")
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/cat_tail
	name = "Cat Tail"
	id = "cattail"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 20)
	build_path = /obj/item/organ/tail/cat
	category = list(SPECIES_HUMAN)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/cat_ears
	name = "Cat Ears"
	id = "catears"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 10)
	build_path = /obj/item/organ/ears/cat
	category = list(SPECIES_HUMAN)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/ethereal_stomach
	name = "Biological Battery"
	id = "etherealstomach"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 10, /datum/reagent/consumable/liquidelectricity/enriched = 20)
	build_path = /obj/item/organ/stomach/ethereal
	category = list(SPECIES_ETHEREAL)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/ethereal_tongue
	name = "Electrical Discharger"
	id = "etherealtongue"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 10, /datum/reagent/consumable/liquidelectricity/enriched = 20)
	build_path = /obj/item/organ/tongue/ethereal
	category = list(SPECIES_ETHEREAL)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/ethereal_lungs
	name = "Aeration Reticulum"
	id = "ethereallungs"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 10, /datum/reagent/consumable/liquidelectricity/enriched = 20)
	build_path = /obj/item/organ/lungs/ethereal
	category = list(SPECIES_ETHEREAL)
	mapload_design_flags = DESIGN_LIMBGROWER

// Intentionally not growable by normal means - for balance conerns.
/datum/design/ethereal_heart
	name = "Crystal Core"
	id = "etherealheart"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 10, /datum/reagent/consumable/liquidelectricity/enriched = 20)
	build_path = /obj/item/organ/heart/ethereal
	category = list(SPECIES_ETHEREAL)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/armblade
	name = "Arm Blade"
	id = "armblade"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 75)
	build_path = /obj/item/melee/synthetic_arm_blade
	category = list("other","emagged")

/// Design disks and designs - for adding limbs and organs to the limbgrower.
/obj/item/disk/data/limbs
	name = "limb design data disk"
	desc = "A disk containing limb and organ designs for a limbgrower."
	icon_state = "datadisk1"
	/// List of all limb designs this disk will contain on init.
	var/list/limb_designs = list()

/obj/item/disk/data/limbs/Initialize(mapload)
	. = ..()
	storage = limb_designs.len
	set_data(SStech.fetch_designs(limb_designs))
	limb_designs = null

/datum/design/limb_disk
	name = "Limb Design Disk"
	desc = "Contains designs for various limbs."
	id = "limbdesign_parent"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 300, /datum/material/glass = 100)
	build_path = /obj/item/disk/data/limbs
	category = list(DCAT_MEDICAL)
	mapload_design_flags = DESIGN_FAB_MEDICAL

/obj/item/disk/data/limbs/lizard
	name = "Jinan Organ Design Disk"
	limb_designs = list(/datum/design/lizard_tail, /datum/design/lizard_tongue)

/datum/design/limb_disk/lizard
	name = "Jinan Organ Design Disk"
	desc = "Contains designs for Jinan organs for the limbgrower - Jinan tongue, and tail"
	id = "limbdesign_unathi"
	build_path = /obj/item/disk/data/limbs/lizard

/obj/item/disk/data/limbs/ethereal
	name = "Ethereal Organ Design Disk"
	limb_designs = list(/datum/design/ethereal_stomach, /datum/design/ethereal_tongue, /datum/design/ethereal_lungs)

/datum/design/limb_disk/ethereal
	name = "Ethereal Organ Design Disk"
	desc = "Contains designs for ethereal organs for the limbgrower - Ethereal tongue and stomach."
	id = "limbdesign_ethereal"
	build_path = /obj/item/disk/data/limbs/ethereal
