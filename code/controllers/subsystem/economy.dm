SUBSYSTEM_DEF(economy)
	name = "Economy"
	wait = 5 MINUTES
	init_order = INIT_ORDER_ECONOMY
	runlevels = RUNLEVEL_GAME
	///How many paychecks should players start out the round with?
	var/roundstart_paychecks = 5
	///How many credits does the in-game economy have in circulation at round start? Divided up by 6 of the 7 department budgets evenly, where cargo starts with nothing.
	var/budget_pool = 52500
	var/list/department_id2name = list(
		ACCOUNT_ENG = ACCOUNT_ENG_NAME,
		ACCOUNT_SCI = ACCOUNT_SCI_NAME,
		ACCOUNT_MED = ACCOUNT_MED_NAME,
		ACCOUNT_SRV = ACCOUNT_SRV_NAME,
		ACCOUNT_CAR = ACCOUNT_CAR_NAME,
		ACCOUNT_SEC = ACCOUNT_SEC_NAME,
		ACCOUNT_STATION_MASTER = ACCOUNT_STATION_MASTER_NAME
	)
	///The station's master account, used for splitting up funds and pooling money.
	var/datum/bank_account/department/station_master
	///Used to not spam the payroll announcement
	var/run_dry = FALSE
	///Payroll boolean
	var/payroll_active = TRUE

	///Departmental account datums by ID
	var/list/department_accounts_by_id = list()
	var/list/generated_accounts = list()

	/**
	 * Enables extra money charges for things that normally would be free, such as sleepers/cryo/beepsky.
	 * Take care when enabling, as players will NOT respond well if the economy is set up for low cash flows.
	 */
	var/full_ancap = FALSE

	/// Departmental cash provided to science when a node is researched in specific configs.
	var/techweb_bounty = 250
	/**
	  * List of normal (no department ones) accounts' identifiers with associated datum accounts, for big O performance.
	  * A list of sole account datums can be obtained with flatten_list(), another variable would be redundant rn.
	  */
	var/list/bank_accounts_by_id = list()
	///List of the departmental budget cards in existance.
	var/list/dep_cards = list()
	/// A var that collects the total amount of credits owned in player accounts on station, reset and recounted on fire()
	var/station_total = 0
	/// How many civilain bounties have been completed so far this shift? Affects civilian budget payout values.
	var/civ_bounty_tracker = 0
	/// Contains the message to send to newscasters about price inflation and earnings, updated on price_update()
	var/earning_report
	///The modifier multiplied to the value of bounties paid out.
	var/bounty_modifier = 1
	///The modifier multiplied to the value of cargo pack prices.
	var/pack_price_modifier = 1
	/**
	 * A list of strings containing a basic transaction history of purchases on the station.
	 * Added to any time when player accounts purchase something.
	 */
	var/list/audit_log = list()

	/// Total value of exported materials.
	var/export_total = 0
	/// Total value of imported goods.
	var/import_total = 0
	/// Number of mail items generated.
	var/mail_waiting = 0
	/// Mail Holiday: AKA does mail arrive today? Always blocked on Sundays.
	var/mail_blocked = FALSE

/datum/controller/subsystem/economy/Initialize(timeofday)
	///The master account gets 50% of the roundstart budget
	var/reserved_for_master = round(budget_pool / 2)
	station_master = new(ACCOUNT_STATION_MASTER, ACCOUNT_STATION_MASTER_NAME, reserved_for_master)
	department_accounts_by_id[ACCOUNT_STATION_MASTER] = station_master
	budget_pool = round(budget_pool/2)

	var/budget_to_hand_out = round(budget_pool / ECON_NUM_DEPARTMENT_ACCOUNTS)

	for(var/dep_id in department_id2name - ACCOUNT_STATION_MASTER)
		department_accounts_by_id[dep_id] = new /datum/bank_account/department(dep_id, department_id2name[dep_id], budget_to_hand_out)
	return ..()

