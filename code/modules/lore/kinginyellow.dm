/obj/item/kinginyellow
	name = "The King In Yellow"
	desc = "An old book with the author's name scratched out, leaving only an \"H\"."
	icon = 'goon/icons/obj/kinginyellow.dmi'
	icon_state = "bookkiy"

	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

	var/process_interval = 0
	var/static/list/datum/weakref/cursed = list()
	var/static/list/datum/weakref/cursed_stage_2 = list()
	var/obj/effect/kinginyellow_mob/my_liege

/obj/item/kinginyellow/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/kinginyellow/Destroy(force)
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/kinginyellow/process(delta_time)
	if(process_interval++ % 3)
		return

	if(!length(cursed))
		return

	var/datum/weakref/weakref = pick(cursed)
	var/mob/living/L = weakref.resolve()
	if(QDELETED(L))
		cursed -= weakref
		return

	var/turf/possible_loc = get_oov_turf(L)
	if(possible_loc && !my_liege)
		my_liege = new(possible_loc, L)
		RegisterSignal(my_liege, COMSIG_PARENT_QDELETING, .proc/king_gone)

/obj/item/kinginyellow/proc/king_gone(datum/source)
	SIGNAL_HANDLER
	my_liege = null

/obj/item/kinginyellow/attack_self(mob/user, modifiers)
	var/datum/weakref/weak_user = WEAKREF(user)
	if(!(weak_user in cursed))
		to_chat(user, span_notice("You turn open the cover of the book, and begin to read, \"Chapter One: The Repairer of Reputations\"..."))
		if(do_after(user, time = 8 SECONDS, interaction_key = "kinginyellow"))
			to_chat(user, span_notice("The first act is a confusing mess about 1920's America.") + "<br>" + span_danger("You feel as if you're about to faint."))
			cursed += weak_user
			user.adjust_drowsyness(3)

	else if(!(weak_user in cursed_stage_2))
		to_chat(user, span_notice("You begin to read the second chapter, it's title has been scratched out..."))
		if(do_after(user, time = 3 SECONDS, interaction_key = "kinginyellow"))
			to_chat(user, span_warning("No, no no what is this?! It's gibberish! It can't be!"))
			cursed_stage_2 += weak_user
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 50, 150)
			else
				var/mob/living/L = user
				L.adjustBruteLoss(20)
	else
		var/reads = 0
		while(do_after(user, time = 1 SECONDS, interaction_key = "kinginyellow"))
			reads++
			to_chat(user, span_danger("Your mind is scarred by the horrors within! You must keep reading!"))
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2.5 * reads)
			else if(isliving(user))
				var/mob/living/L = user
				L.adjustBruteLoss(10)

	return TRUE

/obj/item/kinginyellow/examine(mob/user)
	. = ..()
	var/static/text = "You feel the irresistible urge to keep reading The King In Yellow."
	for(var/datum/weakref/weakref in cursed)
		var/mob/living/L = weakref.resolve()
		if(!L)
			cursed -= weakref
			continue
		to_chat(L, (weakref in cursed_stage_2) ? span_warning(text) : span_notice(text))

/obj/effect/kinginyellow_mob
	name = "strange person"
	desc = "You don't remember seeing them before..."
	icon = null
	icon_state = null
	density = FALSE
	anchored = TRUE
	layer = MOB_LAYER

	var/mob/living/target
	var/image/me
	COOLDOWN_DECLARE(grace_period)

/obj/effect/kinginyellow_mob/Initialize(mapload, _target)
	. = ..()
	if(!_target)
		return INITIALIZE_HINT_QDEL
	COOLDOWN_START(src, grace_period, 5 SECONDS)
	target = _target
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, .proc/target_moved)
	me = image('goon/icons/obj/kinginyellow.dmi', src, "kingyellow")
	target.client?.images += me
	setDir(get_dir(src, target))
	addtimer(CALLBACK(src, .proc/check_expire), 5 SECONDS)

/obj/effect/kinginyellow_mob/Destroy(force)
	if(target)
		UnregisterSignal(target, COMSIG_MOVABLE_MOVED)
		target.client?.images -= me
		target = null
	return ..()

/obj/effect/kinginyellow_mob/proc/target_moved(datum/source)
	SIGNAL_HANDLER
	var/mob/living/target = source
	if(!target || !target.client)
		vanish()

	if(COOLDOWN_FINISHED(src, grace_period) && !(target in viewers(src)))
		vanish()

	if(get_dist(src, target) <= 2)
		vanish()

	setDir(get_dir(src, target))

/obj/effect/kinginyellow_mob/proc/vanish()
	set waitfor = FALSE
	setDir(get_dir(src, target))
	new /obj/effect/abstract/kinginyellow_vanish(get_turf(src), target)
	QDEL_IN(src, 0.3 SECONDS)

/obj/effect/kinginyellow_mob/proc/check_expire()
	if(!(src in view(target)))
		vanish()
	else
		addtimer(CALLBACK(src, .proc/check_expire), 5 SECONDS)

/obj/effect/kinginyellow_mob/attackby(obj/item/weapon, mob/user, params)
	vanish()
	return ..()

/obj/effect/kinginyellow_mob/attack_hand(mob/living/user, list/modifiers)
	vanish()
	return ..()

/obj/effect/abstract/kinginyellow_vanish
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = EFFECTS_LAYER
	var/image/me
	var/mob/living/target

/obj/effect/abstract/kinginyellow_vanish/Initialize(mapload, _target)
	. = ..()
	if(!_target)
		return INITIALIZE_HINT_QDEL
	target = _target
	me = image('goon/icons/obj/kinginyellow.dmi', src, "kingyellowvanish")
	target.client?.images += me
	QDEL_IN(src, 0.3 SECONDS)

/obj/effect/abstract/kinginyellow_vanish/Destroy(force)
	target?.client?.images -= me
	target = null
	return ..()

///Returns a turf that is barely out of view of the target.
/proc/get_oov_turf(atom/target)
	var/list/turfs_in_range = RANGE_TURFS(10, target)
	var/list/turfs_in_view = list()

	for(var/turf/T as turf in oview(target))
		turfs_in_view += T

	var/list/unseen_turfs = turfs_in_view ^ turfs_in_range
	var/list/turfs_to_consider = list()

	for(var/turf/T as anything in unseen_turfs)
		if(isspaceturf(T) || IS_OPAQUE_TURF(T) || T.contains_dense_objects())
			continue
		if(can_see(T, target, 10))
			turfs_to_consider += T

	if(!length(turfs_to_consider))
		return

	return pick(turfs_to_consider)



