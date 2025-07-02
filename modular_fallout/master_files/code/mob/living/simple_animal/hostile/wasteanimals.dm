/mob/living/simple_animal/hostile/cazador
	name = "cazador"
	desc = "A mutated insect known for its fast move_to_delay, deadly sting, and being huge bastards."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/wastemobs.dmi'
	icon_state = "cazador"
	icon_living = "cazador"
	icon_dead = "cazador_dead1"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_chance = 0
	turns_per_move = 5
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/cazador_meat = 2, /obj/item/stack/sheet/sinew = 2, /obj/item/stack/sheet/animalhide/chitin = 2)
	butcher_results = list(/obj/item/food/meat/slab/cazador_meat = 1, /obj/item/stack/sheet/animalhide/chitin = 1)
	butcher_difficulty = 1.5
	response_help_simple = "pets"
	response_disarm_simple = "gently pushes aside"
	response_harm_simple = "hits"
	emote_taunt = list("buzzes")
	emote_taunt_sound = list('modular_fallout/master_files/sound/mobs/cazador/cazador_alert.ogg')
	aggrosound = list('modular_fallout/master_files/sound/mobs/cazador/cazador_charge1.ogg', 'modular_fallout/master_files/sound/mobs/cazador/cazador_charge2.ogg', 'modular_fallout/master_files/sound/mobs/cazador/cazador_charge3.ogg')
	idlesound = list('modular_fallout/master_files/sound/creatures/cazador_buzz.ogg')
	stat_attack = UNCONSCIOUS
	robust_searching = 1
	taunt_chance = 30
	move_to_delay = -0.5
	maxHealth = 40
	health = 40
	harm_intent_damage = 8
	obj_damage = 20
	melee_damage_lower = 20
	melee_damage_upper = 20
	attack_verb_simple = "stings"
	attack_sound = 'modular_fallout/master_files/sound/creatures/cazador_attack.ogg'
	speak_emote = list("buzzes")
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	faction = list("hostile", "cazador")
	movement_type = FLYING
	gold_core_spawnable = HOSTILE_SPAWN
	death_sound = 'modular_fallout/master_files/sound/mobs/cazador/cazador_death.ogg'
	blood_volume = 0
	decompose = FALSE

/mob/living/simple_animal/hostile/cazador/playable
	emote_taunt_sound = null
	emote_taunt = null
	aggrosound = null
	idlesound = null
	see_in_dark = 8
	wander = 0
	anchored = FALSE

/mob/living/simple_animal/hostile/cazador/AttackingTarget()
	. = ..()
	if(. && ishuman(target))
		var/mob/living/carbon/human/H = target
		H.reagents.add_reagent(/datum/reagent/toxin/cazador_venom, 5)

/mob/living/simple_animal/hostile/cazador/death(gibbed)
	icon_dead = "cazador_dead[rand(1,5)]"
	. = ..()

/mob/living/simple_animal/hostile/cazador/bullet_act(obj/projectile/Proj)
	if(!Proj)
		return
	if(prob(50))
		return ..()
	else
		visible_message("<span class='danger'>[src] dodges [Proj]!</span>")
		return 0

/mob/living/simple_animal/hostile/cazador/young
	name = "young cazador"
	desc = "A mutated insect known for its fast move_to_delay, deadly sting, and being huge bastards. This one's little."
	maxHealth = 40
	health = 40
	move_to_delay = 1
	melee_damage_lower = 5
	melee_damage_upper = 10
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/cazador_meat = 1, /obj/item/stack/sheet/animalhide/chitin = 1, /obj/item/stack/sheet/sinew = 1)
	butcher_results = list(/obj/item/food/meat/slab/cazador_meat = 1, /obj/item/stack/sheet/animalhide/chitin = 1)
	butcher_difficulty = 1.5
/mob/living/simple_animal/hostile/cazador/young/playable
	emote_taunt_sound = null
	emote_taunt = null
	aggrosound = null
	idlesound = null
	see_in_dark = 8
	wander = 0
	anchored = FALSE
	health = 150
	maxHealth = 150
	melee_damage_lower = 15
	melee_damage_upper = 25
	move_to_delay = 0


