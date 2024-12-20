/obj/machinery/light/broken
	status = LIGHT_BROKEN
	icon_state = "tube-broken"

/obj/machinery/light/built
	icon_state = "tube-empty"
	start_with_cell = FALSE

/obj/machinery/light/built/Initialize(mapload)
	. = ..()
	status = LIGHT_EMPTY
	update(FALSE, FALSE, FALSE)

/obj/machinery/light/warm
	bulb_colour = LIGHTBULB_COLOR_WARM

/obj/machinery/light/warm/bar
	bulb_inner_range = 1.8
	bulb_outer_range = 7
	bulb_power = 0.75

/obj/machinery/light/cold
	bulb_colour = LIGHT_COLOR_FAINT_BLUE

/obj/machinery/light/red
	bulb_colour = "#FF3232"
	no_emergency = TRUE
	bulb_inner_range = 4
	bulb_power = 0.7

/obj/machinery/light/blacklight
	bulb_colour = "#A700FF"
	bulb_inner_range = 4
	bulb_power = 0.8

/obj/machinery/light/dim
	bulb_colour = "#FFDDCC"
	bulb_power = 0.6

// the smaller bulb light fixture

/obj/machinery/light/small
	icon_state = "bulb"
	base_state = "bulb"
	fitting = "bulb"
	bulb_inner_range = 1
	bulb_outer_range = 5
	bulb_colour = "#FFD6AA"
	desc = "A small lighting fixture."
	light_type = /obj/item/light/bulb

/obj/machinery/light/small/broken
	status = LIGHT_BROKEN
	icon_state = "bulb-broken"

/obj/machinery/light/small/bar
	bulb_colour = LIGHTBULB_COLOR_WARM

/obj/machinery/light/small/built
	icon_state = "bulb-empty"
	start_with_cell = FALSE

/obj/machinery/light/small/built/Initialize(mapload)
	. = ..()
	status = LIGHT_EMPTY
	update(FALSE, FALSE, FALSE)

/obj/machinery/light/small/red
	bulb_colour = "#FF3232"
	no_emergency = TRUE
	bulb_power = 0.8

/obj/machinery/light/small/blacklight
	bulb_colour = "#A700FF"
	bulb_power = 0.9

/obj/machinery/light/small/maintenance
	color = "#FFCC66"
	bulb_colour = "#e0a142"
	bulb_power = 0.8

/obj/machinery/light/small/maintenance/turn_on(trigger, play_sound)
	var/old_color = color
	color = bulb_colour
	. = ..()
	color = old_color

// -------- Directional presets
// The directions are backwards on the lights we have now
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light, 21, 0, 10, -10)

// ---- Broken tube
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/broken, 21, 0, 10, -10)

// ---- Tube construct
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/structure/light_construct, 21, 0, 10, -10)

// ---- Tube frames
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/built, 21, 0, 10, -10)

// ---- Warm light tubes
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/warm, 21, 0, 10, -10)

MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/warm/bar, 21, 0, 10, -10)

// ---- Cold light tubes
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/cold, 21, 0, 10, -10)

// ---- Red tubes
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/red, 21, 0, 10, -10)

// ---- Blacklight tubes
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/blacklight, 21, 0, 10, -10)

// ---- Dim tubes
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/dim, 21, 0, 10, -10)


// -------- Bulb lights
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/small, 21, 0, 10, -10)
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/small/bar, 21, 0, 10, -10)

// ---- Bulb construct
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/structure/light_construct/small, 21, 0, 10, -10)

// ---- Bulb frames
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/small/built, 21, 0, 10, -10)

// ---- Broken bulbs
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/small/broken, 21, 0, 10, -10)

// ---- Red bulbs
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/small/red, 21, 0, 10, -10)

// ---- Blacklight bulbs
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/small/blacklight, 21, 0, 10, -10)

// ---- Maintenance bulbs
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/small/maintenance, 21, 0, 10, -10)
