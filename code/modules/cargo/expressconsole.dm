#define MAX_EMAG_ROCKETS 5
#define BEACON_COST 500
#define SP_LINKED 1
#define SP_READY 2
#define SP_LAUNCH 3
#define SP_UNLINK 4
#define SP_UNREADY 5

/obj/machinery/computer/cargo/express
	name = "express supply console"
	desc = "This console allows the user to purchase a package \
		with 1/40th of the delivery time: made possible by Nanotrasen's new \"1500mm Orbital Railgun\".\
		All sales are near instantaneous - please choose carefully"
	icon_screen = "supply_express"

	circuit = /obj/item/circuitboard/computer/cargo/express

	blockade_warning = "Bluespace instability detected. Delivery impossible."
	is_express = TRUE
	interface_type = "CargoExpress"
	cargo_account = ACCOUNT_CAR

	COOLDOWN_DECLARE(order_cd)

	var/message = "Sales are near-instantaneous - please choose carefully."
	/// The name of the UI
	var/ui_title = "Supply Console"
	/// The currency displayed
	var/ui_currency = "credits"

	/// An optional extended travel time for supply pods.
	var/travel_time_in_minutes = 0

	var/printed_beacons = 0 //number of beacons printed. Used to determine beacon names.
	var/list/buyable_supply_packs
	var/obj/item/supplypod_beacon/beacon //the linked supplypod beacon
	var/area/landingzone = /area/station/cargo/storage //where we droppin boys
	var/podType = /obj/structure/closet/supplypod
	var/cooldown = 0 //cooldown to prevent printing supplypod beacon spam
	var/locked = FALSE //is the console locked? unlock with ID
	var/usingBeacon = FALSE //is the console in beacon mode? exists to let beacon know when a pod may come in
	var/can_use_without_beacon = TRUE

/obj/machinery/computer/cargo/express/Initialize(mapload)
	. = ..()
	buyable_supply_packs = get_buyable_supply_packs()

/obj/machinery/computer/cargo/express/on_construction()
	. = ..()
	buyable_supply_packs = get_buyable_supply_packs()

/obj/machinery/computer/cargo/express/Destroy()
	if(beacon)
		beacon.unlink_console()
	return ..()

/obj/machinery/computer/cargo/express/attackby(obj/item/W, mob/living/user, params)
	if(W.GetID() && allowed(user))
		locked = !locked
		to_chat(user, span_notice("You [locked ? "lock" : "unlock"] the interface."))
		return
	else if(istype(W, /obj/item/disk/cargo/bluespace_pod))
		podType = /obj/structure/closet/supplypod/bluespacepod//doesnt effect circuit board, making reversal possible
		to_chat(user, span_notice("You insert the disk into [src], allowing for advanced supply delivery vehicles."))
		qdel(W)
		return TRUE
	else if(istype(W, /obj/item/supplypod_beacon))
		var/obj/item/supplypod_beacon/sb = W
		if (sb.express_console != src)
			sb.link_console(src, user)
			return TRUE
		else
			to_chat(user, span_alert("[src] is already linked to [sb]."))
	..()

/obj/machinery/computer/cargo/express/emag_act(mob/living/user)
	if(obj_flags & EMAGGED)
		return

	if(user)
		user.visible_message(span_warning("[user] swipes a suspicious card through [src]!"),
		span_notice("You change the routing protocols, allowing the Supply Pod to land anywhere on the station."))

	obj_flags |= EMAGGED
	supply_flags |= SUPPLY_PACK_CONTRABAND|SUPPLY_PACK_EMAG

	// This also sets this on the circuit board
	var/obj/item/circuitboard/computer/cargo/board = circuit
	board.obj_flags |= EMAGGED
	board.supply_flags |= SUPPLY_PACK_CONTRABAND|SUPPLY_PACK_EMAG

	buyable_supply_packs = get_buyable_supply_packs()
	update_static_data_for_all()

