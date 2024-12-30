/datum/action/cooldown/ghost_whisper
	name = "Dream Daemon"
	desc = "Allows you to influence the dreams of a sleeping creature."

	click_to_activate = TRUE
	cooldown_time = 60 SECONDS
	write_log = TRUE
	ranged_mousepointer = 'icons/effects/mouse_pointers/supplypod_target.dmi'

	var/message_to_send

/datum/action/cooldown/ghost_whisper/is_valid_target(atom/cast_on)
	. = ..()
	if(!isliving(cast_on))
		return FALSE

	var/mob/living/L = cast_on
	if(L.stat == DEAD)
		to_chat(owner, span_warning("That one has no life force left."))
		return FALSE

	if(L.stat == CONSCIOUS)
		to_chat(owner, span_warning("I cannot influence those that are awake."))
		return FALSE

	if(!L.client)
		to_chat(owner, span_warning("There is nobody inside of there to listen."))
		return FALSE

/datum/action/cooldown/ghost_whisper/PreActivate(atom/target, list/params)
	message_to_send = ""
	var/input = tgui_input_text(owner, "What do you want to say?", max_length = 20)
	if(!input)
		return FALSE

	var/confirmation = tgui_alert(owner, "\"... [input] ...\"", "Confirm Whisper", list("Ok", "Cancel"))
	if(confirmation != "Ok")
		return FALSE

	if(!IsAvailable())
		return FALSE
	return ..()

/datum/action/cooldown/ghost_whisper/Activate(atom/target)
	. = ..()
	to_chat(target, span_obviousnotice("<i>... [message_to_send] ...</i>"))
	message_to_send = ""

	RECORD_GHOST_POWER(src)
