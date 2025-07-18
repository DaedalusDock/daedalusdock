TYPEINFO_DEF(/obj/item/clothing/head/hooded/ablative)
	default_armor = list(BLUNT = 10, PUNCTURE = 10, SLASH = 0, LASER = 60, ENERGY = 60, BOMB = 0, BIO = 0, FIRE = 100, ACID = 100)

/obj/item/clothing/head/hooded/ablative
	name = "ablative hood"
	desc = "Hood hopefully belonging to an ablative trenchcoat. Includes a visor for cool-o-vision."
	icon_state = "ablativehood"
	strip_delay = 30
	var/hit_reflect_chance = 50

/obj/item/clothing/head/hooded/ablative/IsReflect(def_zone)
	if(def_zone != BODY_ZONE_HEAD) //If not shot where ablative is covering you, you don't get the reflection bonus!
		return FALSE
	if (prob(hit_reflect_chance))
		return TRUE

TYPEINFO_DEF(/obj/item/clothing/suit/hooded/ablative)
	default_armor = list(BLUNT = 10, PUNCTURE = 10, SLASH = 0, LASER = 60, ENERGY = 60, BOMB = 0, BIO = 0, FIRE = 100, ACID = 100)

/obj/item/clothing/suit/hooded/ablative
	name = "ablative trenchcoat"
	desc = "Experimental trenchcoat specially crafted to reflect and absorb laser and disabler shots. Don't expect it to do all that much against an axe or a shotgun, however."
	icon_state = "ablativecoat"
	inhand_icon_state = "ablativecoat"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	hoodtype = /obj/item/clothing/head/hooded/ablative
	strip_delay = 30
	equip_delay_other = 40
	var/hit_reflect_chance = 50

/obj/item/clothing/suit/hooded/ablative/Initialize(mapload)
	. = ..()
	allowed = GLOB.security_vest_allowed

/obj/item/clothing/suit/hooded/ablative/IsReflect(def_zone)
	if(!(def_zone in list(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_GROIN, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))) //If not shot where ablative is covering you, you don't get the reflection bonus!
		return FALSE
	if (prob(hit_reflect_chance))
		return TRUE

/obj/item/clothing/suit/hooded/ablative/on_hood_equip(mob/living/wearer, obj/item/clothing/hood)
	var/mob/living/carbon/user = loc
	var/datum/atom_hud/hud = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
	ADD_TRAIT(user, TRAIT_SECURITY_HUD, HELMET_TRAIT)
	hud.show_to(user)

/obj/item/clothing/suit/hooded/ablative/on_hood_unequip(obj/item/clothing/hood)
	var/mob/living/carbon/user = equipped_to
	var/datum/atom_hud/hud = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
	REMOVE_TRAIT(user, TRAIT_SECURITY_HUD, HELMET_TRAIT)
	hud.hide_from(user)
