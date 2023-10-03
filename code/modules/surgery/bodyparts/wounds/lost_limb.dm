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
				max_bleeding_stage = -1
				bleed_threshold = INFINITY
				stages = list("mangled robotic socket" = 0)
			else
				max_bleeding_stage = 3 //clotted stump and above can bleed.
				stages = list(
					"ripped stump" = damage_amt*1.3,
					"bloody stump" = damage_amt,
					"clotted stump" = damage_amt*0.5,
					"scarred stump" = 0
				)
		if(DROPLIMB_BURN)
			wound_type = WOUND_BURN
			stages = list(
				"mangled charred stump" = damage_amt*1.3,
				"charred stump" = damage_amt,
				"scarred stump" = damage_amt*0.5,
				"scarred stump" = 0
				)

	..(damage_amt)

/datum/wound/lost_limb/can_merge(datum/wound/other)
	return 0 //cannot be merged
