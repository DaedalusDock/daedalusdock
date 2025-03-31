/// Test EMP flashlight EMPs people you point it at
/datum/unit_test/combat/emp_flashlight
	name = "COMBAT/MISC: EMP Flashlight Shall EMP On Click"
	var/sig_caught = 0

/datum/unit_test/combat/emp_flashlight/Run()
	var/mob/living/carbon/human/consistent/flashlighter = ALLOCATE_BOTTOM_LEFT()
	var/mob/living/carbon/human/consistent/victim = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/flashlight/emp/debug/flashlight = ALLOCATE_BOTTOM_LEFT()

	flashlighter.put_in_active_hand(flashlight, forced = TRUE)
	RegisterSignal(victim, COMSIG_ATOM_EMP_ACT, PROC_REF(sig_caught))

	click_wrapper(flashlighter, victim)
	TEST_ASSERT_NOTEQUAL(sig_caught, 0, "EMP flashlight did not EMP the target on click.")

/datum/unit_test/combat/emp_flashlight/proc/sig_caught()
	SIGNAL_HANDLER
	sig_caught++