/datum/controller/subsystem/economy/Recover()
	generated_accounts = SSeconomy.generated_accounts
	bank_accounts_by_id = SSeconomy.bank_accounts_by_id
	dep_cards = SSeconomy.dep_cards

/datum/controller/subsystem/economy/fire(resumed = 0)
	///The first fire at roundstart is discarded.
	if(!times_fired)
		return

	var/delta_time = wait / (5 MINUTES)

	//Split the station budget amongst the departments
	departmental_payouts()

	///See if we even have enough money to pay these idiots
	var/required_funds = 0
	for(var/account in bank_accounts_by_id)
		var/datum/bank_account/bank_account = bank_accounts_by_id[account]
		required_funds += round(bank_account.account_job.paycheck * bank_account.payday_modifier)

	if(payroll_active)
		if(required_funds > station_master.account_balance)
			if(!run_dry)
				minor_announce("The station budget appears to have run dry. We regret to inform you that no further wage payments are possible until this situation is rectified.","Payroll Announcement")
				run_dry = TRUE
		else
			if(run_dry)
				run_dry = FALSE
			for(var/account in bank_accounts_by_id)
				var/datum/bank_account/bank_account = bank_accounts_by_id[account]
				bank_account.payday()

	//price_update() This doesn't need to fire every 5 minutes. The only current use is market crash, which handles it on its own.
	var/effective_mailcount = round(living_player_count())
	mail_waiting += clamp(effective_mailcount, 1, MAX_MAIL_PER_MINUTE * delta_time)
	send_fax_paperwork()

/**
 * Departmental income payments are kept static and linear for every department, and paid out once every 5 minutes.
 * Iterates over every department account for the same payment.
 */
/datum/controller/subsystem/economy/proc/departmental_payouts()
	var/payout_pool = (station_master.account_balance - ECON_STATION_PAYOUT) < 0 ? station_master.account_balance : ECON_STATION_PAYOUT
	if(payout_pool < ECON_STATION_PAYOUT_REQUIREMENT)
		return

	var/split = round(payout_pool / (length(department_accounts_by_id) - 1))

	for(var/iteration in department_id2name - ACCOUNT_STATION_MASTER)
		var/datum/bank_account/dept_account = department_accounts_by_id[iteration]
		if(dept_account.account_balance >= ECON_STATION_PAYOUT_MAX)
			continue

		var/real_split = min(ECON_STATION_PAYOUT_MAX - dept_account.account_balance, split)

		if(!dept_account.transfer_money(station_master, real_split))
			dept_account.transfer_money(station_master, payout_pool)
			break
		else
			payout_pool -= real_split


/**
 * Updates the prices of all station vendors.
 *
 * Iterates over the machines list for vending machines, resets their regular and premium product prices (Not contraband).
 **/
/datum/controller/subsystem/economy/proc/price_update()
	var/multiplier = 1

	if(HAS_TRAIT(src, TRAIT_MARKET_CRASHING))
		multiplier = 4

	for(var/obj/machinery/vending/V in GLOB.machines)
		if(istype(V, /obj/machinery/vending/custom))
			continue
		if(!is_station_level(V.z))
			continue
		V.reset_prices(V.product_records, V.coin_records, multiplier)

/**
 * Proc that adds a set of strings and ints to the audit log, tracked by the economy SS.
 *
 * * account: The bank account of the person purchasing the item.
 * * price_to_use: The cost of the purchase made for this transaction.
 * * vendor: The object or structure medium that is charging the user. For Vending machines that's the machine, for payment component that's the parent, cargo that's the crate, etc.
 */
/datum/controller/subsystem/economy/proc/track_purchase(datum/bank_account/account, price_to_use, vendor)
	if(isnull(account) || isnull(price_to_use) || isnull(vendor))
		CRASH("Track purchases was missing an argument! (Account, Price, or Vendor.)")

	audit_log += list(list(
		"account" = account.account_holder,
		"cost" = price_to_use,
		"vendor" = vendor,
	))

