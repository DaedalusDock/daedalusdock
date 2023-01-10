#define RANSOM_LOWER 25
#define RANSOM_UPPER 75
#define CONTRACTOR_RANSOM_CUT 0.35

/datum/syndicate_contract
	/// Unique ID tied to the contract
	var/id = 0
	/// If the contract is the contractor's current one
	var/status = CONTRACT_STATUS_INACTIVE
	/// Reference to the objective datum
	var/datum/objective/contract/contract = new()
	/// Target's job
	var/target_rank
	/// A number in multiples of 100, anywhere from 2500 credits to 7500, station cost when someone is kidnapped
	var/ransom = 0
	/// TC payout size, will be small, medium, or large.
	var/payout_type
	/// Mad-libs style wanted message, just flavor.
	var/wanted_message
	/// List of the items the victim had on them prior to kidnapping.
	var/list/victim_belongings = list()

/datum/syndicate_contract/New(contract_owner, blacklist, type = CONTRACT_PAYOUT_SMALL)
	contract.owner = contract_owner
	payout_type = type

	generate(blacklist)

/// Generation of the contract, called on New()
/datum/syndicate_contract/proc/generate(blacklist)
	contract.find_target(null, blacklist)

	var/datum/data/record/record
	if (contract.target)
		record = find_record("name", contract.target.name, GLOB.data_core.general)

	if (record)
		target_rank = record.fields["rank"]
	else
		target_rank = "Unknown"

	if (payout_type == CONTRACT_PAYOUT_LARGE)
		contract.payout_bonus = rand(9,13)
	else if (payout_type == CONTRACT_PAYOUT_MEDIUM)
		contract.payout_bonus = rand(6,8)
	else
		contract.payout_bonus = rand(2,4)

	contract.payout = rand(1, 2)
	contract.generate_dropoff()

	ransom = 100 * rand(RANSOM_LOWER, RANSOM_UPPER)

	var/base = pick_list(WANTED_FILE, "basemessage")
	var/verb_string = pick_list(WANTED_FILE, "verb")
	var/noun = pick_list_weighted(WANTED_FILE, "noun")
	var/location = pick_list_weighted(WANTED_FILE, "location")
	wanted_message = "[base] [verb_string] [noun] [location]."

/// Handler to find a valid turn and launch victim collector
/datum/syndicate_contract/proc/handle_extraction(mob/living/user)
	if(!(contract.target && contract.dropoff_check(user, contract.target.current)))
		return FALSE

	var/turf/free_location = find_obstruction_free_location(3, user, contract.dropoff)

	if(!free_location)
		return FALSE

	launch_extraction_pod(free_location)
	return TRUE


/// Launch the pod to collect our victim.
/datum/syndicate_contract/proc/launch_extraction_pod(turf/empty_pod_turf)
	var/obj/structure/closet/supplypod/extractionpod/empty_pod = new()
	empty_pod.contract_hub = GLOB.contractors[contract.owner]
	empty_pod.tied_contract = src
	empty_pod.recieving = TRUE

	RegisterSignal(empty_pod, COMSIG_ATOM_ENTERED, .proc/enter_check)

	empty_pod.stay_after_drop = TRUE
	empty_pod.reversing = TRUE
	empty_pod.explosionSize = list(0,0,0,1)
	empty_pod.leavingSound = 'sound/effects/podwoosh.ogg'

	new /obj/effect/pod_landingzone(empty_pod_turf, empty_pod)

/datum/syndicate_contract/proc/enter_check(datum/source, mob/living/sent_mob)
	SIGNAL_HANDLER
	if(!istype(source, /obj/structure/closet/supplypod/extractionpod))
		return
	if(!istype(sent_mob))
		return
	var/datum/contractor_hub/the_hub = GLOB.contractors[contract.owner]
	if(!the_hub)
		return
	if (sent_mob == contract.target.current)
		the_hub.contract_TC_to_redeem += contract.payout
		the_hub.contracts_completed += 1

		if (sent_mob.stat != DEAD)
			the_hub.contract_TC_to_redeem += contract.payout_bonus

		status = CONTRACT_STATUS_COMPLETE

		the_hub.contract_rep += 2
	else
		status = CONTRACT_STATUS_ABORTED // Sending a sent_mob that wasn't even yours is as good as just aborting it

	if(the_hub.current_contract == src)
		the_hub.current_contract = null

	if(ishuman(sent_mob))
		var/mob/living/carbon/human/sent_mob_human = sent_mob
		for(var/obj/item/sent_mob_item in sent_mob_human)
			if(sent_mob_item == sent_mob_human.w_uniform)
				continue //So all they're left with are shoes and uniform.
			if(sent_mob_item == sent_mob_human.shoes)
				continue

			sent_mob_human.transferItemToLoc(sent_mob_item)
			victim_belongings.Add(sent_mob_item)
		// After we remove items, at least give them what they need to live.
		sent_mob_human.dna.species.give_important_for_life(sent_mob_human)

	var/obj/structure/closet/supplypod/extractionpod/pod = source
	pod.recieving = FALSE

	// Handle the pod returning
	pod.startExitSequence(pod)

	// After pod is sent we start the victim narrative/heal.
	INVOKE_ASYNC(src, .proc/handle_victim_experience, sent_mob)

	// This is slightly delayed because of the sleep calls above to handle the narrative.
	// We don't want to tell the station instantly.
	var/points_to_check
	var/datum/bank_account/bank = SSeconomy.department_accounts_by_id[ACCOUNT_CAR]
	if(bank)
		points_to_check = bank.account_balance
	if(points_to_check >= ransom)
		bank.adjust_money(-ransom)
	else
		bank.adjust_money(-points_to_check)

	priority_announce("One of your crew was captured by a rival organisation - we've needed to pay their ransom to bring them back. \
					As is policy we've taken a portion of the station's funds to offset the overall cost.", "Daedalus Industries Asset Protection", sound_type = ANNOUNCER_CENTCOM)

	addtimer(CALLBACK(src, .proc/finish_enter), 3 SECONDS)

