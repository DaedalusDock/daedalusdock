/// An icon state information for GAGS system
/datum/greyscale_state
	/// Flags for the bitmasking configuration
	var/bitmask_config = NONE
	var/default_state_if_bitmask = FALSE
	/// List of `/datum/greyscale_layer`
	var/list/layers

/datum/greyscale_state/New(layers, bitmask_config, default_state_if_bitmask)
	src.layers = layers
	src.bitmask_config = bitmask_config