/obj/machinery/computer/cargo/express/get_buyable_supply_packs()
	var/meme_pack_data = list()
	for(var/pack in SSshuttle.supply_packs)
		var/datum/supply_pack/P = SSshuttle.supply_packs[pack]
		if(!can_purchase_pack(P))
			continue

		if(!meme_pack_data[P.group])
			meme_pack_data[P.group] = list(
				"name" = P.group,
				"packs" = list()
			)
		meme_pack_data[P.group]["packs"] += list(list(
			"name" = P.name,
			"cost" = P.get_cost(),
			"id" = pack,
			"desc" = P.desc || P.name
		))

	return meme_pack_data

/obj/machinery/computer/cargo/express/proc/get_ui_message()
	. = message

	if(SSshuttle.supply_blocked)
		message = blockade_warning

	if(usingBeacon)
		if(!beacon)
			message = "BEACON ERROR: BEACON MISSING"

		else if (!can_use_beacon())
			message = "BEACON ERROR: MUST BE EXPOSED"

	if(obj_flags & EMAGGED)
		message = "(&!#@ERROR: R0UTING_#PRO7O&OL MALF(*CT#ON. $UG%ESTE@ ACT#0N: !^/PULS3-%E)ET CIR*)ITB%ARD."

/obj/machinery/computer/cargo/express/proc/can_use_beacon()
	return beacon && (isturf(beacon.loc) || ismob(beacon.loc))//is the beacon in a valid location?

/obj/machinery/computer/cargo/express/ui_static_data(mob/user)
	var/list/data = list()
	data["supplies"] = buyable_supply_packs
	data["uiTitle"] = ui_title
	data["uiCurrency"] = " [ui_currency]"
	return data

/obj/machinery/computer/cargo/express/ui_data(mob/user)
	var/canBeacon = can_use_beacon()
	var/list/data = list()
	var/datum/bank_account/D = SSeconomy.department_accounts_by_id[cargo_account]
	if(D)
		data["points"] = D.account_balance

	data["locked"] = locked //swipe an ID to unlock
	data["siliconUser"] = user.has_unlimited_silicon_privilege

	data["beaconzone"] = beacon ? get_area(beacon) : "" //where is the beacon located? outputs in the tgui
	data["usingBeacon"] = usingBeacon //is the mode set to deliver to the beacon or the cargobay?
	data["canBeacon"] = !usingBeacon || canBeacon //is the mode set to beacon delivery, and is the beacon in a valid location?
	data["canBuyBeacon"] = cooldown <= 0 && D.account_balance >= BEACON_COST
	data["beaconError"] = usingBeacon && !canBeacon ? "(BEACON ERROR)" : ""//changes button text to include an error alert if necessary
	data["hasBeacon"] = !!beacon //is there a linked beacon?
	data["beaconName"] = beacon ? beacon.name : "No Beacon Found"
	data["printMsg"] = cooldown > 0 ? "Print Beacon for [BEACON_COST] [ui_currency] ([cooldown])" : "Print Beacon for [BEACON_COST] [ui_currency]"//buttontext for printing beacons
	data["canUseWithoutBeacon"] = can_use_without_beacon
	data["message"] = get_ui_message()

	if (cooldown > 0)//cooldown used for printing beacons
		cooldown--
	return data

