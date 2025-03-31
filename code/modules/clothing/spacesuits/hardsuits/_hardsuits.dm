/// How much damage you take from an emp when wearing a hardsuit
#define HARDSUIT_EMP_BURN 2 // a very orange number

/obj/item/clothing/suit/space/hardsuit
	name = "voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding."
	icon = 'icons/obj/clothing/hardsuits/suit.dmi'
	worn_icon = 'icons/mob/clothing/hardsuit/hardsuit_body.dmi'
	icon_state = "hardsuit-engineering"
	inhand_icon_state = "eng_hardsuit"
	max_integrity = 300
	armor = list(BLUNT = 10, PUNCTURE = 5, SLASH = 0, LASER = 10, ENERGY = 20, BOMB = 10, BIO = 100, FIRE = 50, ACID = 75)
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/t_scanner, /obj/item/construction/rcd, /obj/item/pipe_dispenser)
	siemens_coefficient = 0
	actions_types = list(/datum/action/item_action/toggle_spacesuit, /datum/action/item_action/toggle_helmet)
	supports_variations_flags = CLOTHING_TESHARI_VARIATION
	slowdown = 1

	var/obj/item/clothing/head/helmet/space/hardsuit/helmet
	var/helmettype = /obj/item/clothing/head/helmet/space/hardsuit
	/// Whether the helmet is on.
	var/helmet_on = FALSE

/obj/item/clothing/suit/space/hardsuit/Initialize(mapload)
	. = ..()

	MakeHelmet()

/obj/item/clothing/suit/space/hardsuit/Destroy()
	if(!QDELETED(helmet))
		QDEL_NULL(helmet)
	return ..()

/obj/item/clothing/suit/space/hardsuit/proc/MakeHelmet()
	if(!helmettype)
		return
	if(!helmet)
		var/obj/item/clothing/head/helmet/space/hardsuit/W = new helmettype(src)
		W.suit = src
		helmet = W

/obj/item/clothing/suit/space/hardsuit/proc/RemoveHelmet()
	if(!helmet)
		return
	helmet_on = FALSE
	if(ishuman(helmet.loc))
		var/mob/living/carbon/H = helmet.loc
		if(helmet.on)
			helmet.attack_self(H)
		H.transferItemToLoc(helmet, src, TRUE)
		H.update_worn_oversuit()
		to_chat(H, span_notice("The helmet on the hardsuit disengages."))
		playsound(src.loc, 'sound/mecha/mechmove03.ogg', 50, TRUE)
	else
		helmet.forceMove(src)

/obj/item/clothing/suit/space/hardsuit/proc/ToggleHelmet()
	var/mob/living/carbon/human/H = src.loc
	if(!istype(src.loc) || !helmettype)
		return
	if(!helmet)
		to_chat(H, span_warning("The helmet's lightbulb seems to be damaged! You'll need a replacement bulb."))
		return
	if(!helmet_on)
		if(H.wear_suit != src)
			to_chat(H, span_warning("You must be wearing [src] to engage the helmet!"))
			return
		if(H.head)
			to_chat(H, span_warning("You're already wearing something on your head!"))
			return
		else if(H.equip_to_slot_if_possible(helmet,ITEM_SLOT_HEAD,0,0,1))
			to_chat(H, span_notice("You engage the helmet on the hardsuit."))
			helmet_on = TRUE
			H.update_worn_oversuit()
			playsound(src.loc, 'sound/mecha/mechmove03.ogg', 50, TRUE)
	else
		RemoveHelmet()

/obj/item/clothing/suit/space/hardsuit/ui_action_click(mob/user, actiontype)
	if(istype(actiontype, /datum/action/item_action/toggle_helmet))
		ToggleHelmet()
	else
		return ..()

/obj/item/clothing/suit/space/hardsuit/attack_self(mob/user)
	user.changeNext_move(CLICK_CD_MELEE)
	..()

/obj/item/clothing/suit/space/hardsuit/examine(mob/user)
	. = ..()
	if(!helmet && helmettype)
		. += span_notice("The helmet on [src] seems to be malfunctioning. Its light bulb needs to be replaced.")

/obj/item/clothing/suit/space/hardsuit/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/light) && helmettype)
		if(src == user.get_item_by_slot(ITEM_SLOT_OCLOTHING))
			to_chat(user, span_warning("You cannot replace the bulb in the helmet of [src] while wearing it."))
			return
		if(helmet)
			to_chat(user, span_warning("The helmet of [src] does not require a new bulb."))
			return
		var/obj/item/light/L = I
		if(L.status)
			to_chat(user, span_warning("This bulb is too damaged to use as a replacement!"))
			return
		if(do_after(user, 5 SECONDS, src))
			qdel(I)
			helmet = new helmettype(src)
			to_chat(user, span_notice("You have successfully repaired [src]'s helmet."))
			new /obj/item/light/bulb/broken(drop_location())
	return ..()

/obj/item/clothing/suit/space/hardsuit/equipped(mob/user, slot)
	..()
	if(helmet && slot != ITEM_SLOT_OCLOTHING)
		RemoveHelmet()

/obj/item/clothing/suit/space/hardsuit/unequipped(mob/user)
	..()
	RemoveHelmet()

/obj/item/clothing/suit/space/hardsuit/item_action_slot_check(slot)
	if(slot == ITEM_SLOT_OCLOTHING) //we only give the mob the ability to toggle the helmet if he's wearing the hardsuit.
		return 1

/// Burn the person inside the hard suit just a little, the suit got really hot for a moment
/obj/item/clothing/suit/space/emp_act(severity)
	. = ..()
	var/mob/living/carbon/human/user = src.loc
	if(istype(user))
		user.apply_damage(HARDSUIT_EMP_BURN, BURN, spread_damage=TRUE)
		to_chat(user, span_warning("You feel \the [src] heat up from the EMP burning you slightly."))

		// Chance to scream
		if (user.stat < UNCONSCIOUS && prob(10))
			user.emote("scream")
