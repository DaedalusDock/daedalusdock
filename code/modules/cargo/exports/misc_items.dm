
/datum/export/chem_cartridge
	k_elasticity = FALSE

/datum/export/chem_cartridge/small
	unit_name = /obj/item/reagent_containers/chem_cartridge/small::name
	export_types = list(/obj/item/reagent_containers/chem_cartridge/small)
	cost = CARTRIDGE_VOLUME_SMALL / 25

/datum/export/chem_cartridge/medium
	unit_name = /obj/item/reagent_containers/chem_cartridge/medium::name
	export_types = list(/obj/item/reagent_containers/chem_cartridge/medium)
	cost = CARTRIDGE_VOLUME_MEDIUM / 25

/datum/export/chem_cartridge/large
	unit_name = /obj/item/reagent_containers/chem_cartridge/large::name
	export_types = list(/obj/item/reagent_containers/chem_cartridge/large)
	cost = CARTRIDGE_VOLUME_LARGE / 25
