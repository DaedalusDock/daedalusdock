/datum/codex_entry/atmos_pipe
	name = "Pipes"
	associated_paths = list(/obj/machinery/atmospherics/pipe/smart/simple, /obj/machinery/atmospherics/pipe/smart/manifold, /obj/machinery/atmospherics/pipe/smart/manifold4w)
	use_typesof = TRUE
	mechanics_text = "&nbsp;&nbsp;&nbsp;&nbsp;All pipes can be connected or disconnected with a wrench. More pipes can be obtained from a pipe dispenser. \
	Some pipes, like scrubbers and supply pipes, do not connect to 'normal' pipes. If you want to connect them, use a universal adapter pipe. \
	Pipes generally do not exchange thermal energy with the environment (ie. they do not heat up or cool down their turf), but heat exchange pipes are an exception. \
	To join three or more pipe segments, you can use a pipe manifold."
	disambiguator = "atmospherics"

	controls_text = {"
	Right Click - Adjust the layer of the pipe.
	"}

/datum/codex_entry/atmos_pipe/New(_display_name, list/_associated_paths, list/_associated_strings, _lore_text, _mechanics_text, _antag_text)

/datum/codex_entry/atmos_valve
	name = "Manual Valve"
	associated_paths = list(/obj/machinery/atmospherics/components/binary/valve)
	use_typesof = TRUE
	mechanics_text = "&nbsp;&nbsp;&nbsp;&nbsp;Click this to turn the valve.  If red, the pipes on each end are seperated.  Otherwise, they are connected."
	disambiguator = "atmospherics"

/datum/codex_entry/atmos_pump
	name = "Pressure Pump"
	use_typesof = TRUE
	associated_paths = list(/obj/machinery/atmospherics/components/binary/pump)
	mechanics_text = "&nbsp;&nbsp;&nbsp;&nbsp;This moves gas from one pipe to another.  A higher target pressure demands more energy.  The side with the red end is the output."
	disambiguator = "atmospherics"

/datum/codex_entry/atmos_vent_pump
	name = "Vent Pump"
	use_typesof = TRUE
	associated_paths = list(/obj/machinery/atmospherics/components/unary/vent_pump)
	mechanics_text = "&nbsp;&nbsp;&nbsp;&nbsp;This pumps the contents of the attached pipe out into the atmosphere, if needed."
	controls_text = "Multitool - Toggle Low-Power mode."
	disambiguator = "atmospherics"

/datum/codex_entry/atmos_freezer
	name = "Thermomachine"
	use_typesof = TRUE
	associated_paths = list(/obj/machinery/atmospherics/components/unary/thermomachine)
	mechanics_text = {"
		&nbsp;&nbsp;&nbsp;&nbsp;Adjusts the temperature of gas flowing through it.
		<ul>
		<li>It uses massive amounts of electricity while on.</li>
		<li>It can be upgraded by replacing the capacitors, manipulators, and matter bins.<li>
		</ul>
	"}
	disambiguator = "atmospherics"

/datum/codex_entry/atmos_vent_scrubber
	name = "Vent Scrubber"
	use_typesof = TRUE
	associated_paths = list(/obj/machinery/atmospherics/components/unary/vent_scrubber)
	mechanics_text = "&nbsp;&nbsp;&nbsp;&nbsp;This filters the atmosphere of harmful gas.  Filtered gas goes to the pipes connected to it, typically a scrubber pipe. \
	It can be controlled from an Air Alarm.  Has a mode to siphon much faster, using much more power in the process."
	controls_text = "Multitool - Toggle Low-Power mode."
	disambiguator = "atmospherics"

/datum/codex_entry/atmos_canister
	name = "Gas Canister" // because otherwise it shows up as 'canister: [caution]'
	associated_paths = list(/obj/machinery/portable_atmospherics/canister)
	use_typesof = TRUE
	mechanics_text = {"
		&nbsp;&nbsp;&nbsp;&nbsp;The canister can be connected to a connector port with a wrench.  Tanks of gas (the kind you can hold in your hand)
		can be filled by the canister, by using the tank on the canister, increasing the release pressure, then opening the valve until it is full, and then close it.
		<br>
		*DO NOT* remove the tank until the valve is closed.
		<br>
		A gas analyzer can be used to check the contents of the canister.
	"}
	antag_text = "&nbsp;&nbsp;&nbsp;&nbsp;Canisters can be damaged, spilling their contents into the air, or you can just leave the release valve open."
	disambiguator = "atmospherics"

/datum/codex_entry/atmos_meter
	name = "Gas Meter"
	use_typesof = TRUE
	associated_paths = list(/obj/machinery/meter)
	mechanics_text = "&nbsp;&nbsp;&nbsp;&nbsp;Measures the volume and temperature of the pipe under the meter.</span>"
	disambiguator = "atmospherics"

/datum/codex_entry/transfer_valve
	name = "Tank Transfer Valve"
	associated_paths = list(/obj/item/transfer_valve)
	mechanics_text = "&nbsp;&nbsp;&nbsp;&nbsp;This machine is used to merge the contents of two different gas tanks. Plug the tanks into the transfer, then open the valve to mix them together. You can also attach various assembly devices to trigger this process."
	antag_text = "&nbsp;&nbsp;&nbsp;&nbsp;With a tank of hot hydrogen and cold oxygen, this benign little atmospheric device becomes an incredibly deadly bomb. You don't want to be anywhere near it when it goes off."
	disambiguator = "component"

/datum/codex_entry/gas_analyzer
	name = "Gas Analyzer"
	use_typesof = TRUE
	associated_paths = list(/obj/item/analyzer) //:(
	mechanics_text = {"
		&nbsp;&nbsp;&nbsp;&nbsp;A device that analyzes the gas contents of a tile or atmospherics devices. Has 3 modes: Default operates without
		additional output data; Moles and volume shows the moles per gas in the mixture and the total moles and volume; Gas
		traits and data describes the traits per gas, how it interacts with the world, and some of its property constants.
	"}
	controls_text = {"
	Alt Click - Activate barometer.<br>
	Right Click - Open gas reference.
	"}

	disambiguator = "equipment"
