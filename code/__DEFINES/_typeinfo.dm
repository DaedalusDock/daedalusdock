/// Define an objects typeinfo
#define TYPEINFO_DEF(typepath) \
	typepath/__typeinfo_path = /datum/typeinfo ## typepath; \
	/datum/typeinfo ## typepath