/mob/living/simple_animal/hostile/cazador/young/Initialize()
	. = ..()
	update_transform(0.75)

/datum/reagent/toxin/cazador_venom
	name = "Cazador venom"
	description = "A potent toxin resulting from cazador stings that quickly kills if too much remains in the body."
	color = "#801E28" // rgb: 128, 30, 40
	toxpwr = 1
	taste_description = "pain"
	taste_mult = 1.3

/datum/reagent/toxin/cazador_venom/on_mob_life(mob/living/M)
	if(volume >= 15)
		M.adjustToxLoss(5, 0)
	..()

/mob/living/simple_animal/hostile/radscorpion
	name = "giant radscorpion"
	desc = "A mutated arthropod with an armored carapace and a powerful sting."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/wastemobs.dmi'
	icon_state = "radscorpion"
	icon_living = "radscorpion"
	icon_dead = "radscorpion_dead"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_chance = 0
	turns_per_move = 5
	guaranteed_butcher_results  = list(/obj/item/food/meat/slab/radscorpion_meat = 2)
	butcher_results = list(/obj/item/stack/sheet/animalhide/chitin = 2)
	butcher_difficulty = 1.5
	response_help_simple = "pets"
	response_disarm_simple = "gently pushes aside"
	response_harm_simple = "hits"

	taunt_chance = 30
	move_to_delay = 1.25
	maxHealth = 150
	health = 150
	harm_intent_damage = 8
	obj_damage = 20
	melee_damage_lower = 35
	melee_damage_upper = 35
	attack_verb_simple = "stings"
	attack_sound = 'modular_fallout/master_files/sound/creatures/radscorpion_attack.ogg'
	speak_emote = list("hisses")
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	faction = list("hostile", "radscorpion")
	gold_core_spawnable = HOSTILE_SPAWN
	var/scorpion_color = "radscorpion" //holder for icon set
	var/list/icon_sets = list("radscorpion", "radscorpion_blue", "radscorpion_black")
	blood_volume = 0
	emote_taunt = list("snips")
	emote_taunt_sound = list('modular_fallout/master_files/sound/mobs/scorpion/taunt1.ogg', 'modular_fallout/master_files/sound/mobs/scorpion/taunt2.ogg', 'modular_fallout/master_files/sound/mobs/scorpion/taunt3.ogg')

	aggrosound = list('modular_fallout/master_files/sound/mobs/scorpion/aggro.ogg', )
	idlesound = list('modular_fallout/master_files/sound/creatures/radscorpion_snip.ogg', )

	death_sound = 'modular_fallout/master_files/sound/mobs/scorpion/death.ogg'

/mob/living/simple_animal/hostile/gecko
	name = "gecko"
	desc = "A large mutated reptile with sharp teeth."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/wastemobs.dmi'
	icon_state = "gekkon"
	icon_living = "gekkon"
	icon_dead = "gekkon_dead"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_chance = 0
	turns_per_move = 5
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/gecko = 2, /obj/item/stack/sheet/animalhide/gecko = 1)
	butcher_results = list(/obj/item/stack/sheet/bone = 1)
	butcher_difficulty = 1
	response_help_simple = "pets"
	response_disarm_simple = "gently pushes aside"
	response_harm_simple = "hits"
	taunt_chance = 30
	move_to_delay = 1
	maxHealth = 40
	health = 40
	harm_intent_damage = 8
	obj_damage = 20
	melee_damage_lower = 10
	melee_damage_upper = 15
	attack_verb_simple = "claws"
	speak_emote = list("hisses")
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	faction = list("gecko")
	gold_core_spawnable = HOSTILE_SPAWN

	emote_taunt = list("screeches")
	emote_taunt_sound = list('modular_fallout/master_files/sound/mobs/gecko/gecko_charge1.ogg', 'modular_fallout/master_files/sound/mobs/gecko/gecko_charge2.ogg', 'modular_fallout/master_files/sound/mobs/gecko/gecko_charge3.ogg',)
	aggrosound = list('modular_fallout/master_files/sound/mobs/gecko/gecko_alert.ogg', )
	death_sound = 'modular_fallout/master_files/sound/mobs/gecko/gecko_death.ogg'

