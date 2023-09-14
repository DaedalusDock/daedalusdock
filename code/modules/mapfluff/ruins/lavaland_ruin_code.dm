//If you're looking for spawners like ash walker eggs, check ghost_role_spawners.dm

///Wizard tower item
/obj/item/disk/data/knight_gear
	name = "Magic Disk of Smithing"

/obj/item/disk/data/knight_gear/Initialize(mapload)
	. = ..()
	LAZYADD(memory[DATA_IDX_DESIGNS], SStech.designs_by_type[/datum/design/knight_armour])
	LAZYADD(memory[DATA_IDX_DESIGNS],SStech.designs_by_type[/datum/design/knight_helmet])
