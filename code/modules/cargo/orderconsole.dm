/obj/machinery/computer/cargo
	name = "supply console"
	desc = "Used to order supplies, approve requests, and control the shuttle."
	icon_screen = "supply"
	circuit = /obj/item/circuitboard/computer/cargo
	light_color = COLOR_BRIGHT_ORANGE

	///Can the supply console send the shuttle back and forth? Used in the UI backend.
	var/can_send = TRUE
	///Can this console only send requests?
	var/requestonly = FALSE
	///Can you approve requests placed for cargo? Works differently between the app and the computer.
	var/can_approve_requests = TRUE
	var/contraband = FALSE
	var/self_paid = FALSE
	var/safety_warning = "For safety and ethical reasons, the automated supply shuttle cannot transport live organisms, \
		human remains, classified nuclear weaponry, mail, undelivered departmental order crates, syndicate bombs, \
		homing beacons, unstable eigenstates, or machinery housing any form of artificial intelligence."
	var/blockade_warning = "Bluespace instability detected. Shuttle movement impossible."
	/// radio used by the console to send messages on supply channel
	var/obj/item/radio/headset/radio
	/// var that tracks message cooldown
	var/message_cooldown
	var/list/loaded_coupons
	/// var that makes express console use rockets
	var/is_express = FALSE
	///The name of the shuttle template being used as the cargo shuttle. 'supply' is default and contains critical code. Don't change this unless you know what you're doing.
	var/cargo_shuttle = "supply"
	///The docking port called when returning to the station.
	var/docking_home = "supply_home"
	///The docking port called when leaving the station.
	var/docking_away = "supply_away"
	///If this console can loan the cargo shuttle. Set to false to disable.
	var/stationcargo = TRUE
	///The account this console processes and displays. Independent from the account the shuttle processes.
	var/cargo_account = ACCOUNT_CAR
	///Interface name for the ui_interact call for different subtypes.
	var/interface_type = "Cargo"

	/// Matches supply pack flags
	var/supply_flags = NONE

/obj/machinery/computer/cargo/request
	name = "supply request console"
	desc = "Used to request supplies from cargo."
	icon_screen = "request"
	circuit = /obj/item/circuitboard/computer/cargo/request
	can_send = FALSE
	can_approve_requests = FALSE
	requestonly = TRUE

/obj/machinery/computer/cargo/Initialize(mapload)
	. = ..()
	radio = new /obj/item/radio/headset/headset_cargo(src)

/obj/machinery/computer/cargo/Destroy()
	QDEL_NULL(radio)
	return ..()

/obj/machinery/computer/cargo/attacked_by(obj/item/I, mob/living/user)
	if(istype(I,/obj/item/trade_chip))
		var/obj/item/trade_chip/contract = I
		contract.try_to_unlock_contract(user)
		return TRUE
	else
		return ..()

/obj/machinery/computer/cargo/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	if(user)
		user.visible_message(span_warning("[user] swipes a suspicious card through [src]!"),
		span_notice("You adjust [src]'s routing and receiver spectrum, unlocking special supplies and contraband."))

	obj_flags |= EMAGGED
	supply_flags |= SUPPLY_PACK_CONTRABAND|SUPPLY_PACK_EMAG

	// This also permanently sets this on the circuit board
	var/obj/item/circuitboard/computer/cargo/board = circuit
	board.supply_flags |= SUPPLY_PACK_CONTRABAND|SUPPLY_PACK_EMAG
	board.obj_flags |= EMAGGED
	update_static_data(user)

/obj/machinery/computer/cargo/on_construction()
	. = ..()
	circuit.configure_machine(src)

/obj/item/circuitboard/computer/cargo/multitool_act(mob/living/user)
	. = ..()
	if(!(obj_flags & EMAGGED))
		supply_flags ^= SUPPLY_PACK_CONTRABAND
		to_chat(user, span_notice("Receiver spectrum set to [(supply_flags & SUPPLY_PACK_CONTRABAND) ? "Broad" : "Standard"]."))
	else
		to_chat(user, span_alert("The spectrum chip is unresponsive."))

/obj/machinery/computer/cargo/proc/get_export_categories()
	. = EXPORT_CARGO
	if(supply_flags & SUPPLY_PACK_CONTRABAND)
		. |= EXPORT_CONTRABAND
	if(supply_flags & SUPPLY_PACK_EMAG)
		. |= EXPORT_EMAG