/mob/living/simple_animal/hostile/gecko/playable
	health = 200
	maxHealth = 200
	move_to_delay = 0
	emote_taunt_sound = null
	emote_taunt = null
	aggrosound = null
	idlesound = null
	see_in_dark = 8
	wander = 0
	anchored = FALSE
	melee_damage_lower = 20
	melee_damage_upper = 45

/mob/living/simple_animal/hostile/radroach
	name = "radroach"
	desc = "A large mutated insect that finds its way everywhere."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/wastemobs.dmi'
	icon_state = "radroach"
	icon_living = "radroach"
	icon_dead = "radroach_dead"
	icon_gib = "radroach_gib"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_chance = 0
	turns_per_move = 5
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/radroach_meat = 2, /obj/item/stack/sheet/sinew = 1)
	butcher_results = list(/obj/item/stack/sheet/animalhide/chitin = 1)
	butcher_difficulty = 1.5
	response_help_simple = "pets"
	response_disarm_simple = "gently pushes aside"
	response_harm_simple = "hits"

	move_to_delay = 1
	maxHealth = 40
	health = 40
	harm_intent_damage = 8
	obj_damage = 20
	melee_damage_lower = 10
	melee_damage_upper = 10
	attack_verb_simple = "nips"
	attack_sound = 'modular_fallout/master_files/sound/creatures/radroach_attack.ogg'
	speak_emote = list("skitters")
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	faction = list("gecko")
	gold_core_spawnable = HOSTILE_SPAWN

	aggrosound = list('modular_fallout/master_files/sound/creatures/radroach_chitter.ogg',)
	idlesound = list('modular_fallout/master_files/sound/mobs/roach/idle1.ogg', 'modular_fallout/master_files/sound/mobs/roach/idle2.ogg', 'modular_fallout/master_files/sound/mobs/roach/idle3.ogg',)
	death_sound = 'modular_fallout/master_files/sound/mobs/roach/roach_death.ogg'

/mob/living/simple_animal/hostile/giantant
	name = "fireant"
	desc = "A large mutated insect that finds its way everywhere."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/wastemobs.dmi'
	icon_state = "GiantAnt"
	icon_living = "GiantAnt"
	icon_dead = "GiantAnt_dead"
	icon_gib = "GiantAnt_gib"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_chance = 0
	turns_per_move = 5
	guaranteed_butcher_results = list(/obj/item/stack/sheet/sinew = 1, /obj/item/food/meat/slab/ant_meat = 2)
	butcher_results = list(/obj/item/stack/sheet/animalhide/chitin = 1)
	butcher_difficulty = 1.5
	response_help_simple = "pets"
	response_disarm_simple = "gently pushes aside"
	response_harm_simple = "hits"
	emote_taunt = list("chitters")
	emote_taunt_sound = 'modular_fallout/master_files/sound/creatures/radroach_chitter.ogg'
	taunt_chance = 30
	move_to_delay = 1
	maxHealth = 160
	health = 160
	harm_intent_damage = 8
	obj_damage = 20
	melee_damage_lower = 20
	melee_damage_upper = 20
	attack_verb_simple = "stings"
	attack_sound = 'modular_fallout/master_files/sound/creatures/radroach_attack.ogg'
	speak_emote = list("skitters")
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	faction = list("ant")
	gold_core_spawnable = HOSTILE_SPAWN
	decompose = TRUE
	blood_volume = 0

/mob/living/simple_animal/hostile/giantant/Initialize()
	. = ..()

/mob/living/simple_animal/hostile/giantant/Aggro()
	..()
	summon_backup(10)

