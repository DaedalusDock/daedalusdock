/**
 * The offhand dummy item for two handed items
 *
 */
/obj/item/offhand
	name = "offhand"
	icon_state = "offhand"
	w_class = WEIGHT_CLASS_HUGE
	item_flags = ABSTRACT | DROPDEL
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

	/// A weakref to the wielded item.
	var/datum/weakref/parent

/obj/item/offhand/Initialize(mapload, obj/item/parent_item)
	. = ..()
	if(!parent_item)
		return INITIALIZE_HINT_QDEL

	var/mob/living/wielder = loc
	RegisterSignal(wielder, COMSIG_MOB_SWAP_HANDS, PROC_REF(try_swap_hands))

	parent = WEAKREF(parent_item)
	name = "[parent_item.name] - offhand"
	desc = "Your second grip on [parent_item]."

	RegisterSignal(parent_item, list(COMSIG_ITEM_UNEQUIPPED, COMSIG_ITEM_UNWIELD), PROC_REF(deleteme))

/obj/item/offhand/unequipped(mob/user, silent = FALSE)
	. = ..()
	var/obj/item/I = parent.resolve()
	if(QDELETED(I) || !I.wielded)
		return

	I.unwield(user)

/obj/item/offhand/proc/deleteme(datum/source, mob/user)
	SIGNAL_HANDLER
	if(!QDELETED(src))
		qdel(src)

/obj/item/offhand/proc/try_swap_hands(datum/source, obj/item/held_item)
	SIGNAL_HANDLER

	return COMPONENT_BLOCK_SWAP
