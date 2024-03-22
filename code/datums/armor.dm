#define ARMORID "armor-[blunt]-[puncture]-[slash]-[laser]-[energy]-[bomb]-[bio]-[fire]-[acid]"

/proc/getArmor(blunt = 0, puncture = 0, slash = 0, laser = 0, energy = 0, bomb = 0, bio = 0, fire = 0, acid = 0)
	. = locate(ARMORID)
	if (!.)
		. = new /datum/armor(blunt, puncture, slash, laser, energy, bomb, bio, fire, acid)

///Retreive an atom's armor, creating it if it doesn't exist
/atom/proc/returnArmor() //This is copypasted to physiology/proc/returnArmor()!!! update it too!!!
	RETURN_TYPE(/datum/armor)
	if(istype(armor, /datum/armor))
		return armor

	if(islist(armor) || isnull(armor))
		armor = getArmor(arglist(armor))
		return armor

	CRASH("Armor is not a datum or a list, what the fuck?")

///Setter for armor
/atom/proc/setArmor(datum/new_armor)
	armor = new_armor

/datum/armor
	var/blunt
	var/puncture
	var/slash
	var/laser
	var/energy
	var/bomb
	var/bio
	var/fire
	var/acid

/datum/armor/New(blunt = 0, puncture = 0, slash = 0, laser = 0, energy = 0, bomb = 0, bio = 0, fire = 0, acid = 0)
	src.blunt = blunt
	src.puncture = puncture
	src.slash = slash
	src.laser = laser
	src.energy = energy
	src.bomb = bomb
	src.bio = bio
	src.fire = fire
	src.acid = acid
	GenerateTag()

/datum/armor/Destroy(force, ...)
	if(!force)
		stack_trace("Some mf tried to delete an armor datum, KILL THIS MAN")
		return QDEL_HINT_LETMELIVE
	return ..()

/datum/armor/proc/modifyRating(blunt = 0, puncture = 0, slash = 0, laser = 0, energy = 0, bomb = 0, bio = 0, fire = 0, acid = 0)
	return getArmor(
		src.blunt + blunt,
		src.puncture + puncture,
		src.slash + slash,
		src.laser + laser,
		src.energy + energy,
		src.bomb + bomb,
		src.bio + bio,
		src.fire + fire,
		src.acid + acid
	)

/datum/armor/proc/modifyAllRatings(modifier = 0)
	return getArmor(
		blunt + modifier,
		puncture + modifier,
		slash + modifier,
		laser + modifier,
		energy + modifier,
		bomb + modifier,
		bio + modifier,
		fire + modifier,
		acid + modifier
	)

/datum/armor/proc/setRating(blunt, puncture, slash, laser, energy, bomb, bio, fire, acid)
	return getArmor(
		(isnull(blunt) ? src.blunt : blunt),
		(isnull(puncture) ? src.puncture : puncture),
		(isnull(slash) ? src.slash : slash),
		(isnull(laser) ? src.laser : laser),
		(isnull(energy) ? src.energy : energy),
		(isnull(bomb) ? src.bomb : bomb),
		(isnull(bio) ? src.bio : bio),
		(isnull(fire) ? src.fire : fire),
		(isnull(acid) ? src.acid : acid)
	)

/datum/armor/proc/getRating(rating)
	return vars[rating]

/datum/armor/proc/getList()
	return list(BLUNT = blunt, PUNCTURE = puncture, SLASH = slash, LASER = laser, ENERGY = energy, BOMB = bomb, BIO = bio, FIRE = fire, ACID = acid)

/datum/armor/proc/attachArmor(datum/armor/AA)
	return getArmor(
		blunt + AA.blunt,
		puncture + AA.puncture,
		slash + AA.slash,
		laser + AA.laser,
		energy + AA.energy,
		bomb + AA.bomb,
		bio + AA.bio,
		fire + AA.fire,
		acid + AA.acid
	)

/datum/armor/proc/detachArmor(datum/armor/AA)
	return getArmor(
		blunt - AA.blunt,
		puncture - AA.puncture,
		slash - AA.slash,
		laser - AA.laser,
		energy - AA.energy,
		bomb - AA.bomb,
		bio - AA.bio,
		fire - AA.fire,
		acid - AA.acid
	)

/datum/armor/GenerateTag()
	. = ..()
	tag = ARMORID

/datum/armor/vv_edit_var(var_name, var_value)
	if (var_name == NAMEOF(src, tag))
		return FALSE
	. = ..()
	GenerateTag()

#undef ARMORID

/proc/armor_flag_to_strike_string(flag)
	switch(flag)
		if(BLUNT)
			return "strike"
		if(PUNCTURE)
			return "stab"
		if(SLASH)
			return "slash"
		if(ACID)
			return "acid"
		if(FIRE)
			return "burn"
		else
			return "blow"
