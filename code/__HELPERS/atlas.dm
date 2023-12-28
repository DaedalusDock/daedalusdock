/// A massive nested associative list that tracks type instances, set by the below macros.
GLOBAL_REAL_VAR(list/atlas) = list()

#define SET_TRACKING(x) \
	if(isnull(::atlas[x])) { \
		::atlas[x] = list(); \
	} \
	::atlas[x][src] = 1;

#define UNSET_TRACKING(x) (::atlas[x] -= src)

/// Returns a list of tracked instances of a given value.
#define INSTANCES_OF(x) (global.atlas[x])

#define INSTANCES_OF_COPY(x) (global.atlas[x]:Copy())
