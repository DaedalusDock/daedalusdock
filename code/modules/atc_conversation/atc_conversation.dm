GLOBAL_LIST_INIT(whole_ship_names, world.file2list("[global.config.directory]/atc_strings/whole_ship_names.txt"))

/datum/atc_conversation
	var/pilot_name
	var/atc_name
	var/vessel_name
	var/vessel_prefix

	/// Cache of name : prefix. So that you don't get names having different prefixes throughout the round.
	var/static/list/prefix_cache = list()

	///Lol
	var/obj/item/radio/radio

/datum/atc_conversation/New()
	atc_name = "[capitalize(station_name())]"
	radio = new /obj/item/radio/headset/silicon/ai
	radio.broadcast_z_override = list(SSmapping.levels_by_trait(ZTRAIT_STATION)[1])
	generate_vessel_name()

/datum/atc_conversation/Destroy()
	QDEL_NULL(radio)
	return ..()

/datum/atc_conversation/proc/generate_vessel_name()
	vessel_name = pick(GLOB.whole_ship_names)
	if(prefix_cache[vessel_name])
		vessel_prefix = prefix_cache[vessel_name]
		return

	vessel_prefix = "HUF"
	prefix_cache[vessel_name] = vessel_prefix

/datum/atc_conversation/proc/vessel_talk(message)
	transmit_speech("[vessel_prefix] [vessel_name]", message)

/datum/atc_conversation/proc/atc_talk(message)
	transmit_speech("[atc_name] ATC", message)

/datum/atc_conversation/proc/transmit_speech(speaker_name, message)
	radio.name = speaker_name
	radio.talk_into(radio, message, RADIO_CHANNEL_SUPPLY)

/// The chatter loop. Blocking proc.
/datum/atc_conversation/proc/chatter()
	vessel_talk("[atc_name] Tower, [vessel_name], VFR, [round(rand(5000, 15000), 100)] to dock, requesting docking codes.")

	if(prob(10))
		var/squawk_num = rand(10000, 99990)
		atc_talk("[vessel_name], [atc_name], squawk [squawk_num] and ident.")
		sleep(rand(3 SECONDS, 7 SECONDS))
		vessel_talk("Squawk [squawk_num], [vessel_name].")

	sleep(rand(5 SECONDS, 9 SECONDS))
	atc_talk("[vessel_name], [atc_name], acknowledged, stand by.")

	sleep(rand(4 SECONDS, 8 SECONDS))
	vessel_talk("Copy.")

	var/heading = "[fit_with_zeros("[rand(1, 360)]", 3)], [fit_with_zeros("[rand(1, 360)]")]"

	sleep(rand(2 SECONDS, 9 SECONDS))
	atc_talk("[vessel_name], [atc_name], docking codes transmitted, you are clear to land, fly heading [heading].")

	sleep(rand(9 SECONDS, 15 SECONDS))
	vessel_talk("[atc_name], [vessel_name], wilco, initiating approach, fly heading [heading].")

	if(prob(30))
		sleep(rand(4 SECONDS, 8 SECONDS))
		atc_talk("[vessel_name], [atc_name], make short approach.")

		sleep(rand(3 SECONDS, 6 SECONDS))
		vessel_talk("[atc_name], [vessel_name], acknowledged, making short approach.")

	else
		sleep(rand(10 SECONDS, 20 SECONDS))

	vessel_talk("[atc_name], [vessel_name], touch down achieved.")
