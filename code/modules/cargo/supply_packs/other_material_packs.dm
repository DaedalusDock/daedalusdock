/datum/supply_pack/materials_other
	group = "Materials (Other)"

/datum/supply_pack/materials_other/rcd_ammo
	name = "RCD Ammo"
	desc = "Contains four raw material cartridges that can be used to quickly recharge any RCD."
	cost = CARGO_CRATE_VALUE * 8.5
	contains = list(
		/obj/item/rcd_ammo,
		/obj/item/rcd_ammo,
		/obj/item/rcd_ammo/large,
		/obj/item/rcd_ammo/large,
	)
	crate_name = "rcd ammo crate"

/datum/supply_pack/materials_other/foamtank
	name = "Firefighting Foam Tank Crate"
	desc = "Contains a tank of firefighting foam."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/structure/reagent_dispensers/foamtank)
	crate_name = "foam tank crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials_other/fueltank
	name = "Fuel Tank Crate"
	desc = "Contains a welding fuel tank. Caution, highly flammable."
	cost = CARGO_CRATE_VALUE * 1.6
	contains = list(/obj/structure/reagent_dispensers/fueltank)
	crate_name = "fuel tank crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials_other/hightank
	name = "Large Water Tank Crate"
	desc = "Contains a high-capacity water tank. Useful for botany or other service jobs."
	cost = CARGO_CRATE_VALUE * 2.4
	contains = list(/obj/structure/reagent_dispensers/watertank/high)
	crate_name = "high-capacity water tank crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials_other/hightankfuel
	name = "Large Fuel Tank Crate"
	desc = "Contains a high-capacity fuel tank. Keep contents away from open flame."
	cost = CARGO_CRATE_VALUE * 4
	access_view = ACCESS_ENGINEERING
	contains = list(/obj/structure/reagent_dispensers/fueltank/large)
	crate_name = "high-capacity fuel tank crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials_other/watertank
	name = "Water Tank Crate"
	desc = "Contains a tank of dihydrogen monoxide... sounds dangerous."
	cost = CARGO_CRATE_VALUE * 1.2
	contains = list(/obj/structure/reagent_dispensers/watertank)
	crate_name = "water tank crate"
	crate_type = /obj/structure/closet/crate/large

