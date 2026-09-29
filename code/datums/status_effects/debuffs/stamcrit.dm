/// Stamina stun
/datum/status_effect/incapacitating/stamcrit
	id = "stamcrit"
	status_type = STATUS_EFFECT_UNIQUE
	duration = STAMINA_STUN_TIME

/// Signal proc for [COMSIG_LIVING_POST_FULLY_HEAL]
/datum/status_effect/incapacitating/stamcrit/proc/on_heal(datum/source, admin_revive)
	SIGNAL_HANDLER

	qdel(src)

/datum/status_effect/incapacitating/stamcrit/on_apply()
	RegisterSignal(owner, COMSIG_LIVING_POST_FULLY_HEAL, PROC_REF(on_heal))
	if(owner.stat == DEAD)
		return FALSE
	if(!(owner.status_flags & CANKNOCKDOWN) || HAS_TRAIT(owner, TRAIT_STUNIMMUNE))
		return FALSE
	if(owner.absorb_stun(1))
		return FALSE
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_INCAPACITATED, STAMINA)
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, STAMINA)
	ADD_TRAIT(owner, TRAIT_FLOORED, STAMINA)
	owner.add_filter("stamcrit", 1, drop_shadow_filter(x = 0, y = 0, size = -3, color = "#04080F"))
	owner.update_stamina_hud()

/datum/status_effect/incapacitating/stamcrit/on_remove()
	UnregisterSignal(owner, COMSIG_LIVING_POST_FULLY_HEAL)
	REMOVE_TRAIT(owner, TRAIT_INCAPACITATED, STAMINA)
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, STAMINA)
	REMOVE_TRAIT(owner, TRAIT_FLOORED, STAMINA)
	owner.remove_filter("stamcrit")
	owner.update_stamina_hud()
	return ..()
