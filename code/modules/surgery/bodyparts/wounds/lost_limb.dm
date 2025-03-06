/** BODYPART LOSS **/
/datum/wound/lost_limb

/datum/wound/lost_limb/New(obj/item/bodypart/lost_limb, losstype, clean)
	var/damage_amt = lost_limb.max_damage
	if(clean)
		damage_amt /= 2

	switch(losstype)
		if(DROPLIMB_EDGE, DROPLIMB_BLUNT)
			wound_type = WOUND_CUT
			if(!IS_ORGANIC_LIMB(lost_limb))
				min_bleeding_stage = INFINITY
				always_bleed_threshold = INFINITY
				stages = list("mangled robotic socket" = 0)
			else
				min_bleeding_stage = 2 //clotted stump and above can bleed.
				stages = list(
					"scarred stump" = 0,
					"clotted stump" = damage_amt*0.5,
					"bloody stump" = damage_amt,
					"ripped stump" = damage_amt*1.3,
				)

		if(DROPLIMB_BURN)
			wound_type = WOUND_BURN
			stages = list(
				"scarred stump" = 0,
				"scarred stump" = damage_amt*0.5,
				"charred stump" = damage_amt,
				"mangled charred stump" = damage_amt*1.3,
			)

	..(damage_amt)

/datum/wound/lost_limb/can_merge(datum/wound/other)
	return 0 //cannot be merged
