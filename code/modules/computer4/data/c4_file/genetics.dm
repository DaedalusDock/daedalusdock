/datum/c4_file/gene_buffer
	name = "gbuf"
	extension = "BUF"

	size = 2

	var/list/buffer_data

/datum/c4_file/gene_buffer/New(list/new_buf)
	. = ..()
	if(!new_buf)
		new_buf = list()
	buffer_data = new_buf

/datum/c4_file/gene_buffer/to_string()
	return "--PLACEHOLDER--"

/datum/c4_file/gene_buffer/copy()
	var/datum/c4_file/gene_buffer/clone = ..()
	clone.buffer_data = buffer_data.Copy()
	return clone

/datum/c4_file/gene_mutation_db
	name = "mutate"
	extension = "MDB"

	size = 4

	var/list/datum/mutation/human/stored_mutations

/datum/c4_file/gene_mutation_db/New(list/datum/mutation/human/new_buf)
	if(!new_buf)
		new_buf = list()
	stored_mutations = new_buf

/datum/c4_file/gene_mutation_db/copy()
	var/datum/c4_file/gene_mutation_db/clone = ..()
	clone.stored_mutations = stored_mutations.Copy()
	return clone
