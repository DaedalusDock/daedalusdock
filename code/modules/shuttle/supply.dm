GLOBAL_LIST_INIT(blacklisted_cargo_types, typecacheof(list(
		/mob/living,
		/obj/structure/blob,
		/obj/effect/rune,
		/obj/item/disk/nuclear,
		/obj/machinery/nuclearbomb,
		/obj/item/beacon,
		/obj/narsie,
		/obj/tear_in_reality,
		/obj/machinery/teleport/station,
		/obj/machinery/teleport/hub,
		/obj/machinery/quantumpad,
		/obj/effect/mob_spawn,
		/obj/structure/receiving_pad,
		/obj/machinery/rnd/production, //print tracking beacons, send shuttle
		/obj/machinery/autolathe, //same
		/obj/projectile/beam/wormhole,
		/obj/effect/portal,
		/obj/structure/extraction_point,
		/obj/machinery/syndicatebomb,
		/obj/item/hilbertshotel,
		/obj/item/swapper,
		/obj/docking_port,
		/obj/machinery/launchpad,
		/obj/machinery/disposal,
		/obj/structure/disposalpipe,
		/obj/item/mail,
		/obj/machinery/camera,
		/obj/item/gps,
		/obj/structure/checkoutmachine
	)))

/// How many goody orders we can fit in a lockbox before we upgrade to a crate
#define GOODY_FREE_SHIPPING_MAX 5
/// How much to charge oversized goody orders
#define CRATE_TAX 700

/obj/docking_port/mobile/supply
	name = "supply shuttle"
	id = "supply"
	callTime = 600

	dir = WEST
	port_direction = EAST
	width = 12
	dwidth = 5
	height = 7
	movement_force = list("KNOCKDOWN" = 0, "THROW" = 0)


	//Export categories for this run, this is set by console sending the shuttle.
	var/export_categories = EXPORT_CARGO

/obj/docking_port/mobile/supply/register()
	. = ..()
	SSshuttle.supply = src

/obj/docking_port/mobile/supply/canMove()
	if(is_station_level(z))
		return check_blacklist(shuttle_areas)
	return ..()

/obj/docking_port/mobile/supply/proc/check_blacklist(areaInstances)
	for(var/place in areaInstances)
		var/area/shuttle/shuttle_area = place
		for(var/turf/shuttle_turf in shuttle_area)
			for(var/atom/passenger in shuttle_turf.get_all_contents())
				if((is_type_in_typecache(passenger, GLOB.blacklisted_cargo_types) || HAS_TRAIT(passenger, TRAIT_BANNED_FROM_CARGO_SHUTTLE)) && !istype(passenger, /obj/docking_port))
					return FALSE
	return TRUE

/obj/docking_port/mobile/supply/request(obj/docking_port/stationary/S)
	if(mode != SHUTTLE_IDLE)
		return 2
	return ..()

/obj/docking_port/mobile/supply/pre_dock(obj/docking_port/stationary/new_dock, movement_direction, force)
	. = ..()
	if(getDockedId() == "supply_away") // Buy when we leave home.
		buy()
		create_mail()
		return

	if(new_dock.id != "supply_away" && !istype(new_dock, /obj/docking_port/stationary/transit) && mode != SHUTTLE_PREARRIVAL)
		var/datum/atc_conversation/convo = new()
		convo.chatter()
		qdel(convo)

/obj/docking_port/mobile/supply/post_dock(obj/docking_port/stationary/new_dock, dock_status)
	. = ..()
	if(dock_status != DOCKING_SUCCESS)
		return

	if(getDockedId() == "supply_away") // Sell when we get home
		sell()

