/datum/action/cooldown/spell/pointed/lucid_lightning
	name = "Discharge"
	desc = "Drain the beating energy of one's heart, taking it for yourself."
	button_icon_state = "lightning"

	//sound = 'sound/magic/exit_blood.ogg'

	invocation = "Kasyah shach hala"
	invocation_type = INVOCATION_NONE
	school = SCHOOL_BLOOD
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC|SPELL_REQUIRES_HUMAN|SPELL_CASTABLE_WITHOUT_INVOCATION

	cooldown_time = 10 SECONDS

	var/damage_per_zap = 25
	var/arc_jump_coeff = 0.66
	var/arc_jumps = 3

/datum/action/cooldown/spell/pointed/lucid_lightning/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return

	return isliving(cast_on)

/datum/action/cooldown/spell/pointed/lucid_lightning/cast(atom/cast_on)
	. = ..()
	tesla_zap_target(owner, cast_on, TESLA_MOB_DAMAGE_TO_POWER(damage_per_zap))

	cast_on.visible_message(
		span_danger("<b>[cast_on]</b> is struck by a bolt of energy arcing off of <b>[owner]</b>."),
		blind_message = span_hear("You hear a loud electrical crackle."),
	)

	log_combat(owner, cast_on, "fires a lightning bolt at")

	var/list/hit_mobs = list(cast_on, owner)
	var/mob/previous_hit = cast_on
	var/end_of_chain = TRUE

	for(var/i in 1 to arc_jumps)
		end_of_chain = TRUE

		for(var/mob/living/M in viewers(2, get_turf(previous_hit)))
			if((M in hit_mobs))
				continue

			end_of_chain = FALSE

			hit_mobs += M
			tesla_zap_target(previous_hit, M, TESLA_MOB_DAMAGE_TO_POWER(damage_per_zap * (arc_jump_coeff * i)))
			cast_on.visible_message(
				span_danger("<b>[M]</b> is struck by a bolt of energy arcing off of <b>[previous_hit]</b>."),
				blind_message = span_hear("You hear a loud electrical crackle."),
			)

			previous_hit = M
			log_combat(owner, cast_on, "damages with an arc chain")
			break

		if(end_of_chain)
			break
