/datum/movespeed_modifier/shrink_ray
	movetypes = GROUND
	slowdown = 4
	flags = IGNORE_NOSLOW

/datum/movespeed_modifier/snail_crawl
	slowdown = -7
	movetypes = GROUND

/datum/movespeed_modifier/tenacious
	slowdown = -0.7
	movetypes = GROUND

/datum/movespeed_modifier/sanity
	id = MOVESPEED_ID_SANITY
	movetypes = (~FLYING)

/datum/movespeed_modifier/sanity/insane
	slowdown = 1

/datum/movespeed_modifier/sanity/crazy
	slowdown = 0.5

/datum/movespeed_modifier/sanity/disturbed
	slowdown = 0.25
