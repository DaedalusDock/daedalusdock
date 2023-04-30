/////////////////////////////////////
//////////Limb Grower Designs ///////
/////////////////////////////////////

/datum/design/leftarm
	name = "Left Arm"
	id = "l_arm"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 25)
	build_path = /obj/item/bodypart/arm/left
	category = list("initial",SPECIES_HUMAN,SPECIES_LIZARD,SPECIES_MOTH,SPECIES_PLASMAMAN,SPECIES_ETHEREAL)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/rightarm
	name = "Right Arm"
	id = "r_arm"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 25)
	build_path = /obj/item/bodypart/arm/right
	category = list("initial",SPECIES_HUMAN,SPECIES_LIZARD,SPECIES_MOTH,SPECIES_PLASMAMAN,SPECIES_ETHEREAL)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/leftleg
	name = "Left Leg"
	id = "l_leg"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 25)
	build_path = /obj/item/bodypart/leg/left
	category = list("initial",SPECIES_HUMAN,SPECIES_LIZARD,SPECIES_MOTH,SPECIES_PLASMAMAN,SPECIES_ETHEREAL, "digitigrade")
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/rightleg
	name = "Right Leg"
	id = "r_leg"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 25)
	build_path = /obj/item/bodypart/leg/right
	category = list("initial",SPECIES_HUMAN,SPECIES_LIZARD,SPECIES_MOTH,SPECIES_PLASMAMAN,SPECIES_ETHEREAL, "digitigrade")
	mapload_design_flags = DESIGN_LIMBGROWER

//Non-limb limb designs

/datum/design/heart
	name = "Heart"
	id = "heart"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 30)
	build_path = /obj/item/organ/internal/heart
	category = list(SPECIES_HUMAN,"initial")
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/lungs
	name = "Lungs"
	id = "lungs"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 20)
	build_path = /obj/item/organ/internal/lungs
	category = list(SPECIES_HUMAN,"initial")
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/liver
	name = "Liver"
	id = "liver"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 20)
	build_path = /obj/item/organ/internal/liver
	category = list(SPECIES_HUMAN,"initial")
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/stomach
	name = "Stomach"
	id = "stomach"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 15)
	build_path = /obj/item/organ/internal/stomach
	category = list(SPECIES_HUMAN,"initial")
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/appendix
	name = "Appendix"
	id = "appendix"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 5) //why would you need this
	build_path = /obj/item/organ/internal/appendix
	category = list(SPECIES_HUMAN,"initial")
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/eyes
	name = "Eyes"
	id = "eyes"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10)
	build_path = /obj/item/organ/internal/eyes
	category = list(SPECIES_HUMAN,"initial")
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/ears
	name = "Ears"
	id = "ears"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10)
	build_path = /obj/item/organ/internal/ears
	category = list(SPECIES_HUMAN,"initial")
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/tongue
	name = "Tongue"
	id = "tongue"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10)
	build_path = /obj/item/organ/internal/tongue
	category = list(SPECIES_HUMAN,"initial")
	mapload_design_flags = DESIGN_LIMBGROWER

