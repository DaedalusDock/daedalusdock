/obj/machinery/rnd/production/fabricator/department
	name = "departmental fabricator"
	desc = "A special fabricator with a built in interface meant for departmental usage, with built in ExoSync receivers allowing it to print designs researched that match its ROM-encoded department type."
	icon_state = "protolathe"
	circuit = /obj/item/circuitboard/machine/fabricator/department

/obj/machinery/rnd/production/fabricator/department/service
	name = "service fabricator"
	design_flags_to_init = DESIGN_FAB_SERVICE
	department_tag = "Service"
	circuit = /obj/item/circuitboard/machine/fabricator/department/service
	stripe_color = "#83ca41"

/obj/machinery/rnd/production/fabricator/department/medical
	name = "medical fabricator"
	design_flags_to_init = DESIGN_FAB_MEDICAL
	department_tag = "Medical"
	circuit = /obj/item/circuitboard/machine/fabricator/department/medical
	stripe_color = "#52B4E9"

/obj/machinery/rnd/production/fabricator/department/cargo
	name = "supply fabricator"
	design_flags_to_init = DESIGN_FAB_SUPPLY
	department_tag = "Cargo"
	circuit = /obj/item/circuitboard/machine/fabricator/department/cargo
	stripe_color = "#956929"

/obj/machinery/rnd/production/fabricator/department/security
	name = "security fabricator"
	design_flags_to_init = DESIGN_FAB_SECURITY
	department_tag = "Security"
	circuit = /obj/item/circuitboard/machine/fabricator/department/security
	stripe_color = "#DE3A3A"

/obj/machinery/rnd/production/fabricator/department/robotics
	name = "robotics fabricator"
	department_tag = "Robotics"
	circuit = /obj/item/circuitboard/machine/fabricator/department/robotics
	stripe_color = "#575456"
	design_flags_to_init = DESIGN_FAB_ROBOTICS

/obj/machinery/rnd/production/fabricator/department/engineering
	name = "engineering fabricator"
	design_flags_to_init = DESIGN_FAB_ENGINEERING
	department_tag = "Engineering"
	circuit = /obj/item/circuitboard/machine/fabricator/department/engineering
	stripe_color = "#EFB341"

