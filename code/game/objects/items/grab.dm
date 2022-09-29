/obj/item/grab
	name = "grip"
	desc = "Your furious (or not so) grab on a target."
	icon = 'goon/icons/obj/item/grab.dmi'
	item_flags = ABSTRACT | DROPDEL | NOBLUDGEON
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	///The person doing the grab
	var/atom/movable/owner
	///The person being the grabbed
	var/atom/movable/victim
	///The "strength" of the grip on the victim
	var/grip_strength = 0
	///The current state of the grab
	var/current_state = GRAB_LEVEL_PULL
	///The possible grab states.
	var/static/list/possible_states = list(GRAB_LEVEL_PULL, GRAB_LEVEL_AGGRESSIVE, GRAB_LEVEL_CHOKEHOLD)
	///How long it takes to elevate to this state
	var/static/list/state_grab_time = list(
		GRAB_LEVEL_PULL = 0,
		GRAB_LEVEL_AGGRESSIVE = 0,
		GRAB_LEVEL_CHOKEHOLD = 4 SECONDS,
	)
	///Is the victim being pinned to the floor?
	var/pinned = FALSE

/obj/item/grab/Destroy(force)
	if(victim)
		release() //You WILL stop grabbing NOW

	owner?.grab = null
	owner = null
	return ..()

/obj/item/grab/update_icon_state()
	. = ..()
	if(pinned)
		icon_state = "pinned"
	else
		icon_state = "[current_state]"


///Release the victim and GC ourselves
/obj/item/grab/proc/release()
	. = TRUE
	if(!victim)
		stack_trace("Victim is null!")

	SEND_SIGNAL(victim, COMSIG_ATOM_NO_LONGER_PULLED, owner)
	owner.on_grab_release(victim)

	victim.grabbedby = null
	victim = null
	owner.grab = null
	owner = null

	if(!QDELETED(src))
		qdel(src)

///Try to release the victim, passing a pull strength to contest the owner's.
/obj/item/grab/proc/can_release(strength)
	if(grip_strength > strength)
		return FALSE
	return TRUE

/obj/item/grab/proc/init_grapple(atom/movable/owner, atom/movable/target, state, strength, supress_message)
	PRIVATE_PROC(TRUE)
	src.owner = owner

	if(!owner || !target)
		return FALSE

	if(owner == target || target.anchored || !isturf(owner.loc))
		return FALSE

	if(!(target.can_be_pulled(owner, strength)))
		return FALSE

	if(isliving(owner))
		var/mob/living/living_owner = owner
		if(living_owner.throwing || !(living_owner.mobility_flags & MOBILITY_PULL))
			return FALSE
		if(SEND_SIGNAL(living_owner, COMSIG_LIVING_TRY_PULL, target, force) & COMSIG_LIVING_CANCEL_PULL)
			return FALSE

	owner.add_fingerprint(target)

	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		if(!C.can_put_in_hand(src, C.active_hand_index))
			return FALSE

	if(target.grabbedby)
		if(!target.grabbedby.can_release(strength))
			return FALSE //Can't override their grab, abort!
		else
			if(!supress_message)
				victim.visible_message(
					span_danger("[owner] pulls [target] from [target.grabbedby.owner]'s grip."),
					span_danger("[owner] pulls you from [target.grabbedby.owner]'s grip."),
					null,
					null,
					src
				)
			to_chat(owner, span_notice("You pull [owner] from [owner.grabbedby.owner]'s grip!"))
			log_combat(target, target.grabbedby.owner, "pulled from", owner)
			QDEL_NULL(target.grabbedby) //an object can't be pulled by two things at once.


	///By this point, we're locked into this grab happening.
	return TRUE

