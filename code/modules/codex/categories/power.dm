GLOBAL_LIST_EMPTY(power_codex_entries)

/datum/codex_category/power
	name = "Power"
	desc = "The station's power network and you"
	guide_name = "the Supermatter"
	guide_html = {"
		This guide goes over the basic operational information for the <span codexlink='Supermatter Engine'>Supermatter</span>.

		While the supermatter engine is an inherently complex and intricate collection of yet more complex and intricate individual parts, the basic principles by which it operates are fairly straightforward.

		<h2>Default Setup</h2>
		This proceedure covers the default state of equipment without modification, and results in a conservative, but sufficient power output.

		<ol>
		<li>Equip radiation protective equipment. Namely a Radiation Suit and Meson Scanner (Or such configured Scanner Goggles.)</li>
		<li>Enable the two Head Pressure pumps for the Thermo-Electric Generators.</li>
		<li>Confirm that all loop ties are closed.</li>
		<li>Confirm that the waste filter is configured correctly for your chosen coolant (It is set up for Hydrogen by default.)</li>
		<li>Inject two cans of Hydrogen into each loop with the provided connector ports.</li>
		<li>Confirm that gas is flowing correctly. The equipment in the engine vessel can be controlled from the central computer in Engine Monitoring.</li>
		<li>Configure SMES units appropriately and secure the SMES access door.</li>
		<li>Energize the crystal with ~5-7 emitter charges. This will begin the internal reactions and result in the release of radiation into the engine chamber.</li>
		<li>Monitor for irregular operations or temperature anomalies.</li>
		</ol>
		<li></li>

		<h2>Emergency Proceedures</h2>
		This proceedure is to be used when the engine is in a feedback loop that <b>CAN NOT</b> be recovered from. The crystal will be permanently lost after the completion of these proceedures, and a replacement will need to be installed.

		<ol>
		<li>If you are not the Chief Engineer, Contact the Chief Engineer.</li>
		<li>Open the Core Vent, this will vent the engine vessel to vacuum.</li>
		<li>Trigger the Core Ejection. Failure to open the Core Vent will result in Core Ejection becoming inoperative due to misalignments.</li>
		<li>If the core has already begun to delaminate, it will likely have melted itself into the hull, and ejection will fail. Evacuation is suggested.</li>
		</ol>
	"}

/datum/codex_category/power/Populate()
	items = GLOB.power_codex_entries
	return ..()
