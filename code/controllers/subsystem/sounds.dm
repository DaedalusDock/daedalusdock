#define DATUMLESS "NO_DATUM"

SUBSYSTEM_DEF(sounds)
	name = "Sounds"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_SOUNDS
	var/static/using_channels_max = CHANNEL_HIGHEST_AVAILABLE //BYOND max channels
	/// Amount of channels to reserve for random usage rather than reservations being allowed to reserve all channels. Also a nice safeguard for when someone screws up.
	var/static/random_channels_min = 50

	// Hey uh these two needs to be initialized fast because the whole "things get deleted before init" thing.
	/// Assoc list, `"[channel]" =` either the datum using it or TRUE for an unsafe-reserved (datumless reservation) channel
	var/list/using_channels
	/// Assoc list datum = list(channel1, channel2, ...) for what channels something reserved.
	var/list/using_channels_by_datum
	// Special datastructure for fast channel management
	/// List of all channels as numbers
	var/list/channel_list
	/// Associative list of all reserved channels associated to their position. `"[channel_number]" =` index as number
	var/list/reserved_channels
	/// lower iteration position - Incremented and looped to get "random" sound channels for normal sounds. The channel at this index is returned when asking for a random channel.
	var/channel_random_low
	/// higher reserve position - decremented and incremented to reserve sound channels, anything above this is reserved. The channel at this index is the highest unreserved channel.
	var/channel_reserve_high

/datum/controller/subsystem/sounds/Initialize()
	setup_available_channels()
	return ..()

/datum/controller/subsystem/sounds/proc/setup_available_channels()
	channel_list = list()
	reserved_channels = list()
	using_channels = list()
	using_channels_by_datum = list()
	for(var/i in 1 to using_channels_max)
		channel_list += i
	channel_random_low = 1
	channel_reserve_high = length(channel_list)

/// Removes a channel from using list.
/datum/controller/subsystem/sounds/proc/free_sound_channel(channel)
	var/text_channel = num2text(channel)
	var/using = using_channels[text_channel]
	using_channels -= text_channel
	if(using != TRUE) // datum channel
		using_channels_by_datum[using] -= channel
		if(!length(using_channels_by_datum[using]))
			stop_tracking_datum(using)

	free_channel(channel)

/// Frees all the channels a datum is using.
/datum/controller/subsystem/sounds/proc/free_datum_channels(datum/D)
	var/list/L = using_channels_by_datum[D]
	if(!L)
		return

	for(var/channel in L)
		using_channels -= num2text(channel)
		free_channel(channel)

	stop_tracking_datum(D)

/// Frees all datumless channels
/datum/controller/subsystem/sounds/proc/free_datumless_channels()
	free_datum_channels(DATUMLESS)

/// Reserve a sound channel. Free it later with free_sound_channel()
/datum/controller/subsystem/sounds/proc/reserve_sound_channel()
	. = reserve_channel()
	if(!.) //oh no..
		return FALSE

	var/text_channel = num2text(.)
	using_channels[text_channel] = DATUMLESS
	LAZYINITLIST(using_channels_by_datum[DATUMLESS])
	using_channels_by_datum[DATUMLESS] += .

/// Reserves a channel for a datum. Automatic cleanup only when the datum is deleted. Returns an integer for channel.
/datum/controller/subsystem/sounds/proc/reserve_sound_channel_for_datum(datum/D)
	if(!D) //i don't like typechecks but someone will fuck it up
		CRASH("Attempted to reserve sound channel without datum using the managed proc.")

	.= reserve_channel()
	if(!.)
		return FALSE

	var/text_channel = num2text(.)
	using_channels[text_channel] = D
	LAZYINITLIST(using_channels_by_datum[D])
	using_channels_by_datum[D] += .

	RegisterSignal(D, COMSIG_PARENT_QDELETING, PROC_REF(tracked_datum_deleted))

/**
 * Reserves a channel and updates the datastructure. Private proc.
 */
/datum/controller/subsystem/sounds/proc/reserve_channel()
	PRIVATE_PROC(TRUE)
	if(channel_reserve_high <= random_channels_min) // out of channels
		return
	var/channel = channel_list[channel_reserve_high]
	reserved_channels[num2text(channel)] = channel_reserve_high--
	return channel

/**
 * Frees a channel and updates the datastructure. Private proc.
 */
/datum/controller/subsystem/sounds/proc/free_channel(number)
	PRIVATE_PROC(TRUE)
	var/text_channel = num2text(number)
	var/index = reserved_channels[text_channel]
	if(!index)
		CRASH("Attempted to (internally) free a channel that wasn't reserved.")
	reserved_channels -= text_channel
	// push reserve index up, which makes it now on a channel that is reserved
	channel_reserve_high++
	// swap the reserved channel wtih the unreserved channel so the reserve index is now on an unoccupied channel and the freed channel is next to be used.
	channel_list.Swap(channel_reserve_high, index)
	// now, an existing reserved channel will likely (exception: unreserving last reserved channel) be at index
	// get it, and update position.
	var/text_reserved = num2text(channel_list[index])
	if(!reserved_channels[text_reserved]) //if it isn't already reserved make sure we don't accidently mistakenly put it on reserved list!
		return
	reserved_channels[text_reserved] = index

/// Random available channel, returns text.
/datum/controller/subsystem/sounds/proc/random_available_channel_text()
	if(channel_random_low > channel_reserve_high)
		channel_random_low = 1
	. = "[channel_list[channel_random_low++]]"

/// Random available channel, returns number
/datum/controller/subsystem/sounds/proc/random_available_channel()
	if(channel_random_low > channel_reserve_high)
		channel_random_low = 1
	. = channel_list[channel_random_low++]

/// How many channels we have left.
/datum/controller/subsystem/sounds/proc/available_channels_left()
	return length(channel_list) - random_channels_min

/datum/controller/subsystem/sounds/proc/stop_tracking_datum(datum/D)
	PRIVATE_PROC(TRUE)

	using_channels_by_datum -= D
	UnregisterSignal(D, COMSIG_PARENT_QDELETING)

/// Handles a tracked datum being deleted, automatically freeing the channels.
/datum/controller/subsystem/sounds/proc/tracked_datum_deleted(datum/source)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)

	free_datum_channels(source)

#undef DATUMLESS
