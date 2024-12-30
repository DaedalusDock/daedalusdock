/obj/machinery/rnd/production/circuit_imprinter
	name = "circuit imprinter"
	desc = "Manufactures circuit boards for the construction of machines."
	icon_state = "circuit_imprinter"
	circuit = /obj/item/circuitboard/machine/circuit_imprinter
	allowed_buildtypes = IMPRINTER

/obj/machinery/rnd/production/circuit_imprinter/calculate_efficiency()
	. = ..()
	var/total_rating = 0
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		total_rating += M.rating * 2 //There is only one.
	total_rating = max(1, total_rating)
	efficiency_coeff = total_rating

/obj/machinery/rnd/production/circuit_imprinter/user_try_print_id(id, amount)
	. = ..()
	if(!.)
		return
	flick("circuit_imprinter_ani", src)

/obj/machinery/rnd/production/circuit_imprinter/offstation
	name = "ancient circuit imprinter"
	desc = "Manufactures circuit boards for the construction of machines. Its ancient construction may limit its ability to print all known technology."
	allowed_buildtypes = AWAY_IMPRINTER | IMPRINTER
	circuit = /obj/item/circuitboard/machine/circuit_imprinter/offstation

/obj/machinery/rnd/production/circuit_imprinter/robotics
	name = "robotics circuit imprinter"
	circuit = /obj/item/circuitboard/machine/circuit_imprinter/robotics
