/**
* Abstract-ness is a meta-property of a class that is used to indicate
* that the class is intended to be used as a base class for others, and
* should not (or cannot) be instantiated.
* We have no such language concept in DM, and so we provide a datum member
* that can be used to hint at abstractness for circumstances where we would
* like that to be the case, such as base behavior providers.
*/

//This helper is underutilized, but that's a problem for me later. -Francinum

//514 does not allow initial(foo.static_var) on types, so we have to work around it.

#if DM_VERSION > 514
/// TRUE if the current path is abstract. See __DEFINES\abstract.dm for more information.
/// Instantiating abstract paths is illegal.
#define isabstract(foo) (initial(foo.type) == initial(foo.abstract_type))
#else
/// TRUE if the current path is abstract. See __DEFINES\abstract.dm for more information.
/// Instantiating abstract paths is illegal.
#define isabstract(foo) (ispath(foo) ? foo == initial(foo.abstract_type) : foo.type == foo.abstract_type)
#endif
