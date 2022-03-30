#define LOWEST_TC 30

/datum/contractor_hub
	var/contract_rep = 0
	var/list/hub_items = list()
	var/list/purchased_items = list()
	var/static/list/contractor_items = typecacheof(/datum/contractor_item/, ignore_root_path = TRUE)

	var/datum/syndicate_contract/current_contract
	var/list/datum/syndicate_contract/assigned_contracts = list()

	var/list/assigned_targets = list() // used as a blacklist to make sure we're not assigning targets already assigned

	var/contracts_completed = 0
	var/contract_TC_payed_out = 0 // Keeping track for roundend reporting
	var/contract_TC_to_redeem = 0 // Used internally and roundend reporting - what TC we have available to cashout.

/// Generates a list of all valid hub items to set for purchase
/datum/contractor_hub/proc/create_hub_items()
	for(var/path in contractor_items)
		var/datum/contractor_item/contractor_item = new path

		hub_items.Add(contractor_item)

/// Create initial list of contracts
/datum/contractor_hub/proc/create_contracts(datum/mind/owner)

	// 6 initial contracts
	var/list/to_generate = list(
		CONTRACT_PAYOUT_LARGE,
		CONTRACT_PAYOUT_MEDIUM,
		CONTRACT_PAYOUT_MEDIUM,
		CONTRACT_PAYOUT_SMALL,
		CONTRACT_PAYOUT_SMALL,
		CONTRACT_PAYOUT_SMALL
	)

	//What the fuck
	if(length(to_generate) > length(GLOB.data_core.locked))
		to_generate.Cut(1, length(GLOB.data_core.locked))

	var/total = 0
	var/lowest_paying_sum = 0
	var/datum/syndicate_contract/lowest_paying_contract

	// Randomise order, so we don't have contracts always in payout order.
	to_generate = shuffle(to_generate)

	// Support contract generation happening multiple times
	var/start_index = 1
	if (length(assigned_contracts))
		start_index = length(assigned_contracts) + 1

	// Generate contracts, and find the lowest paying.
	for(var/contract_gen in 1 to length(to_generate))
		var/datum/syndicate_contract/contract_to_add = new(owner, assigned_targets, to_generate[contract_gen])
		var/contract_payout_total = contract_to_add.contract.payout + contract_to_add.contract.payout_bonus

		assigned_targets.Add(contract_to_add.contract.target)

		if (!lowest_paying_contract || (contract_payout_total < lowest_paying_sum))
			lowest_paying_sum = contract_payout_total
			lowest_paying_contract = contract_to_add

		total += contract_payout_total
		contract_to_add.id = start_index
		assigned_contracts.Add(contract_to_add)

		start_index++

	// If the threshold for TC payouts isn't reached, boost the lowest paying contract
	if (total < LOWEST_TC)
		lowest_paying_contract.contract.payout_bonus += (LOWEST_TC - total)

#undef LOWEST_TC
