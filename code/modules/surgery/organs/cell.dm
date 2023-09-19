/obj/item/organ/cell
	name = "microcell"
	desc = "A small, powerful cell for use in fully prosthetic bodies."
	icon_state = "cell"

	organ_flags = ORGAN_SYNTHETIC | ORGAN_VITAL
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_CELL

	/// Is the cell housing open?
	var/open
	/// The internal cell that actually holds power.
	var/obj/item/stock_parts/cell/high/cell = /obj/item/stock_parts/cell/high
	//at 2.6 completely depleted after 60ish minutes of constant walking or 130 minutes of standing still
	var/servo_cost = 2.6

/obj/item/organ/cell/Initialize(mapload, mob_sprite)
	. = ..()
	cell = new cell(src)

/obj/item/organ/cell/Insert(mob/living/carbon/carbon, special = 0)
	if(!(carbon.get_bodypart(BODY_ZONE_CHEST).bodytype & BODYTYPE_ROBOTIC))
		return FALSE
	. = ..()
	if(!.)
		return

	RegisterSignal(owner, COMSIG_PROCESS_BORGCHARGER_OCCUPANT, PROC_REF(give))
	RegisterSignal(owner, COMSIG_LIVING_ELECTROCUTE_ACT, PROC_REF(on_electrocute))
	if(owner.stat == DEAD)
		owner.set_stat(CONSCIOUS)

/obj/item/organ/stomach/ethereal/Remove(mob/living/carbon/carbon, special = 0)
	UnregisterSignal(owner, COMSIG_PROCESS_BORGCHARGER_OCCUPANT)
	UnregisterSignal(owner, COMSIG_LIVING_ELECTROCUTE_ACT)

	carbon.clear_alert(ALERT_ETHEREAL_CHARGE)
	carbon.clear_alert(ALERT_ETHEREAL_OVERCHARGE)

/obj/item/organ/cell/on_life(delta_time, times_fired)
	var/last_charge = get_percent()

	if(owner.stat != DEAD)
		use(get_power_drain(), TRUE)

	handle_charge(owner, last_charge)

/obj/item/organ/cell/proc/give(datum/source, amount, repairs)
	SIGNAL_HANDLER
	if(!cell)
		return
	cell.give(amount)

/obj/item/organ/cell/proc/on_electrocute(datum/source, shock_damage, siemens_coeff = 1, flags = NONE)
	SIGNAL_HANDLER
	if(flags & SHOCK_ILLUSION)
		return
	give(shock_damage * siemens_coeff * 2)
	to_chat(owner, span_notice("You absorb some of the shock into your body!"))

/obj/item/organ/cell/proc/handle_charge(mob/living/carbon/carbon, last_charge)
	var/percent = get_percent()
	switch(percent)
		if(0)
			carbon.throw_alert(ALERT_CHARGE, /atom/movable/screen/alert/emptycell)
			carbon.set_stat(DEAD)

		if(0 to 25)
			carbon.throw_alert(ALERT_CHARGE, /atom/movable/screen/alert/lowcell, 3)
			if(last_charge > 25)
				to_chat(owner, span_warning("Your internal battery beeps an alert code, it is low on charge!"))

		if(25 to 50)
			carbon.throw_alert(ALERT_CHARGE, /atom/movable/screen/alert/lowcell, 2)

		if(50 to 75)
			carbon.throw_alert(ALERT_CHARGE, /atom/movable/screen/alert/lowcell, 1)

		else
			carbon.clear_alert(ALERT_CHARGE)

	if(percent > 0 && last_charge == 0)
		owner.set_stat(CONSCIOUS)

/obj/item/organ/cell/proc/get_percent()
	if(!cell)
		return 0
	return get_charge()/cell.maxcharge * 100

/obj/item/organ/cell/proc/get_charge()
	if(!cell)
		return 0
	if(organ_flags & ORGAN_DEAD)
		return 0
	return round(cell.charge*(1 - damage/maxHealth))

/obj/item/organ/cell/use(amount, force)
	if(organ_flags & ORGAN_DEAD)
		return FALSE
	return cell && cell.use(amount, force)

/// Power drain per tick or per step, scales with damage taken.
/obj/item/organ/cell/proc/get_power_drain()
	var/damage_factor = 1 + 10 * damage/maxHealth
	return servo_cost * damage_factor