/obj/item/grab/proc/setup(atom/movable/owner, atom/movable/target, state, strength, supress_message)
	if(!init_grapple(arglist(args)))
		qdel(src)
		return

	src.victim = target
	target.grabbedby = src


	if(isliving(owner))
		SEND_SIGNAL(owner, COMSIG_LIVING_START_PULL, victim, state, strength)
		owner:changeNext_move(CLICK_CD_GRABBING)

		if(iscarbon(owner))
			owner:put_in_active_hand(src, ignore_animation = TRUE)

	///Update action CD
	if(try_set_state(state, supress_message))
		supress_message = TRUE

	//Audio for the pull
	if(!supress_message)
		var/sound_to_play = 'sound/weapons/thudswoosh.ogg'
		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			if(H.dna.species.grab_sound)
				sound_to_play = H.dna.species.grab_sound
			if(HAS_TRAIT(H, TRAIT_STRONG_GRABBER))
				sound_to_play = null
		playsound(src.loc, sound_to_play, 50, TRUE, -1)

	///Update owner's HUD
	if(ismob(owner))
		var/mob/owner_mob= owner
		owner_mob.update_pull_hud_icon()

	//Special mob stuff
	if(ismob(target))
		var/mob/target_mob = target
		if(state == GRAB_LEVEL_PULL)
			log_combat(owner, target_mob, "grabbed", addition="passive grab")

		if(!iscarbon(owner))
			target_mob.LAssailant = null
		else
			target_mob.LAssailant = WEAKREF(usr)

		if(isliving(target_mob))
			var/mob/living/living_target = target_mob

			SEND_SIGNAL(living_target, COMSIG_LIVING_GET_PULLED, owner)
			if(isliving(owner))
				var/mob/living/living_owner = owner
				////Share diseases that are spread by touch
				//Owner > Target
				for(var/datum/disease/D as anything in living_owner.diseases)
					if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
						living_target.ContactContractDisease(D)

				//Target > Owner
				for(var/datum/disease/D as anything in living_target.diseases)
					if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
						living_owner.ContactContractDisease(D)

			if(HAS_TRAIT(src, TRAIT_STRONG_GRABBER) && state == GRAB_LEVEL_PULL)
				try_set_state(GRAB_LEVEL_AGGRESSIVE)

			owner.update_pull_movespeed()

		owner.set_pull_offsets(target_mob, current_state)

	update_icon_state()


/obj/item/grab/proc/try_set_state(state as num)
	if(state == src.current_state)
		return FALSE

	if(!isliving(victim))
		return FALSE //The fuck you trying to do, choke a soda can?

	if(!(state in src.possible_states))
		return FALSE

	if(!on_state_increase_attempt(state))
		return FALSE

	if(state_grab_time[state])
		if(!do_mob(owner, victim, state_grab_time[state]))
			return FALSE

	. = TRUE

	change_state(state)


/obj/item/grab/proc/change_state(new_state)
	PRIVATE_PROC(TRUE)

	SEND_SIGNAL(owner, COMSIG_MOVABLE_SET_GRAB_STATE, new_state)

	var/old_state = current_state

	current_state = new_state
	update_icon_state()

	///Do trait stuff
	switch(new_state)
		if(GRAB_LEVEL_PULL)
			REMOVE_TRAIT(victim, TRAIT_IMMOBILIZED, CHOKEHOLD_TRAIT)
			//REMOVE_TRAIT(victim, TRAIT_HANDS_BLOCKED, CHOKEHOLD_TRAIT)
		/*
			if(old_state >= GRAB_NECK) // Previous state was a a neck-grab or higher.
				REMOVE_TRAIT(victim, TRAIT_FLOORED, CHOKEHOLD_TRAIT)
		*/
		if(GRAB_LEVEL_AGGRESSIVE)
			/*
			if(old_state >= GRAB_NECK) // Grab got downgraded.
				REMOVE_TRAIT(victim, TRAIT_FLOORED, CHOKEHOLD_TRAIT)

			else // Grab got upgraded from a passive one
			*/
			ADD_TRAIT(victim, TRAIT_IMMOBILIZED, CHOKEHOLD_TRAIT)
			//ADD_TRAIT(victim, TRAIT_HANDS_BLOCKED, CHOKEHOLD_TRAIT)
		/*if(GRAB_LEVEL_CHOKEHOLD)
			if(old_state <= GRAB_AGGRESSIVE)
				ADD_TRAIT(victim, TRAIT_FLOORED, CHOKEHOLD_TRAIT)
		*/

	///Do movespeed stuff
	if(isliving(owner))
		var/mob/living/living_owner = owner
		switch(current_state)
			if(GRAB_LEVEL_PULL)
				living_owner.remove_movespeed_modifier(MOVESPEED_ID_MOB_GRAB_STATE)
			if(GRAB_LEVEL_AGGRESSIVE)
				living_owner.add_movespeed_modifier(/datum/movespeed_modifier/grab_slowdown/aggressive)
			if(GRAB_LEVEL_CHOKEHOLD)
				living_owner.add_movespeed_modifier(/datum/movespeed_modifier/grab_slowdown/kill)

	///Do visible message stuff
	switch(current_state)
		if(GRAB_LEVEL_AGGRESSIVE)
			victim.visible_message(
				span_danger("[owner] has grabbed [victim] aggressively (now hands)!"),
				span_danger("[owner] has grabbed you aggressively!"),
				span_hear("You hear cloth shuffle around."),
			)
			log_combat(owner, victim, "grabbed", addition="aggressive grab")
		if(GRAB_LEVEL_CHOKEHOLD)
			victim.visible_message(
				span_danger("[owner] tightens [owner.p_their()] grip on [victim]'s neck!"),
				span_danger("[owner]'s arm tightens around your neck!"),
				span_hear("You hear someone choking.")
			)
			log_combat(owner, victim, "grabbed", addition="neck grab")
			if(isliving(victim))
				if(!victim:buckled && !victim.density)
					victim.Move(owner.loc)

	if(isliving(victim))
		owner.set_pull_offsets(victim, current_state)