/obj/docking_port/mobile/supply/proc/buy()
	SEND_SIGNAL(SSshuttle, COMSIG_SUPPLY_SHUTTLE_BUY)

	var/list/empty_turfs = list()
	for(var/place in shuttle_areas)
		var/area/shuttle/shuttle_area = place
		for(var/turf/open/floor/T in shuttle_area)
			if(T.is_blocked_turf())
				continue
			empty_turfs += T

	//quickly and greedily handle chef's grocery runs first, there are a few reasons why this isn't attached to the rest of cargo...
	//but the biggest reason is that the chef requires produce to cook and do their job, and if they are using this system they
	//already got let down by the botanists. So to open a new chance for cargo to also screw them over any more than is necessary is bad.
	if(SSshuttle.chef_groceries.len)
		var/obj/structure/closet/crate/freezer/grocery_crate = new(pick_n_take(empty_turfs))
		grocery_crate.name = "kitchen produce freezer"
		investigate_log("Chef's [SSshuttle.chef_groceries.len] sized produce order arrived. Cost was deducted from orderer, not cargo.", INVESTIGATE_CARGO)
		for(var/datum/orderable_item/item as anything in SSshuttle.chef_groceries)//every order
			for(var/amt in 1 to SSshuttle.chef_groceries[item])//every order amount
				new item.item_path(grocery_crate)
		SSshuttle.chef_groceries.Cut() //This lets the console know it can order another round.

	if(!SSshuttle.shopping_list.len)
		return

	var/value = 0
	var/purchases = 0
	for(var/datum/supply_order/spawning_order in SSshuttle.shopping_list)
		if(!empty_turfs.len)
			break
		var/price = spawning_order.pack.get_cost()
		if(spawning_order.applied_coupon)
			price *= (1 - spawning_order.applied_coupon.discount_pct_off)

		var/datum/bank_account/paying_for_this

		//department orders EARN money for cargo, not the other way around
		if(!spawning_order.department_destination)
			if(spawning_order.paying_account) //Someone paid out of pocket
				paying_for_this = spawning_order.paying_account
				price *= 1.1 //TODO make this customizable by the quartermaster
			else
				paying_for_this = SSeconomy.department_accounts_by_id[ACCOUNT_CAR]

			if(paying_for_this)
				if(!paying_for_this.adjust_money(-price))
					if(spawning_order.paying_account)
						paying_for_this.bank_card_talk("Cargo order #[spawning_order.id] rejected due to lack of funds. Marks required: [price]")
					continue

		if(spawning_order.paying_account)
			paying_for_this.bank_card_talk("Cargo order #[spawning_order.id] has shipped. [price] marks have been charged to your bank account.")
			SSeconomy.track_purchase(paying_for_this, price, spawning_order.pack.name)
			var/datum/bank_account/department/cargo = SSeconomy.department_accounts_by_id[ACCOUNT_CAR]
			cargo.adjust_money(price - spawning_order.pack.get_cost()) //Cargo gets the handling fee
		value += spawning_order.pack.get_cost()
		SSshuttle.shopping_list -= spawning_order
		SSshuttle.order_history += spawning_order
		QDEL_NULL(spawning_order.applied_coupon)

		spawning_order.generate(pick_n_take(empty_turfs))

		SSblackbox.record_feedback("nested tally", "cargo_imports", 1, list("[spawning_order.pack.get_cost()]", "[spawning_order.pack.name]"))

		var/from_whom = paying_for_this?.account_holder || "nobody (department order)"

		investigate_log("Order #[spawning_order.id] ([spawning_order.pack.name], placed by [key_name(spawning_order.orderer_ckey)]), paid by [from_whom] has shipped.", INVESTIGATE_CARGO)
		if(spawning_order.pack.dangerous)
			message_admins("\A [spawning_order.pack.name] ordered by [ADMIN_LOOKUPFLW(spawning_order.orderer_ckey)], paid by [from_whom] has shipped.")
		purchases++

	SSeconomy.import_total += value
	var/datum/bank_account/cargo_budget = SSeconomy.department_accounts_by_id[ACCOUNT_CAR]
	investigate_log("[purchases] orders in this shipment, worth [value] marks. [cargo_budget.account_balance] marks left.", INVESTIGATE_CARGO)

/obj/docking_port/mobile/supply/proc/sell()
	var/datum/bank_account/cargo_account = SSeconomy.department_accounts_by_id[ACCOUNT_CAR]
	var/datum/bank_account/master_account = SSeconomy.station_master
	var/total

	if(!GLOB.exports_list.len) // No exports list? Generate it!
		setupExports()

	var/msg = ""

	var/datum/export_report/ex = new

	for(var/place in shuttle_areas)
		var/area/shuttle/shuttle_area = place
		for(var/atom/movable/AM in shuttle_area)
			if(iscameramob(AM))
				continue
			if(!AM.anchored)
				export_item_and_contents(AM, export_categories , dry_run = FALSE, external_report = ex)

	if(ex.exported_atoms)
		ex.exported_atoms += "." //ugh

	for(var/datum/export/E in ex.total_amount)
		var/export_text = E.total_printout(ex)
		if(!export_text)
			continue

		msg += export_text + "\n"
		total += ex.total_value[E]

	SSeconomy.export_total += total
	var/cargo_split = round(total/2)
	cargo_account.adjust_money(cargo_split)
	master_account.adjust_money(total - cargo_split)

	SSshuttle.centcom_message = msg
	investigate_log("Shuttle contents sold for [total] marks. Contents: [ex.exported_atoms ? ex.exported_atoms.Join(",") + "." : "none."] Message: [SSshuttle.centcom_message || "none."]", INVESTIGATE_CARGO)

/*
	Generates a box of mail depending on our exports and imports.
	Applied in the cargo shuttle sending/arriving, by building the crate if the round is ready to introduce mail based on the economy subsystem.
	Then, fills the mail crate with mail, by picking applicable crew who can recieve mail at the time to sending.
*/
/obj/docking_port/mobile/supply/proc/create_mail()
	//Early return if there's no mail waiting to prevent taking up a slot. We also don't send mails on sundays or holidays.
	if(!SSeconomy.mail_waiting || SSeconomy.mail_blocked)
		return

	//spawn crate
	var/list/empty_turfs = list()
	for(var/place as anything in shuttle_areas)
		var/area/shuttle/shuttle_area = place
		for(var/turf/open/floor/shuttle_floor in shuttle_area)
			if(shuttle_floor.is_blocked_turf())
				continue
			empty_turfs += shuttle_floor

	new /obj/structure/closet/crate/mail/economy(pick(empty_turfs))

#undef GOODY_FREE_SHIPPING_MAX
#undef CRATE_TAX
