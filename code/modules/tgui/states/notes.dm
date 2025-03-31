/**
 * tgui state: notes_state
 *
 * Checks that the user is the owner of the note panel datum.
 */

GLOBAL_DATUM_INIT(notes_state, /datum/ui_state/notes, new)

/datum/ui_state/notes/can_use_topic(src_object, mob/user)
	var/datum/note_panel/notes_panel = src_object
	if(notes_panel.mind_reference.current != user)
		return UI_CLOSE
	return UI_INTERACTIVE
