// For modularity, we hook into the update_explanation_text to be sure we have a target to register.
/datum/objective/assassinate/update_explanation_text()
	RegisterSignal(target, COMSIG_LIVING_DEATH, PROC_REF(register_target_death))
	return ..()
/datum/objective/assassinate/proc/register_target_death(mob/living/dead_guy, gibbed)
	SIGNAL_HANDLER
	completed = TRUE
	UnregisterSignal(dead_guy, COMSIG_LIVING_DEATH)

/datum/objective/download
	name = "download"
	var/datum/design/target_design

/datum/objective/download/New(text)
	. = ..()
	var/list/designs = SStech.designs.Copy()
	while(!target_design)
		var/datum/design/D = pick_n_take(designs)
		if(D.mapload_design_flags & (DESIGN_FAB_ENGINEERING|DESIGN_FAB_MEDICAL|DESIGN_FAB_ROBOTICS|DESIGN_FAB_SECURITY|DESIGN_FAB_SERVICE|DESIGN_FAB_SUPPLY))
			target_design = D

/datum/objective/download/update_explanation_text()
	..()
	explanation_text = "Obtain a design for [target_design.name]."

/datum/objective/download/check_completion()
	var/obj/item/disk/design_disk/dat_fukken_disk = new(null)

	var/list/datum/mind/owners = get_owners()
	for(var/datum/mind/owner in owners)
		if(ismob(owner.current))
			var/mob/mob_owner = owner.current //Yeah if you get morphed and you eat a quantum tech disk with the RD's latest backup good on you soldier.
			if(ishuman(mob_owner))
				var/mob/living/carbon/human/human_downloader = mob_owner
				if(human_downloader && (human_downloader.stat != DEAD) && istype(human_downloader.wear_suit, /obj/item/clothing/suit/space/space_ninja))
					var/obj/item/clothing/suit/space/space_ninja/ninja_suit = human_downloader.wear_suit
					dat_fukken_disk.add_design_list(ninja_suit.stored_designs)

			var/list/otherwise = mob_owner.get_contents()
			for(var/obj/item/disk/design_disk/dat_fukken_disk in otherwise)
				dat_fukken_disk.add_design_list(checking.stored_research)

	return locate(target_design) in dat_fukken_disk.stored_designs

/datum/objective/download/admin_edit(mob/admin)
	var/count = input(admin,"How many nodes ?","Nodes",target_amount) as num|null
	if(count)
		target_amount = count
	update_explanation_text()
