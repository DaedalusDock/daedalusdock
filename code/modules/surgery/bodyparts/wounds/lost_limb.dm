/** BODYPART LOSS **/
/datum/wound/lost_limb
	var/zone = null
	var/plaintext_zone = ""

/datum/wound/lost_limb/New(obj/item/bodypart/lost_limb, losstype, clean, obj/item/bodypart/affected_limb)
	zone = lost_limb.body_zone
	plaintext_zone = lost_limb.plaintext_zone
	var/damage_amt = lost_limb.max_damage
	if(clean) damage_amt /= 2

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

	..(damage_amt, affected_limb)

/datum/wound/lost_limb/can_merge(datum/wound/other)
	return 0 //cannot be merged

/datum/wound/lost_limb/get_examine_desc()
	var/this_wound_desc = desc

	if(bleeding())
		if(wound_damage() > bleed_threshold)
			this_wound_desc = "<b>bleeding</b> [this_wound_desc]"
		else
			this_wound_desc = "bleeding [this_wound_desc]"
	else if(bandaged)
		this_wound_desc = "bandaged [this_wound_desc]"

	return "[this_wound_desc] where a [plaintext_zone] should be"