/// Returns TRUE if the pack can be purchased.
/obj/machinery/computer/cargo/proc/can_purchase_pack(datum/supply_pack/pack)
	. = TRUE
	if((pack.supply_flags & SUPPLY_PACK_EMAG) && !(supply_flags & SUPPLY_PACK_EMAG))
		return FALSE

	if((pack.supply_flags & SUPPLY_PACK_CONTRABAND) && !(supply_flags & SUPPLY_PACK_CONTRABAND))
		return FALSE

	if((pack.supply_flags & SUPPLY_PACK_DROPPOD_ONLY) && !is_express)
		return FALSE

	if(pack.special && !pack.special_enabled)
		return FALSE

	if((pack.supply_flags & SUPPLY_PACK_GOVERNMENT) && !(supply_flags & SUPPLY_PACK_GOVERNMENT))
		return FALSE

/obj/machinery/computer/cargo/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, interface_type, name)
		ui.open()

/obj/machinery/computer/cargo/ui_data()
	var/list/data = list()
	data["location"] = SSshuttle.supply.getStatusText()
	var/datum/bank_account/D = SSeconomy.department_accounts_by_id[cargo_account]
	if(D)
		data["points"] = D.account_balance

	data["grocery"] = SSshuttle.chef_groceries.len
	data["away"] = SSshuttle.supply.getDockedId() == docking_away
	data["self_paid"] = self_paid
	data["docked"] = SSshuttle.supply.mode == SHUTTLE_IDLE
	data["loan"] = !!SSshuttle.shuttle_loan
	data["loan_dispatched"] = SSshuttle.shuttle_loan && SSshuttle.shuttle_loan.dispatched
	data["can_send"] = can_send
	data["can_approve_requests"] = can_approve_requests

	var/message = "Remember to stamp and send back the supply manifests."
	if(SSshuttle.centcom_message)
		message = SSshuttle.centcom_message
	if(SSshuttle.supply_blocked)
		message = blockade_warning

	data["message"] = message
	data["cart"] = list()

	for(var/datum/supply_order/SO in SSshuttle.shopping_list)
		data["cart"] += list(list(
			"object" = SO.pack.name,
			"cost" = SO.pack.get_cost(),
			"id" = SO.id,
			"orderer" = SO.orderer,
			"paid" = !isnull(SO.paying_account), //paid by requester
			"dep_order" = SO.department_destination ? TRUE : FALSE
		))

	data["requests"] = list()
	for(var/datum/supply_order/SO in SSshuttle.request_list)
		data["requests"] += list(list(
			"object" = SO.pack.name,
			"cost" = SO.pack.get_cost(),
			"orderer" = SO.orderer,
			"reason" = SO.reason,
			"id" = SO.id
		))

	return data

/obj/machinery/computer/cargo/ui_static_data(mob/user)
	var/list/data = list()
	data["supplies"] = get_buyable_supply_packs()
	return data

/obj/machinery/computer/cargo/proc/get_buyable_supply_packs()
	RETURN_TYPE(/list)
	. = list()
	for(var/pack in SSshuttle.supply_packs)
		var/datum/supply_pack/P = SSshuttle.supply_packs[pack]
		if(!can_purchase_pack(P))
			continue

		if(!.[P.group])
			.[P.group] = list(
				"name" = P.group,
				"packs" = list()
			)

		.[P.group]["packs"] += list(list(
			"name" = P.name,
			"cost" = P.get_cost(),
			"id" = pack,
			"desc" = P.desc || P.name, // If there is a description, use it. Otherwise use the pack's name.
			"goody" = P.goody,
			"access" = P.access
		))

	sortTim(., GLOBAL_PROC_REF(cmp_text_asc))

