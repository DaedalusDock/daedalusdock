
//jobs from ss13 but DEAD.

/obj/effect/mob_spawn/corpse/human/cargo_tech
	name = "Cargo Tech"
	outfit = /datum/outfit/job/cargo_tech
	icon_state = "corpsecargotech"

/obj/effect/mob_spawn/corpse/human/cook
	name = "Cook"
	outfit = /datum/outfit/job/cook
	icon_state = "corpsecook"

/obj/effect/mob_spawn/corpse/human/doctor
	name = "Doctor"
	outfit = /datum/outfit/job/doctor
	icon_state = "corpsedoctor"

/obj/effect/mob_spawn/corpse/human/engineer
	name = "Engineer"
	outfit = /datum/outfit/job/engineer
	icon_state = "corpseengineer"

/obj/effect/mob_spawn/corpse/human/engineer/mod
	outfit = /datum/outfit/job/engineer/mod

/obj/effect/mob_spawn/corpse/human/clown
	name = JOB_CLOWN
	outfit = /datum/outfit/job/clown
	icon_state = "corpseclown"

/obj/effect/mob_spawn/corpse/human/miner
	name = JOB_PROSPECTOR
	outfit = /datum/outfit/job/miner
	icon_state = "corpseminer"

/obj/effect/mob_spawn/corpse/human/miner/mod
	outfit = /datum/outfit/job/miner/equipped/mod

/obj/effect/mob_spawn/corpse/human/miner/explorer
	outfit = /datum/outfit/job/miner/equipped

/obj/effect/mob_spawn/corpse/human/assistant
	name = JOB_ASSISTANT
	outfit = /datum/outfit/job/assistant
	icon_state = "corpsegreytider"

/obj/effect/mob_spawn/corpse/human/assistant/beesease_infection/special(mob/living/spawned_mob)
	. = ..()
	spawned_mob.try_contract_pathogen(new /datum/pathogen/beesease)

/obj/effect/mob_spawn/corpse/human/assistant/brainrot_infection/special(mob/living/spawned_mob)
	. = ..()
	spawned_mob.try_contract_pathogen(new /datum/pathogen/brainrot)

/obj/effect/mob_spawn/corpse/human/assistant/spanishflu_infection/special(mob/living/spawned_mob)
	. = ..()
	spawned_mob.try_contract_pathogen(new /datum/pathogen/fluspanish)
