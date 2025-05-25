/datum/directive/import_tax
	name = "Import Tax"

	severity = DIRECTIVE_SEVERITY_MED

	reward = 3000

	var/tax_low = 15
	var/tax_high = 45

	var/final_tax

/datum/directive/import_tax/New()
	..()
	final_tax = rand(tax_low, tax_high)
	desc = "All imported goods have a [final_tax]% tax applied."

/datum/directive/import_tax/start()
	. = ..()
	SSeconomy.pack_price_modifier -= final_tax / 100

/datum/directive/import_tax/end(successful)
	. = ..()
	SSeconomy.pack_price_modifier += final_tax / 100

/datum/directive/import_tax/get_announce_start_text()
	return "All imported goods have a [final_tax]% tax applied."

/datum/directive/import_tax/get_announce_end_text(successful)
	return "The import tax has been lifted."
