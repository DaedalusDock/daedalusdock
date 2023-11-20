//////////////////////////////////////////////////////////
//A bunch of helpers to make genetics less of a headache//
//////////////////////////////////////////////////////////

#define GET_INITIALIZED_MUTATION(A) GLOB.all_mutations[A]
#define GET_GENE_STRING(A, B) (B.mutation_index[A])
#define GET_SEQUENCE(A) (GLOB.full_sequences[A])
#define GET_MUTATION_TYPE_FROM_ALIAS(A) (GLOB.alias_mutations[A])

#define GET_MUTATION_STABILIZER(A) ((A.stabilizer_coeff < 0) ? 1 : A.stabilizer_coeff)
#define GET_MUTATION_SYNCHRONIZER(A) ((A.synchronizer_coeff < 0) ? 1 : A.synchronizer_coeff)
#define GET_MUTATION_POWER(A) ((A.power_coeff < 0) ? 1 : A.power_coeff)
#define GET_MUTATION_ENERGY(A) ((A.energy_coeff < 0) ? 1 : A.energy_coeff)

///Getter macro used to get the length of a identity block
#define GET_UI_BLOCK_LEN(blocknum) (GLOB.identity_block_lengths["[blocknum]"] || DNA_BLOCK_SIZE)
///Ditto, but for a feature.
#define GET_UF_BLOCK_LEN(blocknum) (GLOB.features_block_lengths["[blocknum]"] || DNA_BLOCK_SIZE)

/mob/proc/has_hair(include_bald = TRUE)
	return FALSE

///Does this mob have hair? Pass bald_is_false = TRUE to have "Bald" count as FALSE
/mob/living/carbon/human/has_hair(bald_is_false)
	var/obj/item/bodypart/head/myhead = get_bodypart(BODY_ZONE_HEAD)
	if(!myhead)
		return FALSE

	if(bald_is_false && (myhead.hair_style == "Bald"))
		return FALSE

	return (HAIR in myhead.species_flags_list) || (NONHUMANHAIR in myhead.species_flags_list)
