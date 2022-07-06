#define ATOM_IS_TEMPERATURE_SENSITIVE(A) (A && !QDELETED(A) && !(A.flags_2 & NO_TEMP_CHANGE_2))
#define ATOM_TEMPERATURE_EQUILIBRIUM_THRESHOLD 5
#define ATOM_TEMPERATURE_EQUILIBRIUM_CONSTANT 0.25

#define ADJUST_ATOM_TEMPERATURE(_atom, _temp) \
	_atom.temperature = _temp; \
	QUEUE_TEMPERATURE_ATOMS(_atom);

#define QUEUE_TEMPERATURE_ATOMS(_atoms) \
	if(islist(_atoms)) { \
		for(var/atom/A as anything in _atoms) { \
			if(ATOM_IS_TEMPERATURE_SENSITIVE(A)) { \
				START_PROCESSING(SSairatoms, A); \
			} \
		} \
	} else if(ATOM_IS_TEMPERATURE_SENSITIVE(_atoms)) { \
		START_PROCESSING(SSairatoms, _atoms); \
	}
