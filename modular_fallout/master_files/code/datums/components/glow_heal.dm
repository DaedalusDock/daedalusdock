//I tried hard to make it for any living thing, but really, its better for only simple animals, sorry
//I won't remove the above comment, because I don't want to hide my previous self ideas
/datum/component/glow_heal
	//this is the var to choose what is healed over time when the parent is alive
	var/mob/living/living_targets
	//because I need this for some reason(?)
	var/mob/living/living_owner
	//this is to make sure it doesnt get ridiculous
	var/time_cooldown = 0
	//this is the cooldown time
	var/actual_cooldown = 5 SECONDS
	//perhaps someone wants to make a healing effect smaller/larger(?)
	var/heal_range = 3
	//customization
	var/revive_allowed = FALSE
	//faction healing only
	var/faction_only = null
	//allows healing of types: Brute, Burn, Toxin, Oxygen.
	var/healing_types = BRUTELOSS | FIRELOSS | TOXLOSS | OXYLOSS
	//glow colour
	var/glow_color = "#d9ff00" //I want yellow because glowing, can be overridden

/datum/component/glow_heal/Initialize(mob/living/simple_animal/chosen_targets, allow_revival = TRUE, restrict_faction = null, list/type_healing = BRUTELOSS | FIRELOSS | TOXLOSS | OXYLOSS, color_glow = null)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	living_owner = parent
	if(chosen_targets)
		living_targets = chosen_targets
	revive_allowed = allow_revival
	if(restrict_faction)
		faction_only = restrict_faction
	if(color_glow)
		glow_color = color_glow
	healing_types = type_healing
	START_PROCESSING(SSobj, src)
	RegisterSignal(living_owner, COMSIG_LIVING_REVIVE, .proc/restart_process)

/datum/component/glow_heal/proc/restart_process()
	START_PROCESSING(SSobj, src)

/datum/component/glow_heal/process()
	if(living_owner.stat == DEAD)
		STOP_PROCESSING(SSobj, src)
		return //cmon, only living things are allowed use this process
	if(!living_targets)
		return //we don't need to go on cooldown if we have no targets, so keep checking
	if(time_cooldown > world.time)
		return //honestly need a cooldown on the healing, it could make combat really hard against a horde of ghouls
	time_cooldown = world.time + actual_cooldown
	for(var/mob/living/livingMob in range(heal_range, living_owner))
		if(!istype(livingMob, living_targets))
			continue
		if(faction_only && !(faction_only in livingMob.faction))
			continue //if you don't have the faction listed in the intial, then you aren't getting targeted
		if(livingMob.stat == DEAD)
			if(revive_allowed)
				livingMob.revive(full_heal = TRUE)
			return //dont waste cpu on dead mobs that cant be revived
		if(healing_types && BRUTELOSS)
			livingMob.adjustBruteLoss(-livingMob.maxHealth*0.1)
		if(healing_types && FIRELOSS)
			livingMob.adjustFireLoss(-livingMob.maxHealth*0.1)
		if(healing_types && TOXLOSS)
			livingMob.adjustToxLoss(-livingMob.maxHealth*0.1)
		if(healing_types && OXYLOSS)
			livingMob.adjustOxyLoss(-livingMob.maxHealth*0.1)
		var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal(get_turf(livingMob)) //shameless copy from blobbernaut
		H.color = glow_color
