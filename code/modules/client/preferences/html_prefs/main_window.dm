/datum/preferences
	/// Stores the instance of the category we are viewing.
	var/datum/preference_group/category/selected_category

	var/character_name = ""

/datum/preferences/proc/html_new(client/C)
	selected_category = locate(/datum/preference_group/category/general) in GLOB.all_pref_groups

/datum/preferences/proc/html_topic(href, list/href_list)

	if(usr.client != parent)
		if(!check_rights())
			return

	if(href_list["change_slot"])
		change_character(usr)
		return TRUE


	if(href_list["select_category"])
		var/datum/preference_group/category/C = locate(href_list["select_category"]) in GLOB.all_pref_groups
		if(!C)
			return TRUE
		selected_category = C
		update_html()
		return TRUE

	if(href_list["pref_act"])
		var/datum/preference/P = GLOB.preference_entries[text2path(href_list["pref_act"])]
		if(!P)
			return TRUE
		if(P.clicked(usr, src))
			save_character()
			update_html()
		return TRUE

	/*if(href_list["close"])
		var/client/C = usr.client
		if(C)
			C.clear_character_previews()*/

/client/verb/dpref()
	usr.client.prefs.html_show(usr)

/datum/preferences/proc/html_show(mob/user)
	if(!user || !user.client)
		return

	var/content = {"
	<script type='text/javascript'>
		function update_content(data){
			document.getElementById('content').innerHTML = data;
		}
	</script>
	<div id='content'>[html_create_window(user)]</div>
	"}

	winshow(user, "preferences_window", TRUE)
	var/datum/browser/popup = new(user, "preferences_window", "<div align='center'>Character Setup</div>", 640, 770)
	popup.set_content(content)
	popup.open(FALSE)
	onclose(user, "preferences_window", src)

/datum/preferences/proc/html_create_window()
	. = list()
	. += "<fieldset class='computerPane' style='min-height:900px'>"
	. += "<legend class='computerLegend' style='margin: 0 auto'>[button_element(src, character_name, "change_slot=1")]</legend>"
	. += html_create_categories()
	. += "<div style='display:flex;flex-wrap:wrap'>"
	. += selected_category.get_content(src)
	. += "</div>"
	. += "</fieldset>"
	return jointext(., "")

/datum/preferences/proc/change_character()
	var/list/characters = create_character_profiles()

	var/chosen_slot = input(usr, "Change Character",, characters[default_slot]) as null|anything in characters
	if(!chosen_slot)
		return

	if(!characters.Find(chosen_slot))
		return

	default_slot = characters.Find(chosen_slot)
	character_name = chosen_slot
	update_html()

/datum/preferences/proc/html_create_categories()
	. = list()
	. += "<div style='text-align: center'>"
	for(var/datum/preference_group/category/P in GLOB.all_pref_groups)
		if(selected_category == P)
			. += "<span class='linkOn'>[P.name]</span>"
		else
			. += button_element(src, P.name, "select_category=\ref[P]")
	. += "</div><HR style='background-color: #202020'>"

	return jointext(., "")

