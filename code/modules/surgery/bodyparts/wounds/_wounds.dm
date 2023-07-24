
/****************************************************
					WOUNDS
****************************************************/
/datum/wound
	///The bodypart this wound is on
	var/obj/item/bodypart/parent
	///The mob this wound belongs to
	var/mob/living/carbon/mob_parent

	///Number representing the current stage
	var/current_stage = 0
	///Description of the wound.
	var/desc = "wound"
	///Amount of damage this wound causes
	var/damage = 0
	///Ticks of bleeding left
	var/bleed_timer = 0
	///Above this amount wounds you will need to treat the wound to stop bleeding, regardless of bleed_timer
	var/bleed_threshold = 30
	///Amount of damage the current wound type requires(less means we need to apply the next healing stage)
	var/min_damage = 0

	///Is bandaged?
	var/bandaged = 0
	///Is clamped?
	var/clamped = 0
	///Is salved?
	var/salved = 0
	///Is disinfected?
	var/disinfected = 0

	var/created = 0
	///Number of wounds of this type
	var/amount = 1
	///Amount of germs in the wound
	var/germ_level = 0

	/*  These are defined by the wound type and should not be changed */
	/// stages such as "cut", "deep cut", etc.
	var/list/stages

	///Maximum stage at which bleeding should still happen. Beyond this stage bleeding is prevented.
	var/max_bleeding_stage = 0

	/// String (One of `wound_type_*`). The wound's injury type.
	var/wound_type = WOUND_CUT

	// the maximum amount of damage that this wound can have and still autoheal
	var/autoheal_cutoff = 15

	// helper lists
	var/tmp/list/desc_list = list()
	var/tmp/list/damage_list = list()

/datum/wound/New(damage, obj/item/bodypart/BP = null)

	created = world.time

	// reading from a list("stage" = damage) is pretty difficult, so build two separate
	// lists from them instead
	for(var/V in stages)
		desc_list += V
		damage_list += stages[V]

	src.damage = damage

	// initialize with the appropriate stage
	src.init_stage(damage)

	bleed_timer += damage

	if(istype(BP))
		parent = BP
		if(BP.current_gauze)
			bandage()
		RegisterSignal(parent, COMSIG_BODYPART_GAUZED, PROC_REF(on_gauze))
		RegisterSignal(parent, COMSIG_BODYPART_GAUZE_DESTROYED, PROC_REF(on_ungauze))
		if(parent.owner)
			register_to_mob(parent.owner)

/datum/wound/Destroy()
	if(mob_parent)
		unregister_from_mob()
	if(parent)
		LAZYREMOVE(parent.wounds, src)
		parent = null

	return ..()

/datum/wound/proc/register_to_mob(mob/living/carbon/C)
	if(mob_parent)
		unregister_from_mob()
	mob_parent = C
	SEND_SIGNAL(mob_parent, COMSIG_CARBON_GAIN_WOUND, src, parent)

/datum/wound/proc/unregister_from_mob()
	SEND_SIGNAL(mob_parent, COMSIG_CARBON_LOSE_WOUND, src, parent)
	mob_parent = null


///Returns 1 if there's a next stage, 0 otherwise
/datum/wound/proc/init_stage(initial_damage)
	current_stage = stages.len

	while(src.current_stage > 1 && src.damage_list[current_stage-1] <= initial_damage / src.amount)
		src.current_stage--

	src.min_damage = damage_list[current_stage]
	src.desc = desc_list[current_stage]

///The amount of damage per wound
/datum/wound/proc/wound_damage()
	return src.damage / src.amount

/datum/wound/proc/can_autoheal()
	return (wound_damage() <= autoheal_cutoff) ? 1 : is_treated()

///Checks whether the wound has been appropriately treated
/datum/wound/proc/is_treated()
	switch(wound_type)
		if (WOUND_BRUISE, WOUND_CUT, WOUND_PIERCE)
			return bandaged
		if (WOUND_BURN)
			return salved

	// Checks whether other other can be merged into src.
