/obj/item/clothing/gloves
	name = "gloves"
	gender = PLURAL //Carn: for grammarically correct text-parsing
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/clothing/gloves.dmi'
	fallback_colors = list(list(10, 13))
	fallback_icon_state = "gloves"
	siemens_coefficient = 0.5
	body_parts_covered = HANDS
	slot_flags = ITEM_SLOT_GLOVES
	supports_variations_flags = CLOTHING_VOX_VARIATION
	attack_verb_continuous = list("challenges")
	attack_verb_simple = list("challenge")

	equip_delay_self = EQUIP_ALLOW_MOVEMENT
	equip_delay_self = EQUIP_DELAY_GLOVES
	equip_delay_other = EQUIP_DELAY_GLOVES + (3 SECONDS)
	strip_delay = EQUIP_DELAY_GLOVES + (3 SECONDS)

	// Path variable. If defined, will produced the type through interaction with wirecutters.
	var/cut_type = null
	/// Used for handling bloody gloves leaving behind bloodstains on objects. Will be decremented whenever a bloodstain is left behind, and be incremented when the gloves become bloody.
	var/transfer_blood = 0

/obj/item/clothing/gloves/wash(clean_types)
	. = ..()
	if((clean_types & CLEAN_TYPE_BLOOD) && transfer_blood > 0)
		transfer_blood = 0
		return TRUE

/obj/item/clothing/gloves/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("\the [src] are forcing [user]'s hands around [user.p_their()] neck! It looks like the gloves are possessed!"))
	return OXYLOSS

/obj/item/clothing/gloves/worn_overlays(mob/living/carbon/human/wearer, mutable_appearance/standing, isinhands = FALSE)
	. = ..()
	if(isinhands)
		return

	if(damaged_clothes)
		. += mutable_appearance('icons/effects/item_damage.dmi', "damagedgloves")

	var/list/dna = return_blood_DNA()
	if(length(dna))
		if(istype(wearer))
			var/obj/item/bodypart/arm = wearer.get_bodypart(BODY_ZONE_R_ARM) || wearer.get_bodypart(BODY_ZONE_L_ARM)
			if(!arm?.icon_bloodycover)
				return
			var/image/bloody_overlay = image(arm.icon_bloodycover, "bloodyhands")
			bloody_overlay.color = get_blood_dna_color(dna)
			. += bloody_overlay
		else
			. += mutable_appearance('icons/effects/blood.dmi', "bloodyhands")

/obj/item/clothing/gloves/wirecutter_act(mob/living/user, obj/item/I)
	. = ..()
	if(!cut_type)
		return
	if(icon_state != initial(icon_state))
		return // We don't want to cut dyed gloves.
	new cut_type(drop_location())
	qdel(src)
	return TRUE
