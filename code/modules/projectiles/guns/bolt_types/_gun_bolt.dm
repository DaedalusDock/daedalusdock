///Gun has a bolt, it stays closed while not cycling. The gun must be racked to have a bullet chambered when a mag is inserted.
///  Example: c20, shotguns, m90
/datum/gun_bolt
	var/obj/item/gun/ballistic/parent
	var/is_locked = FALSE

/datum/gun_bolt/New(obj/item/gun/parent)
	src.parent = parent

/datum/gun_bolt/Destroy(force, ...)
	parent = null
	return ..()

/// Returns overlays for a gun's update_overlays()
/datum/gun_bolt/proc/get_overlays()
	return

/// Called during attack_self(). Return TRUE to cancel the rest of the proc.
/datum/gun_bolt/proc/attack_self(mob/living/user)
	return

/// Called at the start of rack(), return TRUE to cancel the rest of the proc.
/datum/gun_bolt/proc/pre_rack(mob/user)
	return

/// Called after rack(), before update_appearance()
/datum/gun_bolt/proc/post_rack(mob/user)
	playsound(parent, parent.rack_sound, parent.rack_sound_volume, parent.rack_sound_vary)

/// Called when ammo was successfully loaded into the weapon.
/datum/gun_bolt/proc/loaded_ammo()
	return

/// Called after a magazine is successfully inserted into the firearm.
/datum/gun_bolt/proc/magazine_inserted()
	return

/// Called when a magazine is about to be ejected.
/datum/gun_bolt/proc/magazine_ejected()
	return

/// Called at the start of unload(), return TRUE to cancel the rest of the proc.
/datum/gun_bolt/proc/unload(mob/user)
	return

/// Called during before_firing()
/datum/gun_bolt/proc/before_firing()
	return

/// Called at the foot of after_chambering()
/datum/gun_bolt/proc/after_chambering()
	return
