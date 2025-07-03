/obj/structure/lamp_post
	name = "lamp post"
	desc = "A relic of the past that continues to illuminate the darkness."
	icon = 'modular_fallout/master_files/icons/fallout/objects/96x160_street_decore.dmi'
	icon_state = "nvlamp-singles"

	light_system = MOVABLE_LIGHT
	light_range = 4
	light_color = "#a8a582"
	light_on = FALSE

	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	layer = GASFIRE_LAYER
	anchored = TRUE
	opacity = 0
	density = TRUE

	pixel_x = -32

/obj/structure/lamp_post/doubles
	icon_state = "nvlamp-straight-doubles"

/obj/structure/lamp_post/doubles/bent
	icon_state = "nvlamp-corner-doubles"

/obj/structure/lamp_post/triples
	icon_state = "nvlamp-tripples"

/obj/structure/lamp_post/quadra
	icon_state = "nvlamp-quadra"

/obj/structure/lamp_post/Initialize()
	. = ..()
	GLOB.lamppost += src

/obj/structure/lamp_post/Destroy()
	GLOB.lamppost -= src
	. = ..()

/obj/effect/lamp_post/traffic_light
	name = "traffic light"
	desc = "A relic of the past, associated with sirens of justice and tickets."
	icon = 'modular_fallout/master_files/icons/fallout/objects/96x160_street_decore.dmi'

	anchored = TRUE
	opacity = 0
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	layer = GASFIRE_LAYER

	pixel_x = -32

/obj/effect/lamp_post/traffic_light/left
	icon_state = "traffic-light-leftside"

/obj/effect/lamp_post/traffic_light/right
	icon_state = "traffic-light-rightside"

/obj/effect/lamp_post/traffic_light/blinking
	icon_state = "traffic-light-south-blinking"
