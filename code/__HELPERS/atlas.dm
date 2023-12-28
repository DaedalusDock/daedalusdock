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
#define TRACKING_KEY_DOORS "doors"
