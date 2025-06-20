/// Max number of atoms a broom can sweep at once
#define BROOM_PUSH_LIMIT 20

/obj/item/pushbroom
	name = "push broom"
	desc = "This is my BROOMSTICK! It can be used manually or braced with two hands to sweep items as you move. It has a telescopic handle for compact storage."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "broom0"
	base_icon_state = "broom"
	lefthand_file = 'icons/mob/inhands/equipment/custodial_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/custodial_righthand.dmi'

	force = 8
	force_wielded = 12
	throwforce = 10
	throw_speed = 1.5
	throw_range = 7

	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("sweeps", "brushes off", "bludgeons", "whacks")
	attack_verb_simple = list("sweep", "brush off", "bludgeon", "whack")
	resistance_flags = FLAMMABLE

/obj/item/pushbroom/Initialize(mapload)
	. = ..()
	icon_state_wielded = "[base_icon_state][1]"

/obj/item/pushbroom/update_icon_state()
	icon_state = "[base_icon_state]0"
	return ..()

/obj/item/pushbroom/wield(mob/user)
	. = ..()
	if(!.)
		return
	RegisterSignal(user, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(sweep))

/obj/item/pushbroom/unwield(mob/user)
	. = ..()
	if(!.)
		return

	UnregisterSignal(user, COMSIG_MOVABLE_PRE_MOVE)

/obj/item/pushbroom/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(user.combat_mode)
		return

	sweep(user, interacting_with)
	return ITEM_INTERACT_SUCCESS

/**
 * Attempts to push up to BROOM_PUSH_LIMIT atoms from a given location the user's faced direction
 *
 * Arguments:
 * * user - The user of the pushbroom
 * * A - The atom which is located at the location to push atoms from
 */
/obj/item/pushbroom/proc/sweep(mob/user, atom/A)
	SIGNAL_HANDLER

	var/turf/current_item_loc = isturf(A) ? A : A.loc
	if (!isturf(current_item_loc))
		return
	var/turf/new_item_loc = get_step(current_item_loc, user.dir)
	var/obj/machinery/disposal/bin/target_bin = locate(/obj/machinery/disposal/bin) in new_item_loc.contents
	var/i = 1
	for (var/obj/item/garbage in current_item_loc.contents)
		if (!garbage.anchored)
			if (target_bin)
				garbage.forceMove(target_bin)
			else
				garbage.Move(new_item_loc, user.dir)
			i++
		if (i > BROOM_PUSH_LIMIT)
			break
	if (i > 1)
		if (target_bin)
			target_bin.update_appearance()
			to_chat(user, span_notice("You sweep the pile of garbage into [target_bin]."))
		playsound(loc, 'sound/weapons/thudswoosh.ogg', 30, TRUE, -1)


/obj/item/pushbroom/cyborg
	name = "cyborg push broom"

/obj/item/pushbroom/cyborg/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CYBORG_ITEM_TRAIT)
