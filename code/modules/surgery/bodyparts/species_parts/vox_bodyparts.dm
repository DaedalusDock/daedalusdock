// voxs!
/obj/item/bodypart/head/vox
	icon_greyscale = 'icons/mob/species/vox/bodyparts.dmi'
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ORGANIC
	limb_id = SPECIES_VOX
	is_dimorphic = TRUE

	eyes_icon_file = 'icons/mob/species/vox/eyes.dmi'

/obj/item/bodypart/chest/vox
	icon_greyscale = 'icons/mob/species/vox/bodyparts.dmi'
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ORGANIC | BODYTYPE_VOX_OTHER
	limb_id = SPECIES_VOX
	is_dimorphic = TRUE

/obj/item/bodypart/arm/left/vox
	mutcolor_used = MUTCOLORS_GENERIC_2
	icon_greyscale = 'icons/mob/species/vox/bodyparts.dmi'
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ORGANIC | BODYTYPE_VOX_OTHER
	limb_id = SPECIES_VOX
	unarmed_attack_verb = "slash"
	unarmed_attack_effect = ATTACK_EFFECT_CLAW
	unarmed_attack_sound = 'sound/weapons/slash.ogg'
	unarmed_miss_sound = 'sound/weapons/slashmiss.ogg'

/obj/item/bodypart/arm/right/vox
	mutcolor_used = MUTCOLORS_GENERIC_2
	icon_greyscale = 'icons/mob/species/vox/bodyparts.dmi'
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ORGANIC | BODYTYPE_VOX_OTHER
	limb_id = SPECIES_VOX
	unarmed_attack_verb = "slash"
	unarmed_attack_effect = ATTACK_EFFECT_CLAW
	unarmed_attack_sound = 'sound/weapons/slash.ogg'
	unarmed_miss_sound = 'sound/weapons/slashmiss.ogg'

/obj/item/bodypart/leg/left/vox
	mutcolor_used = MUTCOLORS_GENERIC_2
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ORGANIC | BODYTYPE_VOX_LEGS
	icon_greyscale = 'icons/mob/species/vox/bodyparts.dmi'
	limb_id = "vox_digitigrade"
	blood_print = BLOOD_PRINT_CLAWS
	barefoot_step_type = FOOTSTEP_MOB_CLAW

/obj/item/bodypart/leg/left/vox/update_limb(dropping_limb = FALSE, is_creating = FALSE)
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		var/uniform_compatible = FALSE
		var/suit_compatible = FALSE
		if(!(human_owner.w_uniform) || (human_owner.w_uniform.supports_variations_flags & CLOTHING_VOX_VARIATION)) //Checks uniform compatibility
			uniform_compatible = TRUE
		if((!human_owner.wear_suit) || (human_owner.wear_suit.supports_variations_flags & CLOTHING_VOX_VARIATION) || !(human_owner.wear_suit.body_parts_covered & LEGS)) //Checks suit compatability
			suit_compatible = TRUE

		if((uniform_compatible && suit_compatible) || (suit_compatible && (human_owner.obscured_slots & HIDEJUMPSUIT))) //If the uniform is hidden, it doesnt matter if its compatible
			limb_id = "vox_digitigrade"

		else
			limb_id = SPECIES_VOX

/obj/item/bodypart/leg/right/vox
	mutcolor_used = MUTCOLORS_GENERIC_2
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ORGANIC | BODYTYPE_VOX_LEGS
	icon_greyscale = 'icons/mob/species/vox/bodyparts.dmi'
	limb_id = "vox_digitigrade"
	blood_print = BLOOD_PRINT_CLAWS
	barefoot_step_type = FOOTSTEP_MOB_CLAW

/obj/item/bodypart/leg/right/vox/update_limb(dropping_limb = FALSE, is_creating = FALSE)
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		var/uniform_compatible = FALSE
		var/suit_compatible = FALSE
		if(!(human_owner.w_uniform) || (human_owner.w_uniform.supports_variations_flags & CLOTHING_VOX_VARIATION)) //Checks uniform compatibility
			uniform_compatible = TRUE
		if((!human_owner.wear_suit) || (human_owner.wear_suit.supports_variations_flags & CLOTHING_VOX_VARIATION) || !(human_owner.wear_suit.body_parts_covered & LEGS)) //Checks suit compatability
			suit_compatible = TRUE

		if((uniform_compatible && suit_compatible) || (suit_compatible && (human_owner.obscured_slots & HIDEJUMPSUIT))) //If the uniform is hidden, it doesnt matter if its compatible
			limb_id = "vox_digitigrade"

		else
			limb_id = SPECIES_VOX
