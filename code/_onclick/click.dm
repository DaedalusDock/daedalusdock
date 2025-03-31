/*
	Click code cleanup
	~Sayu
*/

// 1 decisecond click delay (above and beyond mob/next_move)
//This is mainly modified by click code, to modify click delays elsewhere, use next_move and changeNext_move()
/mob/var/next_click = 0

// THESE DO NOT EFFECT THE BASE 1 DECISECOND DELAY OF NEXT_CLICK
/mob/var/next_move_adjust = 0 //Amount to adjust action/click delays by, + or -
/mob/var/next_move_modifier = 1 //Value to multiply action/click delays by


//Delays the mob's next click/action by num deciseconds
// eg: 10-3 = 7 deciseconds of delay
// eg: 10*0.5 = 5 deciseconds of delay
// DOES NOT EFFECT THE BASE 1 DECISECOND DELAY OF NEXT_CLICK

/mob/proc/changeNext_move(num)
	next_move = world.time + ((num+next_move_adjust)*next_move_modifier)

/mob/living/changeNext_move(num)
	var/mod = next_move_modifier
	var/adj = next_move_adjust
	for(var/datum/status_effect/effect as anything in status_effects)
		mod *= effect.nextmove_modifier()
		adj += effect.nextmove_adjust()
	next_move = world.time + ((num + adj)*mod)

	SEND_SIGNAL(src, COMSIG_LIVING_CHANGENEXT_MOVE, next_move)

/**
 * Before anything else, defer these calls to a per-mobtype handler.  This allows us to
 * remove istype() spaghetti code, but requires the addition of other handler procs to simplify it.
 *
 * Alternately, you could hardcode every mob's variation in a flat [/mob/proc/ClickOn] proc; however,
 * that's a lot of code duplication and is hard to maintain.
 *
 * Note that this proc can be overridden, and is in the case of screen objects.
 */
/atom/Click(location, control, params)
	if(initialized)
		SEND_SIGNAL(src, COMSIG_CLICK, location, control, params, usr)

		usr.ClickOn(src, params)

/atom/DblClick(location,control,params)
	if(initialized)
		usr.DblClickOn(src,params)

/atom/MouseWheel(delta_x,delta_y,location,control,params)
	if(initialized)
		usr.MouseWheelOn(src, delta_x, delta_y, params)

/**
 * Standard mob ClickOn()
 * Handles exceptions: Buildmode, middle click, modified clicks, mech actions
 *
 * After that, mostly just check your state, check whether you're holding an item,
 * check whether you're adjacent to the target, then pass off the click to whoever
 * is receiving it.
 * The most common are:
 * * [mob/proc/UnarmedAttack] (atom,adjacent) - used here only when adjacent, with no item in hand; in the case of humans, checks gloves
 * * [atom/proc/attackby] (item,user) - used only when adjacent
 * * [obj/item/proc/afterattack] (atom,user,adjacent,params) - used both ranged and adjacent
 * * [mob/proc/RangedAttack] (atom,modifiers) - used only ranged, only used for tk and laser eyes but could be changed
 */
