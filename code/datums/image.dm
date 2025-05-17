/image/Destroy(force, ...)
	SHOULD_CALL_PARENT(FALSE)

	. = QDEL_HINT_LETMELIVE
	CRASH("Image Destroy() invoked.")
