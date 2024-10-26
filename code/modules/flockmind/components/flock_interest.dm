
/// Mark a specific flock as interested in this
/datum/component/flock_interest
	/// The flock who is intently interested in this thing.
	var/datum/flock/flock

/datum/component/flock_interest/Initialize(datum/flock/flock)
	. = ..()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	src.flock = flock

/datum/component/flock_interest/RegisterWithParent()
	RegisterSignal(parent, COMSIG_FLOCK_PROTECTION_TRIGGER, PROC_REF(handle_flock_attack))

/// If flockdrone is in our flock, deny the attack, otherwise scream and cry
/datum/component/flock_interest/proc/handle_flock_attack(atom/source, atom/attacker, intentional, projectile_attack)
	SIGNAL_HANDLER

	if(isflockmob(attacker))
		var/mob/living/simple_animal/flock/bird = attacker
		if(bird.flock == flock && intentional)
			return COMPONENT_FLOCK_DENY_ATTACK

	if(isflockdrone(attacker))
		return

	var/mob/living/simple_animal/flock/drone/snitch
	for (var/mob/living/simple_animal/flock/drone/bird in viewers(attacker))
		if(bird == attacker)
			continue
		if(bird.stat != CONSCIOUS)
			continue
		if(bird.ai_controller.ai_status == AI_OFF)
			continue
		if(bird.flock != flock)
			continue

		snitch = bird
		break

	if(!snitch)
		return

	var/report_name = source.get_flock_id()

	if(flock.is_mob_ignored(attacker))
		flock_talk(snitch, "Damage sighted on [report_name], [pick(GLOB.flock_betrayal_phrases)] [attacker].")
	else if(!flock.is_mob_enemy(attacker))
		flock_talk(snitch, "Damage sighted on [report_name], [pick(GLOB.flockdrone_new_enemy_phrases)] [attacker].")

	flock.update_enemy(attacker)

