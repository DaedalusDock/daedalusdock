/datum/grab/normal/kill
	downgrab = /datum/grab/normal/neck

	grab_slowdown = 1.4

	shift = 0
	stop_move = TRUE
	reverse_facing = TRUE
	point_blank_mult = 2
	damage_stage = GRAB_KILL
	same_tile = TRUE
	enable_violent_interactions = TRUE
	restrains = TRUE
	downgrade_on_action = TRUE
	downgrade_on_move = TRUE
	icon_state = "3"
	break_chance_table = list(5, 20, 40, 80, 100)

/datum/grab/normal/kill/apply_grab_effects(obj/item/hand_item/grab/G)
	. = ..()
	if(!isliving(G.affecting))
		return

	ADD_TRAIT(G.affecting, TRAIT_KILL_GRAB, REF(G))

/datum/grab/normal/kill/remove_grab_effects(obj/item/hand_item/grab/G)
	. = ..()
	REMOVE_TRAIT(G.affecting, TRAIT_KILL_GRAB, REF(G))

/datum/grab/normal/kill/enter_as_up(obj/item/hand_item/grab/G)
	. = ..()
	G.assailant.visible_message(
		span_danger("<b>[G.assailant]</b> begins to strangle [G.affecting]!"),
		blind_message = span_hear("You hear aggressive shuffling.")
	)
