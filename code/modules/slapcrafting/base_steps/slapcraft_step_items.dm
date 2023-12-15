/// A parent type that denotes inserting an item
/datum/slapcraft_step/item
	abstract_type = /datum/slapcraft_step/item
	insert_item_into_result = TRUE

/datum/slapcraft_step/item/welder
	desc = "Start with normal sized welding tool."
	finished_desc = "A welding tool has been added."
	item_types = list(/obj/item/weldingtool)

/datum/slapcraft_step/item/welder/base_only
	blacklist_item_types = list(/obj/item/weldingtool/mini, /obj/item/weldingtool/largetank, /obj/item/weldingtool/experimental)

/datum/slapcraft_step/item/igniter
	desc = "Attach an igniter"
	finished_desc = "An igniter has been added."
	todo_desc = "You could add an igniter..."
	item_types = list(/obj/item/assembly/igniter)

	start_msg = "%USER% begins attaching an igniter to the %TARGET%."
	start_msg_self = "You begin attaching an igniter to the %TARGET%."

/datum/slapcraft_step/item/glass_shard
	desc = "Attach a shard of glass."
	finished_desc = "A shard of glass has been added."
	todo_desc = "You could add a shard of glass..."
	item_types = list(/obj/item/shard)

	start_msg = "%USER% begins attaching shard of glass to the %TARGET%."
	start_msg_self = "You begin attaching shard of glass to the %TARGET%."

/datum/slapcraft_step/item/glass_shard/insert
	insert_item_into_result = TRUE

/datum/slapcraft_step/item/wirerod
	desc = "Attach a wirerod."
	todo_desc = "You could attach a wired rod..."
	finished_desc = "A wired rod has been added."
	item_types = list(/obj/item/wirerod)

	start_msg = "%USER% begins attaching a wirerod to the %TARGET%."
	start_msg_self = "You begin attaching a wirerod to the %TARGET%."

/datum/slapcraft_step/item/metal_ball
	desc = "Attach a metal ball."
	todo_desc = "You could attach a metal ball..."
	finished_desc = "A metal ball has been added."
	item_types = list(/obj/item/wirerod)

	start_msg = "%USER% begins attaching a metal ball to the %TARGET%."
	start_msg_self = "You begin attaching a metal ball to the %TARGET%."

/datum/slapcraft_step/item/grenade
	desc = "Attach a grenade."
	todo_desc = "You could attach a grenade..."
	finished_desc = "A grenade has been added."
	item_types = list(/obj/item/grenade)
	perform_time = 0
	finish_msg = "%USER% attaches an explosive to the %TARGET%."
	finish_msg_self = "You attach an explosive to the %TARGET%."
