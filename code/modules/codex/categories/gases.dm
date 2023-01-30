/datum/codex_category/gases
	name = "Gases"
	desc = "Information on gas types found in game."

/datum/codex_category/gases/Populate()
	for(var/path as anything in subtypesof(/datum/xgm_gas) - /datum/xgm_gas/alium)
		var/datum/xgm_gas/iter_gas = new path
		var/list/material_info = list()

		material_info += "<li>It has a specific heat of [iter_gas.specific_heat] J/(mol*K).</li>"
		material_info += "<li>It has a molar mass of [iter_gas.molar_mass] kg/mol.</li>"
		if(iter_gas.flags & XGM_GAS_FUEL)
			material_info += "<li>It is flammable.</li>"
			if(!isnull(iter_gas.burn_product))
				material_info += "<li>It produces [xgm_gas_data.name[iter_gas.burn_product]] when burned.</li>"
		if(iter_gas.flags & XGM_GAS_OXIDIZER)
			material_info += "<li>It is an oxidizer, required to sustain fire.</li>"
		if(iter_gas.flags & XGM_GAS_CONTAMINANT)
			material_info += "<li>It contaminates exposed clothing with residue.</li>"
		if(iter_gas.flags & XGM_GAS_FUSION_FUEL)
			material_info += "<li>It can be used as fuel in a fusion reaction.</li>"
		if(!isnull(iter_gas.condensation_point) && iter_gas.condensation_point < INFINITY)
			material_info += "<li>It condenses at [iter_gas.condensation_point] K.</li>"
		material_info += "</ul>"

		var/datum/codex_entry/entry = new(
			_display_name = "[iter_gas.name] (gas)",
			_mechanics_text = jointext(material_info, null)
		)

		items |= entry.name

	return ..()
