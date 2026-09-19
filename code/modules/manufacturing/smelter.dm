/obj/machinery/manufacturing/furnace
	name = "furnace"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "furnace"

/obj/machinery/manufacturing/furnace/check_item_type(obj/item/item)
	var/obj/item/stack/ore/ore = item
	if(!istype(ore))
		return FALSE

	if(!ore.refined_type)
		return FALSE

	return TRUE

/obj/machinery/manufacturing/furnace/process_item(obj/item/item)
	var/obj/item/stack/ore/ore = item
	ore.use(1)

	var/obj/item/stack/output = new ore.refined_type(null, 1)
	eject_item(output)
