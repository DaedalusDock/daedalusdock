#define LOWEST_TC 30

GLOBAL_LIST_EMPTY(contractors)
/datum/contractor_hub
	/// How much reputation the contractor has
	var/contract_rep = 0
	/// What contractor items can be purchased
	var/list/hub_items = list()
	/// List of what the contractor's purchased
	var/list/purchased_items = list()
	/// Static of contractor_item subtypes
	var/static/list/contractor_items = typecacheof(/datum/contractor_item, ignore_root_path = TRUE)
	/// Reference to the current contract datum
	var/datum/syndicate_contract/current_contract
	/// List of all contract datums the contractor has available
	var/list/datum/syndicate_contract/assigned_contracts = list()
	/// Used as a blacklist to make sure we're not assigning targets already assigned
	var/list/assigned_targets = list()
	/// Number of how many contracts you've done
	var/contracts_completed = 0
	/// How many TC you've paid out in contracts
	var/contract_paid_out = 0
	/// Amount of TC that has yet to be redeemed
	var/contract_TC_to_redeem = 0
	/// Current index number for contract IDs
	var/start_index = 1

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
	if (total < LOWEST_TC && lowest_paying_contract)
		lowest_paying_contract.contract.payout_bonus += (LOWEST_TC - total)

/// End-round generation proc for contractors
/datum/contractor_hub/proc/contractor_round_end()
	var/result = ""
	var/total_spent_rep = 0

	var/contractor_item_icons = "" // Icons of purchases
	var/contractor_support_unit = "" // Set if they had a support unit - and shows appended to their contracts completed

	// Get all the icons/total cost for all our items bought
	for (var/datum/contractor_item/contractor_purchase in purchased_items)
		contractor_item_icons += "<span class='tooltip_container'>\[ <i class=\"fas [contractor_purchase.item_icon]\"></i><span class='tooltip_hover'><b>[contractor_purchase.name] - [contractor_purchase.cost] Rep</b><br><br>[contractor_purchase.desc]</span> \]</span>"

		total_spent_rep += contractor_purchase.cost

		// Special case for reinforcements, we want to show their ckey and name on round end.
		if (istype(contractor_purchase, /datum/contractor_item/contractor_partner))
			var/datum/contractor_item/contractor_partner/partner = contractor_purchase
			contractor_support_unit += "<br><b>[partner.partner_mind.key]</b> played <b>[partner.partner_mind.current.name]</b>, their contractor support unit."

	if (length(purchased_items))
		result += "<br>(used [total_spent_rep] Rep) "
		result += contractor_item_icons
	result += "<br>"
	if (contracts_completed > 0)
		var/plural_check = "contract[contracts_completed > 1 ? "s" : ""]"

		result += "Completed [span_greentext("[contracts_completed]")] [plural_check] for a total of \
					[span_greentext("[contract_paid_out + contract_TC_to_redeem] TC")]![contractor_support_unit]<br>"

	return result

#undef LOWEST_TC
