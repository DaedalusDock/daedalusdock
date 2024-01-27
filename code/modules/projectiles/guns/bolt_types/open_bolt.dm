///Gun has a bolt, it is open when ready to fire. The gun can never have a chambered bullet with no magazine, but the bolt stays ready when a mag is removed.
///  Example: Some SMGs, the L6
/datum/gun_bolt/open

/datum/gun_bolt/open/get_overlays()
	if(is_locked)
		return "[parent.icon_state]_bolt"

/datum/gun_bolt/open/pre_rack(mob/user)
	if(!is_locked) //If it's an open bolt, racking again would do nothing
		if (user)
			to_chat(user, span_notice("[parent]'s [parent.bolt_wording] is already cocked!"))
		return

	is_locked = FALSE

/datum/gun_bolt/open/magazine_inserted()
	if(!is_locked)
		parent.chamber_round(TRUE)

/datum/gun_bolt/open/magazine_ejected()
	parent.chambered = null

/datum/gun_bolt/open/before_firing()
	if (!parent.chambered && !parent.get_ammo() && !is_locked)
		is_locked = TRUE
		playsound(parent, parent.bolt_drop_sound, parent.bolt_drop_sound_volume)
		parent.update_appearance()
