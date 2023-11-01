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
	var/datum/mining_template/selected_template

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

	if(href_list["select"])
		var/datum/mining_template/T = locate(href_list["select"]) in available_templates
		if(!T)
			return
		if(selected_template)
			available_templates += T
		selected_template = T
		available_templates -= T
		updateUsrDialog()
		return

/obj/machinery/asteroid_magnet/ui_interact(mob/user, datum/tgui/ui)
	var/content = list()

	content += {"
	<div style='width: 100%; display: flex; flex-wrap: wrap; justify-content: center; align-items: stretch;'>
	<fieldset class='computerPane' style='margin-right: 2em; display: inline-block; min-width: 45%;'>
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
			<div style='display: flex; justify-content: center; gap: 5px'>
				<div style='display: inline-block'>[button_element(src, "-100", "x=-100")]</div>
				<div style='display: inline-block'>[button_element(src, "-10", "x=-10")]</div>
				<div style='display: inline-block'>[button_element(src, "-1", "x=-1")]</div>
				<div style='display: inline-block; padding: 0.5em'>
					<span class='computerLegend'>[coords_x]</span>
				</div>
				<div style='display: inline-block'>[button_element(src, "1", "x=1")]</div>
				<div style='display: inline-block'>[button_element(src, "10", "x=10")]</div>
				<div style='display: inline-block'>[button_element(src, "100", "x=100")]</div>
				<span style='visibility: hidden'>---</span>
			</div>
		</fieldset>
	"}

	// Y selector
	content += {"
		<fieldset class='computerPaneNested'>
			<legend class='computerLegend' style='margin: auto'>
				<b>Y-Axis</b>
			</legend>
			<div style='display: flex; justify-content: center'>
				<div style='display: inline-block'>[button_element(src, "-100", "y=-100")]</div>
				<div style='display: inline-block'>[button_element(src, "-10", "y=-10")]</div>
				<div style='display: inline-block'>[button_element(src, "-1", "y=-1")]</div>
				<div style='display: inline-block; padding: 0.5em'>
					<span class='computerLegend'>[coords_y]</span>
				</div>
				<div style='display: inline-block'>[button_element(src, "1", "y=1")]</div>
				<div style='display: inline-block'>[button_element(src, "10", "y=10")]</div>
				<div style='display: inline-block'>[button_element(src, "100", "y=100")]</div>
				<span style='visibility: hidden'>---</span>
			</div>
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

	// Asteroids list fieldset
	content += {"
	<fieldset class='computerPane' style='display: inline-block; min-width: 45%;'>
		<legend class='computerLegend'>
			<b>Available Asteroids</b>
		</legend>
	"}
	// Selected asteroid container
	var/asteroid_name = "N/A"
	var/asteroid_desc = "N/A"
	if(selected_template)
		asteroid_name = selected_template.name
		asteroid_desc = selected_template.description

	content += {"
		<div class="computerLegend" style="margin-bottom: 2em; width: 97%; height: 7em;">
			<div style='font-size: 200%; text-align: center'>
				[asteroid_name]
			</div>
			<div style='text-align: center'>
				[asteroid_desc]
			</div>
		</div>
	"}

	// Asteroid list container
	content += {"
		<div class='zebraTable' style='display: flex;width: 100%; height: 120px;overflow-y: auto'>
	"}

	var/i = 0
	for(var/datum/mining_template/template as anything in available_templates)
		i++
		var/bg_color = i % 2 == 0 ? "#7c5500" : "#533200"
		content += {"
					<div class='highlighter' onclick='byondCall(\"[ref(template)]\")' style='width: 100%;height: 2em;background-color: [bg_color]'>
						<span class='computerText' style='padding-left: 10px'>[template.name] ([template.x],[template.y])</span>
					</div>
		"}

	content += "</div></fieldset></div>"

	content += {"
	<script>
	function byondCall(id){
		window.location = 'byond://?src=[ref(src)];select=' + id
	}
	</script>
	"}


	var/datum/browser/popup = new(user, "asteroidmagnet", name, 920, 400)
	popup.set_content(jointext(content,""))
	popup.open()

/obj/machinery/asteroid_magnet/proc/ping(coords_x, coords_y)
	var/datum/mining_template/T = map.return_coordinate(coords_x, coords_y)
	if(T)
		ping_result = "LOCATED"
		available_templates += T
		return

	var/datum/mining_template/closest
	var/lowest_dist = INFINITY
	for(var/datum/mining_template/asteroid as anything in all_templates)
		// Get the euclidean distance between the ping and the asteroid.
		var/dist = sqrt(((asteroid.x - coords_x) ** 2) + ((asteroid.y - coords_y) ** 2))
		if(dist < lowest_dist)
			closest = asteroid
			lowest_dist = dist

	if(closest)
		var/dx = closest.x - coords_x
		var/dy = closest.y - coords_y
		// Get the angle as 0 - 180 degrees
		var/angle = arccos(dy / sqrt((dx ** 2) + (dy ** 2)))
		if(dx < 0) // If the X-axis distance is negative, put it between 181 and 359. 180 and 360/0 are impossible, as that requires X == 0.
			angle = 360 - angle

		ping_result = "AZIMUTH [round(angle, 0.01)]"
	else
		ping_result = "ERR"
