
///assoc list of ckey -> /datum/persistent_client
GLOBAL_LIST_EMPTY_TYPED(persistent_clients_by_ckey, /datum/persistent_client)
GLOBAL_LIST_EMPTY(persistent_clients)

/datum/persistent_client
	/// The actual client, can be null at any time (duh)
	var/client/client
	/// The mob this client is bound to.
	var/mob/mob

	/// The last known byond version the client connected with.
	var/byond_version
	/// The last known byond build the client connected with.
	var/byond_build

	/// Nested list of client-related logging.
	var/list/logging = list()
	var/list/player_actions = list()
	/// The name of every mob this user has been associated with this round.
	var/list/played_names = list()

	/// Callbacks for mob/Login()
	var/list/post_login_callbacks = list()
	/// Callbacks for mob/Logout()
	var/list/post_logout_callbacks = list()

	var/datum/achievement_data/achievements
	/// The preferences of the client.
	var/datum/preferences/prefs

	/// Lobby music playlist.
	var/datum/playlist/playlist

/datum/persistent_client/New(ckey, client/_client)
	client = _client
	achievements = new(ckey)
	GLOB.persistent_clients_by_ckey[ckey] = src
	GLOB.persistent_clients += src

	playlist = new(src)

/datum/persistent_client/Destroy(force, ...)
	SHOULD_CALL_PARENT(FALSE)
	. = QDEL_HINT_LETMELIVE
	CRASH("Who the FUCK tried to delete a persistent client? FUCK OFF!!!")

/// Setter for the mob var, handles both references.
/datum/persistent_client/proc/SetMob(mob/new_mob)
	if(mob == new_mob)
		return

	mob?.persistent_client = null
	new_mob?.persistent_client?.SetMob(null)

	mob = new_mob
	new_mob?.persistent_client = src

/datum/persistent_client/proc/SetClient(client/new_client)
	if(client == new_client)
		return

	client?.persistent_client = null
	client = new_client

	if(client)
		client.persistent_client = src
		byond_build = client.byond_build
		byond_version = client.byond_version

/// Returns the full version string (i.e 515.1642) of the BYOND version and build.
/datum/persistent_client/proc/full_byond_version()
	if(!byond_version)
		return "Unknown"
	return "[byond_version].[byond_build || "xxx"]"

/proc/log_played_names(ckey, ...)
	if(!ckey)
		return
	if(args.len < 2)
		return
	var/list/names = args.Copy(2)
	var/datum/persistent_client/P = GLOB.persistent_clients_by_ckey[ckey]
	if(P)
		for(var/name in names)
			if(name)
				P.played_names |= name
