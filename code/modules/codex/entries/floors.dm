/datum/codex_entry/floor
	abstract_type = /datum/codex_entry/floor
	disambiguator = "floor"

/datum/codex_entry/floor/iron
	name = "Iron Floor"
	use_typesof = TRUE
	associated_paths = list(/turf/open/floor/iron)
	controls_text = {"
	<span codexlink='Crowbar'>Crowbar</span> - Pry up the floor.
	"}

/datum/codex_entry/floor/catwalk
	name = "Catwalk"
	use_typesof = TRUE
	associated_paths = list(/obj/structure/overfloor_catwalk)

	controls_text = {"
	<span codexlink='Crowbar'>Crowbar</span> - Pry up the floor.
	<br>
	<span codexlink='Screwdriver'>Screwdriver</span> - Access or hide the contents underneath.
	"}

/datum/codex_entry/floor/wood
	name = "Wooden Floor"
	use_typesof = TRUE
	associated_paths = list(/turf/open/floor/wood)

	controls_text = {"
	<span codexlink='Crowbar'>Crowbar</span> - Pry up the floor.
	"}

/datum/codex_entry/floor/carpet
	name = "Carpet"
	use_typesof = TRUE
	associated_paths = list(/turf/open/floor/carpet)

	controls_text = {"
	<span codexlink='Crowbar'>Crowbar</span> - Pry up the floor.
	"}
