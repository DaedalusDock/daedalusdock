/datum/export/organ
	include_subtypes = FALSE //CentCom doesn't need organs from non-humans.

/datum/export/organ/heart
	cost = PAYCHECK_ASSISTANT * 30 //For the man who has everything and nothing.
	unit_name = "humanoid heart"
	export_types = list(/obj/item/organ/heart)

/datum/export/organ/eyes
	cost = PAYCHECK_ASSISTANT * 15.3
	unit_name = "humanoid eyes"
	export_types = list(/obj/item/organ/eyes)

/datum/export/organ/ears
	cost = PAYCHECK_ASSISTANT * 17.1
	unit_name = "humanoid ears"
	export_types = list(/obj/item/organ/ears)

/datum/export/organ/liver
	cost = PAYCHECK_ASSISTANT * 23.9
	unit_name = "humanoid liver"
	export_types = list(/obj/item/organ/liver)

/datum/export/organ/lungs
	cost = PAYCHECK_ASSISTANT * 21.2
	unit_name = "humanoid lungs"
	export_types = list(/obj/item/organ/lungs)

/datum/export/organ/stomach
	cost = PAYCHECK_ASSISTANT * 7.5
	unit_name = "humanoid stomach"
	export_types = list(/obj/item/organ/stomach)

/datum/export/organ/tongue
	cost = PAYCHECK_ASSISTANT * 2.4
	unit_name = "humanoid tounge"
	export_types = list(/obj/item/organ/tongue)

/datum/export/organ/external/tail/lizard
	cost = PAYCHECK_ASSISTANT * 4.1
	unit_name = "lizard tail"
	export_types = list(/obj/item/organ/tail/lizard)

