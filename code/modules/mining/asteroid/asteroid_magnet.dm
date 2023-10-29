/obj/machinery/asteroid_magnet
	name = "asteroid magnet computer"
	icon_state = "blackbox"
	use_power = NO_POWER_USE

	/// Templates available to succ in
	var/list/datum/mining_template/available_templates
	/// All templates in the "map".
	var/list/datum/mining_template/all_templates
	/// The map that stores asteroids
	var/datum/cartesian_plane/map
	/// The currently selected template
	var/list/datum/mining_template/selected_template

	var/coords_x = 0
	var/coords_y = 0

	var/ping_result = "N/A"

/obj/machinery/asteroid_magnet/Initialize(mapload)
	. = ..()

	available_templates = list()
	all_templates = list()
	map = new(-100, 100, -100, 100)
	var/datum/mining_template/simple_asteroid/A = new()
	A.x = 0
	A.y = 1
	all_templates += A
	map.set_coordinate(0, 1, A)

/obj/machinery/asteroid_magnet/Topic(href, href_list)
	. = ..()
	if(.)
		return

	var/list/map_offsets = map.return_offsets()
	var/list/map_bounds = map.return_bounds()
	var/value = text2num(href_list["x"] || href_list["y"])
	if(!isnull(value)) // round(null) = 0
		value = round(value, 1)
		if("x" in href_list)
			coords_x = WRAP(coords_x + map_offsets[1] + value, map_bounds[1] + map_offsets[1], map_bounds[2] + map_offsets[1])
			coords_x -= map_offsets[1]
			updateUsrDialog()

		else if("y" in href_list)
			coords_y = WRAP(coords_y + map_offsets[2] + value, map_bounds[3] + map_offsets[2], map_bounds[4] + map_offsets[2])
			coords_y -= map_offsets[2]
			updateUsrDialog()
		return

	if(href_list["ping"])
		ping(coords_x, coords_y)
		updateUsrDialog()
		return

/obj/machinery/asteroid_magnet/ui_interact(mob/user, datum/tgui/ui)
	var/content = list()

	content += {"
	<fieldset class='computerPane'>
		<legend class='computerLegend'>
			<b>Magnet Controls</b>
		</legend>
	"}

	// X selector
	content += {"
		<fieldset class='computerPaneNested'>
			<legend class='computerLegend' style='margin: auto'>
				<b>X-Axis</b>
			</legend>
			<table style='margin: auto'>
				<tr>
					<td style='min-width: 5%;text-align: right;'>[button_element(src, "-100", "x=-100")]</td>
					<td style='min-width: 5%;text-align: right;'>[button_element(src, "-10", "x=-10")]</td>
					<td style='min-width: 5%;text-align: right;'>[button_element(src, "-1", "x=-1")]</td>
					<td style='min-width: 5%;text-align: center;'>
						<span class='computerLegend'>[coords_x]</span>
					</td>
					<td style='min-width: 5%;text-align: left;'>[button_element(src, "1", "x=1")]</td>
					<td style='min-width: 5%;text-align: left;'>[button_element(src, "10", "x=10")]</td>
					<td style='min-width: 5%;text-align: left;'>[button_element(src, "100", "x=100")]</td>
				</tr>
			</table>
		</fieldset>
	"}

	// Y selector
	content += {"
		<fieldset class='computerPaneNested'>
			<legend class='computerLegend' style='margin: auto'>
				<b>Y-Axis</b>
			</legend>
			<table style='margin: auto'>
				<tr>
					<td style='min-width: 5%;text-align: right;'>[button_element(src, "-100", "y=-100")]</td>
					<td style='min-width: 5%;text-align: right;'>[button_element(src, "-10", "y=-10")]</td>
					<td style='min-width: 5%;text-align: right;'>[button_element(src, "-1", "y=-1")]</td>
					<td style='min-width: 5%;text-align: center;'>
						<span class='computerLegend'>[coords_y]</span>
					</td>
					<td style='min-width: 5%;text-align: left;'>[button_element(src, "1", "y=1")]</td>
					<td style='min-width: 5%;text-align: left;'>[button_element(src, "10", "y=10")]</td>
					<td style='min-width: 5%;text-align: left;'>[button_element(src, "100", "y=100")]</td>
				</tr>
			</table>
		</fieldset>
	"}

	// Ping button
	content += {"
		<fieldset class='computerPaneNested'>
			<legend class='computerLegend' style='margin: auto;'>
				<b>Ping</b>
			</legend>
			<div class='computerLegend' style='margin: auto; width:25%'>
				[ping_result]
			</div>
			<div style='margin: auto; width: 10%'>
				[button_element(src, "PING", "ping=1")]
			</div>
		</fieldset>
	"}

	// Close coordinates fieldset
	content += "</fieldset>"


	content += {"
	<fieldset class='computerPane'>
		<legend class='computerLegend'>
			<b>Available Asteroids</b>
		</legend>
	<table style='width:100%'>
	"}
	content += "</table></fieldset>"

	var/datum/browser/popup = new(user, "asteroidmagnet", name, 460, 550)
	popup.set_content(jointext(content,""))
	popup.open()

/obj/machinery/asteroid_magnet/proc/ping(coords_x, coords_y)
	var/datum/mining_template/T = map.return_coordinate(coords_x, coords_y)
	if(T)
		ping_result = "LOCATED"
		return

	var/datum/mining_template/closest
	var/lowest_dist = INFINITY
	for(var/datum/mining_template/asteroid as anything in all_templates)
		var/dist = sqrt(((asteroid.x - coords_x) ** 2) + ((asteroid.y - coords_y) ** 2))
		if(dist < lowest_dist)
			closest = asteroid
			lowest_dist = dist

	if(closest)
		var/dx = closest.x - coords_x
		var/dy = closest.y - coords_y
		var/angle = arccos(dy / sqrt((dx ** 2) + (dy ** 2)))
		if(dx < 0)
			angle = 360 - angle

		ping_result = "AZIMUTH [angle]"
	else
		ping_result = "ERR"
