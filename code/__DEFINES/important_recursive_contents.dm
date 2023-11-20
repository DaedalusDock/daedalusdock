///the area channel of the important_recursive_contents list, everything in here will be sent a signal when their last holding object changes areas
#define RECURSIVE_CONTENTS_AREA_SENSITIVE "recursive_contents_area_sensitive"
///the hearing channel of the important_recursive_contents list, everything in here will count as a hearing atom
#define RECURSIVE_CONTENTS_HEARING_SENSITIVE "recursive_contents_hearing_sensitive"
///the client mobs channel of the important_recursive_contents list, everything in here will be a mob with an attached client
///this is given to both a clients mob, and a clients eye, both point to the clients mob
#define RECURSIVE_CONTENTS_CLIENT_MOBS "recursive_contents_client_mobs"
///the parent of storage components currently shown to some client mob get this. gets removed when nothing is viewing the parent
#define RECURSIVE_CONTENTS_ACTIVE_STORAGE "recursive_contents_active_storage"
///this is given to radio listeners of any channel that ISN'T FREQ_ATMOS_CONTROL
#define RECURSIVE_CONTENTS_RADIO_NONATMOS "recursive_contents_radio_nonatmos"
///this is given to radio listents of SPECIFICALLY FREQ_ATMOS_CONTROL
#define RECURSIVE_CONTENTS_RADIO_ATMOS "recursive_contents_radio_atmos"
