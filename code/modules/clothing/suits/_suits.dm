/obj/item/clothing/suit
	name = "suit"
	icon = 'icons/obj/clothing/suits.dmi'
	fallback_colors = list(list(13, 15))
	fallback_icon_state = "coat"

	allowed = list(/obj/item/tank/internals/emergency_oxygen)

	armor = list(BLUNT = 0, PUNCTURE = 0, SLASH = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 0)

	drop_sound = 'sound/items/handling/cloth_drop.ogg'
	pickup_sound = 'sound/items/handling/cloth_pickup.ogg'

	equip_self_flags = NONE
	equip_delay_self = EQUIP_DELAY_OVERSUIT
	equip_delay_other = EQUIP_DELAY_OVERSUIT * 1.5
	strip_delay = EQUIP_DELAY_OVERSUIT * 1.5

	slot_flags = ITEM_SLOT_OCLOTHING

	limb_integrity = 0 // disabled for most exo-suits

	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION
	var/blood_overlay_type = "suit"
	var/fire_resist = T0C+100

/obj/item/clothing/suit/Initialize(mapload)
	. = ..()
	setup_shielding()

/obj/item/clothing/suit/worn_overlays(mob/living/carbon/human/wearer, mutable_appearance/standing, isinhands = FALSE)
	. = ..()
	if(isinhands)
		return

	if(damaged_clothes)
		. += mutable_appearance('icons/effects/item_damage.dmi', "damaged[blood_overlay_type]")
	var/list/dna = return_blood_DNA()
	if(length(dna))
		if(istype(wearer))
			var/obj/item/bodypart/chest = wearer.get_bodypart(BODY_ZONE_CHEST)
			if(!chest?.icon_bloodycover)
				return
			. += image(chest.icon_bloodycover, "[blood_overlay_type]blood")
			var/image/bloody_overlay = image(chest.icon_bloodycover, "[blood_overlay_type]blood")
			bloody_overlay.color = get_blood_dna_color(dna)
			. += bloody_overlay
		else
			. += mutable_appearance('icons/effects/blood.dmi', "[blood_overlay_type]blood")

	var/mob/living/carbon/human/M = loc
	if(!ishuman(M) || !M.w_uniform)
		return
	var/obj/item/clothing/under/U = M.w_uniform
	if(istype(U) && U.attached_accessory)
		var/obj/item/clothing/accessory/A = U.attached_accessory
		if(A.above_suit)
			. += U.accessory_overlay

/**
 * Wrapper proc to apply shielding through AddComponent().
 * Called in /obj/item/clothing/Initialize().
 * Override with an AddComponent(/datum/component/shielded, args) call containing the desired shield statistics.
 * See /datum/component/shielded documentation for a description of the arguments
 **/
/obj/item/clothing/suit/proc/setup_shielding()
	return
