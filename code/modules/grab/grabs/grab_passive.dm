/datum/grab/normal/passive
	upgrab = /datum/grab/normal/struggle
	shift = 8
	stop_move = 0
	reverse_facing = 0
	point_blank_mult = 1.1
	same_tile = 0
	icon_state = "!reinforce"
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

/datum/grab/normal/passive/on_hit_help(obj/item/hand_item/grab/G, atom/A)
	if(isitem(A) && ishuman(G.assailant) && (G.affecting == A))
		var/obj/item/I = G.affecting
		var/mob/living/carbon/human/H = G.assailant
		qdel(G)
		H.put_in_active_hand(I)
		return

/datum/grab/normal/passive/resolve_openhand_attack(obj/item/hand_item/grab/G)
	return FALSE
