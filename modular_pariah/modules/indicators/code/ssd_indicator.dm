GLOBAL_VAR_INIT(ssd_indicator_overlay, mutable_appearance('modular_pariah/modules/indicators/icons/ssd_indicator.dmi', "default0", FLY_LAYER))

/mob/living
	var/ssd_indicator = FALSE
	var/lastclienttime = 0

/mob/living/proc/set_ssd_indicator(var/state)
	if(state == ssd_indicator)
		return
	ssd_indicator = state
	if(ssd_indicator)
		add_overlay(GLOB.ssd_indicator_overlay)
		log_message("<font color='green'>has went SSD and got their indicator!</font>", LOG_ATTACK)
	else
		cut_overlay(GLOB.ssd_indicator_overlay)
		log_message("<font color='green'>is no longer SSD and lost their indicator!</font>", LOG_ATTACK)

/mob/living/Login()
	. = ..()
	set_ssd_indicator(FALSE)

/mob/living/Logout()
	lastclienttime = world.time
	set_ssd_indicator(TRUE)
	. = ..()

//Temporary, look below for the reason
/mob/living/ghostize(can_reenter_corpse = TRUE, admin_ghost)
	. = ..()
	set_ssd_indicator(FALSE)
