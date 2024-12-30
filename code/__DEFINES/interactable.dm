/// A "helper" for defining all of the needed things for mouse pointers to recognize an object is interactable
#define DEFINE_INTERACTABLE(TYPE) \
	##TYPE/is_mouseover_interactable = TRUE; \
	##TYPE/MouseExited(location, control, params) { \
		. = ..(); \
		usr.update_mouse_pointer(); \
	} \

#define MOUSE_ICON_HOVERING_INTERACTABLE 'icons/effects/mouse_pointers/interact.dmi'