///Called when the owner tries to increase the grab level
/obj/item/grab/proc/on_state_increase_attempt(state as num)
	if(!isliving(victim))
		return FALSE

	var/mob/living/mob_victim = victim
	if(isliving(owner))
		var/mob/living/living_owner = owner
		living_owner.changeNext_move(CLICK_CD_GRABBING)

	var/sound_to_play = 'sound/weapons/thudswoosh.ogg'
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(H.dna.species.grab_sound)
			sound_to_play = H.dna.species.grab_sound
	playsound(owner.loc, sound_to_play, 50, TRUE, -1)

	if(state >= GRAB_LEVEL_AGGRESSIVE && !(mob_victim.status_flags & CANPUSH) || HAS_TRAIT(victim, TRAIT_PUSHIMMUNE))
		to_chat(owner, span_warning("[victim] can't be grabbed more aggressively!"))
		return FALSE

	if(HAS_TRAIT(owner, TRAIT_PACIFISM))
		return FALSE

	//At this point, we are increasing the grab state
	. = TRUE

	if(state > GRAB_LEVEL_PULL)
		victim.grab?.release()

	switch(state)
		if(GRAB_LEVEL_CHOKEHOLD)
			visible_message(
				span_danger("[owner] starts to tighten [owner.p_their()] grip on [victim]!"),
				span_userdanger("[owner] starts to tighten [owner.p_their()] grip on you!"),
				span_hear("You hear aggressive shuffling!"),
				null,
			)
			log_combat(owner, victim, "attempted to strangle", addition="kill grab")
			if(ishuman(victim))
				var/mob/living/carbon/human/human_victim = victim
				if(human_victim.w_uniform)
					human_victim.w_uniform.add_fingerprint(owner)

///Return FALSE if the victim is able to move, TRUE if they are still restrained
/obj/item/grab/proc/victim_try_move()
	var/mob/living/living_victim = victim

	if(living_victim?.grab?.victim == owner && victim.grab?.current_state == GRAB_LEVEL_PULL) //Don't autoresist passive grabs if we're grabbing them too.
		return FALSE

	if(!ismob(victim))
		return FALSE

	var/mob/victim_mob = victim

	if(HAS_TRAIT(victim_mob, TRAIT_INCAPACITATED))
		if(victim_mob.client)
			COOLDOWN_START(victim_mob.client, move_delay, 1 SECONDS)
		return TRUE
	else if(HAS_TRAIT(victim_mob, TRAIT_RESTRAINED))
		if(victim_mob.client)
			COOLDOWN_START(victim_mob.client, move_delay, 1 SECONDS)
		to_chat(victim_mob, span_warning("You're restrained! You can't move!"))
		return TRUE

	return living_victim.resist_grab(TRUE)

/obj/item/grab/attack_self(mob/user, modifiers)
	. = ..()
	try_set_state(current_state+1)

/obj/item/grab/pre_attack(mob/living/M, mob/living/user, params)
	. = ..()
	if(M == victim)
		try_set_state(current_state+1)

///Hijack atom attacking completely
/obj/item/grab/attack_atom(atom/attacked_atom, mob/living/user, params)
	if(!owner.Adjacent(attacked_atom))
		return

	attacked_atom.on_grab_attack(src, victim, current_state)


/*
/turf/open/floor/attackby(obj/item/C, mob/user, params)
	. = ..()
	if(istype(C, /obj/item/grab))
		var/obj/item/grab/holder = C
		if(user.Adjacent(src))
			INVOKE_ASYNC(holder, /obj/item/grab/proc/try_pin_to, src)
			return TRUE


/obj/item/grab/proc/try_pin_to(turf/T)
	if(!)
*/
