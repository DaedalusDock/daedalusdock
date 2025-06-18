/datum/typeinfo

/proc/typeinfo(datum/typepath) as /datum/typeinfo
	var/path = typepath.__typeinfo_path
	return global.__typeinfo_cache[path] ||= new path
