/mob/living/silicon/ai/Logout()
	client.images -= sense_of_self
	..()
	set_eyeobj_visible(FALSE)
	view_core()
