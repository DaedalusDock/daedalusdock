/// Ensures that when disassembling a machine, all the parts are given back
/datum/unit_test/machine_disassembly/Run()
	var/obj/machinery/freezer = allocate(/obj/machinery/atmospherics/components/unary/thermomachine/freezer)

	var/turf/freezer_location = freezer.loc
	freezer.deconstruct()

	// Check that the components are created
	TEST_ASSERT(locate(/obj/item/stock_parts/capacitor) in freezer_location, "Couldn't find capacitor when disassembling freezer")

	// Check that the circuit board itself is created
	TEST_ASSERT(locate(/obj/item/circuitboard/machine/thermomachine) in freezer_location, "Couldn't find the circuit board when disassembling freezer")
