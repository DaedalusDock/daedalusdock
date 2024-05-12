/datum/codex_category
	var/name = "Generic Category"
	var/desc = "Some description for category's codex entry"
	var/list/items = list()
	var/defer_population = FALSE
	var/guide_name
	var/guide_html
	var/link_columns = 0

/datum/codex_category/proc/get_category_link(datum/codex_entry/entry)
	return "This page is categorized under <span codexlink='[name] (category)'>[name]</span>."

//Children should call ..() at the end after filling the items list
/datum/codex_category/proc/Populate()
	SHOULD_CALL_PARENT(TRUE)

	if(!length(items))
		return

	var/lore_text = "<div style='text-align:center'>[desc]</div>" + "<hr>"
	if(guide_name && guide_html)
		lore_text += "This category has <span codexlink='Guide to [capitalize(guide_name || name)]'>an associated guide</span>.<hr>"

	items = sortTim(items, GLOBAL_PROC_REF(cmp_codex_name))

	var/list/links = list()
	for(var/datum/codex_entry/item_entry as anything in items)
		if(!istype(item_entry))
			stack_trace("Invalid item supplied to codex category Populate(): [item_entry]")
			continue

		var/starter = uppertext(copytext(strip_improper(item_entry.name), 1, 2))
		LAZYADD(links[starter], "<l>[item_entry.name]</l>")
		LAZYDISTINCTADD(item_entry.categories, src)

	var/list/link_cells = list()
	for(var/letter in GLOB.alphabet_upper)
		if(length(links[letter]))
			link_cells += "<td style='width:100%'><b><center>[letter]</center></b>\n<hr>\n<br>\n[jointext(links[letter], "\n<br>\n")]</td>\n"

	var/list/link_table = list("<table style='width:100%'>")
	var/link_counter = 0
	for(var/i = 1 to length(link_cells))
		if(link_counter == 0)
			link_table += "<tr style='width:100%'>"
		link_table += link_cells[i]
		if(link_counter == link_columns)
			link_table += "</tr>"
		link_counter++
		if(link_counter > link_columns)
			link_counter = 0

	if(link_counter != link_columns)
		link_table += "</tr>"
	link_table += "</table>"

	lore_text += jointext(link_table, "\n")
	var/datum/codex_entry/entry = new(
		_display_name = "[name] (category)",
		_lore_text = lore_text
	)
	// Categorize the categories.
	var/datum/codex_category/categories/cats_cat = SScodex.codex_categories[/datum/codex_category/categories]
	LAZYDISTINCTADD(entry.categories, cats_cat)
	LAZYDISTINCTADD(cats_cat.items, entry)

	if(guide_html)
		var/datum/codex_entry/guide_entry = new(
			_display_name = "Guide to [capitalize(guide_name || name)]",
			_mechanics_text = guide_html,
			_disambiguator = "guide"
		)
		LAZYDISTINCTADD(guide_entry.categories, src)
		// It's a guide so we track it.
		var/datum/codex_category/guides/guides_cat = SScodex.codex_categories[/datum/codex_category/guides]
		LAZYDISTINCTADD(guide_entry.categories, guides_cat)
		LAZYDISTINCTADD(guides_cat.items, guide_entry)
