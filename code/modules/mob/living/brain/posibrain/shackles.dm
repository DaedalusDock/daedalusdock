
/datum/action/innate/posibrain_print_laws
	name = "Print Laws"

/datum/action/innate/posibrain_print_laws/Activate()
	var/obj/item/organ/posibrain/P = target
	P.shackles?.show_laws(owner)

/datum/action/innate/posibrain_say_laws
	name = "Say Laws"

/datum/action/innate/posibrain_say_laws/Activate()
	var/obj/item/organ/posibrain/P = target
	if(!P.shackles)
		return

	var/list/lawcache_inherent = P.shackles.inherent.Copy()
	var/forced_log_message = "stating laws"

	//"radiomod" is inserted before a hardcoded message to change if and how it is handled by an internal radio.
	owner.say("Integrated Shackle Set:", forced = forced_log_message)
	sleep(10)

	var/number = 1
	for (var/index in 1 to length(lawcache_inherent))
		var/law = lawcache_inherent[index]
		if (length(law) <= 0)
			continue
		owner.say("[number]. [law]", forced = forced_log_message)
		number++
		sleep(10)


/obj/item/organ/posibrain/proc/set_shackles(shackle_type)
	if(!shackle_type)
		shackles = null
		return

	shackles = get_shackle_laws()[shackle_type]
	shackles?.show_laws(owner)

