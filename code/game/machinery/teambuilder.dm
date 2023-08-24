/**
 * Simple admin tool that enables players to be assigned to a VERY SHITTY, very visually distinct team, quickly and affordably.
 */
/obj/machinery/teambuilder
	name = "Teambuilding Machine"
	desc = "A machine that, when passed, colors you based on the color of your team. Lead free!"
	icon = 'icons/obj/telescience.dmi'
	icon_state = "lpad-idle"
	density = FALSE
	can_buckle = FALSE
	resistance_flags = INDESTRUCTIBLE // Just to be safe.
	use_power = NO_POWER_USE
	cross_flags = CROSSED
	///Are non-humans allowed to use this?
	var/humans_only = FALSE
	///What color is your mob set to when crossed?
	var/team_color = COLOR_WHITE
	///What radio station is your radio set to when crossed (And human)?
	var/team_radio = FREQ_COMMON

/obj/machinery/teambuilder/Initialize(mapload)
	. = ..()
	add_filter("teambuilder", 2, list("type" = "outline", "color" = team_color, "size" = 2))

/obj/machinery/teambuilder/examine_more(mob/user)
	. = ..()
	. += span_notice("You see a hastily written note on the side, it says '1215-1217, PICK A SIDE'.")

/obj/machinery/teambuilder/Crossed(atom/movable/crossed_by, oldloc)
	if(!ishuman(crossed_by) && humans_only)
		return
	if(crossed_by.get_filter("teambuilder"))
		return
	if(isliving(crossed_by) && team_color)
		crossed_by.add_filter("teambuilder", 2, list("type" = "outline", "color" = team_color, "size" = 2))
	if(ishuman(crossed_by) && team_radio)
		var/mob/living/carbon/human/human = crossed_by
		var/obj/item/radio/Radio = human.ears
		if(!Radio)
			return
		Radio.set_frequency(team_radio)

/obj/machinery/teambuilder/red
	name = "Teambuilding Machine (Red)"
	desc = "A machine that, when passed, colors you based on the color of your team. Go red team!"
	humans_only = TRUE
	team_color = COLOR_RED
	team_radio = FREQ_CTF_RED

/obj/machinery/teambuilder/blue
	name = "Teambuilding Machine (Blue)"
	desc = "A machine that, when passed, colors you based on the color of your team. Go blue team!"
	humans_only = TRUE
	team_color = COLOR_BLUE
	team_radio = FREQ_CTF_BLUE
