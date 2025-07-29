/datum/species/ghoul
	name = "Ghoul"
	id = "ghoul"
	say_mod = "rasps"
	limbs_id = "ghoul"
	species_traits = list(HAIR,FACEHAIR)
	inherent_traits = list(TRAIT_RADIMMUNE, TRAIT_NOBREATH)
	inherent_biotypes = list(MOB_INORGANIC, MOB_HUMANOID)
	punchstunthreshold = 9
	use_skintones = 0
	sexes = 1
	disliked_food = GROSS
	liked_food = JUNKFOOD | FRIED | RAW

//Ghouls have weak limbs.
/datum/species/ghoul/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	for(var/obj/item/bodypart/b in C.bodyparts)
		b.max_damage -= 10
	C.faction |= "ghoul"
/datum/species/ghoul/on_species_loss(mob/living/carbon/C)
	..()
	C.faction -= "ghoul"
	for(var/obj/item/bodypart/b in C.bodyparts)
		b.max_damage = initial(b.max_damage)

/datum/species/ghoul/qualifies_for_rank(rank, list/features)
	if(rank in GLOB.legion_positions) /* legion HATES these ghoul */
		return 0
	if(rank in GLOB.brotherhood_positions) //don't hate them, just tolorate.
		return 0
	if(rank in GLOB.vault_positions) //purest humans left in america. supposedly.
		return 0
	return ..()

/*/datum/species/ghoul/glowing
	name = "Glowing Ghoul"
	id = "glowing ghoul"
	limbs_id = "glowghoul"
	armor = -30
	speedmod = 0.5
	brutemod = 1.3
	punchdamagehigh = 6
	punchstunthreshold = 6
	use_skintones = 0
	sexes = 0

//Ghouls have weak limbs.
/datum/species/ghoul/glowing/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	for(var/obj/item/bodypart/b in C.bodyparts)
		b.max_damage -= 15
	C.faction |= "ghoul"
	C.set_light(2, 1, LIGHT_COLOR_GREEN)
	SSradiation.processing += C

/datum/species/ghoul/glowing/on_species_loss(mob/living/carbon/C)
	..()
	C.set_light(0)
	C.faction -= "ghoul"
	for(var/obj/item/bodypart/b in C.bodyparts)
		b.max_damage = initial(b.max_damage)
	SSradiation.processing -= C
*/
