/** Materials made from other materials.
 */
/datum/material/alloy
	abstract_type = /datum/material/alloy

	name = "alloy"
	desc = "A material composed of two or more other materials."
	/// The materials this alloy is made from weighted by their ratios.
	var/list/composition = null
	/// Breakdown flags required to reduce this alloy to its component materials.
	var/req_breakdown_flags = BREAKDOWN_ALLOYS

/datum/material/alloy/return_composition(amount=1, breakdown_flags)
	if(req_breakdown_flags & !(breakdown_flags & req_breakdown_flags))
		return ..()

	. = list()
	var/list/cached_comp = composition
	for(var/comp_mat in cached_comp)
		var/datum/material/component_material = GET_MATERIAL_REF(comp_mat)
		var/list/component_composition = component_material.return_composition(cached_comp[comp_mat], breakdown_flags)
		for(var/comp_comp_mat in component_composition)
			.[comp_comp_mat] += component_composition[comp_comp_mat] * amount


/** Plasteel
 *
 * An alloy of iron and plasma.
 * Applies a significant slowdown effect to any and all items that contain it.
 */
/datum/material/alloy/plasteel
	name = "plasteel"
	desc = "The heavy duty result of infusing iron with plasma."
	color = "#706374"
	greyscale_colors = "#706374"
	value_per_unit = ((/datum/material/iron::value_per_unit * 0.5) + (/datum/material/plasma::value_per_unit * 0.5)) * 1.1
	strength_modifier = 1.25
	integrity_modifier = 1.5 // Heavy duty.
	armor_modifiers = list(BLUNT = 1.4, PUNCTURE = 1.4, SLASH = 0, LASER = 1.1, ENERGY = 1.1, BOMB = 1.5, BIO = 1, FIRE = 1.1, ACID = 1)
	sheet_type = /obj/item/stack/sheet/plasteel
	categories = list(MAT_CATEGORY_RIGID=TRUE, MAT_CATEGORY_BASE_RECIPES=TRUE, MAT_CATEGORY_ITEM_MATERIAL=TRUE)
	composition = list(/datum/material/iron=1, /datum/material/plasma=1)
	reinforced_wall_icon = 'icons/turf/walls/solid_wall_reinforced.dmi'
	//This creates legacy r_walls so that I don't have to recode a shitload of stuff
	wall_type = /turf/closed/wall/r_wall
	false_wall_type = /obj/structure/falsewall/reinforced
	wall_name = "bulkhead"
	wall_color = "#57575c"
	hard_wall_decon = TRUE

/datum/material/alloy/plasteel/on_applied_obj(obj/item/target_item, amount, material_flags)
	. = ..()
	if(!istype(target_item))
		return

	target_item.slowdown += MATERIAL_SLOWDOWN_PLASTEEL * amount / MINERAL_MATERIAL_AMOUNT

/datum/material/alloy/plasteel/on_removed_obj(obj/item/target_item, amount, material_flags)
	. = ..()

	if(!istype(target_item))
		return

	target_item.slowdown -= MATERIAL_SLOWDOWN_PLASTEEL * amount / MINERAL_MATERIAL_AMOUNT

/** Plastitanium
 *
 * An alloy of titanium and plasma.
 */
/datum/material/alloy/plastitanium
	name = "plastitanium"
	desc = "The extremely heat resistant result of infusing titanium with plasma."
	color = "#3a313a"
	greyscale_colors = "#3a313a"
	value_per_unit = ((/datum/material/titanium::value_per_unit * 0.5) + (/datum/material/plasma::value_per_unit * 0.5)) * 1.2
	strength_modifier = 0.9 // It's a lightweight alloy.
	integrity_modifier = 1.3
	armor_modifiers = list(BLUNT = 1.1, PUNCTURE = 1.1, SLASH = 0, LASER = 1.4, ENERGY = 1.4, BOMB = 1.1, BIO = 1.2, FIRE = 1.5, ACID = 1)
	sheet_type = /obj/item/stack/sheet/mineral/plastitanium
	categories = list(MAT_CATEGORY_RIGID=TRUE, MAT_CATEGORY_BASE_RECIPES=TRUE, MAT_CATEGORY_ITEM_MATERIAL=TRUE)
	composition = list(/datum/material/titanium=1, /datum/material/plasma=1)
	wall_icon = 'icons/turf/walls/metal_wall.dmi'
	reinforced_wall_icon = 'icons/turf/walls/solid_wall_reinforced.dmi'
	wall_type = /turf/closed/wall/mineral/plastitanium
	false_wall_type = /obj/structure/falsewall/plastitanium
	hard_wall_decon = TRUE
	wall_color = "#423b3b"

/** Plasmaglass
 *
 * An alloy of silicate and plasma.
 */
