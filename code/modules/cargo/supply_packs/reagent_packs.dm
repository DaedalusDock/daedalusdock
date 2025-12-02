//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Reagent /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
/datum/supply_pack/reagent
	group = "Reagents"
	crate_type = /obj/structure/closet/crate/medical

/datum/supply_pack/reagent/chemical_carts
	name = "Generic Chemistry Cartridge Pack"
	desc = "You shouldn't see this."
	crate_name = "chemical cartridges crate"

/datum/supply_pack/reagent/chemical_carts/New()
	. = ..()
	set_cart_list()

//this is just here for subtypes
/datum/supply_pack/reagent/chemical_carts/proc/set_cart_list()
	return

/datum/supply_pack/reagent/chemical_carts/fill(obj/structure/closet/crate/crate)
	for(var/datum/reagent/chem as anything in contains)
		var/obj/item/reagent_containers/chem_cartridge/cartridge = contains[chem]
		cartridge = new cartridge(crate)
		if(admin_spawned)
			cartridge.flags_1 |= ADMIN_SPAWNED_1
		cartridge.setLabel(initial(chem.name))
		cartridge.reagents.add_reagent(chem, cartridge.volume)

/datum/supply_pack/reagent/chemical_carts_empty
	name = "Empty Chemical Cartridge Pack"
	desc = "A pack of empty cartridges for use in chem dispensers."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/reagent_containers/chem_cartridge/large,
					/obj/item/reagent_containers/chem_cartridge/large,
					/obj/item/reagent_containers/chem_cartridge/medium,
					/obj/item/reagent_containers/chem_cartridge/medium,
					/obj/item/reagent_containers/chem_cartridge/medium,
					/obj/item/reagent_containers/chem_cartridge/small,
					/obj/item/reagent_containers/chem_cartridge/small,
					/obj/item/reagent_containers/chem_cartridge/small)
	crate_name = "empty chemical cartridges crate"

/datum/supply_pack/reagent/chemical_carts/chemistry_starter_pack
	name = "Full Chemistry Cartridge Pack"
	desc = "Contains a full set of chem dispenser cartridges with every chemical you'll need for making pharmaceuticals."
	cost = PAYCHECK_ASSISTANT * 50 + CARGO_CRATE_VALUE //price may need balancing

/datum/supply_pack/reagent/chemical_carts/chemistry_starter_pack/set_cart_list()
	contains = GLOB.cartridge_list_chems.Copy()

/datum/supply_pack/reagent/chemical_carts/soft_drinks_chem_cartridge
	name = "Drinks Cartridge Luxury Pack (Full Dispenser)"
	desc = "Contains a full set of chem cartridges of the same size inside a soft drinks dispenser at shift start."
	cost = PAYCHECK_ASSISTANT * 8.7 + CARGO_CRATE_VALUE

/datum/supply_pack/reagent/chemical_carts/soft_drinks_chem_cartridge/set_cart_list()
	contains = GLOB.cartridge_list_drinks.Copy()

/datum/supply_pack/reagent/chemical_carts/booze_chem_cartridge
	name = "Booze Cartridge Luxury Pack (Full Dispenser)"
	desc = "Contains a full set of chem cartridges of the same size inside a booze dispenser at shift start."
	cost = PAYCHECK_ASSISTANT * 12.5 + CARGO_CRATE_VALUE

/datum/supply_pack/reagent/chemical_carts/booze_chem_cartridge/set_cart_list()
	contains = GLOB.cartridge_list_booze.Copy()

/datum/supply_pack/reagent/individual_chem_cart

/datum/supply_pack/reagent/individual_chem_cart/generate_supply_packs()
	if(contains) // Prevent infinite recursion
		return

	. = list()

	// The absolute minimum cost of a reagent crate is what the reagents come in.
	var/base_cost = /datum/export/chem_cartridge/medium::cost + CARGO_CRATE_VALUE
	var/volume = /obj/item/reagent_containers/chem_cartridge/medium::volume

	for(var/datum/reagent/reagent_path as anything in GLOB.cartridge_list_chems | GLOB.cartridge_list_botany | GLOB.cartridge_list_booze | GLOB.cartridge_list_drinks)
		var/datum/supply_pack/reagent/individual_chem_cart/pack = new
		var/name = initial(reagent_path.name)
		pack.name = "Single Crate of [name]"
		pack.desc = "Contains [volume]u of [name]."
		pack.crate_name = "reagent crate ([name])"
		pack.id = "[type]([name])"

		pack.cost = round(base_cost + (initial(reagent_path.value) * volume), 5)

		pack.contains = list(reagent_path)

		pack.crate_type = crate_type

		. += pack

/datum/supply_pack/reagent/individual_chem_cart/fill(obj/structure/closet/crate/crate)
	var/datum/reagent/reagent_path = contains[1]
	for(var/i in 1 to 3)
		var/obj/item/reagent_containers/chem_cartridge/medium/cartridge = new(crate)
		if(admin_spawned)
			cartridge.flags_1 |= ADMIN_SPAWNED_1

		cartridge.setLabel(initial(reagent_path.name))
		cartridge.reagents.add_reagent(reagent_path, cartridge.volume)
