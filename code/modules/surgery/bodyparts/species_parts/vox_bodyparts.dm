// voxs!
/obj/item/bodypart/head/vox
	icon_greyscale = 'icons/mob/species/vox/bodyparts.dmi'
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ORGANIC | BODYTYPE_VOX_BEAK
	limb_id = SPECIES_VOX
	is_dimorphic = TRUE

/obj/item/bodypart/chest/vox
	icon_greyscale = 'icons/mob/species/vox/bodyparts.dmi'
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ORGANIC | BODYTYPE_VOX_OTHER
	limb_id = SPECIES_VOX
	is_dimorphic = TRUE

/obj/item/bodypart/l_arm/vox
	mutcolor_used = MUTCOLORS2
	icon_greyscale = 'icons/mob/species/vox/bodyparts.dmi'
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ORGANIC | BODYTYPE_VOX_OTHER
	limb_id = SPECIES_VOX

/obj/item/bodypart/r_arm/vox
	mutcolor_used = MUTCOLORS2
	icon_greyscale = 'icons/mob/species/vox/bodyparts.dmi'
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ORGANIC | BODYTYPE_VOX_OTHER
	limb_id = SPECIES_VOX

/obj/item/bodypart/l_leg/vox
	mutcolor_used = MUTCOLORS2
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ORGANIC | BODYTYPE_VOX_LEGS
	icon_greyscale = 'icons/mob/species/vox/bodyparts.dmi'
	limb_id = "digitigrade"

/obj/item/bodypart/l_leg/vox/update_limb(dropping_limb = FALSE, is_creating = FALSE)
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		var/uniform_compatible = FALSE
		var/suit_compatible = FALSE
		if(!(human_owner.w_uniform) || (human_owner.w_uniform.supports_variations_flags & CLOTHING_VOX_VARIATION)) //Checks uniform compatibility
			uniform_compatible = TRUE
		if((!human_owner.wear_suit) || (human_owner.wear_suit.supports_variations_flags & CLOTHING_VOX_VARIATION) || !(human_owner.wear_suit.body_parts_covered & LEGS)) //Checks suit compatability
			suit_compatible = TRUE

		if((uniform_compatible && suit_compatible) || (suit_compatible && human_owner.wear_suit?.flags_inv & HIDEJUMPSUIT)) //If the uniform is hidden, it doesnt matter if its compatible
			limb_id = "digitigrade"

		else
			limb_id = SPECIES_VOX

/obj/item/bodypart/r_leg/vox
	mutcolor_used = MUTCOLORS2
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ORGANIC | BODYTYPE_VOX_LEGS
	icon_greyscale = 'icons/mob/species/vox/bodyparts.dmi'
	limb_id = "digitigrade"

/obj/item/bodypart/r_leg/vox/update_limb(dropping_limb = FALSE, is_creating = FALSE)
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		var/uniform_compatible = FALSE
		var/suit_compatible = FALSE
		if(!(human_owner.w_uniform) || (human_owner.w_uniform.supports_variations_flags & CLOTHING_VOX_VARIATION)) //Checks uniform compatibility
			uniform_compatible = TRUE
		if((!human_owner.wear_suit) || (human_owner.wear_suit.supports_variations_flags & CLOTHING_VOX_VARIATION) || !(human_owner.wear_suit.body_parts_covered & LEGS)) //Checks suit compatability
			suit_compatible = TRUE

		if((uniform_compatible && suit_compatible) || (suit_compatible && human_owner.wear_suit?.flags_inv & HIDEJUMPSUIT)) //If the uniform is hidden, it doesnt matter if its compatible
			limb_id = "digitigrade"

		else
			limb_id = SPECIES_VOX
