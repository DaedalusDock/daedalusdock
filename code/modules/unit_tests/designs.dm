/datum/unit_test/designs

/datum/unit_test/designs/Run()
//Can't use allocate because of bug with certain datums
	var/datum/design/default_design = new /datum/design()

	for(var/datum/design/current_design as anything in SStech.designs)
		if (current_design.id == DESIGN_ID_IGNORE) //Don't check designs with ignore ID
			continue
		if (isnull(current_design.name) || current_design.name == default_design.name) //Designs with ID must have non default/null Name
			TEST_FAIL("Design [current_design.type] has default or null name var but has an ID")
		if ((!isnull(current_design.materials) && LAZYLEN(current_design.materials)) || (!isnull(current_design.reagents_list) && LAZYLEN(current_design.reagents_list))) //Design requires materials
			if ((isnull(current_design.build_path) || current_design.build_path == default_design.build_path) && (isnull(current_design.make_reagents) || current_design.make_reagents == default_design.make_reagents)) //Check if design gives any output
				TEST_FAIL("Design [current_design.type] requires materials but does not have have any build_path or make_reagents set")
		else if (!isnull(current_design.build_path) || !isnull(current_design.build_path)) // //Design requires no materials but creates stuff
			TEST_FAIL("Design [current_design.type] requires NO materials but has build_path or make_reagents set")

// Make sure all fabricator designs are sane.
/datum/unit_test/fab_sanity

/datum/unit_test/fab_sanity/Run()
	var/obj/machinery/rnd/production/fab
	for(var/type_of_fab in subtypesof(/obj/machinery/rnd/production))
		fab = allocate(type_of_fab, run_loc_floor_bottom_left)
		var/disk = fab.circuit.def_components?[/obj/item/disk/data]
		if(!disk)
			continue

		fab.set_internal_disk(new disk)

		for(var/datum/design/D as anything in fab.disk_get_designs(FABRICATOR_FILE_NAME))
			if(!(D.build_type & fab.allowed_buildtypes))
				TEST_FAIL("[type_of_fab] has a design it cannot print: [D.type]")
