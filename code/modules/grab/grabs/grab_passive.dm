/datum/grab/normal/passive
	upgrab = /datum/grab/normal/aggressive
	shift = 8
	stop_move = 0
	reverse_facing = 0
	point_blank_mult = 1.1
	same_tile = 0
	icon_state = "1"
	break_chance_table = list(15, 60, 100)

/datum/grab/normal/passive/on_hit_disarm(obj/item/hand_item/grab/G, atom/A)
	to_chat(G.assailant, span_warning("Your grip isn't strong enough to pin."))
	return FALSE

/datum/grab/normal/passive/on_hit_grab(obj/item/hand_item/grab/G, atom/A)
	to_chat(G.assailant, span_warning("Your grip isn't strong enough to jointlock."))
	return FALSE

/datum/grab/normal/passive/on_hit_harm(obj/item/hand_item/grab/G, atom/A)
	to_chat(G.assailant, span_warning("Your grip isn't strong enough to dislocate."))
	return FALSE

/datum/grab/normal/passive/resolve_openhand_attack(obj/item/hand_item/grab/G)
	return FALSE