/datum/material/alloy/plasmaglass
	name = "plasmaglass"
	desc = "Plasma-infused silicate. It is much more durable and heat resistant than either of its component materials."
	color = "#ff80f4"
	greyscale_colors = "#ff80f4"
	alpha = 150
	integrity_modifier = 0.5
	armor_modifiers = list(BLUNT = 0.8, PUNCTURE = 0.8, SLASH = 0, LASER = 1.2, ENERGY = 1.2, BOMB = 0.3, BIO = 1.2, FIRE = 2, ACID = 2)
	sheet_type = /obj/item/stack/sheet/plasmaglass
	shard_type = /obj/item/shard/plasma
	value_per_unit = ((/datum/material/glass::value_per_unit * 1) + (/datum/material/plasma::value_per_unit * 0.5)) * 1.1
	categories = list(MAT_CATEGORY_RIGID=TRUE, MAT_CATEGORY_BASE_RECIPES=TRUE, MAT_CATEGORY_ITEM_MATERIAL=TRUE)
	composition = list(/datum/material/glass=1, /datum/material/plasma=0.5)
	wall_type = null

/** Titaniumglass
 *
 * An alloy of glass and titanium.
 */
/datum/material/alloy/titaniumglass
	name = "titanium glass"
	desc = "A specialized silicate-titanium alloy that is commonly used in shuttle windows."
	color = "#cfbee0"
	greyscale_colors = "#cfbee0"
	alpha = 150
	armor_modifiers = list(BLUNT = 1.2, PUNCTURE = 1.2, SLASH = 0, LASER = 0.8, ENERGY = 0.8, BOMB = 0.5, BIO = 1.2, FIRE = 0.8, ACID = 2)
	sheet_type = /obj/item/stack/sheet/titaniumglass
	shard_type = /obj/item/shard/titanium
	value_per_unit = ((/datum/material/glass::value_per_unit * 1) + (/datum/material/titanium::value_per_unit * 0.5)) * 1.04
	categories = list(MAT_CATEGORY_RIGID=TRUE, MAT_CATEGORY_BASE_RECIPES=TRUE, MAT_CATEGORY_ITEM_MATERIAL=TRUE)
	composition = list(/datum/material/glass=1, /datum/material/titanium=0.5)
	wall_type = null

/** Plastitanium Glass
 *
 * An alloy of plastitanium and glass.
 */
/datum/material/alloy/plastitaniumglass
	name = "plastitanium glass"
	desc = "A specialized silicate-plastitanium alloy."
	color = "#5d3369"
	greyscale_colors = "#5d3369"
	alpha = 150
	integrity_modifier = 1.1
	armor_modifiers = list(BLUNT = 1.2, PUNCTURE = 1.2, SLASH = 0, LASER = 1.2, ENERGY = 1.2, BOMB = 0.5, BIO = 1.2, FIRE = 2, ACID = 2)
	sheet_type = /obj/item/stack/sheet/plastitaniumglass
	shard_type = /obj/item/shard/plastitanium
	value_per_unit = (/datum/material/glass::value_per_unit * 1) + (/datum/material/alloy/plastitanium::value_per_unit * 0.5) * 1.2
	categories = list(MAT_CATEGORY_RIGID=TRUE, MAT_CATEGORY_BASE_RECIPES=TRUE, MAT_CATEGORY_ITEM_MATERIAL=TRUE)
	composition = list(/datum/material/glass=1, /datum/material/alloy/plastitanium=0.5)

/** Alien Alloy
 *
 * Densified plasteel.
 * Applies a significant slowdown effect to anything that contains it.
 * Anything constructed from it can slowly regenerate.
 */
/datum/material/alloy/alien
	name = "alien alloy"
	desc = "An extremely dense alloy similar to plasteel in composition. It requires exotic metallurgical processes to create."
	color = "#6041aa"
	greyscale_colors = "#6041aa"
	strength_modifier = 1.5 // It's twice the density of plasteel and just as durable. Getting hit with it is going to HURT.
	integrity_modifier = 1.5
	armor_modifiers = list(BLUNT = 1.4, PUNCTURE = 1.4, SLASH = 0, LASER = 1.2, ENERGY = 1.2, BOMB = 1.5, BIO = 1.2, FIRE = 1.2, ACID = 1.2)
	sheet_type = /obj/item/stack/sheet/mineral/abductor
	value_per_unit = 1
	categories = list(MAT_CATEGORY_RIGID=TRUE, MAT_CATEGORY_BASE_RECIPES=TRUE, MAT_CATEGORY_ITEM_MATERIAL=TRUE)
	composition = list(/datum/material/iron=2, /datum/material/plasma=2)
	reinforced_wall_icon = 'icons/turf/walls/solid_wall_reinforced.dmi'
	wall_name = "hull"
	hard_wall_decon = TRUE

/datum/material/alloy/alien/on_applied_obj(obj/item/target_item, amount, material_flags)
	. = ..()

	target_item.AddElement(/datum/element/obj_regen, _rate=0.02) // 2% regen per tick.
	if(!istype(target_item))
		return

	target_item.slowdown += MATERIAL_SLOWDOWN_ALIEN_ALLOY * amount / MINERAL_MATERIAL_AMOUNT

/datum/material/alloy/alien/on_removed_obj(obj/item/target_item, amount, material_flags)
	. = ..()

	target_item.RemoveElement(/datum/element/obj_regen, _rate=0.02)
	if(!istype(target_item))
		return

	target_item.slowdown -= MATERIAL_SLOWDOWN_ALIEN_ALLOY * amount / MINERAL_MATERIAL_AMOUNT
