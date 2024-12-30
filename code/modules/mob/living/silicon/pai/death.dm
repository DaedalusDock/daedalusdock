/mob/living/silicon/pai/death(gibbed, cause_of_death = "Unknown")
	if(stat == DEAD)
		return
	set_stat(DEAD)
	update_sight()
	clear_fullscreens()

	//New pAI's get a brand new mind to prevent meta stuff from their previous life. This new mind causes problems down the line if it's not deleted here.
	ghostize()

	if (!QDELETED(card) && loc != card)
		card.forceMove(drop_location())
		card.pai = null
		card.emotion_icon = initial(card.emotion_icon)
		card.update_appearance()

	qdel(src)
