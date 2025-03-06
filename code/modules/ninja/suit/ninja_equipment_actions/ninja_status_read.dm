/datum/action/item_action/ninjastatus
	check_flags = NONE
	name = "Status Readout"
	desc = "Gives a detailed readout about your current status."
	button_icon_state = "health"
	button_icon = 'icons/obj/device.dmi'

/**
 * Proc called to put a status readout to the ninja in chat.
 *
 * Called put some information about the ninja's current status into chat.
 * This information used to be displayed constantly on the status tab screen
 * when the suit was on, but was turned into this as to remove the code from
 * human.dm
 */
/obj/item/clothing/suit/space/space_ninja/proc/ninjastatus()
	var/mob/living/carbon/human/ninja = affecting
	var/list/info_list = list()
	info_list += "[span_info("SpiderOS Status: [s_initialized ? "Initialized" : "Disabled"]")]\n"
	info_list += "[span_info("Current Time: [stationtime2text()]")]\n"
	//Ninja status
	info_list += "[span_info("Fingerprints: [ninja.get_fingerprints(TRUE)]")]\n"
	info_list += "[span_info("Unique Identity: [ninja.dna.unique_enzymes]")]\n"
	info_list += "[span_info("Overall Status: [ninja.stat > 1 ? "dead" : "[ninja.health]% healthy"]")]\n"
	info_list += "[span_info("Nutrition Status: [ninja.nutrition]")]\n"
	info_list += "[span_info("Oxygen Loss: [ninja.getOxyLoss()]")]\n"
	info_list += "[span_info("Toxin Levels: [ninja.getToxLoss()]")]\n"
	info_list += "[span_info("Burn Severity: [ninja.getFireLoss()]")]\n"
	info_list += "[span_info("Brute Trauma: [ninja.getBruteLoss()]")]\n"
	info_list += "[span_info("Body Temperature: [ninja.bodytemperature-T0C] degrees C ([FAHRENHEIT(ninja.bodytemperature)] degrees F)")]\n"

	//Diseases
	if(length(ninja.diseases))
		info_list += "Viruses:"
		for(var/datum/pathogen/ninja_disease in ninja.diseases)
			info_list += "[span_info("* [ninja_disease.name], Type: [ninja_disease.spread_text], Stage: [ninja_disease.stage]/[ninja_disease.max_stages], Possible Cure: [ninja_disease.cure_text]")]\n"

	to_chat(ninja, "[info_list.Join()]")
