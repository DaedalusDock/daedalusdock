#define MAKE_REAL_FOR_AIRLOCK(BaseType, Access_Define) ##BaseType/airlock { search_type = /obj/machinery/door/airlock };

#define MAKE_REAL_FOR_WINDOOR(BaseType, Access_Define) ##BaseType/windoor { search_type = /obj/machinery/door/window };

//#define MAKE_FOR_CONTROLLER(BaseType, Slug, Access_Define) ##BaseType/ec { search_type = /obj };

// This coerces it to be a list which is technically hacky and bad but honestly GFY. Rewrite my macros.
#define MAKE_REAL_BASE(BaseType, Access_Define) ##BaseType { granted_access = list(Access_Define) };

#define MAKE_ABSTRACT_IMPL(BaseType, State) ##BaseType { icon_state = State };


#define MAKE_REAL_FOR_ALL(Slug, Access_Define) \
	MAKE_REAL_BASE(/obj/effect/mapping_helpers/access/all/##Slug, Access_Define) \
	MAKE_REAL_FOR_AIRLOCK(/obj/effect/mapping_helpers/access/all/##Slug, Access_Define) \
	MAKE_REAL_FOR_WINDOOR(/obj/effect/mapping_helpers/access/all/##Slug, Access_Define) \
//	MAKE_FOR_CONTROLLER(/obj/effect/mapping_helpers/access/all/##Slug, Access_Define)

#define MAKE_REAL_FOR_ANY(Slug, Access_Define) \
	MAKE_REAL_BASE(/obj/effect/mapping_helpers/access/any/##Slug, Access_Define) \
	MAKE_REAL_FOR_AIRLOCK(/obj/effect/mapping_helpers/access/any/##Slug, Access_Define) \
	MAKE_REAL_FOR_WINDOOR(/obj/effect/mapping_helpers/access/any/##Slug, Access_Define) \
//	MAKE_FOR_CONTROLLER(/obj/effect/mapping_helpers/access/any/##Slug, Access_Define)

/// Make a REAL access helper.
#define MAKE_REAL(Slug, Access_Define) \
	MAKE_REAL_FOR_ALL(Slug, Access_Define) \
	MAKE_REAL_FOR_ANY(Slug, Access_Define)

/// Make an abstract access helper, Used for setting icon_state.
#define MAKE_ABSTRACT(Slug, State) \
	MAKE_ABSTRACT_IMPL(/obj/effect/mapping_helpers/access/all/##Slug, State) \
	MAKE_ABSTRACT_IMPL(/obj/effect/mapping_helpers/access/any/##Slug, State)

#include "types.dm"

#undef MAKE_REAL_BASE
#undef MAKE_REAL_FOR_AIRLOCK
#undef MAKE_REAL_FOR_WINDOOR
//#undef MAKE_FOR_CONTROLLER
#undef MAKE_REAL_FOR_ALL
#undef MAKE_REAL_FOR_ANY
#undef MAKE_REAL

#undef MAKE_ABSTRACT_IMPL
#undef MAKE_ABSTRACT
