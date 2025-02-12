/datum/unit_test/heal_miracle
	name = "MIRACLES/HEAL: Heal Miracle Works."

/datum/unit_test/heal_miracle/Run()
	var/mob/living/carbon/human/invoker = ALLOCATE_BOTTOM_LEFT()
	var/mob/living/carbon/human/target = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/aether_tome/tome = ALLOCATE_BOTTOM_LEFT()

	var/obj/item/reagent_containers/glass/bottle/blood_bottle = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/reagent_containers/glass/bottle/woundseal_bottle = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/reagent_containers/glass/bottle/siphroot_bottle = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/reagent_containers/glass/bottle/burnboil_bottle = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/reagent_containers/glass/bottle/calomel_bottle = ALLOCATE_BOTTOM_LEFT()

	var/obj/effect/aether_rune/heal/heal_rune = ALLOCATE_BOTTOM_LEFT()

	SSmobs.can_fire = FALSE

	invoker.forceMove(get_step(invoker, NORTH))
	invoker.put_in_active_hand(tome)

	blood_bottle.reagents.add_reagent(/datum/reagent/blood, /obj/effect/aether_rune/exchange::required_blood_amt)
	woundseal_bottle.reagents.add_reagent(/datum/reagent/tincture/woundseal, 3)
	burnboil_bottle.reagents.add_reagent(/datum/reagent/tincture/burnboil, 3)
	siphroot_bottle.reagents.add_reagent(/datum/reagent/tincture/siphroot, 10)
	calomel_bottle.reagents.add_reagent(/datum/reagent/tincture/calomel, 1)


	target.set_body_position(LYING_DOWN)
	target.adjustBruteLoss(24)
	target.adjustFireLoss(24)
	target.adjustToxLoss(10)
	target.adjustBloodVolume(-100)
	target.set_heartattack(TRUE)

	invoker.ClickOn(heal_rune)
	sleep(1 SECOND)

	TEST_ASSERT(!blood_bottle.reagents.has_reagent(/datum/reagent/blood), "Blood reagent was not consumed by the miracle.")

	TEST_ASSERT(target.getBruteLoss() == 0, "Target still has brute damage, [target.getBruteLoss()].")
	TEST_ASSERT(target.getFireLoss() == 0, "Target still has burn damage, [target.getFireLoss()].")
	TEST_ASSERT(target.getToxLoss() == 0, "Target still has organ damage, [target.getToxLoss()].")
	TEST_ASSERT(target.blood_volume == BLOOD_VOLUME_NORMAL, "Target does not have normal blood volume, [target.blood_volume].")
	TEST_ASSERT(!target.undergoing_cardiac_arrest(), "Target is still undergoing a heartattack.")

/datum/unit_test/heal_miracle/Destroy()
	SSmobs.can_fire = TRUE
	return ..()
