/obj/item/clothing/mask
	name = "mask"
	icon = 'icons/obj/clothing/masks.dmi'
	body_parts_covered = HEAD
	slot_flags = ITEM_SLOT_MASK
	strip_delay = 40
	equip_delay_other = 40
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION | CLOTHING_VOX_VARIATION

	equip_delay_self = EQUIP_DELAY_MASK
	equip_delay_other = EQUIP_DELAY_MASK * 1.5
	strip_delay = EQUIP_DELAY_MASK * 1.5

	var/modifies_speech = FALSE
	var/mask_adjusted = FALSE
	var/adjusted_flags = null
	///Did we install a filtering cloth?
	var/has_filter = FALSE

/obj/item/clothing/mask/attack_self(mob/user)
	if((clothing_flags & VOICEBOX_TOGGLABLE))
		clothing_flags ^= (VOICEBOX_DISABLED)
		var/status = !(clothing_flags & VOICEBOX_DISABLED)
		to_chat(user, span_notice("You turn the voice box in [src] [status ? "on" : "off"]."))

/obj/item/clothing/mask/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(istype(W, /obj/item/voice_changer))
		if(!(flags_inv & HIDEFACE))
			to_chat(user, span_warning("[src] is not compatible with [W]."))
			return TRUE
		if(!user.is_holding(src))
			to_chat(user, span_warning("You must be holding [src] to do that."))
			return TRUE
		if(!do_after(user, src, 5 SECONDS, DO_PUBLIC, display = W))
			return TRUE
		AddComponent(/datum/component/voice_changer, W)
		to_chat(user, span_notice("You insert [W] into [src]."))
		return TRUE

/obj/item/clothing/mask/equipped(mob/M, slot)
	. = ..()
	if (slot == ITEM_SLOT_MASK && modifies_speech)
		RegisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	else
		UnregisterSignal(M, COMSIG_MOB_SAY)

/obj/item/clothing/mask/unequipped(mob/M)
	. = ..()
	UnregisterSignal(M, COMSIG_MOB_SAY)

/obj/item/clothing/mask/vv_edit_var(vname, vval)
	if(vname == NAMEOF(src, modifies_speech) && equipped_to)
		if(equipped_to.get_item_by_slot(ITEM_SLOT_MASK) == src)
			if(vval)
				if(!modifies_speech)
					RegisterSignal(equipped_to, COMSIG_MOB_SAY, PROC_REF(handle_speech))
			else if(modifies_speech)
				UnregisterSignal(equipped_to, COMSIG_MOB_SAY)
	return ..()

/obj/item/clothing/mask/proc/handle_speech()
	SIGNAL_HANDLER

/obj/item/clothing/mask/worn_overlays(mob/living/carbon/human/wearer, mutable_appearance/standing, isinhands = FALSE)
	. = ..()
	if(isinhands)
		return

	if(body_parts_covered & HEAD)
		if(damaged_clothes)
			. += mutable_appearance('icons/effects/item_damage.dmi', "damagedmask")

		var/list/dna = return_blood_DNA()
		if(length(dna))
			if(istype(wearer))
				var/obj/item/bodypart/head = wearer.get_bodypart(BODY_ZONE_HEAD)
				if(!head?.icon_bloodycover)
					return
				var/image/bloody_overlay = image(head.icon_bloodycover, "maskblood")
				bloody_overlay.color = get_blood_dna_color(dna)
				. += bloody_overlay
			else
				. += mutable_appearance('icons/effects/blood.dmi', "maskblood")

//Proc that moves gas/breath masks out of the way, disabling them and allowing pill/food consumption
/obj/item/clothing/mask/proc/adjustmask(mob/living/carbon/user)
	if(user?.incapacitated())
		return

	mask_adjusted = !mask_adjusted

	if(!mask_adjusted)
		icon_state = initial(icon_state)
		permeability_coefficient = initial(permeability_coefficient)
		clothing_flags |= visor_flags
		flags_inv |= visor_flags_inv
		flags_cover |= visor_flags_cover
		to_chat(user, span_notice("You push \the [src] back into place."))
		slot_flags = initial(slot_flags)

	else
		icon_state += "_up"
		to_chat(user, span_notice("You push \the [src] out of the way."))
		permeability_coefficient = 1
		clothing_flags &= ~visor_flags
		flags_inv &= ~visor_flags_inv
		flags_cover &= ~visor_flags_cover
		if(adjusted_flags)
			slot_flags = adjusted_flags

	if(!istype(user))
		return

	if(user.wear_mask == src)
		user.update_slots_for_item(src, ITEM_SLOT_MASK, TRUE)
		user.wear_mask_update(src, toggle_off = mask_adjusted)

	if(loc == user)
		user.update_mob_action_buttons() //when mask is adjusted out, we update all buttons icon so the user's potential internal tank correctly shows as off.

/**
 * Proc called in lungs.dm to act if wearing a mask with filters, used to reduce the filters durability, return a changed gas mixture depending on the filter status
 * Arguments:
 * * breath - the gas mixture of the breather
 */
/obj/item/clothing/mask/proc/consume_filter(datum/gas_mixture/breath)
	return breath
