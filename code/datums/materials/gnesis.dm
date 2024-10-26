/datum/material/gnesis
	name = "gnesis"
	desc = "A rare, complex crystalline matrix with a lazily shifting internal structure. Not to be confused with gneiss, a metamorphic rock."
	color = "#1bdebd"
	greyscale_colors = "#1bdebd"

	categories = list(MAT_CATEGORY_RIGID = TRUE, MAT_CATEGORY_BASE_RECIPES = TRUE, MAT_CATEGORY_ITEM_MATERIAL=TRUE)
	integrity_modifier = 0.2

	sheet_type = /obj/item/stack/sheet/gnesis
	wall_type = /turf/closed/wall/flock
	wall_icon = 'goon/icons/turf/flock.dmi'
	wall_stripe_icon = null
	wall_color = "#1bdebd"

/datum/material/gnesis_glass
	name = "translucent gnesis"
	desc = "A rare, complex crystalline matrix with a lazily shifting internal structure. The layers are arranged to let light through."
	color = "#1bdebd"
	greyscale_colors = "#1bdebd"
	alpha = 150
	sheet_type = /obj/item/stack/sheet/gnesis_glass
	categories = list(MAT_CATEGORY_RIGID = TRUE, MAT_CATEGORY_BASE_RECIPES = TRUE, MAT_CATEGORY_ITEM_MATERIAL=TRUE)
	integrity_modifier = 0.1
	sheet_type = /obj/item/stack/sheet/gnesis_glass
	shard_type = /obj/item/shard/gnesis_glass
	value_per_unit = IRON_VALUE_PER_UNIT * 50
	beauty_modifier = 0.05
	armor_modifiers = list(BLUNT = 0.2, PUNCTURE = 0.2, SLASH = 0, LASER = 0, ENERGY = 1, BOMB = 0, BIO = 0.2, FIRE = 1, ACID = 0.2)
	wall_type = null

/datum/material/gnesis_glass/on_accidental_mat_consumption(mob/living/carbon/victim, obj/item/source_item)
	victim.apply_damage(10, BRUTE, BODY_ZONE_HEAD, sharpness = TRUE) //cronch
	return TRUE