/mob/living/simple_animal/hostile/fireant
	name = "fireant"
	desc = "A large mutated insect that finds its way everywhere."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/wastemobs.dmi'
	icon_state = "FireAnt"
	icon_living = "FireAnt"
	icon_dead = "FireAnt_dead"
	icon_gib = "FireAnt_gib"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_chance = 0
	turns_per_move = 5
	guaranteed_butcher_results = list(/obj/item/stack/sheet/sinew = 1, /obj/item/food/meat/slab/fireant_meat = 2, /obj/item/food/rawantbrain = 1)
	butcher_results = list(/obj/item/stack/sheet/animalhide/chitin = 2)
	butcher_difficulty = 1.5
	response_help_simple = "pets"
	response_disarm_simple = "gently pushes aside"
	response_harm_simple = "hits"
	emote_taunt = list("chitters")
	emote_taunt_sound = 'modular_fallout/master_files/sound/creatures/radroach_chitter.ogg'
	taunt_chance = 30
	move_to_delay = 1
	maxHealth = 140
	health = 140
	harm_intent_damage = 8
	obj_damage = 20
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_simple = "stings"
	attack_sound = 'modular_fallout/master_files/sound/creatures/radroach_attack.ogg'
	speak_emote = list("skitters")
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	faction = list("ant")
	gold_core_spawnable = HOSTILE_SPAWN
	decompose = TRUE
	blood_volume = 0

/mob/living/simple_animal/hostile/fireant/Initialize()
	. = ..()

/mob/living/simple_animal/hostile/fireant/Aggro()
	..()
	summon_backup(10)

/mob/living/simple_animal/hostile/fireant/AttackingTarget()
	. = ..()
	if(. && ishuman(target))
		var/mob/living/carbon/human/H = target
		H.reagents.add_reagent(/datum/reagent/napalm, 0.1)

// ANT QUEEN
/mob/living/simple_animal/hostile/giantantqueen
	name = "giant ant queen"
	desc = "The queen of a giant ant colony. Butchering it seems like a good way to a pretty penny."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/wastemobslong.dmi'
	icon_state = "antqueen"
	icon_living = "antqueen"
	icon_dead = "antqueen_dead"
	icon_gib = "GiantAnt_gib"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_chance = 0
	turns_per_move = 5
	guaranteed_butcher_results = list(/obj/item/stack/sheet/sinew = 3, /obj/item/food/meat/slab/ant_meat = 6, /obj/item/stack/sheet/animalhide/chitin = 6, /obj/item/food/rawantbrain = 1, /obj/item/stack/sheet/animalhide/chitin = 5)
	butcher_results = list(/obj/item/stack/sheet/animalhide/chitin = 6, /obj/item/food/meat/slab/ant_meat = 3)
	butcher_difficulty = 1.5
	loot = list(/obj/item/food/f13/giantantegg = 10)
	response_help_simple = "pets"
	response_disarm_simple = "gently pushes aside"
	response_harm_simple = "hits"
	emote_taunt = list("chitters")
	emote_taunt_sound = 'modular_fallout/master_files/sound/creatures/radroach_chitter.ogg'
	taunt_chance = 30
	move_to_delay = 5
	maxHealth = 560
	health = 560
	stat_attack = UNCONSCIOUS
	ranged = 1
	harm_intent_damage = 8
	obj_damage = 20
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_simple = "stings"
	attack_sound = 'modular_fallout/master_files/sound/creatures/radroach_attack.ogg'
	projectiletype = /obj/projectile/bile
	projectilesound = 'modular_fallout/master_files/sound/mobs/centaur/spit.ogg'
	extra_projectiles = 2
	speak_emote = list("skitters")
	retreat_distance = 5
	minimum_distance = 7
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	faction = list("ant")
	gold_core_spawnable = HOSTILE_SPAWN
	decompose = FALSE
	var/max_mobs = 2
	var/mob_types = list(/mob/living/simple_animal/hostile/giantant)
	var/spawn_time = 30 SECONDS
	var/spawn_text = "hatches from"
	blood_volume = 0


/mob/living/simple_animal/hostile/giantantqueen/Initialize()
	. = ..()
	AddComponent(/datum/component/spawner, mob_types, spawn_time, faction, spawn_text, max_mobs, _range = 7)

/mob/living/simple_animal/hostile/giantantqueen/death()
	RemoveComponentFrom(/datum/component/spawner)
	. = ..()

