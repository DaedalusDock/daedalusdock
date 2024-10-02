/mob/living/carbon/slip(knockdown_amount, obj/slipped_on, lube_flags, paralyze, force_drop = FALSE)
	if(movement_type & (FLYING | FLOATING))
		return FALSE
	if(!(lube_flags & SLIDE_ICE))
		log_combat(src, (slipped_on || get_turf(src)), "slipped on the", null, ((lube_flags & SLIDE) ? "(SLIDING)" : null))
	..()
	return loc.handle_slip(src, knockdown_amount, slipped_on, lube_flags, paralyze, force_drop)

/mob/living/carbon/Move(NewLoc, direct, glide_size_override, z_movement_flags)
	. = ..()
	if(!(usr == src))
		return

	if(!. || (movement_type & FLOATING)) //floating is easy
		return

	if(isipc(src))
		var/obj/item/organ/cell/C = getorganslot(ORGAN_SLOT_CELL)
		if(C)
			C.use(C.get_power_drain(), TRUE)
		return

	if(HAS_TRAIT(src, TRAIT_NOHUNGER))
		set_nutrition(NUTRITION_LEVEL_FED - 1) //just less than feeling vigorous
	else if(nutrition && stat != DEAD)
		if(m_intent == MOVE_INTENT_WALK)
			adjust_nutrition(-HUNGER_LOSS_WALK)
		else
			adjust_nutrition(-HUNGER_LOSS_RUN)

/mob/living/carbon/set_usable_legs(new_value)
	. = ..()
	if(isnull(.))
		return
	if(. == 0)
		if(usable_legs != 0) //From having no usable legs to having some.
			REMOVE_TRAIT(src, TRAIT_FLOORED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
			REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
	else if(usable_legs == 0 && !(movement_type & (FLYING | FLOATING))) //From having usable legs to no longer having them.
		ADD_TRAIT(src, TRAIT_FLOORED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
		if(!usable_hands)
			ADD_TRAIT(src, TRAIT_IMMOBILIZED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)


/mob/living/carbon/set_usable_hands(new_value)
	. = ..()
	if(isnull(.))
		return
	if(. == 0)
		REMOVE_TRAIT(src, TRAIT_HANDS_BLOCKED, LACKING_MANIPULATION_APPENDAGES_TRAIT)
		if(usable_hands != 0) //From having no usable hands to having some.
			REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
	else if(usable_hands == 0 && default_num_hands > 0) //From having usable hands to no longer having them.
		ADD_TRAIT(src, TRAIT_HANDS_BLOCKED, LACKING_MANIPULATION_APPENDAGES_TRAIT)
		if(!usable_legs && !(movement_type & (FLYING | FLOATING)))
			ADD_TRAIT(src, TRAIT_IMMOBILIZED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)

/mob/living/carbon/on_movement_type_flag_enabled(datum/source, flag, old_movement_type)
	. = ..()
	if(movement_type & (FLYING | FLOATING) && !(old_movement_type & (FLYING | FLOATING)))
		remove_movespeed_modifier(/datum/movespeed_modifier/limbless)
		REMOVE_TRAIT(src, TRAIT_FLOORED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
		REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)

/mob/living/carbon/on_movement_type_flag_disabled(datum/source, flag, old_movement_type)
	. = ..()
	if(old_movement_type & (FLYING | FLOATING) && !(movement_type & (FLYING | FLOATING)))
		var/limbless_slowdown = 0
		if(usable_legs < default_num_legs)
			limbless_slowdown += (default_num_legs - usable_legs) * 3
			if(!usable_legs)
				ADD_TRAIT(src, TRAIT_FLOORED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
				if(usable_hands < default_num_hands)
					limbless_slowdown += (default_num_hands - usable_hands) * 3
					if(!usable_hands)
						ADD_TRAIT(src, TRAIT_IMMOBILIZED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
		if(limbless_slowdown)
			add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/limbless, slowdown = limbless_slowdown)
		else
			remove_movespeed_modifier(/datum/movespeed_modifier/limbless)


/mob/living/carbon/proc/update_move_intent_slowdown()
	var/modifier
	if(m_intent == MOVE_INTENT_WALK)
		modifier = /datum/movespeed_modifier/config_walk_run/walk
	else if(m_intent == MOVE_INTENT_RUN)
		modifier =  /datum/movespeed_modifier/config_walk_run/run
	else
		modifier = /datum/movespeed_modifier/config_walk_run/sprint
	add_movespeed_modifier(modifier)

/mob/living/carbon/update_config_movespeed()
	update_move_intent_slowdown()
	return ..()

/mob/living/carbon/set_move_intent(new_state)
	. = ..()
	update_move_intent_slowdown()

