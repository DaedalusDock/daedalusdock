/datum/codex_category/surgery
	name = "Surgeries"
	desc = "Information on surgerical procedures."

/datum/codex_category/surgery/Populate()
	for(var/datum/surgery_step/step as anything in GLOB.surgeries_list)
		var/list/info = list("<ul>")

		var/obj/path_or_tool = step.allowed_tools[1]
		info += "<li>Best performed with \a [istext(path_or_tool) ? "[path_or_tool]" : "[initial(path_or_tool.name)]"].</li>"
		if(!step.surgery_candidate_flags)
			info += "<li>This operation has no requirements."

		if(step.surgery_candidate_flags & SURGERY_NO_FLESH)
			info += "<li>This operation cannot be performed on organic limbs."
		else if(step.surgery_candidate_flags & SURGERY_NO_ROBOTIC)
			info += "<li>This operation cannot be performed on robotic limbs."

		if(step.surgery_candidate_flags & SURGERY_NO_STUMP)
			info += "<li>This operation cannot be performed on stumps."
		if(step.surgery_candidate_flags & SURGERY_NEEDS_RETRACTED)
			info += "<li>This operation requires <b>[step.strict_access_requirement ? "exactly" : "atleast"]</b> an incision or small cut.</li>"
		else if(step.surgery_candidate_flags & (SURGERY_NEEDS_RETRACTED|SURGERY_NEEDS_DEENCASEMENT))
			info += "<li>This operation requires <b>[step.strict_access_requirement ? "exactly" : "atleast"]</b> a widened incision or large cut.</li>"
		else if(step.surgery_candidate_flags & SURGERY_NEEDS_DEENCASEMENT)
			info += "<li>This operation requires the encasing bones to be broken.</li>"

		info += "</ul>"

		var/datum/codex_entry/entry = new(
			_display_name = "[step.name]",
			_lore_text = step.desc,
			_mechanics_text = jointext(info, null)
		)

		items |= entry.name

	return ..()
