/// Contains the singletons of blood datums
GLOBAL_LIST_EMPTY(blood_datums)

/datum/blood
	abstract_type = /datum/blood
	var/name = "ERROR"
	var/color = COLOR_HUMAN_BLOOD

/// Takes a blood typepath, returns TRUE if it's compatible with this type.
/datum/blood/proc/is_compatible(other_type)
	return ispath(other_type, /datum/blood/universal) || other_type == type

/datum/blood/universal
	name = "U"

/datum/blood/slurry
	name = "??"

/datum/blood/animal
	name = "Y-"

/datum/blood/lizard
	name = "JN"
	color = "#e2ae02"

/datum/blood/universal/vox
	name = "VX"
	color = "#009696"

/datum/blood/human
	abstract_type = /datum/blood/human

/datum/blood/human/is_compatible(other_type)
	var/static/list/bloodtypes_safe = list(
		/datum/blood/human/amin = list(
			/datum/blood/human/amin,
			/datum/blood/human/omin
		),
		/datum/blood/human/apos = list(
			/datum/blood/human/amin,
			/datum/blood/human/apos,
			/datum/blood/human/omin,
			/datum/blood/human/opos,
		),
		/datum/blood/human/bmin = list(
			/datum/blood/human/bmin,
			/datum/blood/human/omin,
		),
		/datum/blood/human/bpos = list(
			/datum/blood/human/bmin,
			/datum/blood/human/bpos,
			/datum/blood/human/omin,
			/datum/blood/human/opos
		),
		/datum/blood/human/abmin = list(
			/datum/blood/human/amin,
			/datum/blood/human/bmin,
			/datum/blood/human/omin,
			/datum/blood/human/abmin
		),
		/datum/blood/human/abpos = list(
			/datum/blood/human/amin,
			/datum/blood/human/apos,
			/datum/blood/human/bmin,
			/datum/blood/human/bpos,
			/datum/blood/human/omin,
			/datum/blood/human/opos,
			/datum/blood/human/abmin,
			/datum/blood/human/abpos
		),
		/datum/blood/human/omin = list(
			/datum/blood/human/omin
		),
		/datum/blood/human/opos = list(
			/datum/blood/human/omin,
			/datum/blood/human/opos
		),
	)
	return (other_type in bloodtypes_safe[type]) || ..()

/datum/blood/human/amin
	name = "A-"

/datum/blood/human/apos
	name = "A+"

/datum/blood/human/bmin
	name = "B-"

/datum/blood/human/bpos
	name = "B+"

/datum/blood/human/abmin
	name = "AB-"

/datum/blood/human/abpos
	name = "AB+"

/datum/blood/human/omin
	name = "AB-"

/datum/blood/human/opos
	name = "AB+"

/datum/blood/xenomorph
	name = "??"
	color = rgb(43, 186, 0)
