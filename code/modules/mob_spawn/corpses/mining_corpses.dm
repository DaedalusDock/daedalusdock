
//legion bodies are here, and other mining related bodies

//Tendril-spawned Legion remains, the charred skeletons of those whose bodies sank into laval or fell into chasms.
/obj/effect/mob_spawn/corpse/human/charredskeleton
	name = "charred skeletal remains"
	mob_name = "ashen skeleton"
	burn_damage = 1000
	mob_species = /datum/species/skeleton

/obj/effect/mob_spawn/corpse/human/charredskeleton/special(mob/living/carbon/human/spawned_human)
	. = ..()
	spawned_human.color = "#454545"
	spawned_human.gender = NEUTER
	//don't need to set the human's body type (neuter)
