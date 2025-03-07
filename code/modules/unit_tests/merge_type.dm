/datum/unit_test/merge_type/Run()
	var/list/blacklist = list() //Abstracted these away :smug:

	var/list/paths = subtypesof(/obj/item/stack) - blacklist

	for(var/stackpath in paths)
		var/obj/item/stack/stack = stackpath
		if(!isabstract(stack) && !stack.merge_type)
			TEST_FAIL("([stack]) lacks set merge_type variable!")
