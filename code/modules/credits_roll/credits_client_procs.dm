/client/proc/clear_credits()
	winset(src, SScredits.control, "is-visible=false")
	//The following line resets the credit's browser back to the pre-script-populated credits.html file, which still has for example the javascript loaded.
	//This technically does cause a mysterious overhead of having a 5kb html file in an invisible browser for your entire play session.
	//Will it cause problems? Probably not, but this is BYOND, so if any mysterious invisible HTML browser problem starts to happen down the line... remember this comment.
	src << output(SScredits.file, SScredits.control)

/client/var/received_credits
/client/proc/download_credits()
	if(!SScredits.finalized)
		CRASH("Tried to download credits before they were finalized!")

	src << output(list2params(SScredits.js_args), "[SScredits.control]:setupCredits")
	received_credits = TRUE

/client/proc/play_downloaded_credits()
	if(!prefs.read_preference(/datum/preference/toggle/see_credits))
		return
	if(!received_credits)
		CRASH("Failed to recieve credits in time!")

	winset(src, SScredits.control, "is-visible=true")
	src << output("", "[SScredits.control]:startCredits") //Execute the startCredits() function in credits.html with no parameters.

/client/verb/hide_credits()
	set name = "Stop Credits"
	set category = "OOC"

	//Copy of [client/proc/clear_credits()]
	winset(src, SScredits.control, "is-visible=false")
	src << output(SScredits.file, SScredits.control)