/*
 * Send paperwork to process to fax machines in the world.
 *
 * if there's multiple fax machines in the same area, only send a fax to the first one we find.
 * if the chosen machine is at the limit length of paperwork, don't send anything.
 * if the chosen machine has recieving paperwork disabled, don't send anything.
 *
 * Otherwise, send a random number of paper to the selected machine.
 */
/datum/controller/subsystem/economy/proc/send_fax_paperwork()
	var/list/area/processed_areas = list()
	for(var/obj/machinery/fax_machine/found_machine as anything in GLOB.fax_machines)
		/// We only send to one fax machine in an area
		var/area/area_loc = get_area(found_machine)
		if(area_loc in processed_areas)
			continue
		processed_areas += area_loc

		if(LAZYLEN(found_machine.received_paperwork) >= found_machine.max_paperwork)
			continue
		if(!found_machine.can_receive_paperwork)
			continue

		var/num_papers_added = 0
		for(var/i in 1 to rand(0, 4))
			if(LAZYLEN(found_machine.received_paperwork) >= found_machine.max_paperwork)
				continue
			num_papers_added++
			LAZYADD(found_machine.received_paperwork, generate_paperwork(found_machine))
		if(num_papers_added)
			found_machine.audible_message(span_notice("[found_machine] beeps as new paperwork becomes available to process."))
			playsound(found_machine, 'sound/machines/twobeep.ogg', 50)

/*
 * Randomly generates a processed paperwork to place in [destination_machine].
 * Spawns an [/obj/item/paper/processed] in [destination_machine]'s contents.
 *
 * return an instance of [/obj/item/paper/processed].
 */
