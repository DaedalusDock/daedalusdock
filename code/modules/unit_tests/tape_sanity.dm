/datum/unit_test/tape_sanity/Run()
	for(var/obj/item/tape/tape as anything in subtypesof(/obj/item/tape))
		tape = allocate(tape)

		if(length(tape.storedinfo) != length(tape.timestamp))
			TEST_FAIL("[tape.type] front side data lengths do not match.")

		if(length(tape.storedinfo_otherside) != length(tape.storedinfo_otherside))
			TEST_FAIL("[tape.type] back side data lengths do not match.")
