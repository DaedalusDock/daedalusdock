GLOBAL_DATUM_INIT(blood_controller, /datum/blood_controller, new)

/datum/blood_controller
	/// A k:v list of weakref(mob) : vampire_blood_packet
	var/list/drain_index = list()

/datum/blood_controller/proc/get_blood_packet(mob/living/carbon/human/victim)
	var/datum/vampire_blood_packet/packet = drain_index[WEAKREF(victim)]
	if(isnull(packet))
		// Set default
		drain_index[WEAKREF(victim)] = packet = new /datum/vampire_blood_packet
		packet.last_check_time = world.time
		packet.remaining_blood = VAMPIRE_BLOOD_DRAIN_PER_TARGET
	else
		packet.update()
	return packet

/datum/blood_controller/proc/get_blood_remaining(mob/living/carbon/human/victim)
	var/datum/vampire_blood_packet/packet = get_blood_packet(victim)
	return packet.remaining_blood

/datum/blood_controller/proc/drain_blood(mob/living/carbon/human/victim, amount)
	var/datum/vampire_blood_packet/packet = get_blood_packet(victim)
	packet.remaining_blood = clamp(packet.remaining_blood - amount, 0, VAMPIRE_BLOOD_DRAIN_PER_TARGET)
	return packet.remaining_blood

/datum/vampire_blood_packet
	var/last_check_time = 0
	var/remaining_blood = 0

/datum/vampire_blood_packet/proc/update()
	var/time_delta = world.time - last_check_time
	if(time_delta == 0)
		return

	last_check_time = world.time
	remaining_blood = clamp(remaining_blood, remaining_blood + VAMPIRE_BLOOD_BUDGET_REGEN_FOR_DELTA(time_delta), VAMPIRE_BLOOD_DRAIN_PER_TARGET)
