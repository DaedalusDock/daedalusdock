
/proc/button_element(trg, text, action, class, style)
	return "<a href='?src=\ref[trg];[action]'[class ? "class='[class]'" : ""][style ? "style='[style]'" : ""]>[text]</a>"

/datum/preferences/proc/update_html()
	usr << output(url_encode(html_create_window()), "preferences_window.preferences_browser:update_content")
