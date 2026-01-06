/**
 * Pitchfork item
 *
 * Essentially spears with different stats and sprites.
 * Also fireproof for some reason.
 */
TYPEINFO_DEF(/obj/item/pitchfork)
	default_armor = list(BLUNT = 0, PUNCTURE = 0, SLASH = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 100, ACID = 30)

/obj/item/pitchfork
	icon_state = "pitchfork0"
	base_icon_state = "pitchfork"
	lefthand_file = 'icons/mob/inhands/weapons/polearms_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/polearms_righthand.dmi'
	icon_state_wielded = "pitchfork1"

	name = "pitchfork"
	desc = "A simple tool used for moving hay."

	force = 7
	force_wielded = 15
	throwforce = 15
	sharpness = SHARP_EDGED

	w_class = WEIGHT_CLASS_BULKY
	attack_verb_continuous = list("attacks", "impales", "pierces")
	attack_verb_simple = list("attack", "impale", "pierce")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = SHARP_EDGED
	max_integrity = 200
	resistance_flags = FIRE_PROOF

/obj/item/pitchfork/update_icon_state()
	icon_state = "[base_icon_state]0"
	return ..()
