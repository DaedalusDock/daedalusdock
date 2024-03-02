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

			var/datum/reagent/unstable_min = null
			var/datum/reagent/unstable_max = null

			for(var/datum/reagent/chemical as anything in reaction.required_catalysts + reaction.required_reagents)
				if(chemical.unstable_temperature)
					if(!chemical.unstable_cold && (!unstable_min || unstable_min.unstable_temperature > chemical.unstable_temperature))
						unstable_min = chemical
					if(chemical.unstable_cold && (!unstable_max || unstable_max.unstable_temperature < chemical.unstable_temperature))
						unstable_max = chemical

			if(length(catalysts))
				production_strings += "- [jointext(reactant_values, " + ")] (catalysts: [jointext(catalysts, ", ")]): [reaction.results[R]]u [lowertext(initial(R.name))]"
			else
				production_strings += "- [jointext(reactant_values, " + ")]: [reaction.results[R]]u [lowertext(initial(R.name))]"

			production_strings += "- Optimal temperature: [KELVIN_TO_CELSIUS(reaction.optimal_temp)]C ([reaction.optimal_temp]K)"

			if (unstable_min)
				production_strings += "- Overheat temperature: [KELVIN_TO_CELSIUS(unstable_min.unstable_temperature)]C ([unstable_min.unstable_temperature]K)"
			else if (reaction.overheat_temp < NO_OVERHEAT)
				production_strings += "- Overheat temperature: [KELVIN_TO_CELSIUS(reaction.overheat_temp)]C ([reaction.overheat_temp]K)"

			if (unstable_max)
				production_strings += "- Overcooled temperature: [KELVIN_TO_CELSIUS(unstable_max.unstable_temperature)]C ([unstable_max.unstable_temperature]K)"

			if (reaction.required_temp > 0)
				production_strings += "- Required temperature: [KELVIN_TO_CELSIUS(reaction.required_temp)]C ([reaction.required_temp]K)"


			if(reaction.thermic_constant != 0)
				// lifted outta modules/reagents/chemistry/holder.dm
				var/thermic_string = ""
				var/thermic = reaction.thermic_constant
				if(reaction.reaction_flags & REACTION_HEAT_ARBITARY)
					thermic *= 100 //Because arbitary is a lower scale
				switch(thermic)
					if(-INFINITY to -1500)
						thermic_string = "overwhelmingly endothermic"
					if(-1500 to -1000)
						thermic_string = "extremely endothermic"
					if(-1000 to -500)
						thermic_string = "strongly endothermic"
					if(-500 to -200)
						thermic_string = "moderately endothermic"
					if(-200 to -50)
						thermic_string = "endothermic"
					if(-50 to 0)
						thermic_string = "weakly endothermic"
					if(0 to 50)
						thermic_string = "weakly exothermic"
					if(50 to 200)
						thermic_string = "exothermic"
					if(200 to 500)
						thermic_string = "moderately exothermic"
					if(500 to 1000)
						thermic_string = "strongly exothermic"
					if(1000 to 1500)
						thermic_string = "extremely exothermic"
					if(1500 to INFINITY)
						thermic_string = "overwhelmingly exothermic"
				production_strings += "- The reaction is [thermic_string]"

		if(length(production_strings))
			if(!entry.mechanics_text)
				entry.mechanics_text = "It can be produced as follows:<br>"
			else
				entry.mechanics_text += "<br><br>It can be produced as follows:<br>"
			entry.mechanics_text += jointext(production_strings, "<br>")

		items += entry.name

	return ..()
