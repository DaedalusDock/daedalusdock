/**
 * tenacious element; which makes the parent move faster while crawling
 *
 * Used by sparring sect!
 */
/datum/element/tenacious

/datum/element/tenacious/Attach(datum/target)
	. = ..()

	if(!ishuman(target))
		return COMPONENT_INCOMPATIBLE

	if(HAS_TRAIT(target, TRAIT_SOFT_CRITICAL_CONDITION))
		on_softcrit_gain(target)

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_SOFT_CRITICAL_CONDITION), PROC_REF(on_softcrit_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_SOFT_CRITICAL_CONDITION), PROC_REF(on_softcrit_loss))
	ADD_TRAIT(target, TRAIT_TENACIOUS, ELEMENT_TRAIT(type))

/datum/element/tenacious/Detach(datum/target)
	UnregisterSignal(target, COMSIG_MOB_STATCHANGE)
	REMOVE_TRAIT(target, TRAIT_TENACIOUS, ELEMENT_TRAIT(type))
	on_softcrit_loss(target)
	return ..()

///signal called by the stat of the target changing
/datum/element/tenacious/proc/on_softcrit_gain(mob/living/carbon/human/target)
	SIGNAL_HANDLER
	to_chat(target, span_danger("Your tenacity kicks in!"))
	target.add_movespeed_modifier(/datum/movespeed_modifier/tenacious)

/datum/element/tenacious/proc/on_softcrit_loss(mob/living/carbon/target)
	SIGNAL_HANDLER
	to_chat(target, span_danger("Your tenacity wears off!"))
	target.remove_movespeed_modifier(/datum/movespeed_modifier/tenacious)
