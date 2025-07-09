/obj/structure/cargocrate
	name = "cargo crate"
	desc = "A rusty cargo crate."
	icon = 'modular_fallout/master_files/icons/fallout/cargocrate.dmi'
	icon_state = "cargocrate"
	anchored = 1
	density = 1
	layer = ABOVE_MOB_LAYER
	resistance_flags = INDESTRUCTIBLE
	bound_width = 64

/obj/structure/cargocrate/Initialize()
	. = ..()
	icon_state = pick("cargocrate1","cargocrate2","cargocrate3","cargocrate4","cargocrate5")
	AddComponent(/datum/component/seethrough, get_seethrough_map())
