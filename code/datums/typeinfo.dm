/datum/typeinfo

/datum/typeinfo/datum

/datum/typeinfo/atom
	parent_type = /datum/typeinfo/datum

/datum/typeinfo/turf
	parent_type = /datum/typeinfo/atom

/datum/typeinfo/area
	parent_type = /datum/typeinfo/atom

/datum/typeinfo/atom/movable

/datum/typeinfo/obj
	parent_type = /datum/typeinfo/atom/movable

/datum/typeinfo/mob
	parent_type = /datum/typeinfo/atom/movable


/// Given an instance or typepath, returns the associated typeinfo.
/proc/typeinfo(datum/typepath) as /datum/typeinfo
	var/path = typepath.__typeinfo_path
	return global.__typeinfo_cache[path] ||= new path
