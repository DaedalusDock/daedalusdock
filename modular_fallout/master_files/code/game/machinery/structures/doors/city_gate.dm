/obj/machinery/door/poddoor/gate
	name = "city gate"
	desc = "A heavy duty gates that opens mechanically."
	icon = 'modular_fallout/master_files/icons/fallout/structures/city_gate.dmi'
	icon_state = "closed"
	armor = list(BLUNT = 20, PUNCTURE = 20, SLASH = 90, LASER = 20, ENERGY = 75, BOMB = 25, BIO = 100, FIRE = 100, ACID = 70)
	id = 333
	bound_width = 96
	ertblast = TRUE

/obj/machinery/door/poddoor/gate/preopen
	icon_state = "open"
	density = FALSE
	opacity = FALSE


/obj/machinery/door/poddoor/gate/open()
	. = ..()
	if(!.)
		return
	set_opacity(FALSE)


/obj/machinery/door/poddoor/gate/close()
	. = ..()
	if(!.)
		return
	set_opacity(TRUE)
