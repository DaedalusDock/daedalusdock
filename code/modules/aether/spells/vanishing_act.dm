/datum/action/cooldown/spell/vanishing_act
	name = "Vanishing Act"
	desc = "Conjure a dense cloud that leeches blood from those caught within it."
	button_icon_state = "smoke"

	invocation = "Kassherev hintza!"
	invocation_type = INVOCATION_SHOUT
	school = SCHOOL_BLOOD
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC|SPELL_REQUIRES_HUMAN|SPELL_CASTABLE_WITHOUT_INVOCATION

	cooldown_time = 10 MINUTES
	smoke_type = /datum/effect_system/fluid_spread/smoke/bad/blood
	smoke_amt = 4

/datum/action/cooldown/spell/vanishing_act/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/caster = cast_on
	caster.adjustBloodVolume(-100)
