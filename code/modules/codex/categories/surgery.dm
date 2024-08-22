/datum/codex_category/surgery
	name = "Surgeries"
	desc = "Information on surgerical procedures."
	guide_name = "Surgery"
	guide_html = {"
		<h2>Important Notes</h2>
		<ul>
		<li>Surgery can be attempted by using a variety of items (such as scalpels, or improvised tools) on a patient who is prone.</li>
		<li>Performing surgery on a conscious patient will cause quite a lot of pain and screaming.</li>
		<li>You can perform some surgeries on yourself, but this is probably not a good idea.</li>
		<li>Attempting surgery on anything other than help intent can have unexpected effects, or can be used to ignore surgery for items with other effects, like trauma kits.</li>
		<li>When violently severed, limbs will leave behind stumps, which may behave differently to regular limbs when operated on.</li>
		<li>Dosing the patient with regenerative medication, or trying to operate on treated wounds, can fail unexpectedly due to the wound closing. Making a new incision or using retractors to widen the wound may help.</li>
		</ul>

		<h2>Making an incision</h2>
		<ol>
		<li>Target the desired bodypart on the target dolly.</li>
		<li>Use a scalpel to make an <span codexlink='make incision'>incision</span>.</li>
		<li>Use a retractor to <span codexlink='widen incision'>widen the incision</span>, if necessary.</li>
		<li>Use a hemostat to <span codexlink='clamp bleeders'>clamp any bleeders</span>, if necessary.</li>
		<li>On bodyparts with bone encasement, like the skull and ribs, use a circular saw to <span codexlink='saw through bone'>open the encasing bone</span>.</li>
		</ol>

		<h2>Closing an incision</h2>
		<ol>
		<li>Close and repair the bone, as below.</li>
		<li>Use a cautery to <span codexlink='cauterize incision'>seal the incision</span>.</li>
		</ol>

		<h2>Setting and repairing a broken bone</h2>
		While splints can make a broken limb usable, surgery will be needed to properly repair them.
		<ol>
		<li>Open an incision as above.</li>
		<li><span codexlink='set bone'>Set the bone in place</span> with a bone setter.</li>
		<li><span codexlink='repair bone'>Apply bone gel</span> to finalize the repair.</li>
		<li>Close the incision as above.</li>
		</ol>

		<h2>Internal organ surgery</h2>
		All internal organ surgery requires access to the internal organs via an incision, as above.
		<ul>
		<li>A scalpel (or a multitool for a <span codexlink='decouple prosthetic organ'>prosthetic</span>) can be used to <span codexlink='detach organ'>detach an organ</span>, followed by a hemostat to <span codexlink='remove internal organ'>remove the organ</span> entirely for transplant.</li>
		<li>A removed organ can be <span codexlink='replace internal organ'>replaced</span> by using it on an empty section of the body, and <span codexlink='attach internal organ'>reattached with sutures</span> (or a <span codexlink='reattach prosthetic organ'>multitool for a prosthetic</span>).</li>
		<li>A damaged organ can be <span codexlink='repair internal organ'>repaired</span> with a trauma pack (or nanopaste for a prosthetic).
		</ul>

		<h2>Amputation</h2>
		Limbs or limb stumps can be <span codexlink='amputate limb'>amputated</span> with a circular saw, but any other form of surgery in progress will take precedence. Cauterize any incisions or wounds before trying to amputate the limb. A proper surgical amputation will not leave a stump.

		<h2>Replacement limb installation</h2>
		Fresh limbs can be sourced from donors, organ printers, or prosthetics fabricators.
		<ol>
		<li>Remove the original limb by <span codexlink='amputate limb'>amputation</span> if it is present.</li>
		<li>Target the appropriate limb slot and <span codexlink='attach limb'>install the new limb</span> on the patient.</li>
		<li>Use a <span codexlink='connect limb'>vascular recoupler to connect the nerves</span> to the new limb.</li>
		</ol>
	"}

/datum/codex_category/surgery/Populate()
	for(var/datum/surgery_step/step as anything in GLOB.surgeries_list)
		var/list/info = list("<ul>")

		var/obj/path_or_tool = step.allowed_tools?[1]
		if(path_or_tool)
			info += "<li>Best performed with \a [istext(path_or_tool) ? "[path_or_tool]" : "[initial(path_or_tool.name)]"].</li>"

		if(!(step.surgery_flags & ~(SURGERY_CANNOT_FAIL | SURGERY_BLOODY_BODY | SURGERY_BLOODY_GLOVES)))
			info += "<li>This operation has no requirements."
		else
			if(step.surgery_flags & SURGERY_NO_FLESH)
				info += "<li>This operation cannot be performed on organic limbs."
			else if(step.surgery_flags & SURGERY_NO_ROBOTIC)
				info += "<li>This operation cannot be performed on robotic limbs."

			if(step.surgery_flags & SURGERY_NO_STUMP)
				info += "<li>This operation cannot be performed on stumps."
			if(step.surgery_flags & SURGERY_NEEDS_INCISION)
				info += "<li>This operation requires <b>[step.strict_access_requirement ? "exactly" : "atleast"]</b> an [CODEX_LINK("incision", "make incision")] or small cut.</li>"
			else if(step.surgery_flags & (SURGERY_NEEDS_RETRACTED|SURGERY_NEEDS_DEENCASEMENT))
				info += "<li>This operation requires <b>[step.strict_access_requirement ? "exactly" : "atleast"]</b> a [CODEX_LINK("widened incision", "widen incision")] or large cut.</li>"
			else if(step.surgery_flags & SURGERY_NEEDS_DEENCASEMENT)
				info += "<li>This operation requires the encasing bones to be [CODEX_LINK("broken", "saw through bone")].</li>"

		info += "</ul>"

		var/datum/codex_entry/entry = new(
			_display_name = "[step.name]",
			_lore_text = step.desc,
			_mechanics_text = jointext(info, null)
		)

		items += entry

	return ..()