/datum/wound/proc/can_merge(datum/wound/other)
	if (other.type != src.type) return 0
	if (other.current_stage != src.current_stage) return 0
	if (other.wound_type != src.wound_type) return 0
	if (!(other.can_autoheal()) != !(src.can_autoheal())) return 0
	if (other.is_surgical() != src.is_surgical()) return 0
	if (!(other.bandaged) != !(src.bandaged)) return 0
	if (!(other.clamped) != !(src.clamped)) return 0
	if (!(other.salved) != !(src.salved)) return 0
	if (!(other.disinfected) != !(src.disinfected)) return 0
	if (other.parent != parent) return 0
	return 1

/datum/wound/proc/merge_wound(datum/wound/other)
	src.damage += other.damage
	src.amount += other.amount
	src.bleed_timer += other.bleed_timer
	src.germ_level = max(src.germ_level, other.germ_level)
	src.created = max(src.created, other.created)	//take the newer created time
	qdel(other)

// checks if wound is considered open for external infections
// untreated cuts (and bleeding bruises) and burns are possibly infectable, chance higher if wound is bigger
/datum/wound/proc/infection_check()
	if (damage < 10)	//small cuts, tiny bruises, and moderate burns shouldn't be infectable.
		return 0
	if (is_treated() && damage < 25)	//anything less than a flesh wound (or equivalent) isn't infectable if treated properly
		return 0
	if (disinfected)
		germ_level = 0	//reset this, just in case
		return 0

	if (wound_type == WOUND_BRUISE && !bleeding()) //bruises only infectable if bleeding
		return 0

	var/dam_coef = round(damage/10)
	switch (wound_type)
		if (WOUND_BRUISE)
			return prob(dam_coef*5)
		if (WOUND_BURN)
			return prob(dam_coef*25)
		if (WOUND_CUT)
			return prob(dam_coef*10)

	return 0

/datum/wound/proc/bandage()
	if(bandaged)
		return FALSE
	bandaged = 1
	return TRUE

/datum/wound/proc/salve()
	if(salved)
		return FALSE
	salved = 1
	return TRUE

/datum/wound/proc/disinfect()
	if(disinfected)
		return FALSE
	disinfected = 1
	return TRUE

/datum/wound/proc/clamp_wound()
	if(clamped)
		return FALSE
	clamped = 1
	if(parent)
		parent.refresh_bleed_rate()
	return TRUE

// heal the given amount of damage, and if the given amount of damage was more
// than what needed to be healed, return how much heal was left
/datum/wound/proc/heal_damage(amount)
	if(parent)
		if (wound_type == WOUND_BURN && parent.burn_ratio > 1)
			return amount	//We don't want to heal wounds on irreparable organs.
		else if(parent.brute_ratio > 1)
			return amount

	var/healed_damage = min(src.damage, amount)
	amount -= healed_damage
	src.damage -= healed_damage

	while(src.wound_damage() < damage_list[current_stage] && current_stage < src.desc_list.len)
		current_stage++
	desc = desc_list[current_stage]
	src.min_damage = damage_list[current_stage]

	// return amount of healing still leftover, can be used for other wounds
	return amount

// opens the wound again
/datum/wound/proc/open_wound(damage)
	src.damage += damage
	bleed_timer += damage

	while(src.current_stage > 1 && src.damage_list[current_stage-1] <= src.damage / src.amount)
		src.current_stage--

	src.desc = desc_list[current_stage]
	src.min_damage = damage_list[current_stage]

/datum/wound/proc/close_wound()
	return

// returns whether this wound can absorb the given amount of damage.
// this will prevent large amounts of damage being trapped in less severe wound types
/datum/wound/proc/can_worsen(wound_type, damage)
	if (src.wound_type != wound_type)
		return 0	//incompatible damage types

	if (src.amount > 1)
		return 0	//merged wounds cannot be worsened.

	//with 1.5*, a shallow cut will be able to carry at most 30 damage,
	//37.5 for a deep cut
	//52.5 for a flesh wound, etc.
	var/max_wound_damage = 1.5*src.damage_list[1]
	if (src.damage + damage > max_wound_damage)
		return 0
	return 1