/obj/machinery/computer/cargo/ui_act(action, params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("send")
			if(!SSshuttle.supply.canMove())
				say(safety_warning)
				return

			if(SSshuttle.supply_blocked)
				say(blockade_warning)
				return

			if(SSshuttle.supply.getDockedId() == docking_home)
				SSshuttle.supply.export_categories = get_export_categories()
				SSshuttle.moveShuttle(cargo_shuttle, docking_away, TRUE)
				say("The supply shuttle is departing.")
				investigate_log("[key_name(usr)] sent the supply shuttle away.", INVESTIGATE_CARGO)

			else
				investigate_log("[key_name(usr)] called the supply shuttle.", INVESTIGATE_CARGO)
				say("The supply shuttle has been called and will arrive in [SSshuttle.supply.timeLeft(600)] minutes.")
				SSshuttle.moveShuttle(cargo_shuttle, docking_home, TRUE)

			. = TRUE

		if("loan")
			if(!SSshuttle.shuttle_loan)
				return

			if(SSshuttle.supply_blocked)
				say(blockade_warning)
				return
			else if(SSshuttle.supply.mode != SHUTTLE_IDLE)
				return
			else if(SSshuttle.supply.getDockedId() != docking_away)
				return
			else if(stationcargo != TRUE)
				return
			else
				SSshuttle.shuttle_loan.loan_shuttle()
				say("The supply shuttle has been loaned to CentCom.")
				investigate_log("[key_name(usr)] accepted a shuttle loan event.", INVESTIGATE_CARGO)
				log_game("[key_name(usr)] accepted a shuttle loan event.")
				. = TRUE

		if("add")
			if(is_express)
				return

			var/id = params["id"]
			id = text2path(id) || id
			var/datum/supply_pack/pack = SSshuttle.supply_packs[id]
			if(!istype(pack))
				CRASH("Unknown supply pack id given by order console ui. ID: [params["id"]]")

			if(!can_purchase_pack(pack))
				return

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

			var/datum/bank_account/account
			if(self_paid && isliving(usr))
				var/mob/living/L = usr
				var/obj/item/card/id/id_card = L.get_idcard(TRUE)
				if(!istype(id_card))
					say("No ID card detected.")
					return

				if(istype(id_card, /obj/item/card/id/departmental_budget))
					say("The [src] rejects [id_card].")
					return

				account = id_card.registered_account
				if(!istype(account))
					say("Invalid bank account.")
					return

			var/reason = ""
			if(requestonly && !self_paid)
				reason = tgui_input_text(usr, "Reason", name)
				if(isnull(reason) || ..())
					return

			if(pack.goody && !self_paid)
				playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
				say("ERROR: Small crates may only be purchased by private accounts.")
				return

			var/obj/item/coupon/applied_coupon
			for(var/i in loaded_coupons)
				var/obj/item/coupon/coupon_check = i
				if(pack.type == coupon_check.discounted_pack)
					say("Coupon found! [round(coupon_check.discount_pct_off * 100)]% off applied!")
					coupon_check.moveToNullspace()
					applied_coupon = coupon_check
					break

			var/turf/T = get_turf(src)
			var/datum/supply_order/SO = new(pack, name, rank, ckey, reason, account, null, applied_coupon)
			SO.generateRequisition(T)
			if(requestonly && !self_paid)
				SSshuttle.request_list += SO
			else
				SSshuttle.shopping_list += SO
				if(self_paid)
					say("Order processed. The price will be charged to [account.account_holder]'s bank account on delivery.")
			if(requestonly && message_cooldown < world.time)
				radio.talk_into(src, "A new order has been requested.", RADIO_CHANNEL_SUPPLY)
				message_cooldown = world.time + 30 SECONDS
			. = TRUE
		if("remove")
			var/id = text2num(params["id"])
			for(var/datum/supply_order/SO in SSshuttle.shopping_list)
				if(SO.id != id)
					continue
				if(SO.department_destination)
					say("Only the department that ordered this item may cancel it.")
					return
				if(SO.applied_coupon)
					say("Coupon refunded.")
					SO.applied_coupon.forceMove(get_turf(src))
				SSshuttle.shopping_list -= SO
				. = TRUE
				break
		if("clear")
			for(var/datum/supply_order/cancelled_order in SSshuttle.shopping_list)
				if(cancelled_order.department_destination)
					continue //don't cancel other department's orders
				SSshuttle.shopping_list -= cancelled_order
			. = TRUE
		if("approve")
			var/id = text2num(params["id"])
			for(var/datum/supply_order/SO in SSshuttle.request_list)
				if(SO.id == id)
					SSshuttle.request_list -= SO
					SSshuttle.shopping_list += SO
					. = TRUE
					break
		if("deny")
			var/id = text2num(params["id"])
			for(var/datum/supply_order/SO in SSshuttle.request_list)
				if(SO.id == id)
					SSshuttle.request_list -= SO
					. = TRUE
					break
		if("denyall")
			SSshuttle.request_list.Cut()
			. = TRUE
		if("toggleprivate")
			self_paid = !self_paid
			. = TRUE
	if(.)
		post_signal(cargo_shuttle)

/obj/machinery/computer/cargo/post_signal(command)
	SHOULD_CALL_PARENT(FALSE) // TODO: make not agony
	var/datum/radio_frequency/frequency = SSpackets.return_frequency(FREQ_STATUS_DISPLAYS)

	if(!frequency)
		return

	var/datum/signal/status_signal = new(src, list("command" = command))
	frequency.post_signal(status_signal)
