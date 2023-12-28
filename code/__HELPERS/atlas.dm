/// A massive nested associative list that tracks type instances, set by the below macros.
GLOBAL_REAL_VAR(list/atlas) = list()

#define IS_TRACKED(x) (!!atlas[x])

#define SET_TRACKING(x) \
	if(isnull(::atlas[x])) { \
		::atlas[x] = list(); \
	} \
	::atlas[x][src] = 1;

#define UNSET_TRACKING(x) (::atlas[x] -= src)

#ifndef DEBUG_ATLAS
/// Returns a list of tracked instances of a given value.
#define INSTANCES_OF(x) (::atlas[x])
#else
/proc/instances_of(foo)
	if(!IS_TRACKED(foo))
		CRASH("Attempted to get instances of untracked key [foo]")

	return ::atlas[foo]

#endif

#define INSTANCES_OF_COPY(x) (::atlas[x]:Copy())

// Tracking keys
/// Key used for things that can call the shuttle
#define TRACKING_KEY_SHUTTLE_CALLER "shuttle_caller"
#define TRACKING_KEY_RCD "rcds"

/proc/list_debug()
	var/list/lists = list()
	for(var/V in GLOB.vars)
		if(islist(GLOB.vars[V]))
			lists[V] = GLOB.vars[V]

	sortTim(lists, GLOBAL_PROC_REF(cmp_list_length), TRUE)

	for(var/name in lists)
		to_chat(world, "[name] - [length(lists[name])]")