/datum/wound/proc/bleeding()
	if(bandaged || clamped)
		return FALSE
	return ((bleed_timer > 0 || wound_damage() > bleed_threshold) && current_stage <= max_bleeding_stage)

/datum/wound/proc/is_surgical()
	return 0

/datum/wound/proc/on_gauze(datum/source)
	SIGNAL_HANDLER
	bandage()

/datum/wound/proc/on_ungauze(datum/source)
	SIGNAL_HANDLER
	bandaged = FALSE

/datum/wound/proc/get_examine_desc()
	var/this_wound_desc = desc
	if (wound_type == WOUND_BURN && salved)
		this_wound_desc = "salved [this_wound_desc]"

	if(bleeding())
		if(wound_damage() > bleed_threshold)
			this_wound_desc = "<b>bleeding</b> [this_wound_desc]"
		else
			this_wound_desc = "bleeding [this_wound_desc]"
	else if(bandaged)
		this_wound_desc = "bandaged [this_wound_desc]"

	if(germ_level > 600)
		this_wound_desc = "badly infected [this_wound_desc]"
	else if(germ_level > 330)
		this_wound_desc = "lightly infected [this_wound_desc]"


	return this_wound_desc

/*Note that the MINIMUM damage before a wound can be applied should correspond to
//the damage amount for the stage with the same name as the wound.
//e.g. /datum/wound/cut/deep should only be applied for 15 damage and up,
//because in it's stages list, "deep cut" = 15.
*/
/proc/get_wound_type(type, damage)
	switch(type)
		if (WOUND_CUT)
			switch(damage)
				if(70 to INFINITY)
					return /datum/wound/cut/massive
				if(60 to 70)
					return /datum/wound/cut/gaping_big
				if(50 to 60)
					return /datum/wound/cut/gaping
				if(25 to 50)
					return /datum/wound/cut/flesh
				if(15 to 25)
					return /datum/wound/cut/deep
				if(0 to 15)
					return /datum/wound/cut/small
		if (WOUND_PIERCE)
			switch(damage)
				if(60 to INFINITY)
					return /datum/wound/puncture/massive
				if(50 to 60)
					return /datum/wound/puncture/gaping_big
				if(30 to 50)
					return /datum/wound/puncture/gaping
				if(15 to 30)
					return /datum/wound/puncture/flesh
				if(0 to 15)
					return /datum/wound/puncture/small
		if (WOUND_BRUISE)
			return /datum/wound/bruise
		if (WOUND_BURN, WOUND_LASER)
			switch(damage)
				if(50 to INFINITY)
					return /datum/wound/burn/carbonised
				if(40 to 50)
					return /datum/wound/burn/deep
				if(30 to 40)
					return /datum/wound/burn/severe
				if(15 to 30)
					return /datum/wound/burn/large
				if(0 to 15)
					return /datum/wound/burn/moderate
	return null //no wound

/obj/item/bodypart/proc/attempt_dismemberment(brute as num, burn as num, sharpness)
	if((sharpness & SHARP_EDGED) && brute >= max_damage * DROPLIMB_THRESHOLD_EDGE)
		if(prob(brute))
			return dismember(DROPLIMB_EDGE, FALSE, FALSE)

	else if(burn >= max_damage * DROPLIMB_THRESHOLD_DESTROY)
		if(prob(burn))
			return dismember(DROPLIMB_BURN, FALSE, FALSE)

	else if(brute >= max_damage * DROPLIMB_THRESHOLD_DESTROY)
		if(prob(brute))
			return dismember(DROPLIMB_BLUNT, FALSE, FALSE)

	else if(brute >= max_damage * DROPLIMB_THRESHOLD_TEAROFF)
		if(prob(brute))
			return dismember(DROPLIMB_EDGE, FALSE, FALSE)