/obj/machinery/computer/cargo/express/ui_act(action, params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	switch(action)
		if("LZCargo")
			if(!can_use_without_beacon)
				return

			usingBeacon = FALSE
			if (beacon)
				beacon.update_status(SP_UNREADY) //ready light on beacon will turn off

		if("LZBeacon")
			usingBeacon = TRUE
			if (beacon)
				beacon.update_status(SP_READY) //turns on the beacon's ready light

		if("printBeacon")
			var/datum/bank_account/D = SSeconomy.department_accounts_by_id[cargo_account]
			if(D)
				if(D.adjust_money(-BEACON_COST))
					cooldown = 10//a ~ten second cooldown for printing beacons to prevent spam
					var/obj/item/supplypod_beacon/C = new /obj/item/supplypod_beacon(drop_location())
					C.link_console(src, usr)//rather than in beacon's Initialize(), we can assign the computer to the beacon by reusing this proc)
					printed_beacons++//printed_beacons starts at 0, so the first one out will be called beacon # 1
					beacon.name = "Supply Pod Beacon #[printed_beacons]"

		if("add") //Generate Supply Order first
			if(!COOLDOWN_FINISHED(src, order_cd))
				say("Railgun recalibrating. Stand by.")
				return

			var/id = params["id"]
			id = text2path(id) || id
			var/datum/supply_pack/pack = SSshuttle.supply_packs[id]
			if(!istype(pack))
				CRASH("Unknown supply pack id given by express order console ui. ID: [params["id"]]")

			purchase_pack(usr, pack)

/obj/machinery/computer/cargo/express/proc/purchase_pack(mob/user, datum/supply_pack/pack)
	set waitfor = FALSE

	// Set cooldown now, since this proc will sleep.
	var/cooldown = 5 SECONDS
	if((obj_flags & EMAGGED))
		cooldown = 10 SECONDS

	COOLDOWN_START(src, order_cd, cooldown)

	var/name = "*None Provided*"
	var/rank = "*None Provided*"
	var/ckey = usr.ckey
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		name = H.get_authentification_name()
		rank = H.get_assignment(hand_first = TRUE)

	else if(issilicon(usr))
		name = usr.real_name
		rank = "Silicon"

	var/datum/supply_order/SO = new(pack, name, rank, ckey, "")
	var/points_to_check
	var/datum/bank_account/D = SSeconomy.department_accounts_by_id[cargo_account]
	if(D)
		points_to_check = D.account_balance

	var/real_cost = SO.pack.get_cost()
	if((obj_flags & EMAGGED))
		real_cost *= (0.72*MAX_EMAG_ROCKETS)

	if(real_cost > points_to_check)
		return

	D.adjust_money(-real_cost)

	var/emagged = obj_flags & EMAGGED
	var/location = get_landing_loc_or_locs()
	if(!location || QDELETED(src))
		COOLDOWN_RESET(src, order_cd)
		D.adjust_money(real_cost) // Refund, since we didnt ship
		return

	SO.generateRequisition(get_turf(src))

	var/datum/callback/CB = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(spawn_express_pods), SO, location, emagged, podType)
	if(travel_time_in_minutes)
		addtimer(CB, (travel_time_in_minutes MINUTES))
		say("REQUISITION SUCCESSFUL. ARRIVAL IN APPROXIMATELY [travel_time_in_minutes] MINUTES.")
	else
		CB.InvokeAsync()

/obj/machinery/computer/cargo/express/proc/generate_landing_turfs()
	. = list()

	var/area/area_to_check = GLOB.areas_by_type[(obj_flags & EMAGGED) ? pick(GLOB.the_station_areas) : landingzone]
	for(var/turf/open/floor/T in area_to_check.get_contained_turfs())
		if(T.is_blocked_turf())
			continue
		. += T
		CHECK_TICK

/obj/machinery/computer/cargo/express/proc/get_landing_loc_or_locs()
	if(!(obj_flags & EMAGGED))
		if (usingBeacon)//prioritize beacons over landing in cargobay
			if(!istype(beacon))
				return
			return get_turf(beacon)

		else if (!usingBeacon)//find a suitable supplypod landing zone in cargobay
			var/list/empty_turfs = generate_landing_turfs()
			if(!empty_turfs.len)
				return
			return pick(empty_turfs)
	else
		return generate_landing_turfs()

/// Spawns express pod(s) at a given location. Landing_loc can be a list in the case of an emagged console.
/proc/spawn_express_pods(datum/supply_order/SO, landing_loc, emagged, pod_type)
	if(!emagged)
		new /obj/effect/pod_landingzone(landing_loc, SO.pack.special_pod || pod_type, SO)
		return

	for(var/i in 1 to MAX_EMAG_ROCKETS)
		if(!length(landing_loc))
			return

		var/LZ = pick_n_take(landing_loc)
		new /obj/effect/pod_landingzone(LZ, SO.pack.special_pod || pod_type, SO)
