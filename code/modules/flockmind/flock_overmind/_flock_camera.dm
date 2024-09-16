/mob/camera/flock
	name = "flockmind"
	desc = "TODO"
	icon = 'goon/icons/mob/featherzone.dmi'
	icon_state ="flockmind"
	layer = FLY_LAYER
	mouse_opacity = MOUSE_OPACITY_ICON
	invisibility = INVISIBILITY_OBSERVER

	appearance_flags = parent_type::appearance_flags | RESET_COLOR
	blend_mode = BLEND_ADD

	see_invisible = SEE_INVISIBLE_LIVING
	see_in_dark = 100
	lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
	sight = SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF
	// faction = list(ROLE_BLOB)
	//hud_type = /datum/hud/blob_overmind

	move_on_shuttle = FALSE
	movement_type = PHASING

	var/datum/flock/flock
	var/list/actions_to_grant = list()

/mob/camera/flock/Initialize(mapload)
	. = ..()

	for(var/action_path in actions_to_grant)
		var/datum/action/action = new action_path
		action.Grant(src)

	add_client_colour(/datum/client_colour/flockmind)

/mob/camera/flock/Login()
	. = ..()
	if(!. || !client)
		return FALSE

	var/turf/T = get_turf(src)
	if (isturf(T))
		update_z(T.z)

/mob/camera/flock/Logout()
	update_z(null)
	return ..()

/mob/camera/flock/proc/update_z(new_z) // 1+ to register, null to unregister
	if (registered_z != new_z)
		if (registered_z)
			SSmobs.flock_cameras_by_zlevel[registered_z] -= src
		if (client)
			if (new_z)
				SSmobs.flock_cameras_by_zlevel[new_z] += src
			registered_z = new_z
		else
			registered_z = null
