// Checks that the confusion symptom correctly gives, and removes, confusion
/datum/unit_test/confusion_symptom/Run()
	var/mob/living/carbon/human/dummy = allocate(/mob/living/carbon/human)
	var/datum/pathogen/advance/confusion/disease = allocate(/datum/pathogen/advance/confusion)
	var/datum/symptom/confusion/confusion = disease.symptoms[1]
	disease.has_started = TRUE
	disease.set_stage(5)
	disease.force_infect(dummy, make_copy = FALSE)
	confusion.on_process(disease)
	TEST_ASSERT(dummy.has_status_effect(/datum/status_effect/confusion), "Human is not confused after getting symptom.")
	disease.force_cure()
	TEST_ASSERT(!dummy.has_status_effect(/datum/status_effect/confusion), "Human is still confused after curing confusion.")

/datum/pathogen/advance/confusion/New()
	symptoms += new /datum/symptom/confusion
	..()