/mob/proc/ClickOn( atom/A, params )
	if(world.time <= next_click)
		return
	next_click = world.time + 1

	if(check_click_intercept(params,A) || notransform)
		return

	var/list/modifiers = params2list(params)

	if(SEND_SIGNAL(src, COMSIG_MOB_CLICKON, A, modifiers) & COMSIG_MOB_CANCEL_CLICKON)
		return

	if(LAZYACCESS(modifiers, SHIFT_CLICK))
		if(LAZYACCESS(modifiers, MIDDLE_CLICK))
			ShiftMiddleClickOn(A)
			return

		if(LAZYACCESS(modifiers, CTRL_CLICK))
			CtrlShiftClickOn(A)
			return

		ShiftClickOn(A)
		return

	if(LAZYACCESS(modifiers, MIDDLE_CLICK))
		if(LAZYACCESS(modifiers, CTRL_CLICK))
			CtrlMiddleClickOn(A)
		else
			MiddleClickOn(A, params)
		return

	if(LAZYACCESS(modifiers, ALT_CLICK)) // alt and alt-gr (rightalt)
		if(LAZYACCESS(modifiers, RIGHT_CLICK))
			alt_click_on_secondary(A)
		else
			AltClickOn(A)
		return

	if(LAZYACCESS(modifiers, CTRL_CLICK))
		CtrlClickOn(A, modifiers)
		return

	//PARIAH EDIT ADDITION
	if(typing_indicator)
		set_typing_indicator(FALSE)
	//PARIAH EDIT END

	if(incapacitated(IGNORE_RESTRAINTS|IGNORE_STASIS))
		return

	face_atom(A)

	if(next_move > world.time) // in the year 2000...
		return

	if(!LAZYACCESS(modifiers, "catcher") && A.IsObscured())
		return

	if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
		changeNext_move(CLICK_CD_HANDCUFFED)   //Doing shit in cuffs shall be vey slow
		UnarmedAttack(A, Adjacent(A), modifiers)
		return

	if(throw_mode)
		if(throw_item(A))
			changeNext_move(CLICK_CD_THROW)
		return

	var/obj/item/W = get_active_held_item()

	if(W == A)
		if(LAZYACCESS(modifiers, RIGHT_CLICK))
			W.attack_self_secondary(src, modifiers)
			update_held_items()
		else
			W.attack_self(src, modifiers)
			update_held_items()
		return

	//These are always reachable.
	//User itself, current loc, and user inventory
	if(A in DirectAccess())
		if(W)
			W.melee_attack_chain(src, A, params)
		else
			if(ismob(A))
				changeNext_move(CLICK_CD_MELEE)

			UnarmedAttack(A, TRUE, modifiers)
		return

	//Can't reach anything else in lockers or other weirdness
	if(!loc.AllowClick())
		return

	// In a storage item with a disassociated storage parent
	var/obj/item/item_atom = A
	if(istype(item_atom))
		if((item_atom.item_flags & IN_STORAGE) && (item_atom.loc.flags_1 & HAS_DISASSOCIATED_STORAGE_1))
			UnarmedAttack(item_atom, TRUE, modifiers)

	//Standard reach turf to turf or reaching inside storage
	if(A.IsReachableBy(src, W?.reach))
		if(W)
			W.melee_attack_chain(src, A, params)
		else
			if(ismob(A))
				changeNext_move(CLICK_CD_MELEE)
			UnarmedAttack(A, TRUE,modifiers)
	else
		if(W)
			if(LAZYACCESS(modifiers, RIGHT_CLICK))
				var/after_attack_secondary_result = W.afterattack_secondary(A, src, FALSE, params)

				if(after_attack_secondary_result == SECONDARY_ATTACK_CALL_NORMAL)
					W.afterattack(A, src, FALSE, params)
			else
				W.afterattack(A,src, FALSE, params)
		else
			if(LAZYACCESS(modifiers, RIGHT_CLICK))
				ranged_secondary_attack(A, modifiers)
			else
				RangedAttack(A,modifiers)

/// Is the atom obscured by a PREVENT_CLICK_UNDER_1 object above it
/atom/proc/IsObscured()
	SHOULD_BE_PURE(TRUE)
	if(!isturf(loc)) //This only makes sense for things directly on turfs for now
		return FALSE
	var/turf/T = get_turf_pixel(src)
	if(!T)
		return FALSE
	for(var/atom/movable/AM in T)
		if(AM.flags_1 & PREVENT_CLICK_UNDER_1 && AM.density && AM.layer > layer)
			return TRUE
	return FALSE

/turf/IsObscured()
	for(var/item in src)
		var/atom/movable/AM = item
		if(AM.flags_1 & PREVENT_CLICK_UNDER_1)
			return TRUE
	return FALSE

/**
 * Returns TRUE if a movable can "Reach" this atom. This is defined as adjacency
 *
 * This is used for crafting by hitting the floor with items.
 * The inital use case is glass sheets breaking in to shards when the floor is hit.
 * Args:
 * * user: The movable trying to reach us.
 * * reacher_range: How far the reacher can reach.
 * * depth: How deep nested inside of an atom contents stack an object can be.
 * * direct_access: Do not override. Used for recursion.
 */
/atom/proc/IsReachableBy(atom/movable/user, reacher_range = 1, depth = INFINITY, direct_access = user.DirectAccess())
	SHOULD_NOT_OVERRIDE(TRUE)

	if(isnull(user))
		return FALSE

	if(src in direct_access)
		return TRUE

	// This is a micro-opt, if any turf ever returns false from IsContainedAtomAccessible, change this.
	if(isturf(loc) || isturf(src))
		if(CheckReachableAdjacency(user, reacher_range))
			return TRUE

	depth--
	if(depth <= 0)
		return FALSE

	if(isnull(loc) || isarea(loc) || !loc.IsContainedAtomAccessible(src, user))
		return FALSE

	return loc.IsReachableBy(user, reacher_range, depth, direct_access)

