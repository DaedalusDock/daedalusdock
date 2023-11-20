/// Data files. Doesn't really hold many important functionalities, here for organization.
/datum/computer_file/data
	/// Whether the user will be reminded that the file probably shouldn't be edited.
	var/do_not_edit = FALSE
	filetype = "DAT"

// /data/text files store data in string format.
// They don't contain other logic for now.
/datum/computer_file/data/text
	filetype = "TXT"
	/// Stored data in string format.
	var/stored_text = ""
	var/block_size = 250

/datum/computer_file/data/text/clone()
	var/datum/computer_file/data/text/temp = ..()
	temp.stored_text = stored_text
	return temp

// Calculates file size from amount of characters in saved string
/datum/computer_file/data/text/proc/calculate_size()
	size = max(1, round(length(stored_text) / block_size))

/datum/computer_file/data/text/logfile
	filetype = "LOG"

/**
 * Ordnance data
 * Holds possible experiments to do
 */
/datum/computer_file/data/ordnance
	filetype = "ORD"
	size = 4

	/// List of experiments filtered by doppler array or populated by the tank compressor. Experiment path as key, score as value.
	var/list/possible_experiments

/datum/computer_file/data/ordnance/proc/return_data()
	return null

/datum/computer_file/data/ordnance/clone()
	var/datum/computer_file/data/ordnance/temp = ..()
	temp.possible_experiments = possible_experiments
	return temp

/**
 * Explosive data
 * Holds a specific taychon record.
 */
/datum/computer_file/data/ordnance/explosive
	filetype = "DOP"
	/// Tachyon record, used for an explosive experiment.
	var/datum/data/tachyon_record/explosion_record

/datum/computer_file/data/ordnance/explosive/return_data()
	return explosion_record

/datum/computer_file/data/ordnance/explosive/clone()
	var/datum/computer_file/data/ordnance/explosive/temp = ..()
	temp.explosion_record = explosion_record
	return temp

/**
 * Gaseous data
 * Holds a specific compressor record.
 */
/datum/computer_file/data/ordnance/gaseous
	filetype = "COM"
	///The gas record stored in the file.
	var/datum/data/compressor_record/gas_record

/datum/computer_file/data/ordnance/gaseous/return_data()
	return gas_record

/datum/computer_file/data/ordnance/gaseous/clone()
	var/datum/computer_file/data/ordnance/gaseous/temp = ..()
	temp.gas_record = gas_record
	return temp
