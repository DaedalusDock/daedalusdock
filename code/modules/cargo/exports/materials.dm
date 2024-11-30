/datum/export/material
	cost = 5 // Cost per MINERAL_MATERIAL_AMOUNT, which is 2000cm3 as of April 2016.
	message = "cm3 of developer's tears. Please, report this on github"
	amount_report_multiplier = MINERAL_MATERIAL_AMOUNT
	var/datum/material/material_path = null
	export_types = list(
		/obj/item/stack/sheet/mineral, /obj/item/stack/tile/mineral,
		/obj/item/stack/ore, /obj/item/coin)

/datum/export/material/New()
	. = ..()
	cost = initial(material_path.value_per_unit) * MINERAL_MATERIAL_AMOUNT

// Yes, it's a base type containing export_types.
// But it has no material_path, so any applies_to check will return false, and these types reduce amount of copypasta a lot

/datum/export/material/get_amount(obj/O)
	if(!material_path)
		return 0
	if(!isitem(O))
		return 0

	var/obj/item/I = O
	var/list/mat_comp = I.get_material_composition(BREAKDOWN_FLAGS_EXPORT)
	var/datum/material/mat_ref = ispath(material_path) ? locate(material_path) in mat_comp : GET_MATERIAL_REF(material_path)
	if(isnull(mat_comp[mat_ref]))
		return 0

	var/amount = mat_comp[mat_ref]
	if(istype(I, /obj/item/stack/ore))
		amount *= 0.8 // Station's ore redemption equipment is really goddamn good.

	return round(amount / MINERAL_MATERIAL_AMOUNT)

// Materials. Nothing but plasma is really worth selling. Better leave it all to RnD and sell some plasma instead.

/datum/export/material/bananium
	material_path = /datum/material/bananium
	message = "cm3 of bananium"

/datum/export/material/diamond
	material_path = /datum/material/diamond
	message = "cm3 of diamonds"

/datum/export/material/plasma
	k_elasticity = 0
	material_path = /datum/material/plasma
	message = "cm3 of plasma"

/datum/export/material/uranium
	material_path = /datum/material/uranium
	message = "cm3 of uranium"

/datum/export/material/gold
	material_path = /datum/material/gold
	message = "cm3 of gold"

/datum/export/material/silver
	material_path = /datum/material/silver
	message = "cm3 of silver"

/datum/export/material/titanium
	material_path = /datum/material/titanium
	message = "cm3 of titanium"

/datum/export/material/mythril
	material_path = /datum/material/mythril
	message = "cm3 of mythril"

/datum/export/material/bscrystal
	message = "of bluespace crystals"
	material_path = /datum/material/bluespace

/datum/export/material/plastic
	message = "cm3 of plastic"
	material_path = /datum/material/plastic

/datum/export/material/runite
	message = "cm3 of runite"
	material_path = /datum/material/runite

/datum/export/material/iron
	message = "cm3 of iron"
	material_path = /datum/material/iron
	export_types = list(
		/obj/item/stack/sheet/iron, /obj/item/stack/tile/iron,
		/obj/item/stack/rods, /obj/item/stack/ore, /obj/item/coin)

/datum/export/material/glass
	message = "cm3 of glass"
	material_path = /datum/material/glass
	export_types = list(/obj/item/stack/sheet/glass, /obj/item/stack/ore,
		/obj/item/shard)

/datum/export/material/hot_ice
	message = "cm3 of Hot Ice"
	material_path = /datum/material/hot_ice
	export_types = /obj/item/stack/sheet/hot_ice

/datum/export/material/metal_hydrogen
	message = "cm3 of metallic hydrogen"
	material_path = /datum/material/metalhydrogen
	export_types = /obj/item/stack/sheet/mineral/metal_hydrogen
