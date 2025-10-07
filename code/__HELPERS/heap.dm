//////////////////////
//datum/heap object
//////////////////////

/datum/heap
	var/list/L
	var/cmp

/datum/heap/New(compare)
	L = new()
	cmp = compare

/datum/heap/Destroy(force, ...)
	if(length(L) && isdatum(L[1]))
		for(var/i in L) // because this is before the list helpers are loaded
			qdel(i)
	L = null
	return ..()

/datum/heap/proc/is_empty()
	return !length(L)

//insert and place at its position a new node in the heap
/datum/heap/proc/insert(atom/A)

	L[++L.len] = A
	swim(length(L))

//removes and returns the first element of the heap
//(i.e the max or the min dependant on the comparison function)
/datum/heap/proc/pop()
	if(!length(L))
		return 0
	. = L[1]

	L[1] = L[length(L)]
	L.Cut(length(L))
	if(length(L))
		sink(1)

//Get a node up to its right position in the heap
/datum/heap/proc/swim(index)
	var/parent = round(index * 0.5)

	while(parent > 0 && (call(cmp)(L[index],L[parent]) > 0))
		L.Swap(index,parent)
		index = parent
		parent = round(index * 0.5)

//Get a node down to its right position in the heap
/datum/heap/proc/sink(index)
	var/g_child = get_greater_child(index)

	while(g_child > 0 && (call(cmp)(L[index],L[g_child]) < 0))
		L.Swap(index,g_child)
		index = g_child
		g_child = get_greater_child(index)

//Returns the greater (relative to the comparison proc) of a node children
//or 0 if there's no child
/datum/heap/proc/get_greater_child(index)
	if(index * 2 > length(L))
		return 0

	if(index * 2 + 1 > length(L))
		return index * 2

	if(call(cmp)(L[index * 2],L[index * 2 + 1]) < 0)
		return index * 2 + 1
	else
		return index * 2

//Replaces a given node so it verify the heap condition
/datum/heap/proc/resort(atom/A)
	var/index = L.Find(A)

	swim(index)
	sink(index)

/datum/heap/proc/List()
	. = L.Copy()


// Heap object optimized for A*
// THESE ARE ALSO USED IN ASTAR_PATH.DM KEEP THEM IN SYNC!
#define ATURF 1
#define TOTAL_COST_F 2
#define DIST_FROM_START_G 3
#define HEURISTIC_H 4
#define PREV_NODE 5
/datum/heap/astar

/datum/heap/astar/swim(index)
	var/parent = round(index * 0.5)

	while(parent > 0 && ((L[parent][TOTAL_COST_F] - L[index][TOTAL_COST_F]) > 0))
		L.Swap(index,parent)
		index = parent
		parent = round(index * 0.5)

/datum/heap/astar/sink(index)
	var/g_child = get_greater_child(index)

	while(g_child > 0 && ((L[g_child][TOTAL_COST_F] - L[index][TOTAL_COST_F]) < 0))
		L.Swap(index,g_child)
		index = g_child
		g_child = get_greater_child(index)

/datum/heap/astar/get_greater_child(index)
	if(index * 2 > length(L))
		return 0

	if(index * 2 + 1 > length(L))
		return index * 2

	if((L[index * 2 + 1][TOTAL_COST_F] - L[index * 2][TOTAL_COST_F]) < 0)
		return index * 2 + 1
	else
		return index * 2

#undef ATURF
#undef TOTAL_COST_F
#undef DIST_FROM_START_G
#undef HEURISTIC_H
#undef PREV_NODE
