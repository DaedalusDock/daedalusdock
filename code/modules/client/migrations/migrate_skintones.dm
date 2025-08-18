/datum/preferences/proc/migrate_skintones(list/save_data)
	var/static/list/skintone_map = null
	if(isnull(skintone_map))
		skintone_map = list(
			"african1" = "Gondari (East)",
			"african2" = "Gondari (West)",
			"albino" = "Albino",
			"arab" = "Emerati",
			"asian1" = "Shaantian (North)",
			"asian2" = "Ikkonese",
			"caucasian1" = "Fjällröker",
			"caucasian2" = "Orleanian",
			"caucasian3" = "Saxon",
			"indian" = "Shaantian (South)",
			"latino" = "Estranian",
			"mediterranean" = "Ravennar",
		)

	var/new_skintone = skintone_map[save_data["skin_tone"]]

	if(isnull(new_skintone))
		return

	save_data["skin_tone"] = new_skintone
