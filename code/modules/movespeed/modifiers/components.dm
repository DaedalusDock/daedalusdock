/datum/movespeed_modifier/shrink_ray
	movetypes = GROUND
	modifier = -1.25
	flags = IGNORE_NOSLOW

/datum/movespeed_modifier/snail_crawl
	modifier = -1.6
	movetypes = GROUND

/datum/movespeed_modifier/tenacious
	modifier = 0.5
	movetypes = GROUND

/datum/movespeed_modifier/sanity
	id = MOVESPEED_ID_SANITY
	movetypes = (~FLYING)

/datum/movespeed_modifier/sanity/insane
	modifier = -0.5

/datum/movespeed_modifier/sanity/crazy
	modifier = -0.27

/datum/movespeed_modifier/sanity/disturbed
	modifier = -0.14