/// Called when person is finished shoving in, awards ransom money
/datum/syndicate_contract/proc/finish_enter()
	// Pay contractor their portion of ransom
	if(!(status == CONTRACT_STATUS_COMPLETE))
		return
	var/obj/item/card/id/owner_id = contract.owner.current?.get_idcard(TRUE)

	if(owner_id?.registered_account)
		owner_id.registered_account.adjust_money(ransom * CONTRACTOR_RANSOM_CUT)

		owner_id.registered_account.bank_card_talk("We've processed the ransom, agent. Here's your cut - your balance is now \
		[owner_id.registered_account.account_balance] credits.", TRUE)

/// They're off to holding - handle the return timer and give some text about what's going on.
/datum/syndicate_contract/proc/handle_victim_experience(mob/living/target)
	// Ship 'em back - dead or alive, 4 minutes wait.
	// Even if they weren't the target, we're still treating them the same.
	addtimer(CALLBACK(src, .proc/return_victim, target), 4 MINUTES)

	if (target.stat == DEAD)
		return
	// Heal them up - gets them out of crit/soft crit. If omnizine is removed in the future, this needs to be replaced with a
	// method of healing them, consequence free, to a reasonable amount of health.
	target.reagents.add_reagent(/datum/reagent/medicine/omnizine, 20)
	victim_stage_one(target)

/datum/syndicate_contract/proc/victim_stage_one(mob/living/target)
	target.flash_act()
	target.adjust_timed_status_effect(10 SECONDS, /datum/status_effect/confusion)
	target.blur_eyes(5)
	to_chat(target, span_warning("You feel strange..."))
	addtimer(CALLBACK(src, .proc/victim_stage_two, target), 6 SECONDS)

/datum/syndicate_contract/proc/victim_stage_two(mob/living/target)
	to_chat(target, span_warning("That pod did something to you..."))
	target.adjust_timed_status_effect(10 SECONDS, /datum/status_effect/dizziness)
	addtimer(CALLBACK(src, .proc/victim_stage_three, target), 6 SECONDS)

/datum/syndicate_contract/proc/victim_stage_three(mob/living/target)
	to_chat(target, span_warning("Your head pounds... It feels like it's going to burst out your skull!"))
	target.flash_act()
	target.adjust_timed_status_effect(20 SECONDS, /datum/status_effect/confusion)
	target.blur_eyes(3)
	addtimer(CALLBACK(src, .proc/victim_stage_four, target), 3 SECONDS)

/datum/syndicate_contract/proc/victim_stage_four(mob/living/target)
	to_chat(target, span_warning("Your head pounds..."))
	addtimer(CALLBACK(src, .proc/victim_stage_five, target), 10 SECONDS)

/datum/syndicate_contract/proc/victim_stage_five(mob/living/target)
	target.flash_act()
	target.Unconscious(200)
	to_chat(target, span_hypnophrase(span_reallybig("A million voices echo in your head... <i>\"Your mind held many valuable secrets - \
				we thank you for providing them. Your value is expended, and you will be ransomed back to your station. We always get paid, \
				so it's only a matter of time before we ship you back...\"</i>")))
	target.blur_eyes(10)
	target.adjust_timed_status_effect(3 SECONDS, /datum/status_effect/dizziness)
	target.adjust_timed_status_effect(20 SECONDS, /datum/status_effect/confusion)

/// We're returning the victim
/datum/syndicate_contract/proc/return_victim(mob/living/carbon/target)
	var/list/possible_drop_loc = list()

	for(var/turf/possible_drop in contract.dropoff.contents)
		if(is_safe_turf(possible_drop))
			possible_drop_loc += possible_drop

	if (length(possible_drop_loc))
		var/pod_rand_loc = rand(1, length(possible_drop_loc))

		var/obj/structure/closet/supplypod/return_pod = new()
		return_pod.bluespace = TRUE
		return_pod.explosionSize = list(0,0,0,0)
		return_pod.style = STYLE_SYNDICATE

		do_sparks(8, FALSE, target)
		target.visible_message(span_notice("[target] vanishes..."))
		if(ishuman(target))
			var/mob/living/carbon/human/human_target = target
			for(var/obj/item/target_item as anything in target.get_all_worn_items())
				if(target_item == human_target.w_uniform)
					continue //So all they're left with are shoes and uniform.
				if(target_item == human_target.shoes)
					continue
				target.dropItemToGround(target_item)

		for(var/obj/item/target_item as anything in victim_belongings)
			target_item.forceMove(return_pod)

		target.forceMove(return_pod)

		target.flash_act()
		target.blur_eyes(30)
		target.adjust_timed_status_effect(7 SECONDS, /datum/status_effect/dizziness)
		target.adjust_timed_status_effect(20 SECONDS, /datum/status_effect/confusion)

		new /obj/effect/pod_landingzone(possible_drop_loc[pod_rand_loc], return_pod)
	else
		to_chat(target, span_hypnophrase(span_reallybig("A million voices echo in your head... <i>\"Seems where you got sent here from won't \
					be able to handle our pod... You will die here instead.\"</i>")))
		target.death()

#undef RANSOM_LOWER
#undef RANSOM_UPPER
#undef CONTRACTOR_RANSOM_CUT
