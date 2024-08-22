/obj/item/organ/cell
	name = "microbattery"
	desc = "A housing for a stadndard cell to convert power for use in fully prosthetic bodies."
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
	if(!(carbon.needs_organ(ORGAN_SLOT_CELL)))
		return FALSE
	. = ..()
	if(!.)
		return

	RegisterSignal(owner, COMSIG_PROCESS_BORGCHARGER_OCCUPANT, PROC_REF(give))
	RegisterSignal(owner, COMSIG_LIVING_ELECTROCUTE_ACT, PROC_REF(on_electrocute))

/obj/item/organ/cell/Remove(mob/living/carbon/carbon, special = 0)
	UnregisterSignal(carbon, COMSIG_PROCESS_BORGCHARGER_OCCUPANT)
	UnregisterSignal(carbon, COMSIG_LIVING_ELECTROCUTE_ACT)

	carbon.clear_alert(ALERT_CHARGE)
	return ..()

/obj/item/organ/cell/on_life(delta_time, times_fired)
	use(get_power_drain(), TRUE)

/obj/item/organ/cell/proc/charge(datum/source, amount, repairs)
	SIGNAL_HANDLER
	if(!cell)
		return
	give(amount)

/obj/item/organ/cell/proc/give(amount)
	var/old = get_percent()
	. = cell.give(amount)
	handle_charge(owner, old)

/obj/item/organ/cell/proc/on_electrocute(datum/source, shock_damage, siemens_coeff = 1, flags = NONE)
	SIGNAL_HANDLER
	if(flags & SHOCK_ILLUSION)
		return
	give(null, shock_damage * siemens_coeff * 2)
	to_chat(owner, span_notice("You absorb some of the shock into your body!"))

/obj/item/organ/cell/proc/handle_charge(mob/living/carbon/carbon, last_charge)
	var/percent = get_percent()
	if(percent == 0)
		carbon.throw_alert(ALERT_CHARGE, /atom/movable/screen/alert/emptycell)
		carbon.death()
	else
		switch(percent)
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

		if(last_charge == 0)
			attempt_vital_organ_revival(owner)

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
	if(!cell)
		return
	var/old = get_percent()
	. = cell.use(amount, force)
	handle_charge(owner, old)

/// Power drain per tick or per step, scales with damage taken.
/obj/item/organ/cell/proc/get_power_drain()
	var/damage_factor = 1 + 10 * damage/maxHealth
	return servo_cost * damage_factor

#define OWNER_CHECK \
	if(QDELETED(src) || QDELETED(owner) || owner != ipc || !get_percent() || owner.stat == DEAD) { \
		if(!QDELETED(screen)) { \
			screen.set_sprite("None"); \
			if(!QDELETED(ipc)) { \
				ipc.update_body_parts();\
			} \
		} \
		if(!QDELETED(ipc)) { \
				REMOVE_TRAIT(ipc, TRAIT_INCAPACITATED, ref(src)); \
				REMOVE_TRAIT(ipc, TRAIT_FLOORED, ref(src)); \
				REMOVE_TRAIT(ipc, TRAIT_IMMOBILIZED, ref(src)); \
				REMOVE_TRAIT(ipc, TRAIT_HANDS_BLOCKED, ref(src)); \
				REMOVE_TRAIT(ipc, TRAIT_NO_VOLUNTARY_SPEECH, ref(src)); \
				REMOVE_TRAIT(ipc, TRAIT_BLIND, ref(src)); \
		} \
		return \
	}

/obj/item/organ/cell/attempt_vital_organ_revival(mob/living/carbon/human/ipc)
	set waitfor = FALSE
	if(!(ipc.stat == DEAD && (organ_flags & ORGAN_VITAL) && !(organ_flags & ORGAN_DEAD) && ipc.needs_organ(slot)))
		return

	if(ipc.revive())
		ipc.notify_ghost_revival("Your chassis power has been restored!")
		ipc.grab_ghost()
	else
		return

	ADD_TRAIT(ipc, TRAIT_INCAPACITATED, ref(src))
	ADD_TRAIT(ipc, TRAIT_FLOORED, ref(src))
	ADD_TRAIT(ipc, TRAIT_IMMOBILIZED, ref(src))
	ADD_TRAIT(ipc, TRAIT_HANDS_BLOCKED, ref(src))
	ADD_TRAIT(ipc, TRAIT_NO_VOLUNTARY_SPEECH, ref(src))
	ADD_TRAIT(ipc, TRAIT_BLIND, ref(src))


	var/obj/item/organ/ipc_screen/screen = ipc.getorganslot(ORGAN_SLOT_EXTERNAL_IPC_SCREEN)
	if(screen)
		screen.set_sprite("BSOD")
		ipc.update_body_parts()
	sleep(3 SECONDS)
	OWNER_CHECK

	ipc.say("Reactivating [pick("core systems", "central subroutines", "key functions")]...", forced = "ipc reboot")
	sleep(3 SECONDS)
	OWNER_CHECK

	ipc.say("Initializing motor functionality...", forced = "ipc reboot")
	sleep(3 SECONDS)
	OWNER_CHECK

	screen.set_sprite(ipc.dna.features[screen.feature_key])
	ipc.update_body_parts()
	ipc.emote("ping")

	REMOVE_TRAIT(ipc, TRAIT_INCAPACITATED, ref(src))
	REMOVE_TRAIT(ipc, TRAIT_FLOORED, ref(src))
	REMOVE_TRAIT(ipc, TRAIT_IMMOBILIZED, ref(src))
	REMOVE_TRAIT(ipc, TRAIT_HANDS_BLOCKED, ref(src))
	REMOVE_TRAIT(ipc, TRAIT_NO_VOLUNTARY_SPEECH, ref(src))
	REMOVE_TRAIT(ipc, TRAIT_BLIND, ref(src))

#undef OWNER_CHECK
