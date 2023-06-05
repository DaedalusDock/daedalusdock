
// The shattered remnants of your broken limbs fill you with determination!
/atom/movable/screen/alert/status_effect/determined
	name = "Determined"
	desc = "The serious wounds you've sustained have put your body into fight-or-flight mode! Now's the time to look for an exit!"
	icon_state = "regenerative_core"

/datum/status_effect/determined
	id = "determined"
	alert_type = /atom/movable/screen/alert/status_effect/determined

/datum/status_effect/determined/on_apply()
	. = ..()
	owner.visible_message(span_danger("[owner]'s body tenses up noticeably, gritting against [owner.p_their()] pain!"), span_notice("<b>Your senses sharpen as your body tenses up from the wounds you've sustained!</b>"), \
		vision_distance=COMBAT_MESSAGE_RANGE)
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		human_owner.physiology.bleed_mod *= WOUND_DETERMINATION_BLEED_MOD

/datum/status_effect/determined/on_remove()
	owner.visible_message(span_danger("[owner]'s body slackens noticeably!"), span_warning("<b>Your adrenaline rush dies off, and the pain from your wounds come aching back in...</b>"), vision_distance=COMBAT_MESSAGE_RANGE)
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		human_owner.physiology.bleed_mod /= WOUND_DETERMINATION_BLEED_MOD
	return ..()

/datum/status_effect/limp
	id = "limp"
	status_type = STATUS_EFFECT_REPLACE
	tick_interval = 0
	alert_type = /atom/movable/screen/alert/status_effect/limp
	var/msg_stage = 0//so you dont get the most intense messages immediately
	/// The left leg of the limping person
	var/obj/item/bodypart/leg/left/left
	/// The right leg of the limping person
	var/obj/item/bodypart/leg/right/right
	/// Which leg we're limping with next
	var/obj/item/bodypart/next_leg
	/// How many deciseconds we limp for on the left leg
	var/slowdown_left = 0
	/// How many deciseconds we limp for on the right leg
	var/slowdown_right = 0
	/// The chance we limp with the left leg each step it takes
	var/limp_chance_left = 0
	/// The chance we limp with the right leg each step it takes
	var/limp_chance_right = 0

/datum/status_effect/limp/on_apply()
	if(!iscarbon(owner))
		return FALSE
	var/mob/living/carbon/C = owner
	left = C.get_bodypart(BODY_ZONE_L_LEG)
	right = C.get_bodypart(BODY_ZONE_R_LEG)
	update_limp()
	RegisterSignal(C, COMSIG_MOVABLE_MOVED, PROC_REF(check_step))
	RegisterSignal(C, list(COMSIG_CARBON_BREAK_BONE, COMSIG_CARBON_HEAL_BONE, COMSIG_CARBON_ATTACH_LIMB, COMSIG_CARBON_REMOVE_LIMB), PROC_REF(update_limp))
	return TRUE

/datum/status_effect/limp/on_remove()
	UnregisterSignal(owner, list(COMSIG_MOVABLE_MOVED, COMSIG_CARBON_BREAK_BONE, COMSIG_CARBON_HEAL_BONE, COMSIG_CARBON_ATTACH_LIMB, COMSIG_CARBON_REMOVE_LIMB))

/atom/movable/screen/alert/status_effect/limp
	name = "Limping"
	desc = "One or more of your legs has been wounded, slowing down steps with that leg! Get it fixed, or at least in a sling of gauze!"

/datum/status_effect/limp/proc/check_step(mob/whocares, OldLoc, Dir, forced)
	SIGNAL_HANDLER

	if(!owner.client || owner.body_position == LYING_DOWN || !owner.has_gravity() || (owner.movement_type & FLYING) || forced || owner.buckled)
		return

	// less limping while we have determination still
	var/determined_mod = owner.has_status_effect(/datum/status_effect/determined) ? 0.5 : 1

	if(next_leg == left)
		if(prob(limp_chance_left * determined_mod))
			owner.client.move_delay += slowdown_left * determined_mod
		next_leg = right
	else
		if(prob(limp_chance_right * determined_mod))
			owner.client.move_delay += slowdown_right * determined_mod
		next_leg = left

/datum/status_effect/limp/proc/update_limp()
	SIGNAL_HANDLER

	var/mob/living/carbon/C = owner
	left = C.get_bodypart(BODY_ZONE_L_LEG)
	right = C.get_bodypart(BODY_ZONE_R_LEG)

	if(!left && !right)
		C.remove_status_effect(src)
		return

	slowdown_left = 0
	slowdown_right = 0
	limp_chance_left = 0
	limp_chance_right = 0

	// technically you can have multiple wounds causing limps on the same limb, even if practically only bone wounds cause it in normal gameplay
	if(left)
		if(left.check_bones() & CHECKBONES_BROKEN)
			slowdown_left = 7
			limp_chance_left = 20

	if(right)
		if(right.check_bones() & CHECKBONES_BROKEN)
			slowdown_right = 7
			limp_chance_left = 20

	// this handles losing your leg with the limp and the other one being in good shape as well
	if(!slowdown_left && !slowdown_right)
		C.remove_status_effect(src)
		return


/////////////////////////
//////// WOUNDS /////////
/////////////////////////

// wound alert
/atom/movable/screen/alert/status_effect/wound
	name = "Wounded"
	desc = "Your body has sustained serious damage, click here to inspect yourself."

/atom/movable/screen/alert/status_effect/wound/Click()
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/carbon_owner = owner
	carbon_owner.check_self_for_injuries()

