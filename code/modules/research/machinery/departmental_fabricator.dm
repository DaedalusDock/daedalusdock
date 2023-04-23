/obj/machinery/rnd/production/fabricator/department
	name = "departmental fabricator"
	desc = "A special fabricator with a built in interface meant for departmental usage, with built in ExoSync receivers allowing it to print designs researched that match its ROM-encoded department type."
	icon_state = "protolathe"
	circuit = /obj/item/circuitboard/machine/fabricator/department

/obj/machinery/rnd/production/fabricator/department/engineering
	name = "engineering fabricator"
	allowed_department_flags = DEPARTMENTAL_FLAG_ENGINEERING
	department_tag = "Engineering"
	circuit = /obj/item/circuitboard/machine/fabricator/department/engineering
	stripe_color = "#EFB341"

/obj/machinery/rnd/production/fabricator/department/service
	name = "service fabricator"
	allowed_department_flags = DEPARTMENTAL_FLAG_SERVICE
	department_tag = "Service"
	circuit = /obj/item/circuitboard/machine/fabricator/department/service
	stripe_color = "#83ca41"

/obj/machinery/rnd/production/fabricator/department/medical
	name = "medical fabricator"
	allowed_department_flags = DEPARTMENTAL_FLAG_MEDICAL
	department_tag = "Medical"
	circuit = /obj/item/circuitboard/machine/fabricator/department/medical
	stripe_color = "#52B4E9"

/obj/machinery/rnd/production/fabricator/department/cargo
	name = "supply fabricator"
	allowed_department_flags = DEPARTMENTAL_FLAG_CARGO
	department_tag = "Cargo"
	circuit = /obj/item/circuitboard/machine/fabricator/department/cargo
	stripe_color = "#956929"

/obj/machinery/rnd/production/fabricator/department/security
	name = "security fabricator"
	allowed_department_flags = DEPARTMENTAL_FLAG_SECURITY
	department_tag = "Security"
	circuit = /obj/item/circuitboard/machine/fabricator/department/security
	stripe_color = "#DE3A3A"
