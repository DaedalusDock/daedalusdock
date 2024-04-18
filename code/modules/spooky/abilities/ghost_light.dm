/datum/action/cooldown/ghost_light
	name = "Ghastly Light"
	desc = "Emit feint light for a short period of time"

	click_to_activate = TRUE
	cooldown_time = 5 MINUTES
	write_log = TRUE
	ranged_mousepointer = 'icons/effects/mouse_pointers/supplypod_target.dmi'

	var/timer

/datum/action/cooldown/ghost_light/Activate(atom/target)
	. = ..()

	timer = addtimer(CALLBACK(src, PROC_REF(disable_light)), 60 SECONDS, TIMER_STOPPABLE)
	owner.set_light_color("#7bfc6a")
	owner.set_light_on(TRUE)

	RECORD_GHOST_POWER(src)

/datum/action/cooldown/ghost_light/Remove(mob/removed_from)
	deltimer(timer)
	disable_light()
	return ..()

/datum/action/cooldown/ghost_light/proc/disable_light()
	owner.set_light_color(initial(owner.light_color))
	owner.set_light_on(FALSE)