/// Checks if a reacher is adjacent to us.
/atom/proc/CheckReachableAdjacency(atom/movable/reacher, reacher_range)
	return reacher.Adjacent(src) || ((reacher_range > 1) && RangedReachCheck(reacher, src, reacher_range))

/// Returns TRUE if an atom contained within our contents is reachable.
/atom/proc/IsContainedAtomAccessible(atom/contained, atom/movable/user)
	return TRUE

/atom/movable/IsContainedAtomAccessible(atom/contained, atom/movable/user)
	return !!atom_storage

/mob/living/IsContainedAtomAccessible(atom/contained, atom/movable/user)
	. = ..()
	if(.)
		return

	if(!isliving(user))
		return

	if(!isitem(contained))
		return

	var/mob/living/living_user = user
	var/obj/item/I = contained
	if(I.can_pickpocket(user))
		return I.atom_storage == living_user.active_storage

/atom/movable/proc/DirectAccess()
	return list(src, loc)

/mob/DirectAccess(atom/target)
	return ..() + contents

/mob/living/DirectAccess(atom/target)
	return ..() + get_all_contents()

/atom/proc/AllowClick()
	return FALSE

/turf/AllowClick()
	return TRUE

/// Called by IsReachableBy() to check for ranged reaches.
/proc/RangedReachCheck(atom/movable/here, atom/movable/there, reach)
	if(!here || !there)
		return FALSE

	if(reach <= 1)
		return FALSE

	// Prevent infinite loop.
	if(istype(here, /obj/effect/abstract/reach_checker))
		return FALSE

	var/obj/effect/abstract/reach_checker/dummy = new(get_turf(here))
	for(var/i in 1 to reach) //Limit it to that many tries
		var/turf/T = get_step(dummy, get_dir(dummy, there))
		if(there.IsReachableBy(dummy))
			. = TRUE
			break

		if(!dummy.Move(T)) //we're blocked!
			break

	qdel(dummy)

/// Default behavior: ignore double clicks (the second click that makes the doubleclick call already calls for a normal click)
/mob/proc/DblClickOn(atom/A, params)
	return


/**
 * UnarmedAttack: The higest level of mob click chain discounting click itself.
 *
 * This handles, just "clicking on something" without an item. It translates
 * into [atom/proc/attack_hand], [atom/proc/attack_animal] etc.
 *
 * Note: proximity_flag here is used to distinguish between normal usage (flag=1),
 * and usage when clicking on things telekinetically (flag=0).  This proc will
 * not be called at ranged except with telekinesis.
 *
 * proximity_flag is not currently passed to attack_hand, and is instead used
 * in human click code to allow glove touches only at melee range.
 *
 * modifiers is a lazy list of click modifiers this attack had,
 * used for figuring out different properties of the click, mostly right vs left and such.
 */

/mob/proc/UnarmedAttack(atom/A, proximity_flag, list/modifiers)
	if(ismob(A))
		changeNext_move(CLICK_CD_MELEE)
	return

/**
 * Ranged unarmed attack:
 *
 * This currently is just a default for all mobs, involving
 * laser eyes and telekinesis.  You could easily add exceptions
 * for things like ranged glove touches, spitting alien acid/neurotoxin,
 * animals lunging, etc.
 */
