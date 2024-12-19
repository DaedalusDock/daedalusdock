/datum/unit_test/combat/harm_punch/Run()
	var/mob/living/carbon/human/puncher = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/victim = allocate(/mob/living/carbon/human)

	// Avoid all randomness in tests
	ADD_TRAIT(puncher, TRAIT_PERFECT_ATTACKER, INNATE_TRAIT)

	puncher.set_combat_mode(TRUE)
	victim.attack_hand(puncher, list(RIGHT_CLICK = FALSE))

	TEST_ASSERT(victim.getBruteLoss() > 0, "Victim took no brute damage after being punched")

/datum/unit_test/combat/harm_melee/Run()
	var/mob/living/carbon/human/tider = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/victim = allocate(/mob/living/carbon/human)
	var/obj/item/storage/toolbox/toolbox = allocate(/obj/item/storage/toolbox)

	tider.put_in_active_hand(toolbox, forced = TRUE)
	tider.set_combat_mode(TRUE)
	victim.attackby(toolbox, tider)

	TEST_ASSERT(victim.getBruteLoss() > 0, "Victim took no brute damage after being hit by a toolbox")

/datum/unit_test/combat/harm_different_damage/Run()
	var/mob/living/carbon/human/attacker = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/victim = allocate(/mob/living/carbon/human)
	var/obj/item/weldingtool/welding_tool = allocate(/obj/item/weldingtool)

	attacker.put_in_active_hand(welding_tool, forced = TRUE)
	attacker.set_combat_mode(TRUE)

	welding_tool.attack_self(attacker) // Turn it on
	victim.attackby(welding_tool, attacker)

	TEST_ASSERT_EQUAL(victim.getBruteLoss(), 0, "Victim took brute damage from a lit welding tool")
	TEST_ASSERT(victim.getFireLoss() > 0, "Victim took no burn damage after being hit by a lit welding tool")

/datum/unit_test/combat/attack_chain
	var/attack_hit
	var/post_attack_hit
	var/pre_attack_hit

/datum/unit_test/combat/attack_chain/proc/attack_hit()
	SIGNAL_HANDLER
	attack_hit = TRUE

/datum/unit_test/combat/attack_chain/proc/post_attack_hit()
	SIGNAL_HANDLER
	post_attack_hit = TRUE

/datum/unit_test/combat/attack_chain/proc/pre_attack_hit()
	SIGNAL_HANDLER
	pre_attack_hit = TRUE

/datum/unit_test/combat/attack_chain/Run()
	var/mob/living/carbon/human/attacker = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/victim = allocate(/mob/living/carbon/human)
	var/obj/item/storage/toolbox/toolbox = allocate(/obj/item/storage/toolbox)

	RegisterSignal(toolbox, COMSIG_ITEM_PRE_ATTACK, PROC_REF(pre_attack_hit))
	RegisterSignal(toolbox, COMSIG_ITEM_ATTACK, PROC_REF(attack_hit))
	RegisterSignal(toolbox, COMSIG_ITEM_AFTERATTACK, PROC_REF(post_attack_hit))

	attacker.put_in_active_hand(toolbox, forced = TRUE)
	attacker.set_combat_mode(TRUE)
	toolbox.melee_attack_chain(attacker, victim)

	TEST_ASSERT(pre_attack_hit, "Pre-attack signal was not fired")
	TEST_ASSERT(attack_hit, "Attack signal was not fired")
	TEST_ASSERT(post_attack_hit, "Post-attack signal was not fired")

/datum/unit_test/combat/non_standard_damage/Run()
	var/mob/living/carbon/human/man = allocate(/mob/living/carbon/human)

	man.adjustOrganLoss(ORGAN_SLOT_BRAIN, 200)
	TEST_ASSERT(man.stat == DEAD, "Victim did not die when taking 200 brain damage.")

/// Tests you can punch yourself
/datum/unit_test/combat/self_punch

/datum/unit_test/combat/self_punch/Run()
	var/mob/living/carbon/human/dummy = allocate(/mob/living/carbon/human/consistent)
	ADD_TRAIT(dummy, TRAIT_PERFECT_ATTACKER, TRAIT_SOURCE_UNIT_TESTS)
	dummy.set_combat_mode(TRUE)
	dummy.ClickOn(dummy)
	TEST_ASSERT_NOTEQUAL(dummy.getBruteLoss(), 0, "Dummy took no brute damage after self-punching")

