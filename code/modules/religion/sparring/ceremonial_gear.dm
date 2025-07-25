TYPEINFO_DEF(/obj/item/ceremonial_blade)
	default_armor = list(BLUNT = 0, PUNCTURE = 0, SLASH = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 100, ACID = 50)
	default_materials = list(/datum/material/iron = 12000)

///ritual weapons. they're really bad, but they become normal weapons when sparring.
/obj/item/ceremonial_blade
	name = "ceremonial blade"
	desc = "A blade created to spar with. It seems weak, but if you spar with it...?"
	icon_state = "default"
	inhand_icon_state = "default"
	icon = 'icons/obj/items/ritual_weapon.dmi'

	//does the exact thing we want so heck why not
	greyscale_config = /datum/greyscale_config/ceremonial_blade
	greyscale_config_inhand_left = /datum/greyscale_config/ceremonial_blade_lefthand
	greyscale_config_inhand_right = /datum/greyscale_config/ceremonial_blade_righthand
	greyscale_colors = "#FFFFFF"

	hitsound = 'sound/weapons/bladeslice.ogg'
	force = 2 //20
	throwforce = 1 //10
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	block_chance = 3 //30
	sharpness = SHARP_EDGED
	max_integrity = 200
	material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX | MATERIAL_GREYSCALE //doesn't affect stats of the weapon as to avoid gamering your opponent with a dope weapon
	resistance_flags = FIRE_PROOF

/obj/item/ceremonial_blade/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, 40, 105)
	RegisterSignal(src, COMSIG_ITEM_SHARPEN_ACT, PROC_REF(block_sharpening))

/obj/item/ceremonial_blade/melee_attack_chain(mob/user, atom/target, params)
	if(!HAS_TRAIT(target, TRAIT_SPARRING))
		return ..()
	var/old_force = force
	var/old_throwforce = throwforce
	force *= 10
	throwforce *= 10
	. = ..()
	force = old_force
	throwforce = old_throwforce

/obj/item/ceremonial_blade/can_block_attack(mob/living/carbon/human/wielder, atom/movable/hitby, attack_type)
	if(attack_type != MELEE_ATTACK || !ishuman(hitby.loc))
		return FALSE
	return ..()

/obj/item/ceremonial_blade/get_block_chance(mob/living/carbon/human/wielder, atom/movable/hitby, damage, attack_type, armor_penetration)
	. = ..()
	if(HAS_TRAIT(hitby.loc, TRAIT_SPARRING))
		//becomes 30 block
		. *= 10

/obj/item/ceremonial_blade/proc/block_sharpening(datum/source, increment, max)
	SIGNAL_HANDLER
	//this breaks it
	return COMPONENT_BLOCK_SHARPEN_BLOCKED
