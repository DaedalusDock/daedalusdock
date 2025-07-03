//Fallout 13 wall destruction simulation

/turf/closed/wall
	var/damage = 0
	var/damage_overlay = 0
	var/global/damage_overlays[16]
	var/unbreakable = 1

/turf/closed/wall/proc/take_damage(dam)
	if(dam)
		damage = max(0, damage + dam)
		update_icon()
	if(damage > hardness)
		dismantle_wall(1)
		playsound(src, 'sound/effects/meteorimpact.ogg', rand(50,100), 1)
		return 1
	return 0

/turf/closed/wall/proc/update_damage_overlay()
	if(damage != 0)

		var/overlay = round(damage / hardness * damage_overlays.len) + 1
		if(overlay > damage_overlays.len)
			overlay = damage_overlays.len

		overlays += damage_overlays[overlay]

/turf/closed/wall/proc/generate_overlays()
	var/alpha_inc = 256 / damage_overlays.len

	for(var/i = 1; i <= damage_overlays.len; i++)
		var/image/img = image(icon = 'modular_fallout/master_files/icons/fallout/turfs/walls_overlay.dmi', icon_state = "overlay_damage")
		img.blend_mode = BLEND_MULTIPLY
		img.alpha = (i * alpha_inc) - 1
		damage_overlays[i] = img

/turf/closed/wall/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(!.)
		user.do_attack_animation(src)
		if(istype(W, /obj/item/pickaxe)) //stops pickaxes from running needless attack checks on our baseturf
			return
		if(W.force > hardness/3 && !unbreakable)
			take_damage(W.force/10)
			to_chat(user, text("<span class='warning'>You smash the wall with [W].</span>"))
			playsound(src, 'sound/effects/bang.ogg', 50, 1)
		else
			to_chat(user, text("<span class='notice'>You hit the wall with [W] to no effect.</span>"))
			playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
