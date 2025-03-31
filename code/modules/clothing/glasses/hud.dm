/obj/item/clothing/glasses/hud
	name = "HUD"
	desc = "A heads-up display that provides important info in (almost) real time."
	flags_1 = null //doesn't protect eyes because it's a monocle, duh
	var/hud_type = null
	///Used for topic calls. Just because you have a HUD display doesn't mean you should be able to interact with stuff.
	var/hud_trait = null


/obj/item/clothing/glasses/hud/equipped(mob/living/carbon/human/user, slot)
	..()
	if(slot != ITEM_SLOT_EYES)
		return
	if(hud_type)
		var/datum/atom_hud/H = GLOB.huds[hud_type]
		H.show_to(user)
	if(hud_trait)
		ADD_TRAIT(user, hud_trait, GLASSES_TRAIT)

/obj/item/clothing/glasses/hud/unequipped(mob/living/carbon/human/user)
	..()
	if(!istype(user) || user.glasses != src)
		return
	if(hud_type)
		var/datum/atom_hud/H = GLOB.huds[hud_type]
		H.hide_from(user)
	if(hud_trait)
		REMOVE_TRAIT(user, hud_trait, GLASSES_TRAIT)

/obj/item/clothing/glasses/hud/emp_act(severity)
	. = ..()
	if(obj_flags & EMAGGED || . & EMP_PROTECT_SELF)
		return
	obj_flags |= EMAGGED
	desc = "[desc] The display is flickering slightly."

/obj/item/clothing/glasses/hud/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	to_chat(user, span_warning("PZZTTPFFFT"))
	desc = "[desc] The display is flickering slightly."

/obj/item/clothing/glasses/hud/suicide_act(mob/user)
	if(user.is_blind() || !isliving(user))
		return ..()
	var/mob/living/living_user = user
	user.visible_message(span_suicide("[user] looks through [src] and looks overwhelmed with the information! It looks like [user.p_theyre()] trying to commit suicide!"))
	if(living_user.getOrganLoss(ORGAN_SLOT_BRAIN) >= BRAIN_DAMAGE_SEVERE)
		var/mob/thing = pick((/mob in view()) - user)
		if(thing)
			user.say("VALID MAN IS WANTER, ARREST HE!!")
			user.pointed(thing)
		else
			user.say("WHY IS THERE A BAR ON MY HEAD?!!")
	return OXYLOSS

/obj/item/clothing/glasses/hud/health
	name = "health scanner HUD"
	desc = "A heads-up display that scans the humanoids in view and provides accurate data about their health status."
	icon_state = "healthhud"
	hud_type = DATA_HUD_MEDICAL_ADVANCED
	hud_trait = TRAIT_MEDICAL_HUD
	glass_colour_type = /datum/client_colour/glass_colour/lightblue
	supports_variations_flags = CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/glasses/hud/health/night
	name = "night vision health scanner HUD"
	desc = "An advanced medical head-up display that allows doctors to find patients in complete darkness."
	icon_state = "healthhudnight"
	inhand_icon_state = "glasses"
	darkness_view = 8
	flash_protect = FLASH_PROTECTION_SENSITIVE
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	glass_colour_type = /datum/client_colour/glass_colour/green

/obj/item/clothing/glasses/hud/health/sunglasses
	name = "medical HUDSunglasses"
	desc = "Sunglasses with a medical HUD."
	icon_state = "sunhudmed"
	darkness_view = 1
	flash_protect = FLASH_PROTECTION_FLASH
	tint = 1
	glass_colour_type = /datum/client_colour/glass_colour/blue

/obj/item/clothing/glasses/hud/diagnostic
	name = "diagnostic HUD"
	desc = "A heads-up display capable of analyzing the integrity and status of robotics and exosuits."
	icon_state = "diagnostichud"
	hud_type = DATA_HUD_DIAGNOSTIC_BASIC
	hud_trait = TRAIT_DIAGNOSTIC_HUD
	glass_colour_type = /datum/client_colour/glass_colour/lightorange

/obj/item/clothing/glasses/hud/diagnostic/night
	name = "night vision diagnostic HUD"
	desc = "A robotics diagnostic HUD fitted with a light amplifier."
	icon_state = "diagnostichudnight"
	inhand_icon_state = "glasses"
	darkness_view = 8
	flash_protect = FLASH_PROTECTION_SENSITIVE
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	glass_colour_type = /datum/client_colour/glass_colour/green

/obj/item/clothing/glasses/hud/diagnostic/sunglasses
	name = "diagnostic sunglasses"
	desc = "Sunglasses with a diagnostic HUD."
	icon_state = "sunhuddiag"
	inhand_icon_state = "glasses"
	flash_protect = FLASH_PROTECTION_FLASH
	tint = 1

/obj/item/clothing/glasses/hud/toggle
	name = "Toggle HUD"
	desc = "A hud with multiple functions."
	actions_types = list(/datum/action/item_action/switch_hud)

/obj/item/clothing/glasses/hud/toggle/attack_self(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/wearer = user
	if (wearer.glasses != src)
		return

	if (hud_type)
		var/datum/atom_hud/H = GLOB.huds[hud_type]
		H.hide_from(user)

	if (hud_type == DATA_HUD_MEDICAL_ADVANCED)
		hud_type = null
	else if (hud_type == DATA_HUD_SECURITY_ADVANCED)
		hud_type = DATA_HUD_MEDICAL_ADVANCED
	else
		hud_type = DATA_HUD_SECURITY_ADVANCED

	if (hud_type)
		var/datum/atom_hud/H = GLOB.huds[hud_type]
		H.show_to(user)

/datum/action/item_action/switch_hud
	name = "Switch HUD"

/obj/item/clothing/glasses/hud/toggle/thermal
	name = "thermal HUD scanner"
	desc = "Thermal imaging HUD in the shape of glasses."
	icon_state = "thermal"
	hud_type = DATA_HUD_SECURITY_ADVANCED
	vision_flags = SEE_MOBS
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	glass_colour_type = /datum/client_colour/glass_colour/red

/obj/item/clothing/glasses/hud/toggle/thermal/attack_self(mob/user)
	..()
	switch (hud_type)
		if (DATA_HUD_MEDICAL_ADVANCED)
			icon_state = "meson"
			change_glass_color(user, /datum/client_colour/glass_colour/green)
		if (DATA_HUD_SECURITY_ADVANCED)
			icon_state = "thermal"
			change_glass_color(user, /datum/client_colour/glass_colour/red)
		else
			icon_state = "purple"
			change_glass_color(user, /datum/client_colour/glass_colour/purple)
	user.update_worn_glasses()

/obj/item/clothing/glasses/hud/toggle/thermal/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	thermal_overload()

/obj/item/clothing/glasses/hud/spacecop
	name = "police aviators"
	desc = "For thinking you look cool while brutalizing protestors and minorities."
	icon_state = "bigsunglasses"
	darkness_view = 1
	flash_protect = FLASH_PROTECTION_FLASH
	tint = 1
	glass_colour_type = /datum/client_colour/glass_colour/gray
	supports_variations_flags = CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION


/obj/item/clothing/glasses/hud/spacecop/hidden // for the undercover cop
	name = "sunglasses"
	desc = "These sunglasses are special, and let you view potential criminals."
	icon_state = "sun"
	inhand_icon_state = "sunglasses"

