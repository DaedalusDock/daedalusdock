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
	icon_state = "kill1"
	break_chance_table = list(5, 20, 40, 80, 100)

/datum/grab/normal/kill/apply_unique_grab_effects(atom/movable/affecting)
	. = ..()
	ADD_TRAIT(affecting, TRAIT_KILL_GRAB, KILL_GRAB)

/datum/grab/normal/kill/remove_unique_grab_effects(atom/movable/affecting)
	. = ..()
	REMOVE_TRAIT(affecting, TRAIT_KILL_GRAB, KILL_GRAB)

/datum/grab/normal/kill/enter_as_up(obj/item/hand_item/grab/G, silent)
	. = ..()
	if(!silent)
		G.assailant.visible_message(
			span_danger("<b>[G.assailant]</b> begins to strangle [G.affecting]!"),
			blind_message = span_hear("You hear aggressive shuffling."),
			vision_distance = COMBAT_MESSAGE_RANGE
		)
