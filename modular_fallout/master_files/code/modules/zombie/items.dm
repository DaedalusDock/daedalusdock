/obj/item/zombie_hand/ghoul/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(!proximity_flag)
		return
	else
		if(istype(target, /obj))
			var/obj/target_object = target
			target_object.take_damage(force * 3, BRUTE, "melee", 0)
		else if(isliving(target))
			if(ishuman(target))
				try_to_ghoul_zombie_infect(target)
			else
				check_feast(target, user)

/proc/try_to_ghoul_zombie_infect(mob/living/carbon/human/target)
	CHECK_DNA_AND_SPECIES(target)

	if(NOZOMBIE in target.dna.species.species_traits)
		return

	var/obj/item/organ/zombie_infection/ghoul/infection
	infection = target.getorganslot(ORGAN_SLOT_ZOMBIE)
	if(!infection)
		infection = new()
		infection.Insert(target)

/// These are designed for special variants of ghouls. Mappers are supposed to 'accidentally' place them around the map.
