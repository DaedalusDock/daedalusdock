/obj/item/proc/get_fibers()
	return null

/obj/item/clothing/get_fibers()
	return "material from \a [fiber_name || name]."

/obj/item/clothing/gloves/get_fibers()
	return "material from a pair of [fiber_name || name]."

/obj/item/clothing/shoes/get_fibers()
	return "material from a pair of [fiber_name || name]."