/mob/living/simple_animal/hostile/giantantqueen/Destroy()
	RemoveComponentFrom(/datum/component/spawner)
	. = ..()

/mob/living/simple_animal/hostile/giantantqueen/Aggro()
	..()
	summon_backup(10)

/obj/projectile/bile
	name = "spit"
	damage = 20
	icon_state = "toxin"

/obj/item/clothing/head/f13/stalkerpelt
	name = "nightstalker pelt"
	desc = "A hat made from nightstalker pelt which makes the wearer feel both comfortable and elegant."
	icon_state = "stalkerpelt"
	inhand_icon_state  = "stalkerpelt"

/obj/structure/stalkeregg
	name = "nightstalker egg"
	desc = "A shiny egg coming from a nightstalker."
	icon = 'modular_fallout/master_files/icons/mob/wastemobsdrops.dmi'
	icon_state = "stalker-egg"
	density = 1
	anchored = 0

/obj/structure/mirelurkegg
	name = "mirelurk eggs"
	desc = "A fresh clutch of mirelurk eggs."
	icon = 'modular_fallout/master_files/icons/mob/wastemobsdrops.dmi'
	icon_state = "mirelurkeggs"
	density = 1
	anchored = 0

/mob/living/simple_animal/hostile/stalkeryoung
	name = "young nightstalker"
	desc = "A juvenile crazed genetic hybrid of rattlesnake and coyote DNA."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/wastemobs.dmi'
	icon_state = "nightstalker"
	icon_living = "nightstalker"
	icon_dead = "nightstalker_dead"
	icon_gib = null
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_chance = 0
	turns_per_move = 5
	guaranteed_butcher_results = list(/obj/item/food/meat/slab = 2, /obj/item/stack/sheet/sinew = 1, /obj/item/stack/sheet/bone = 1)
	response_help_simple = "pets"
	response_disarm_simple = "pushes aside"
	response_harm_simple = "kicks"
	taunt_chance = 30
	move_to_delay = -1
	maxHealth = 50
	health = 100
	harm_intent_damage = 8
	obj_damage = 15
	melee_damage_lower = 5
	melee_damage_upper = 10
	attack_verb_simple = "bites"
	speak_emote = list("howls")
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	faction = list("gecko")
	gold_core_spawnable = HOSTILE_SPAWN
	emote_taunt_sound = list('modular_fallout/master_files/sound/mobs/nightstalker/taunt1.ogg', 'modular_fallout/master_files/sound/mobs/nightstalker/taunt2.ogg')
	emote_taunt = list("growls", "snarls")
	aggrosound = list('modular_fallout/master_files/sound/mobs/nightstalker/aggro1.ogg', 'modular_fallout/master_files/sound/mobs/nightstalker/aggro2.ogg', 'modular_fallout/master_files/sound/mobs/nightstalker/aggro3.ogg')
	idlesound = list('modular_fallout/master_files/sound/mobs/nightstalker/idle1.ogg')
	death_sound = 'modular_fallout/master_files/sound/mobs/nightstalker/death.ogg'
	attack_sound = 'modular_fallout/master_files/sound/mobs/nightstalker/attack1.ogg'

/mob/living/simple_animal/hostile/stalkeryoung/playable
	health = 250
	maxHealth = 250
	emote_taunt_sound = null
	emote_taunt = null
	aggrosound = null
	idlesound = null
	see_in_dark = 8
	wander = 0
	anchored = FALSE
	melee_damage_lower = 20
	melee_damage_upper = 45

/mob/living/simple_animal/hostile/stalker/AttackingTarget()
	. = ..()
	if(. && ishuman(target))
		var/mob/living/carbon/human/H = target
		H.reagents.add_reagent(/datum/reagent/toxin/cazador_venom, 2)

/datum/reagent/toxin/cazador_venom/on_mob_life(mob/living/M)
	if(volume >= 20)
		M.adjustToxLoss(5, 0)
	..()

