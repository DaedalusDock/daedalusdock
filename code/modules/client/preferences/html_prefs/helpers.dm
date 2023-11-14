/datum/preferences/proc/update_html()
	usr << output(url_encode(html_create_window()), "preferences_window.preferences_browser:update_content")
