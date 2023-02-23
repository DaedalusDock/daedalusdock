/obj/item/bodypart/proc/create_wound(wound_type = WOUND_CUT, damage, surgical, update_damage = TRUE)
	if(damage <= 0)
		return

	var/static/list/interal_wounds_check = list(WOUND_CUT, WOUND_PIERCE, WOUND_BRUISE)

	var/static/list/fluid_wounds_check = list(WOUND_BURN, WOUND_LASER)

	//Burn damage can cause fluid loss due to blistering and cook-off
	if(owner && !surgical && (damage > FLUIDLOSS_BURN_REQUIRED) && (bodypart_flags & BP_HAS_BLOOD) && (wound_type in fluid_wounds_check))
		var/fluid_loss_severity
		switch(wound_type)
			if (WOUND_BURN)
				fluid_loss_severity = FLUIDLOSS_BURN_WIDE
			if (WOUND_LASER)
				fluid_loss_severity = FLUIDLOSS_BURN_CONCENTRATED
		var/fluid_loss = (damage/(owner.maxHealth)) * BLOOD_VOLUME_NORMAL * fluid_loss_severity
		owner.bleed(fluid_loss)

	//Check whether we can widen an existing wound
	if(!surgical && LAZYLEN(wounds) && prob(max(50+(real_wound_count-1)*10,90)))
		if ((wound_type == WOUND_CUT || wound_type == WOUND_BRUISE) && damage >= 5)
			//we need to make sure that the wound we are going to worsen is compatible with the type of damage...
			var/list/compatible_wounds = list()
			for (var/datum/wound/W as anything in wounds)
				if (W.can_worsen(type, damage))
					compatible_wounds += W

			if(length(compatible_wounds))
				var/datum/wound/W = pick(compatible_wounds)
				W.open_wound(damage)
				if(prob(25))
					if(!IS_ORGANIC_LIMB(src))
						owner.visible_message(
							span_danger("The damage to \the [owner]'s [name] worsens."),\
							span_danger("The damage to your [name] worsens."),\
							span_danger("You hear the screech of abused metal.")
						)
					else
						owner.visible_message(
							span_danger("The wound on \the [owner]'s [name] widens with a nasty ripping noise."),\
							span_danger("The wound on your [name] widens with a nasty ripping noise."),\
							span_danger("You hear a nasty ripping noise, as if flesh is being torn apart.")
						)
				return W


	//Creating wound
	var/new_wound_type = get_wound_type(wound_type, damage)

	if(new_wound_type)
		var/datum/wound/W = new new_wound_type(damage, src)

		//Check whether we can add the wound to an existing wound
		if(surgical)
			W.autoheal_cutoff = 0
		else
			for(var/datum/wound/other as anything in wounds)
				if(other.can_merge(W))
					other.merge_wound(W)
					if(update_damage)
						update_damage()
					return other

		LAZYADD(wounds, W)
		if(update_damage)
			update_damage()
		return W

/obj/item/bodypart/proc/create_wound_easy(type2make, damage, update_damage = TRUE)
	var/datum/wound/W = new type2make(damage, src)
	var/merged = FALSE
	for(var/datum/wound/other as anything in wounds)
		if(other.can_merge(W))
			other.merge_wound(W)
			merged = TRUE
			. = other

	if(!merged)
		LAZYADD(wounds, W)
	if(update_damage)
		update_damage()
	return W