/mob/living/simple_animal/hostile/stalker
	name = "nightstalker"
	desc = "A crazed genetic hybrid of rattlesnake and coyote DNA."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/wastemobslong.dmi'
	icon_state = "nightstalker"
	icon_living = "nightstalker"
	icon_dead = "nightstalker-dead"
	icon_gib = null
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_chance = 0
	turns_per_move = 5
	guaranteed_butcher_results = list(/obj/item/food/meat/slab = 2, /obj/item/stack/sheet/sinew = 2, /obj/item/stack/sheet/bone = 2)
	butcher_results = list(/obj/item/clothing/head/f13/stalkerpelt = 1)
	butcher_difficulty = 3
	response_help_simple = "pets"
	response_disarm_simple = "gently pushes aside"
	response_harm_simple = "bites"
	emote_taunt = list("growls")
	taunt_chance = 30
	move_to_delay = -1
	maxHealth = 250
	health = 250
	harm_intent_damage = 8
	obj_damage = 15
	melee_damage_lower = 10
	melee_damage_upper = 20
	attack_verb_simple = "bites"
	attack_sound = 'modular_fallout/master_files/sound/creatures/nightstalker_bite.ogg'
	speak_emote = list("growls")
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	faction = list("gecko")
	gold_core_spawnable = HOSTILE_SPAWN

/mob/living/simple_animal/hostile/stalker/playable
	health = 300
	maxHealth = 300
	emote_taunt_sound = null
	emote_taunt = null
	aggrosound = null
	idlesound = null
	see_in_dark = 8
	wander = 0
	anchored = FALSE
	melee_damage_lower = 20
	melee_damage_upper = 45

/mob/living/simple_animal/hostile/stalker/AttackingTarget()
	. = ..()
	if(. && ishuman(target))
		var/mob/living/carbon/human/H = target
		H.reagents.add_reagent(/datum/reagent/toxin/cazador_venom, 4)

/datum/reagent/toxin/cazador_venom/on_mob_life(mob/living/M)
	if(volume >= 16)
		M.adjustToxLoss(5, 0)
	..()

/mob/living/simple_animal/hostile/bloatfly
	name = "bloatfly"
	desc = "A common mutated pest resembling an oversized blow-fly."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/wastemobs.dmi'
	icon_state = "bloatfly"
	icon_living = "bloatfly"
	icon_dead = "bloatfly_dead"
	icon_gib = null
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_chance = 0
	turns_per_move = 5
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/bloatfly_meat = 2, /obj/item/stack/sheet/sinew = 1)
	butcher_results = list(/obj/item/stack/sheet/animalhide/chitin = 1)
	butcher_difficulty = 1.5
	response_help_simple = "pets"
	response_disarm_simple = "gently pushes aside"
	response_harm_simple = "bites"
	emote_taunt = list("growls")
	taunt_chance = 30
	move_to_delay = -1
	maxHealth = 40
	health = 40
	harm_intent_damage = 8
	obj_damage = 15
	melee_damage_lower = 5
	melee_damage_upper = 8
	attack_verb_simple = "bites"
	attack_sound = 'modular_fallout/master_files/sound/creatures/bloatfly_attack.ogg'
	speak_emote = list("chitters")
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	faction = list("hostile", "gecko")
	gold_core_spawnable = HOSTILE_SPAWN
	blood_volume = 0

/mob/living/simple_animal/hostile/bloatfly/bullet_act(obj/projectile/Proj)
	if(!Proj)
		return
	if(prob(50))
		return ..()
	else
		visible_message("<span class='danger'>[src] dodges [Proj]!</span>")
		return 0

