/obj/machinery/rnd/production/circuit_imprinter/department
	name = "department circuit imprinter"
	desc = "A special circuit imprinter with a built in interface meant for departmental usage, with built in ExoSync receivers allowing it to print designs researched that match its ROM-encoded department type."
	icon_state = "circuit_imprinter"
	circuit = /obj/item/circuitboard/machine/circuit_imprinter/department

/obj/machinery/rnd/production/circuit_imprinter/department/science
	name = "department circuit imprinter (Science)"
	circuit = /obj/item/circuitboard/machine/circuit_imprinter/department/science
	mapload_design_flags = DESIGN_FAB_OMNI
	department_tag = "Science"