/proc/generate_paperwork(obj/machinery/fax_machine/destination_machine)
	// Percent chance this paper will contain an error, somewhere.
	var/error_prob = prob(8)
	// Percent change that something will be redacted from the paper.
	var/redacted_prob = prob(15)
	// The 'base' subject of the paper.
	var/paper_base_subject = pick_list(PAPERWORK_FILE, "subject")
	// The month to this paper's date.
	var/rand_month = rand(1, 12)
	// A var tracking the date range we can use for randomizing dates.
	var/rand_days = 31
	switch(rand_month)
		if(4, 6, 9, 11)
			rand_days = 30
		if(2)
			rand_days = (GLOB.year_integer % 4 == 0) ? 29 : 28
	// The date the event of paper occured, randomly generated.
	var/paper_time_period = "[rand(GLOB.year_integer + 700, GLOB.year_integer + 900)]/[rand_month]/[rand(1, rand_days)]"
	// The event that happened in the paper.
	var/paper_occasion = pick_list_weighted(PAPERWORK_FILE, "occasion")
	// The contents of the paper. Will eventually not be null.
	var/paper_contents
	// The victim of the paper. This will usually be a randomly name.
	var/paper_victim
	// The species of the victim of the paper.
	var/paper_victim_species
	// The first subject of the paper, mentioned first.
	var/paper_primary_subject
	// The second subject of the paper, mentioned second or after victims.
	var/paper_secondary_subject
	// The station mentioned in the paper.
	var/paper_station
	// All the info about the paper we're tracking.
	var/list/all_tracked_data = list("time", "occasion")

	switch(paper_occasion)
		if("trial", "criminal trial", "civil trial", "court case", "criminal case", "civil case")
			paper_contents = pick_list(PAPERWORK_FILE, "contents_court_cases")

		if("execution", "re-education")
			paper_contents = pick_list_replacements(PAPERWORK_FILE, "contents_executions")

		if("patent", "intellectual property", "copyright")
			paper_contents = pick_list(PAPERWORK_FILE, "contents_patents")

		else
			paper_contents = pick_list(PAPERWORK_FILE, "contents_random")

	if(findtext(paper_contents, "subject_one"))
		paper_primary_subject = paper_base_subject
		all_tracked_data += "subject_one"
	if(findtext(paper_contents, "subject_two"))
		paper_secondary_subject = pick_list(PAPERWORK_FILE, "subject")
		if(paper_secondary_subject == paper_base_subject) // okay but what are the odds of picking the same name, threee times?
			paper_secondary_subject = pick_list(PAPERWORK_FILE, "subject")
		all_tracked_data += "subject_two"
	if(findtext(paper_contents, "victim"))
		var/list/possible_names = list(
			"human" = random_unique_name(),
			"lizard" = random_unique_lizard_name(),
			"plasmaman" = random_unique_plasmaman_name(),
			"ethereal" = random_unique_ethereal_name(),
			"moth" = random_unique_moth_name(),)
		paper_victim_species = pick(possible_names)
		paper_victim = possible_names[paper_victim_species]
		all_tracked_data += "victim"
	if(findtext(paper_contents, "station_name"))
		paper_station = prob(80) ? "[new_station_name()] Research Station" : "[syndicate_name()] Research Station"
		all_tracked_data += "station"

	if(redacted_prob)
		var/data_to_redact = pick(all_tracked_data)
		switch(data_to_redact)
			if("subject_one")
				paper_primary_subject = "\[REDACTED\]"
			if("subject_two")
				paper_secondary_subject = "\[REDACTED\]"
			if("station")
				paper_station = "\[REDACTED\]"
			if("victim")
				paper_victim = "\[REDACTED\]"
				paper_victim_species = "\[REDACTED\]"
			if("time")
				paper_time_period = "\[REDACTED\]"
			if("occasion")
				paper_occasion = "\[REDACTED\]"
		all_tracked_data -= data_to_redact

	if(error_prob)
		switch(pick(all_tracked_data))
			if("subject_one")
				paper_primary_subject = scramble_text(paper_primary_subject, rand(4, 8))
			if("subject_two")
				paper_secondary_subject = scramble_text(paper_secondary_subject, rand(4, 8))
			if("station")
				paper_station = scramble_text(paper_station, rand(3, 5))
			if("victim")
				paper_victim = scramble_text(paper_victim, rand(5, 8))
			if("time")
				paper_time_period = "[rand(GLOB.year_integer + 700, GLOB.year_integer + 900)]/[rand_month + 6]/[rand(rand_days, 1.5 * rand_days)]"
			if("occasion")
				paper_occasion = scramble_text(paper_occasion, rand(4, 8))

	if(paper_primary_subject)
		paper_contents = replacetext(paper_contents, "subject_one", paper_primary_subject)
	if(paper_secondary_subject)
		paper_contents = replacetext(paper_contents, "subject_two", paper_secondary_subject)
	if(paper_station)
		paper_contents = replacetext(paper_contents, "station_name", paper_station)
	if(paper_victim)
		paper_contents = replacetext(paper_contents, "victim", paper_victim)

	var/list/processed_paper_data = list()
	if(paper_primary_subject)
		processed_paper_data["subject_one"] = paper_primary_subject
	if(paper_secondary_subject)
		processed_paper_data["subject_two"] = paper_secondary_subject
	if(paper_victim)
		processed_paper_data["victim"] = paper_victim
		processed_paper_data["victim_species"] = paper_victim_species
	if(paper_station)
		processed_paper_data["station"] = paper_station
	processed_paper_data["time_period"] = paper_time_period
	processed_paper_data["occasion"] = paper_occasion
	processed_paper_data["redacts_present"] = redacted_prob
	processed_paper_data["errors_present"] = error_prob

	var/obj/item/paper/processed/spawned_paper = new(destination_machine)
	spawned_paper.paper_data = processed_paper_data
	spawned_paper.info = "[paper_time_period] - [paper_occasion]: [paper_contents]"
	spawned_paper.generate_requirements()
	spawned_paper.update_appearance()

	return spawned_paper