/mob/living/simple_animal/hostile/molerat
	name = "molerat"
	desc = "A large mutated rat-mole hybrid that finds its way everywhere. Common in caves and underground areas."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/wastemobs.dmi'
	icon_state = "mole_rat"
	icon_living = "mole_rat"
	icon_dead = "mole_rat_dead"
	icon_gib = null
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_chance = 0
	turns_per_move = 5
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/molerat = 2, /obj/item/stack/sheet/sinew = 1,/obj/item/stack/sheet/animalhide/molerat = 1, /obj/item/stack/sheet/bone = 1)
	butcher_results = list(/obj/item/stack/sheet/bone = 1)
	butcher_difficulty = 1.5
	response_help_simple = "pets"
	response_disarm_simple = "gently pushes aside"
	response_harm_simple = "hits"
	taunt_chance = 30
	move_to_delay = -1
	maxHealth = 25
	health = 25
	obj_damage = 15
	melee_damage_lower = 10
	melee_damage_upper = 10
	attack_verb_simple = "bites"
	attack_sound = 'modular_fallout/master_files/sound/creatures/molerat_attack.ogg'
	speak_emote = list("chitters")
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	faction = list("hostile", "gecko")
	gold_core_spawnable = HOSTILE_SPAWN
	emote_taunt_sound = list('modular_fallout/master_files/sound/mobs/molerat/taunt.ogg')
	emote_taunt = list("hisses")
	taunt_chance = 30
	aggrosound = list('modular_fallout/master_files/sound/mobs/molerat/aggro1.ogg', 'modular_fallout/master_files/sound/mobs/molerat/aggro2.ogg',)
	idlesound = list('modular_fallout/master_files/sound/mobs/molerat/idle.ogg')
	death_sound = 'modular_fallout/master_files/sound/mobs/molerat/death.ogg'

/mob/living/simple_animal/hostile/radscorpion/black
	name = "giant rad scorpion"
	desc = "A giant irradiated scorpion with a black exoskeleton. Its appearance makes you shudder in fear.<br>This one has giant pincers."
	icon_state = "radscorpion_black"
	icon_living = "radscorpion_black"
	icon_dead = "radscorpion_black_d"
	icon_gib = "gib"
	maxHealth = 150
	health = 150
	melee_damage_lower = 10
	melee_damage_upper = 30
	move_to_delay = 4
	gold_core_spawnable = HOSTILE_SPAWN

/mob/living/simple_animal/hostile/mirelurk
	name = "mirelurk"
	desc = "A giant mutated crustacean, with a hardened exo-skeleton."
	icon_state = "mirelurk"
	icon_living = "mirelurk"
	icon_dead = "mirelurk_d"
	move_to_delay = 1
	icon_gib = "gib"
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/mirelurk = 2, /obj/item/stack/sheet/sinew = 1)
	maxHealth = 150
	health = 150
	melee_damage_lower = 10
	melee_damage_upper = 20
	gold_core_spawnable = HOSTILE_SPAWN
	blood_volume = 0

/mob/living/simple_animal/hostile/fireant/Initialize()
	. = ..()

/mob/living/simple_animal/hostile/fireant/Aggro()
	..()
	summon_backup(10)

/mob/living/simple_animal/hostile/mirelurk/hunter
	name = "mirelurk hunter"
	desc = "A giant mutated crustacean, with a hardened exoskeleton. Its appearance makes you shudder in fear. This one has giant, razor sharp claw pincers."
	icon_state = "mirelurkhunter"
	icon_living = "mirelurkhunter"
	move_to_delay = 1
	icon_dead = "mirelurkhunter_d"
	icon_gib = "gib"
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/mirelurk = 4, /obj/item/stack/sheet/sinew = 2)
	maxHealth = 250
	health = 250
	melee_damage_lower = 30
	melee_damage_upper = 45
	gold_core_spawnable = HOSTILE_SPAWN

/mob/living/simple_animal/hostile/fireant/Initialize()
	. = ..()

/mob/living/simple_animal/hostile/fireant/Aggro()
	..()
	summon_backup(10)

/mob/living/simple_animal/hostile/mirelurk/baby
	name = "mirelurk baby"
	desc = "A neophyte mirelurk baby, mostly harmless."
	icon_state = "mirelurkbaby"
	icon_living = "mirelurkbaby"
	icon_dead = "mirelurkbaby_d"
	icon_gib = "gib"
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/mirelurk = 1)
	move_to_delay = 1
	maxHealth = 50
	health = 50
	melee_damage_lower = 5
	melee_damage_upper = 10
	gold_core_spawnable = HOSTILE_SPAWN

/mob/living/simple_animal/hostile/mirelurk/baby/Initialize()
	. = ..()

/mob/living/simple_animal/hostile/mirelurk/baby/Aggro()
	..()
	summon_backup(10)
