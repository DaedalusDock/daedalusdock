/// Sent when /datum/storage/dump_content_at(): (obj/item/storage_source, mob/user)
#define COMSIG_STORAGE_DUMP_CONTENT "storage_dump_contents"
	/// Return to stop the standard dump behavior.
	#define STORAGE_DUMP_HANDLED (1<<0)

/// Sent after /datum/storage/attempt_insert(): (obj/item/inserted, mob/user, override, force)
#define COMSIG_STORAGE_INSERTED_ITEM "storage_inserted_item"

/// Sent when /datum/storage/open_storage(): (mob/to_show, performing_quickdraw)
#define COMSIG_STORAGE_ATTEMPT_OPEN "storage_attempt_open"
	/// Interrupt the opening.
	#define STORAGE_INTERRUPT_OPEN (1<<0)

/// Sent when /datum/storage/can_insert(): (obj/item/to_insert, mob/user, messages, force)
#define COMSIG_STORAGE_CAN_INSERT "storage_can_insert"
	/// Disallow the insertion.
	#define STORAGE_NO_INSERT (1<<0)
