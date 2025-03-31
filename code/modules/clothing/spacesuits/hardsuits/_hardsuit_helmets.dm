/obj/item/clothing/head/helmet/space/hardsuit
	name = "voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has radiation shielding."
	icon = 'icons/obj/clothing/hardsuits/helmet.dmi'
	worn_icon = 'icons/mob/clothing/hardsuit/hardsuit_helm.dmi'
	icon_state = "hardsuit0-engineering"
	inhand_icon_state = "eng_helm"
	max_integrity = 300
	armor = list(BLUNT = 10, PUNCTURE = 5, SLASH = 0, LASER = 10, ENERGY = 20, BOMB = 10, BIO = 100, FIRE = 50, ACID = 75)
	light_system = OVERLAY_LIGHT_DIRECTIONAL
	light_outer_range = 4
	light_power = 1
	light_on = FALSE
	actions_types = list(/datum/action/item_action/toggle_helmet_light)
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	supports_variations_flags = CLOTHING_TESHARI_VARIATION

	var/basestate = "hardsuit"
	var/on = FALSE
	var/obj/item/clothing/suit/space/hardsuit/suit
	var/hardsuit_type = "engineering" //Determines used sprites: hardsuit[on]-[type]

/obj/item/clothing/head/helmet/space/hardsuit/Destroy()
	if(!QDELETED(suit))
		QDEL_NULL(suit)
	return ..()

/obj/item/clothing/head/helmet/space/hardsuit/update_icon_state()
	. = ..()
	icon_state = "[basestate][on]-[hardsuit_type]"

/obj/item/clothing/head/helmet/space/hardsuit/attack_self(mob/user)
	on = !on
	update_icon(UPDATE_ICON_STATE)

	set_light_on(on)

	update_action_buttons()

/obj/item/clothing/head/helmet/space/hardsuit/unequipped(mob/user)
	..()
	if(suit)
		suit.RemoveHelmet()

/obj/item/clothing/head/helmet/space/hardsuit/item_action_slot_check(slot)
	if(slot == ITEM_SLOT_HEAD)
		return 1

/obj/item/clothing/head/helmet/space/hardsuit/equipped(mob/user, slot)
	..()
	if(slot != ITEM_SLOT_HEAD)
		if(suit)
			suit.RemoveHelmet()
		else
			qdel(src)

/obj/item/clothing/head/helmet/space/hardsuit/proc/display_visor_message(msg)
	var/mob/wearer = loc
	if(msg && ishuman(wearer))
		wearer.play_screen_text(msg, /atom/movable/screen/text/screen_text/picture/hardsuit_visor)

/obj/item/clothing/head/helmet/space/hardsuit/emp_act(severity)
	. = ..()
	display_visor_message("<b>[severity > 1 ? "LIGHT" : "STRONG"] ELECTROMAGNETIC PULSE DETECTED!</b>")