/mob/proc/RangedAttack(atom/A, modifiers)
	if(SEND_SIGNAL(src, COMSIG_MOB_ATTACK_RANGED, A, modifiers) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE

/**
 * Ranged secondary attack
 *
 * If the same conditions are met to trigger RangedAttack but it is
 * instead initialized via a right click, this will trigger instead.
 * Useful for mobs that have their abilities mapped to right click.
 */
/mob/proc/ranged_secondary_attack(atom/target, modifiers)
	if(SEND_SIGNAL(src, COMSIG_MOB_ATTACK_RANGED_SECONDARY, target, modifiers) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE

/**
 * Middle click
 * Mainly used for swapping hands
 */
/mob/proc/MiddleClickOn(atom/A, params)
	. = SEND_SIGNAL(src, COMSIG_MOB_MIDDLECLICKON, A, params)
	if(. & COMSIG_MOB_CANCEL_CLICKON)
		return
	swap_hand()

/**
 * Shift click
 * For most mobs, examine.
 * This is overridden in ai.dm
 */
/mob/proc/ShiftClickOn(atom/A)
	A.ShiftClick(src)
	return

/atom/proc/ShiftClick(mob/user)
	var/flags = SEND_SIGNAL(user, COMSIG_CLICK_SHIFT, src)
	if(!user.client)
		return
	if(!((user.client.eye == user) || (user.client.eye == user.loc) || isobserver(user)) && !(flags & COMPONENT_ALLOW_EXAMINATE))
		return

	user.examinate(src)

/**
 * Ctrl click
 * For most objects, pull
 */
/mob/proc/CtrlClickOn(atom/A, list/params)
	A.CtrlClick(src, params)
	return

/atom/proc/CtrlClick(mob/user, list/params)
	SEND_SIGNAL(src, COMSIG_CLICK_CTRL, user)
	SEND_SIGNAL(user, COMSIG_MOB_CTRL_CLICKED, src)
	var/mob/living/ML = user
	if(istype(ML))
		ML.pulled(src)
	if(!can_interact(user))
		return FALSE

	return TRUE

/mob/living/CtrlClick(mob/user, list/params)
	if(!isliving(user) || !IsReachableBy(user) || user.incapacitated())
		return ..()

	if(world.time < user.next_move)
		return FALSE

	var/mob/living/user_living = user
	if(user_living.apply_martial_art(src, null, is_grab=TRUE) == MARTIAL_ATTACK_SUCCESS)
		user_living.changeNext_move(CLICK_CD_MELEE)
		return TRUE

	return ..()


/mob/living/carbon/human/CtrlClick(mob/user, list/params)

	if(!ishuman(user) || !IsReachableBy(user) || user.incapacitated())
		return ..()

	if(world.time < user.next_move)
		return FALSE

	var/mob/living/carbon/human/human_user = user
	// If they're wielding a grab item, do the normal click chain.
	var/obj/item/hand_item/grab/G = user.get_active_held_item()
	if(isgrab(G))
		G.current_grab.hit_with_grab(G, src, params)
		return TRUE

	if(human_user.dna.species.grab(human_user, src, human_user.mind.martial_art, params))
		human_user.changeNext_move(CLICK_CD_MELEE)
		return TRUE

	return ..()

/mob/proc/CtrlMiddleClickOn(atom/A)
	if(check_rights_for(client, R_ADMIN))
		client.toggle_tag_datum(A)
	else
		A.CtrlClick(src)
	return

/**
 * Alt click
 * Unused except for AI
 */
/mob/proc/AltClickOn(atom/A)
	. = SEND_SIGNAL(src, COMSIG_MOB_ALTCLICKON, A)
	if(. & COMSIG_MOB_CANCEL_CLICKON)
		return
	A.AltClick(src)

/atom/proc/AltClick(mob/user)
	if(!can_interact(user))
		return FALSE
	if(SEND_SIGNAL(src, COMSIG_CLICK_ALT, user) & COMPONENT_CANCEL_CLICK_ALT)
		return
	var/turf/T = get_turf(src)
	if(T && (isturf(loc) || isturf(src)) && user.TurfAdjacent(T) && !HAS_TRAIT(user, TRAIT_MOVE_VENTCRAWLING))
		user.set_listed_turf(T)

///The base proc of when something is right clicked on when alt is held - generally use alt_click_secondary instead
/atom/proc/alt_click_on_secondary(atom/A)
	. = SEND_SIGNAL(src, COMSIG_MOB_ALTCLICKON_SECONDARY, A)
	if(. & COMSIG_MOB_CANCEL_CLICKON)
		return
	A.alt_click_secondary(src)

///The base proc of when something is right clicked on when alt is held
/atom/proc/alt_click_secondary(mob/user)
	if(!can_interact(user))
		return FALSE
	if(SEND_SIGNAL(src, COMSIG_CLICK_ALT_SECONDARY, user) & COMPONENT_CANCEL_CLICK_ALT_SECONDARY)
		return
	if(isobserver(user) && user.client && check_rights_for(user.client, R_DEBUG))
		user.client.toggle_tag_datum(src)
		return

/// Use this instead of [/mob/proc/AltClickOn] where you only want turf content listing without additional atom alt-click interaction
/atom/proc/AltClickNoInteract(mob/user, atom/A)
	var/turf/T = get_turf(A)
	if(T && user.TurfAdjacent(T))
		user.set_listed_turf(T)

/mob/proc/TurfAdjacent(turf/T)
	return T.Adjacent(src)

/**
 * Control+Shift click
 * Unused except for AI
 */
/mob/proc/CtrlShiftClickOn(atom/A)
	A.CtrlShiftClick(src)
	return

/mob/proc/ShiftMiddleClickOn(atom/A)
	src.pointed(A)
	return

/atom/proc/CtrlShiftClick(mob/user)
	if(!can_interact(user))
		return FALSE
	SEND_SIGNAL(src, COMSIG_CLICK_CTRL_SHIFT, user)
	return

/*
	Misc helpers
	face_atom: turns the mob towards what you clicked on
*/

/// Simple helper to face what you clicked on, in case it should be needed in more than one place
/mob/proc/face_atom(atom/A)
	if( buckled || stat != CONSCIOUS || !A || !x || !y || !A.x || !A.y )
		return
	var/dx = A.x - x
	var/dy = A.y - y
	if(!dx && !dy) // Wall items are graphically shifted but on the floor
		if(A.pixel_y > 16)
			setDir(NORTH)
		else if(A.pixel_y < -16)
			setDir(SOUTH)
		else if(A.pixel_x > 16)
			setDir(EAST)
		else if(A.pixel_x < -16)
			setDir(WEST)
		return

	if(abs(dx) < abs(dy))
		if(dy > 0)
			setDir(NORTH)
		else
			setDir(SOUTH)
	else
		if(dx > 0)
			setDir(EAST)
		else
			setDir(WEST)

//debug
/atom/movable/screen/proc/scale_to(x1,y1)
	if(!y1)
		y1 = x1
	var/matrix/M = new
	M.Scale(x1,y1)
	transform = M

/atom/movable/screen/click_catcher
	icon = 'icons/hud/screen_gen.dmi'
	icon_state = "catcher"
	plane = CLICKCATCHER_PLANE
	mouse_opacity = MOUSE_OPACITY_OPAQUE
	screen_loc = "CENTER"

/atom/movable/screen/click_catcher/can_usr_use(mob/user)
	return TRUE // Owned by a client, not a mob. It's all safe anyways.


#define MAX_SAFE_BYOND_ICON_SCALE_TILES (MAX_SAFE_BYOND_ICON_SCALE_PX / world.icon_size)
#define MAX_SAFE_BYOND_ICON_SCALE_PX (33 * 32) //Not using world.icon_size on purpose.

/atom/movable/screen/click_catcher/proc/UpdateGreed(view_size_x = 15, view_size_y = 15)
	var/icon/newicon = icon('icons/hud/screen_gen.dmi', "catcher")
	var/ox = min(MAX_SAFE_BYOND_ICON_SCALE_TILES, view_size_x)
	var/oy = min(MAX_SAFE_BYOND_ICON_SCALE_TILES, view_size_y)
	var/px = view_size_x * world.icon_size
	var/py = view_size_y * world.icon_size
	var/sx = min(MAX_SAFE_BYOND_ICON_SCALE_PX, px)
	var/sy = min(MAX_SAFE_BYOND_ICON_SCALE_PX, py)
	newicon.Scale(sx, sy)
	icon = newicon
	screen_loc = "CENTER-[(ox-1)*0.5],CENTER-[(oy-1)*0.5]"
	var/matrix/M = new
	M.Scale(px/sx, py/sy)
	transform = M

/atom/movable/screen/click_catcher/Click(location, control, params)
	. = ..()
	if(.)
		return FALSE

	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, MIDDLE_CLICK) && iscarbon(usr))
		var/mob/living/carbon/C = usr
		C.swap_hand()
	else
		var/turf/click_turf = parse_caught_click_modifiers(modifiers, get_turf(usr.client ? usr.client.eye : usr), usr.client)
		if (click_turf)
			modifiers["catcher"] = TRUE
			click_turf.Click(click_turf, control, list2params(modifiers))
	. = 1

/// MouseWheelOn
/mob/proc/MouseWheelOn(atom/A, delta_x, delta_y, params)
	SEND_SIGNAL(src, COMSIG_MOUSE_SCROLL_ON, A, delta_x, delta_y, params)

/mob/dead/observer/MouseWheelOn(atom/A, delta_x, delta_y, params)
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, SHIFT_CLICK))
		var/view = 0
		if(delta_y > 0)
			view = -1
		else
			view = 1
		add_view_range(view)

/mob/proc/check_click_intercept(params,A)
	//Client level intercept
	if(client?.click_intercept)
		if(call(client.click_intercept, "InterceptClickOn")(src, params, A))
			return TRUE

	//Mob level intercept
	if(click_intercept)
		if(call(click_intercept, "InterceptClickOn")(src, params, A))
			return TRUE

	return FALSE
