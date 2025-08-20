/proc/render_stats(list/stats, user, sort = GLOBAL_PROC_REF(cmp_generic_stat_item_time))
	sortTim(stats, sort, TRUE)

	var/list/lines = list()

	for (var/entry in stats)
		var/list/data = stats[entry]
		lines += "[entry] => [num2text(data[STAT_ENTRY_TIME], 10)]ms ([data[STAT_ENTRY_COUNT]]) (avg:[num2text(data[STAT_ENTRY_TIME]/(data[STAT_ENTRY_COUNT] || 1), 99)])"

	if (user)
		var/datum/browser/browser = new(user, url_encode("stats:[REF(stats)]"))
		browser.set_content("<ol><li>[lines.Join("</li><li>")]</li></ol>")
		browser.open()

	. = lines.Join("\n")

/proc/stat_tracking_export_to_csv_later(filename, costs, counts)
	if (IsAdminAdvancedProcCall())
		return

	var/list/output = list()

	output += "key, cost, count"
	for (var/key in costs)
		output += "[replacetext(key, ",", "")], [costs[key]], [counts[key]]"

	rustg_file_write(output.Join("\n"), "[GLOB.log_directory]/[filename]")
