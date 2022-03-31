/mob/living/carbon/human
	///Color of the undershirt
	var/undershirt_color = "#FFFFFF"
	///Color of the socks
	var/socks_color = "#FFFFFF"
	///Flags for showing/hiding underwear, toggleabley by a verb
	var/underwear_visibility = NONE
	///The Examine Panel TGUI.
	var/datum/examine_panel/tgui = new() //create the datum
