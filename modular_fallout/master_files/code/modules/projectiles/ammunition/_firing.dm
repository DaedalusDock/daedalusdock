/obj/item/ammo_casing/fire_casing(atom/target, mob/living/user, params, distro, quiet, zone_override, spread, extra_damage, extra_penetration, extra_speed, atom/fired_from)
	distro += variance
	var/targloc = get_turf(target)
	ready_proj(target, user, quiet, zone_override, extra_damage, extra_penetration, extra_speed, fired_from)
	if(pellets == 1)
		if(distro) //We have to spread a pixel-precision bullet. throw_proj was called before so angles should exist by now...
			if(randomspread)
				spread = round((rand() - 0.5) * distro)
			else //Smart spread
				spread = round(1 - 0.5) * distro
		if(!throw_proj(target, targloc, user, params, spread))
			return FALSE
	else
		if(isnull(loaded_projectile))
			return FALSE
		AddComponent(/datum/component/pellet_cloud, projectile_type, pellets)
		SEND_SIGNAL(src, COMSIG_PELLET_CLOUD_INIT, target, user, fired_from, randomspread, spread, zone_override, params, distro)

	user.DelayNextAction(considered_action = TRUE, immediate = FALSE)
	user.newtonian_move(get_dir(target, user))
	update_icon()
	return 1

/obj/item/ammo_casing/spread(turf/target, turf/current, distro)
	var/dx = abs(target.x - current.x)
	var/dy = abs(target.y - current.y)
	return locate(target.x + round(gaussian(0, distro) * (dy+2)/8, 1), target.y + round(gaussian(0, distro) * (dx+2)/8, 1), target.z)
