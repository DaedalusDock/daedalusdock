/datum/codex_entry/machine
	abstract_type = /datum/codex_entry/machine
	disambiguator = "machine"

/datum/codex_entry/machine/New(_display_name, list/_associated_paths, list/_associated_strings, _lore_text, _mechanics_text, _antag_text, _controls_text)
	. = ..()
	GLOB.machine_codex_entries += name

/datum/codex_entry/machine/airlock
	name = "Airlock"
	use_typesof = TRUE
	associated_paths = list(/obj/machinery/door/airlock)
	mechanics_text = "An airtight mechanical door. Most airlocks require an ID to open (wearing it on your ID slot is enough), and many have special access requirements to be on your ID. You can open an airlock by clicking on one, or simply walking into it, and clicking on an open airlock will close it. If the lights on the door flash red, you don't have the required access to open the airlock, and if they're consistently red, the door is bolted. Airlocks also require power to operate. In a situation without power, a crowbar can be used to force it open. <BR><BR>Airlocks can also be <span codexlink='hacking'>hacked</span>.<BR>Airlock hacking information:<BR>* Door bolts will lock the door, preventing it from being opened by any means until the bolts are raised again. Pulsing the correct wire will toggle the bolts, but cutting it will only drop them.<BR>* IDscan light indicates the door can scan ID cards. If the wire for this is pulsed it will cause the door to flash red, and cutting it will cause doors with restricted access to be unable to scan ID, essentially locking it.<BR>* The AI control light shows whether or not AI and robots can control the door. Pulsing is only temporary, while cutting is more permanent.<BR>* The test light shows whether the door has power or not. When turned off, the door can be opened with a crowbar.<BR>* If the door sparks, it is electrified. Pulsing the corresponding wire causes this to happen for 30 seconds, and cutting it electrifies the door until mended.<BR>* The check wiring light will turn on if the safety is turned off. This causes the airlock to close even when someone is standing on it, crushing them.<BR>* If the Check Timing Mechanism light is on then the door will close much faster than normal. Dangerous in conjuction with the Check Wiring light.<BR><BR><B>Deconstruction</B><BR>To pull apart an airlock, you must open the maintenance panel, disable the power via hacking (or any other means), weld the door shut, and crowbar the electroncs out, cut the wires with a wirecutter, unsecure the whole assembly with a wrench, and then cut it into metal sheets with a welding tool."
	antag_text = "Electrifying a door makes for a good trap, hurting and stunning whoever touches it. The same goes for a combination of disabling the safety and timing mechanisms. Bolting a door can also help ensure privacy, or slow down those in search of you. It's also a good idea to disable AI interaction when needed."
	disambiguator = "machine"

/datum/codex_entry/machine/asteroid_magnet
	name = "Asteroid Magnet"
	use_typesof = TRUE
	associated_paths = list(/obj/machinery/asteroid_magnet)
	lore_text = {"
		An extremely powerful magnet that is able to draw in magnetically charged bodies floating in the void.

		<h2>Error Codes</h2>
		<h1>B1</h1>
		The stellar body magnet is currently busy, wait for it to finish it's current task.

		<h1>C4</h1>
		The coordinates provided have already been used.

		<h1>F5</h1>
		The stellar body magnet is cooling down, wait for it to finish before using it again.

		<h1>L2</h1>
		There is a biological lifeform within the bounds of the magnetic field. Remove it and try again.

		<h1>N1</h1>
		There are no selected coordinates.
	"}
