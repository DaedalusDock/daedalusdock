///Gun has a bolt, it locks back when empty. It can be released to chamber a round if a magazine is in.
///  Example: Pistols with a slide lock, some SMGs
/datum/gun_bolt/locking

/datum/gun_bolt/locking/get_overlays()
	return "[parent.icon_state]_bolt[is_locked ? "_locked" : ""]"

/datum/gun_bolt/locking/post_rack(mob/user)
	if (parent.chambered)
		return ..()

	is_locked = TRUE
	playsound(parent, parent.lock_back_sound, parent.lock_back_sound_volume, parent.lock_back_sound_vary)

/datum/gun_bolt/locking/after_chambering()
	if (!parent.chambered && !parent.get_ammo())
		is_locked = TRUE
		parent.update_appearance()

/datum/gun_bolt/locking/attack_self(mob/living/user)
	if(is_locked)
		parent.drop_bolt(user)
		return TRUE
