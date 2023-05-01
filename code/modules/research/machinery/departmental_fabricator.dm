/obj/machinery/rnd/production/fabricator/department
	name = "departmental fabricator"
	desc = "A special fabricator with a built in interface meant for departmental usage, with built in ExoSync receivers allowing it to print designs researched that match its ROM-encoded department type."
	icon_state = "protolathe"
	circuit = /obj/item/circuitboard/machine/fabricator/department

/obj/machinery/rnd/production/fabricator/department/service
	name = "service fabricator"
	department_tag = "Service"
	circuit = /obj/item/circuitboard/machine/fabricator/department/service
	stripe_color = "#83ca41"

/obj/machinery/rnd/production/fabricator/department/medical
	name = "medical fabricator"
	department_tag = "Medical"
	circuit = /obj/item/circuitboard/machine/fabricator/department/medical
	stripe_color = "#52B4E9"

/obj/machinery/rnd/production/fabricator/department/cargo
	name = "supply fabricator"
	department_tag = "Cargo"
	circuit = /obj/item/circuitboard/machine/fabricator/department/cargo
	stripe_color = "#956929"

/obj/machinery/rnd/production/fabricator/department/security
	name = "security fabricator"
	department_tag = "Security"
	circuit = /obj/item/circuitboard/machine/fabricator/department/security
	stripe_color = "#DE3A3A"

/obj/machinery/rnd/production/fabricator/department/robotics
	name = "robotics fabricator"
	department_tag = "Robotics"
	allowed_buildtypes = FABRICATOR | MECHFAB
	circuit = /obj/item/circuitboard/machine/fabricator/department/robotics
	stripe_color = "#575456"

/obj/machinery/rnd/production/fabricator/department/engineering
	name = "engineering fabricator"
	department_tag = "Engineering"
	circuit = /obj/item/circuitboard/machine/fabricator/department/engineering
	stripe_color = "#EFB341"

/obj/machinery/rnd/production/fabricator/department/civvie
	name = "civilian fabricator"
	department_tag = "Civilian"
	circuit = /obj/item/circuitboard/machine/fabricator/department/civvie
	stripe_color = "#525252ff"
