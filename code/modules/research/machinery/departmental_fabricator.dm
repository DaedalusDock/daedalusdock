/obj/machinery/rnd/production/fabricator/department
	name = "departmental fabricator"
	desc = "A special fabricator with a built in interface meant for departmental usage, with built in ExoSync receivers allowing it to print designs researched that match its ROM-encoded department type."
	circuit = /obj/item/circuitboard/machine/fabricator/department

/obj/machinery/rnd/production/fabricator/department/service
	name = "service fabricator"
	icon_state = "fab-hangar"
	department_tag = "Service"
	circuit = /obj/item/circuitboard/machine/fabricator/department/service

/obj/machinery/rnd/production/fabricator/department/medical
	name = "medical fabricator"
	icon_state = "fab-med"
	department_tag = "Medical"
	circuit = /obj/item/circuitboard/machine/fabricator/department/medical

/obj/machinery/rnd/production/fabricator/department/cargo
	name = "supply fabricator"
	icon_state = "fab-crates"
	department_tag = "Cargo"
	circuit = /obj/item/circuitboard/machine/fabricator/department/cargo

/obj/machinery/rnd/production/fabricator/department/security
	name = "security fabricator"
	icon_state = "fab-recycle"
	department_tag = "Security"
	circuit = /obj/item/circuitboard/machine/fabricator/department/security

/obj/machinery/rnd/production/fabricator/department/robotics
	name = "robotics fabricator"
	icon_state = "fab-robotics"
	department_tag = "Robotics"
	allowed_buildtypes = FABRICATOR | MECHFAB
	circuit = /obj/item/circuitboard/machine/fabricator/department/robotics

/obj/machinery/rnd/production/fabricator/department/engineering
	name = "engineering fabricator"
	icon_state = "fab-mining"
	department_tag = "Engineering"
	circuit = /obj/item/circuitboard/machine/fabricator/department/engineering

/obj/machinery/rnd/production/fabricator/department/civvie
	name = "civilian fabricator"
	icon_state = "fab-jumpsuit"
	department_tag = "Civilian"
	circuit = /obj/item/circuitboard/machine/fabricator/department/civvie
