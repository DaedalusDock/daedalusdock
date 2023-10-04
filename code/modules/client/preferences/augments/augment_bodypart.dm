/datum/augment_item/bodypart
	category = AUGMENT_CATEGORY_BODYPARTS


/datum/augment_item/bodypart/apply_to_human(mob/living/carbon/human/H, datum/species/S)
	var/newpath = S.robotic_bodyparts[initial(path:body_zone)]

	var/obj/item/bodypart/BP = new newpath()
	var/obj/item/bodypart/old = H.get_bodypart(BP.body_zone)
	BP.replace_limb(H, TRUE)
	qdel(old)

/datum/augment_item/bodypart/can_apply_to_species(datum/species/S)
	var/obj/item/bodypart/BP = path
	if(S.robotic_bodyparts?[initial(BP.body_zone)])
		return TRUE
	return FALSE

/datum/augment_item/bodypart/head
	slot = AUGMENT_SLOT_HEAD

/datum/augment_item/bodypart/chest
	slot = AUGMENT_SLOT_CHEST

/datum/augment_item/bodypart/l_arm
	slot = AUGMENT_SLOT_L_ARM

/datum/augment_item/bodypart/r_arm
	slot = AUGMENT_SLOT_R_ARM

/datum/augment_item/bodypart/l_leg
	slot = AUGMENT_SLOT_L_LEG

/datum/augment_item/bodypart/r_leg
	slot = AUGMENT_SLOT_R_LEG


// ROBOTIC LIMBS
/datum/augment_item/bodypart/head/robotic
	name = "Prosthetic"
	slot = AUGMENT_SLOT_HEAD
	path = /obj/item/bodypart/head/robot/surplus

/datum/augment_item/bodypart/chest/robotic
	name = "Prosthetic"
	slot = AUGMENT_SLOT_CHEST
	path = /obj/item/bodypart/chest/robot/surplus

/datum/augment_item/bodypart/l_arm/robotic
	name = "Prosthetic"
	slot = AUGMENT_SLOT_L_ARM
	path = /obj/item/bodypart/arm/left/robot/surplus

/datum/augment_item/bodypart/r_arm/robotic
	name = "Prosthetic"
	slot = AUGMENT_SLOT_R_ARM
	path = /obj/item/bodypart/arm/right/robot/surplus

/datum/augment_item/bodypart/l_leg/robotic
	name = "Prosthetic"
	slot = AUGMENT_SLOT_L_LEG
	path = /obj/item/bodypart/leg/left/robot/surplus

/datum/augment_item/bodypart/r_leg/robotic
	name = "Prosthetic"
	slot = AUGMENT_SLOT_R_LEG
	path = /obj/item/bodypart/leg/right/robot/surplus

/// AMPUTATION
/datum/augment_item/bodypart/amputated/l_arm
	name = "Amputated"
	path = /obj/item/bodypart/arm/left
	slot = AUGMENT_SLOT_L_ARM

/datum/augment_item/bodypart/amputated/r_arm
	name = "Amputated"
	path = /obj/item/bodypart/arm/right
	slot = AUGMENT_SLOT_R_ARM

/datum/augment_item/bodypart/amputated/l_leg
	name = "Amputated"
	path = /obj/item/bodypart/leg/left
	slot = AUGMENT_SLOT_L_LEG

/datum/augment_item/bodypart/amputated/r_leg
	name = "Amputated"
	path = /obj/item/bodypart/leg/right
	slot = AUGMENT_SLOT_R_LEG

/datum/augment_item/bodypart/amputated/apply_to_human(mob/living/carbon/human/H, datum/species/S)
	var/obj/item/bodypart/path = src.path
	var/obj/item/bodypart/BP = H.get_bodypart(initial(path.body_zone))
	var/obj/item/bodypart/stump = BP.create_stump()
	qdel(BP)
	stump.attach_limb(H, TRUE)

/datum/augment_item/bodypart/amputated/can_apply_to_species(datum/species/S)
	return TRUE
