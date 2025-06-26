/*/obj/item

	mob/listeningTo
	var/zoom_out_amt = 0
	var/zoom_amt = 0
	var/zoomable = FALSE

	var/inhand_icon_state  = null


/obj/item/Destroy()
	.=..()
	listeningTo = null
	return ..()

/obj/item/wield(mob/user)
	. = ..()
	if(!.)
		return

	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(on_walk))
	RegisterSignal(user, COMSIG_ATOM_DIR_CHANGE, PROC_REF(rotate))

	listeningTo = user
	user.visible_message(span_notice("[user] holds [src] up to [user.p_their()] eyes."), span_notice("You hold [src] up to your eyes."))
	inhand_icon_state = "binoculars_wielded"
	user.update_held_items()
	user.client.view_size.zoomOut(zoom_out_amt, zoom_amt, user.dir)

/obj/item/rotate(atom/thing, old_dir, new_dir)
	.=..()
	SIGNAL_HANDLER

	if(ismob(thing))
		var/mob/lad = thing
		lad.client.view_size.zoomOut(zoom_out_amt, zoom_amt, new_dir)

/obj/item/on_walk()
	.=..()
	SIGNAL_HANDLER

	attack_self(listeningTo) //Yes I have sinned, why do you ask?

/obj/item/unwield(mob/user)
	. = ..()

	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
		UnregisterSignal(listeningTo, COMSIG_ATOM_DIR_CHANGE)
		listeningTo = null

	user.visible_message(span_notice("[user] lowers [src]."), span_notice("You lower [src]."))
	inhand_icon_state = "binoculars"
	user.update_held_items()
	user.client.view_size.zoomIn()

*/
