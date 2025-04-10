/datum/element/alcoholism_magnet
	element_flags = ELEMENT_BESPOKE
	id_arg_index = 2

	/// Roll difficulty
	var/roll_difficulty = 5

	/// Message displayed on failure.
	var/failure_message

	/// get_examine_result() id arg
	var/result_id = ""

/datum/element/alcoholism_magnet/Attach(datum/target, result_id, failure_message, roll_difficulty)
	. = ..()
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE

	src.result_id = result_id
	src.failure_message = failure_message
	if(roll_difficulty)
		src.roll_difficulty = roll_difficulty

	RegisterSignal(target, COMSIG_DISCO_FLAVOR, PROC_REF(on_disco))

/datum/element/alcoholism_magnet/Detach(datum/source, ...)
	. = ..()
	UnregisterSignal(source, COMSIG_DISCO_FLAVOR)

/datum/element/alcoholism_magnet/proc/on_disco(datum/source, mob/living/carbon/human/user, nearby, is_station_level)
	SIGNAL_HANDLER

	var/modifier = HAS_TRAIT(user.mind, TRAIT_DICK) ? -STATS_BASELINE_VALUE : 0

	var/datum/roll_result/result = user.get_examine_result(result_id, roll_difficulty, /datum/rpg_skill/willpower, modifier = modifier, only_once = TRUE)
	if(result && result.outcome <= FAILURE)
		result.do_skill_sound(user)
		to_chat(
			user,
			result.create_tooltip(failure_message),
		)

