/datum/codex_category/reagents
	name = "Reagents"
	desc = "Chemicals and reagents, both natural and artificial."

/datum/codex_category/reagents/Populate()
	for(var/datum/reagent/R as anything in subtypesof(/datum/reagent))
		if(isabstract(R) || !(initial(R.show_in_codex) || R == /datum/reagent/toxin)) //OOP moment
			continue

		var/datum/codex_entry/entry = new(
			_display_name = "[initial(R.name)] (chemical)",
			_lore_text = "&nbsp;&nbsp;&nbsp;&nbsp;[initial(R.description)] It apparently tastes of [initial(R.taste_description)]."
		)

		var/list/production_strings = list()

		for(var/datum/chemical_reaction/reaction as anything in SSreagents.chemical_reactions_list_product_index[R])

			if(!length(reaction.required_reagents))
				continue

			var/list/reactant_values = list()

			for(var/datum/reagent/reactant as anything in reaction.required_reagents)
				reactant_values += "[reaction.required_reagents[reactant]]u [lowertext(initial(reactant.name))]"


			var/list/catalysts = list()

			for(var/datum/reagent/catalyst as anything in reaction.required_catalysts)
				catalysts += "[reaction.required_catalysts[catalyst]]u [lowertext(initial(catalyst.name))]"


			if(length(catalysts))
				production_strings += "- [jointext(reactant_values, " + ")] (catalysts: [jointext(catalysts, ", ")]): [reaction.results[R]]u [lowertext(initial(R.name))]"
			else
				production_strings += "- [jointext(reactant_values, " + ")]: [reaction.results[R]]u [lowertext(initial(R.name))]"

			production_strings += "- Optimal temperature: [KELVIN_TO_CELSIUS(reaction.optimal_temp)]C ([reaction.optimal_temp]K)"

			if (reaction.overheat_temp < NO_OVERHEAT)
				production_strings += "- Overheat temperature: [KELVIN_TO_CELSIUS(reaction.overheat_temp)]C ([reaction.overheat_temp]K)"
			if (reaction.required_temp > 0)
				production_strings += "- Required temperature: [KELVIN_TO_CELSIUS(reaction.required_temp)]C ([reaction.required_temp]K)"

		if(length(production_strings))
			if(!entry.mechanics_text)
				entry.mechanics_text = "It can be produced as follows:<br>"
			else
				entry.mechanics_text += "<br><br>It can be produced as follows:<br>"
			entry.mechanics_text += jointext(production_strings, "<br>")

		items += entry

	return ..()
