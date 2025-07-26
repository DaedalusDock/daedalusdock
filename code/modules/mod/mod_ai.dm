/obj/item/mod/control/proc/ai_enter_mod(mob/living/silicon/ai/new_ai)
	new_ai.control_disabled = FALSE
	new_ai.radio_enabled = TRUE
	new_ai.ai_restore_power()
	new_ai.cancel_camera()
	new_ai.controlled_equipment = src
	new_ai.remote_control = src
	new_ai.forceMove(src)
	ai = new_ai
	balloon_alert(new_ai, "transferred to a suit")
	for(var/datum/action/action as anything in actions)
		action.Grant(new_ai)

#define MOVE_DELAY 2
#define WEARER_DELAY 1
#define LONE_DELAY 5
#define CHARGE_PER_STEP DEFAULT_CHARGE_DRAIN * 2.5
#define AI_FALL_TIME 1 SECONDS

/obj/item/mod/control/relaymove(mob/user, direction)
	if((!active && wearer) || get_charge() < CHARGE_PER_STEP  || user != ai || !COOLDOWN_FINISHED(src, cooldown_mod_move) || HAS_TRAIT(wearer, TRAIT_AGGRESSIVE_GRAB))
		return FALSE
	var/timemodifier = MOVE_DELAY * (ISDIAGONALDIR(direction) ? 2 : 1) * (wearer ? WEARER_DELAY : LONE_DELAY)
	if(wearer && !wearer.Process_Spacemove(direction))
		return FALSE
	else if(!wearer && (!has_gravity() || !isturf(loc)))
		return FALSE
	COOLDOWN_START(src, cooldown_mod_move, movedelay * timemodifier + slowdown_active)
	subtract_charge(CHARGE_PER_STEP)
	playsound(src, 'sound/mecha/mechmove01.ogg', 25, TRUE)
	if(ismovable(wearer?.loc))
		return wearer.loc.relaymove(wearer, direction)
	else if(wearer)
		ADD_TRAIT(wearer, TRAIT_FORCED_STANDING, MOD_TRAIT)
		addtimer(CALLBACK(src, PROC_REF(ai_fall)), AI_FALL_TIME, TIMER_UNIQUE | TIMER_OVERRIDE)
	var/atom/movable/mover = wearer || src
	return step(mover, direction)

#undef MOVE_DELAY
#undef WEARER_DELAY
#undef LONE_DELAY
#undef CHARGE_PER_STEP

/obj/item/mod/control/proc/ai_fall()
	if(!wearer)
		return
	REMOVE_TRAIT(wearer, TRAIT_FORCED_STANDING, MOD_TRAIT)
