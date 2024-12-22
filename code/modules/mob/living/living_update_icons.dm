/// Update our transform.
/mob/living/do_update_transform()
	var/matrix/ntransform = matrix(transform) //aka transform.Copy()
	var/changed = FALSE

	if(resize != RESIZE_DEFAULT_SIZE)
		changed = TRUE
		ntransform.Scale(resize)
		resize = RESIZE_DEFAULT_SIZE

	if(!changed)
		return FALSE

	z_animate(src, transform = ntransform, time = 2, easing = EASE_IN|EASE_OUT)
