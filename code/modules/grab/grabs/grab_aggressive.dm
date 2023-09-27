/datum/grab/normal/aggressive
	//upgrab =   /datum/grab/normal/neck
	downgrab = /datum/grab/normal/passive
	shift = 12
	stop_move = 1
	reverse_facing = 0
	shield_assailant = 0
	point_blank_mult = 1.5
	damage_stage = 1
	same_tile = 0
	can_throw = 1
	force_danger = 1
	breakability = 3
	icon_state = "2"

	break_chance_table = list(5, 20, 40, 80, 100)

/datum/grab/normal/aggressive/process_effect(obj/item/hand_item/grab/G)
	var/mob/living/affecting_mob = G.get_affecting_mob()
	if(istype(affecting_mob))
		if(G.target_zone in list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM))
			affecting_mob.drop_all_held_items()
		// Keeps those who are on the ground down
		if(affecting_mob.body_position == LYING_DOWN)
			affecting_mob.Knockdown(4 SECONDS)

/datum/grab/normal/aggressive/can_upgrade(obj/item/hand_item/grab/G)
	. = ..()
	if(.)
		if(!ishuman(G.affecting))
			to_chat(G.assailant, span_warning("You can only upgrade an aggressive grab when grappling a human!"))
			return FALSE
		if(!(G.target_zone in list(BODY_ZONE_CHEST, BODY_ZONE_HEAD)))
			to_chat(G.assailant, span_warning("You need to be grabbing their torso or head for this!"))
			return FALSE

		var/mob/living/carbon/human/affecting_mob = G.get_affecting_mob()
		if(istype(affecting_mob))
			var/obj/item/clothing/C = affecting_mob.head
			if(istype(C)) //hardsuit helmets etc
				if((C.clothing_flags & STOPSPRESSUREDAMAGE) && C.returnArmor().getRating(MELEE) > 20)
					to_chat(G.assailant, span_warning("\The [C] is in the way!"))
					return FALSE
