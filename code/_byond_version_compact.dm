// This file contains defines allowing targeting byond versions newer than the supported

//Update this whenever you need to take advantage of more recent byond features
#define MIN_COMPILER_VERSION 516
#define MIN_COMPILER_BUILD 1659
#if (DM_VERSION < MIN_COMPILER_VERSION || DM_BUILD < MIN_COMPILER_BUILD) && !defined(SPACEMAN_DMM) && !defined(OPENDREAM)
//Don't forget to update this part
#error Your version of BYOND is too out-of-date to compile this project. Go to https://secure.byond.com/download and update.
#error For a specific minimum version, check code/_byond_version_compact.dm
#endif

// Keep savefile compatibilty at minimum supported level
/savefile/byond_version = MIN_COMPILER_VERSION

// Backwards compatibility timebomb.
// if there are none, set this to 999 or something.
#if MIN_COMPILER_VERSION >= 517
#error MIN_COMPILER_VERSION Has been raised, please remove expired compatibility layers in _byond_version_compact.dm
#endif


// -- Backwards Compatibility duct tape
