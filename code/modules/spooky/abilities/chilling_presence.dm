/datum/action/cooldown/chilling_presence
	name = "Chilling Presence"
	desc = "Send a chill up your target's spine."

	click_to_activate = TRUE
	cooldown_time = 120 SECONDS
	write_log = TRUE
	ranged_mousepointer = 'icons/effects/mouse_pointers/supplypod_target.dmi'

/datum/action/cooldown/chilling_presence/is_valid_target(atom/cast_on)
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

/datum/action/cooldown/chilling_presence/Activate(atom/target)
	. = ..()
	var/mob/living/L = target
	to_chat(target, span_obviousnotice("You feel a chill run up your spine."))
	L.emote("shiver")

	RECORD_GHOST_POWER(src)
