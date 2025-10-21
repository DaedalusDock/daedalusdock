/datum/hud/flockdrone
	ui_style = 'goon/icons/hud/flock_ui.dmi'

/datum/hud/flockdrone/New(mob/owner)
	. = ..()
	var/atom/movable/screen/using

	using = new /atom/movable/screen/flockdrone_part/converter(null, src)
	static_inventory += using

	using = new /atom/movable/screen/flockdrone_part/incapacitator(null, src)
	static_inventory += using

/atom/movable/screen/flockdrone_part
	icon = 'goon/icons/hud/flock_ui.dmi'
	var/active_state = ""
	var/inactive_state = ""

	var/part_type
	var/datum/flockdrone_part/part_ref

/atom/movable/screen/flockdrone_part/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	var/mob/living/simple_animal/flock/drone/drone = hud?.mymob
	part_ref = locate(part_type) in drone?.parts // create n destroy
	part_ref?.screen_obj = src

	update_appearance(UPDATE_ICON_STATE)

/atom/movable/screen/flockdrone_part/Destroy()
	part_ref?.screen_obj = null
	part_ref = null
	return ..()

/atom/movable/screen/flockdrone_part/update_icon_state()
	if(part_ref.is_active())
		icon_state = active_state
	else
		icon_state = inactive_state
	return ..()

/atom/movable/screen/flockdrone_part/Click(location, control, params)
	. = ..()
	if(.)
		return

	var/mob/living/simple_animal/flock/drone/drone = hud?.mymob
	drone.set_active_part(part_ref)

/atom/movable/screen/flockdrone_part/converter
	name = "converter"
	active_state = "converter1"
	inactive_state = "converter0"

	screen_loc = "CENTER-1:16,SOUTH:5"

	part_type = /datum/flockdrone_part/converter

/atom/movable/screen/flockdrone_part/incapacitator
	name = "incapacitator"
	active_state = "incapacitor1"
	inactive_state = "incapacitor0"

	screen_loc = "CENTER:16,SOUTH:5"

	part_type = /datum/flockdrone_part/incapacitator

/atom/movable/screen/flockdrone_part/incapacitator/update_appearance(updates)
	. = ..()
	var/datum/flockdrone_part/incapacitator/part = part_ref
	maptext = MAPTEXT("[part?.shot_count || "0"]")
