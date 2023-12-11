//Spears
/datum/slapcraft_recipe/spear
	name = "makeshift spear"
	category = SLAP_CAT_WEAPONS
	steps = list(
		/datum/slapcraft_step/item/wirerod,
		/datum/slapcraft_step/item/glass_shard
	)
	result_type = /obj/item/spear

/datum/slapcraft_recipe/explosive_lance
	name = "explosive lance"
	category = SLAP_CAT_WEAPONS
	steps = list(
		/datum/slapcraft_step/spear,
		/datum/slapcraft_step/item/grenade,
		/datum/slapcraft_step/stack/or_other/binding
	)
	result_type = /obj/item/spear/explosive

/datum/slapcraft_step/spear
	desc = "Start with a spear."
	item_types = list(/obj/item/spear)

/datum/slapcraft_recipe/explosive_lance/create_item(item_path, obj/item/slapcraft_assembly/assembly)
	var/obj/item/spear/explosive/spear = new item_path(assembly.drop_location())
	if(!spear)
		return
	var/obj/item/grenade/G = assembly.contents.Find(/obj/item/grenade)
	spear.set_explosive(G)
	return spear