// Grows a fake lizard tail - not usable in lizard wine and other similar recipes.
/datum/design/lizard_tail
	name = "Unathi Tail"
	id = "liztail"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 20)
	build_path = /obj/item/organ/external/tail/lizard/fake
	category = list(SPECIES_LIZARD)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/lizard_tongue
	name = "Forked Tongue"
	id = "liztongue"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 20)
	build_path = /obj/item/organ/internal/tongue/lizard
	category = list(SPECIES_LIZARD)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/monkey_tail
	name = "Monkey Tail"
	id = "monkeytail"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 20)
	build_path = /obj/item/organ/external/tail/monkey
	category = list("other","initial")
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/cat_tail
	name = "Cat Tail"
	id = "cattail"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 20)
	build_path = /obj/item/organ/external/tail/cat
	category = list(SPECIES_HUMAN)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/cat_ears
	name = "Cat Ears"
	id = "catears"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10)
	build_path = /obj/item/organ/internal/ears/cat
	category = list(SPECIES_HUMAN)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/plasmaman_lungs
	name = "Plasma Filter"
	id = "plasmamanlungs"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10, /datum/reagent/toxin/plasma = 20)
	build_path = /obj/item/organ/internal/lungs/plasmaman
	category = list(SPECIES_PLASMAMAN)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/plasmaman_tongue
	name = "Plasma Bone Tongue"
	id = "plasmamantongue"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10, /datum/reagent/toxin/plasma = 20)
	build_path = /obj/item/organ/internal/tongue/bone/plasmaman
	category = list(SPECIES_PLASMAMAN)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/plasmaman_liver
	name = "Reagent Processing Crystal"
	id = "plasmamanliver"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10, /datum/reagent/toxin/plasma = 20)
	build_path = /obj/item/organ/internal/liver/plasmaman
	category = list(SPECIES_PLASMAMAN)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/plasmaman_stomach
	name = "Digestive Crystal"
	id = "plasmamanstomach"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10, /datum/reagent/toxin/plasma = 20)
	build_path = /obj/item/organ/internal/stomach/bone/plasmaman
	category = list(SPECIES_PLASMAMAN)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/ethereal_stomach
	name = "Biological Battery"
	id = "etherealstomach"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10, /datum/reagent/consumable/liquidelectricity/enriched = 20)
	build_path = /obj/item/organ/internal/stomach/ethereal
	category = list(SPECIES_ETHEREAL)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/ethereal_tongue
	name = "Electrical Discharger"
	id = "etherealtongue"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10, /datum/reagent/consumable/liquidelectricity/enriched = 20)
	build_path = /obj/item/organ/internal/tongue/ethereal
	category = list(SPECIES_ETHEREAL)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/ethereal_lungs
	name = "Aeration Reticulum"
	id = "ethereallungs"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10, /datum/reagent/consumable/liquidelectricity/enriched = 20)
	build_path = /obj/item/organ/internal/lungs/ethereal
	category = list(SPECIES_ETHEREAL)
	mapload_design_flags = DESIGN_LIMBGROWER

// Intentionally not growable by normal means - for balance conerns.
/datum/design/ethereal_heart
	name = "Crystal Core"
	id = "etherealheart"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10, /datum/reagent/consumable/liquidelectricity/enriched = 20)
	build_path = /obj/item/organ/internal/heart/ethereal
	category = list(SPECIES_ETHEREAL)
	mapload_design_flags = DESIGN_LIMBGROWER

/datum/design/armblade
	name = "Arm Blade"
	id = "armblade"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 75)
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
	category = list("Medical Designs")
	mapload_design_flags = DESIGN_FAB_MEDICAL

/obj/item/disk/data/limbs/felinid
	name = "Felinid Organ Design Disk"
	limb_designs = list(/datum/design/cat_tail, /datum/design/cat_ears)

/datum/design/limb_disk/felinid
	name = "Felinid Organ Design Disk"
	desc = "Contains designs for felinid organs for the limbgrower - Felinid ears and tail."
	id = "limbdesign_felinid"
	build_path = /obj/item/disk/data/limbs/felinid

/obj/item/disk/data/limbs/lizard
	name = "Unathi Organ Design Disk"
	limb_designs = list(/datum/design/lizard_tail, /datum/design/lizard_tongue)

/datum/design/limb_disk/lizard
	name = "Unathi Organ Design Disk"
	desc = "Contains designs for unathi organs for the limbgrower - Unathi tongue, and tail"
	id = "limbdesign_unathi"
	build_path = /obj/item/disk/data/limbs/lizard

/obj/item/disk/data/limbs/plasmaman
	name = "Plasmaman Organ Design Disk"
	limb_designs = list(/datum/design/plasmaman_stomach, /datum/design/plasmaman_liver, /datum/design/plasmaman_lungs, /datum/design/plasmaman_tongue)

/datum/design/limb_disk/plasmaman
	name = "Plasmaman Organ Design Disk"
	desc = "Contains designs for plasmaman organs for the limbgrower - Plasmaman tongue, liver, stomach, and lungs."
	id = "limbdesign_plasmaman"
	build_path = /obj/item/disk/data/limbs/plasmaman

/obj/item/disk/data/limbs/ethereal
	name = "Ethereal Organ Design Disk"
	limb_designs = list(/datum/design/ethereal_stomach, /datum/design/ethereal_tongue, /datum/design/ethereal_lungs)

/datum/design/limb_disk/ethereal
	name = "Ethereal Organ Design Disk"
	desc = "Contains designs for ethereal organs for the limbgrower - Ethereal tongue and stomach."
	id = "limbdesign_ethereal"
	build_path = /obj/item/disk/data/limbs/ethereal
