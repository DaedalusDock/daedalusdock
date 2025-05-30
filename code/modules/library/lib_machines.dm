/* Library Machines
 *
 * Contains:
 * Borrowbook datum
 * Library Public Computer
 * Book Info datum
 * Library Computer
 * Library Scanner
 * Book Binder
 */

#define DEFAULT_UPLOAD_CATAGORY "Fiction"
#define DEFAULT_SEARCH_CATAGORY "Any"

///How many books should we load per page?
#define BOOKS_PER_PAGE 18
///How many checkout records should we load per page?
#define CHECKOUTS_PER_PAGE 17
///How many inventory items should we load per page?
#define INVENTORY_PER_PAGE 19
/*
 * Library Public Computer
 */
/obj/machinery/computer/libraryconsole
	name = "library visitor console"
	icon_state = "oldcomp"
	icon_screen = "library"
	icon_keyboard = null
	circuit = /obj/item/circuitboard/computer/libraryconsole
	desc = "Checked out books MUST be returned on time."
	///The current title we're searching for
	var/title = ""
	///The category we're searching for
	var/category = ""
	///The author we're searching for
	var/author = ""
	///The results of our last query
	var/list/page_content = list()
	///The the total pages last we checked
	var/page_count = 0
	///The page of our current query
	var/search_page = 0
	///Can we connect to the db?
	var/can_connect = FALSE
	///A hash of the last search we did, prevents spam in a different way then the cooldown
	var/last_search_hash = ""
	///Have the search params changed at all since the last search?
	var/params_changed = FALSE
	///Are we currently sending a db request for books?
	var/sending_request = FALSE
	///Prevents spamming requests, acts as a second layer of protection against spam
	COOLDOWN_DECLARE(db_request_cooldown)
	///Interface name for the ui_interact call for different subtypes.
	var/interface_type = "LibraryVisitor"

/obj/machinery/computer/libraryconsole/Initialize(mapload)
	. = ..()
	category = DEFAULT_SEARCH_CATAGORY
	INVOKE_ASYNC(src, PROC_REF(update_db_info))

/obj/machinery/computer/libraryconsole/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, interface_type)
		ui.open()

/obj/machinery/computer/libraryconsole/ui_data(mob/user)
	var/list/data = list()
	data["can_db_request"] = can_db_request()
	data["search_categories"] = SSlibrary.search_categories
	data["category"] = category
	data["author"] = author
	data["title"] = title
	data["page_count"] = page_count + 1 //Increase these by one so it looks like we're not indexing at 0
	data["our_page"] = search_page + 1
	data["pages"] = page_content
	data["can_connect"] = can_connect
	data["params_changed"] = params_changed
	return data

/obj/machinery/computer/libraryconsole/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("set_search_title")
			var/newtitle = params["title"]
			if(newtitle != title)
				params_changed = TRUE
			title = newtitle
			return TRUE
		if("set_search_category")
			var/newcategory = params["category"]
			if(!(newcategory in SSlibrary.search_categories)) //Nice try
				newcategory = DEFAULT_SEARCH_CATAGORY
			if(newcategory != category)
				params_changed = TRUE
			category = newcategory
			return TRUE
		if("set_search_author")
			var/newauthor = params["author"]
			if(newauthor != author)
				params_changed = TRUE
			author = newauthor
			return TRUE
		if("search")
			if(!prevent_db_spam())
				say("Database cables refreshing. Please wait a moment.")
				return
			INVOKE_ASYNC(src, PROC_REF(update_db_info))
			return TRUE
		if("switch_page")
			if(!prevent_db_spam())
				say("Database cables refreshing. Please wait a moment.")
				return
			search_page = sanitize_page_input(params["page"], search_page, page_count)
			INVOKE_ASYNC(src, PROC_REF(update_db_info))
			return TRUE
		if("clear_data") //The cap just walked in on your browsing, quick! delete it!
			if(!prevent_db_spam())
				say("Database cables refreshing. Please wait a moment.")
				return
			title = initial(title)
			author = initial(author)
			category = DEFAULT_SEARCH_CATAGORY
			search_page = 0
			INVOKE_ASYNC(src, PROC_REF(update_db_info))
			return TRUE

///Checks if the machine is alloweed to make another db request yet. TRUE if so, FALSE otherwise
/obj/machinery/computer/libraryconsole/proc/prevent_db_spam()
	var/allowed = can_db_request()
	if(!allowed)
		return FALSE
	COOLDOWN_START(src, db_request_cooldown, 1 SECONDS)
	return TRUE

/obj/machinery/computer/libraryconsole/proc/can_db_request()
	if(sending_request) //Absolutely not
		return FALSE
	if(!COOLDOWN_FINISHED(src, db_request_cooldown))
		return FALSE
	return TRUE

///Returns a santized page input, so converted from num/text to num, and properly maxed
/obj/machinery/computer/libraryconsole/proc/sanitize_page_input(input, default, max)
	input = convert_ambiguous_input(input, default + 1) // + 1 to invert the below reasons
	//We expect the search page to be one greater then it should be, because we're lying about indexing at 1
	return clamp(input - 1, 0, max)

///Takes input that could either be a number, or a string that represents a number and returns a number
/obj/machinery/computer/libraryconsole/proc/convert_ambiguous_input(input, default)
	if(isnum(input))
		return input
	if(!istext(input))
		return default
	var/hidden_number = text2num(input)
	if(!isnum(hidden_number))
		return default
	return hidden_number

/obj/machinery/computer/libraryconsole/proc/update_db_info()
	if(!has_anything_changed()) //You're not allowed to make the same search twice, waste of resources
		return
	if (!SSdbcore.Connect())
		can_connect = FALSE
		page_count = 0
		page_content = list()
		return
	can_connect = TRUE
	params_changed = FALSE
	last_search_hash = hash_search_info()

	update_page_count()
	update_page_contents()
	SStgui.update_uis(src) //We need to do this because we sleep here, so we've gotta update manually

//Returns true if there's been an update worth refreshing our pages for, false otherwise
/obj/machinery/computer/libraryconsole/proc/has_anything_changed()
	if(last_search_hash == hash_search_info())
		return FALSE
	return TRUE

/obj/machinery/computer/libraryconsole/proc/hash_search_info()
	return "[title]-[author]-[category]-[search_page]-[page_count]"

/obj/machinery/computer/libraryconsole/proc/update_page_contents()
	if(sending_request) //Final defense against nerds spamming db requests
		return
	sending_request = TRUE
	search_page = clamp(search_page, 0, page_count)
	var/datum/db_query/query_library_list_books = SSdbcore.NewQuery({"
		SELECT author, title, category, id
		FROM [format_table_name("library")]
		WHERE isnull(deleted)
			AND author LIKE CONCAT('%',:author,'%')
			AND title LIKE CONCAT('%',:title,'%')
			AND (:category = 'Any' OR category = :category)
		ORDER BY id DESC
		LIMIT :skip, :take
	"}, list("author" = author, "title" = title, "category" = category, "skip" = BOOKS_PER_PAGE * search_page, "take" = BOOKS_PER_PAGE))

	var/query_succeeded = query_library_list_books.Execute()
	sending_request = FALSE
	page_content.Cut()
	if(!query_succeeded)
		qdel(query_library_list_books)
		return
	while(query_library_list_books.NextRow())
		page_content += list(list(
			"author" = html_decode(query_library_list_books.item[1]),
			"title" = html_decode(query_library_list_books.item[2]),
			"category" = query_library_list_books.item[3],
			"id" = query_library_list_books.item[4]
		))
	qdel(query_library_list_books)

/obj/machinery/computer/libraryconsole/proc/update_page_count()
	var/bookcount = 0
	var/datum/db_query/query_library_count_books = SSdbcore.NewQuery({"
		SELECT COUNT(id) FROM [format_table_name("library")]
		WHERE isnull(deleted)
			AND author LIKE CONCAT('%',:author,'%')
			AND title LIKE CONCAT('%',:title,'%')
			AND (:category = 'Any' OR category = :category)
	"}, list("author" = author, "title" = title, "category" = category))

	if(!query_library_count_books.warn_execute())
		qdel(query_library_count_books)
		return
	if(query_library_count_books.NextRow())
		bookcount = text2num(query_library_count_books.item[1])
	qdel(query_library_count_books)

	page_count = round(max(bookcount - 1, 0) / BOOKS_PER_PAGE) //This is just floor()
	search_page = clamp(search_page, 0, page_count)

/*
 * Borrowbook datum
 */
/datum/borrowbook // Datum used to keep track of who has borrowed what when and for how long.
	var/datum/book_info/book_data
	var/loanedto
	var/checkout
	var/duedate

#define PRINTER_COOLDOWN 6 SECONDS
#define LIBRARY_NEWSFEED "Station Book Club"
//The different states the computer can be in, only send the info we need yeah?
#define LIBRARY_INVENTORY 1
#define LIBRARY_CHECKOUT 2
#define LIBRARY_ARCHIVE 3
#define LIBRARY_UPLOAD 4
#define LIBRARY_PRINT 5
#define LIBRARY_TOP_SNEAKY 6
#define MIN_LIBRARY LIBRARY_INVENTORY
#define MAX_LIBRARY LIBRARY_TOP_SNEAKY

/*
 * Library Computer
 * After 860 days, it's finally a buildable computer.
 */
// TODO: Make this an actual /obj/machinery/computer that can be crafted from circuit boards and such
// It is August 22nd, 2012... This TODO has already been here for months.. I wonder how long it'll last before someone does something about it.
// It's December 25th, 2014, and this is STILL here, and it's STILL relevant. Kill me
/obj/machinery/computer/libraryconsole/bookmanagement
	name = "book inventory management console"
	desc = "Librarian's command station."
	verb_say = "beeps"
	verb_ask = "beeps"
	verb_exclaim = "beeps"
	pass_flags = PASSTABLE

	icon_state = "oldcomp"
	icon_screen = "library"
	icon_keyboard = null
	circuit = /obj/item/circuitboard/computer/libraryconsole
	interface_type = "LibraryConsole"
	///Can spawn secret lore item
	var/can_spawn_lore = TRUE
	///The screen we're currently on, sent to the ui
	var/screen_state = LIBRARY_INVENTORY
	///Should we show the buttons required for changing screens?
	var/show_dropdown = TRUE
	///The name of the book being checked out
	var/datum/book_info/buffer_book
	///List of checked out books, /datum/borrowbook
	var/list/checkouts = list()
	///The current max amount of checkout pages allowed
	var/checkout_page_count = 0
	///The current page we're on in the checkout listing
	var/checkout_page = 0
	///List of book info datums to display to the user as our "inventory"
	var/list/inventory = list()
	///The current max amount of inventory pages allowed
	var/inventory_page_count = 0
	///The current page we're on in the inventory
	var/inventory_page = 0
	///Should we load our inventory from the bookselves in our area?
	var/dynamic_inv_load = FALSE
	///Toggled if some bit of code wants to override hashing and allow for page updates
	var/ignore_hash = FALSE
	///Book scanner that will be used when uploading books to the Archive
	var/datum/weakref/scanner
	///Our cooldown on using the printer
	COOLDOWN_DECLARE(printer_cooldown)

/obj/machinery/computer/libraryconsole/bookmanagement/Initialize(mapload)
	. = ..()
	if(mapload)
		dynamic_inv_load = TRUE //Only load in stuff if we were placed during mapload

/obj/machinery/computer/libraryconsole/bookmanagement/ui_data(mob/user)
	var/list/data = list()
	data["can_db_request"] = can_db_request()
	data["screen_state"] = screen_state
	data["show_dropdown"] = show_dropdown
	data["display_lore"] = (obj_flags & EMAGGED && can_spawn_lore)
	if(dynamic_inv_load) //Time to load those area books in
		dynamic_inv_load = FALSE
		load_nearby_books()

	switch(screen_state)
		if(LIBRARY_INVENTORY)
			data["inventory"] = list()
			var/inventory_len = length(inventory)
			if(inventory_len)
				for(var/id in ((INVENTORY_PER_PAGE * inventory_page) + 1) to min(INVENTORY_PER_PAGE * (inventory_page + 1), inventory_len))
					var/book_ref = inventory[id]
					var/datum/book_info/info = inventory[book_ref]
					data["inventory"] += list(list(
						"id" = id,
						"ref" = book_ref,
						"title" = info.get_title(),
						"author" = info.get_author(),
					))
			data["has_inventory"] = !!inventory_len
			data["inventory_page"] = inventory_page + 1
			data["inventory_page_count"] = inventory_page_count + 1

		if(LIBRARY_CHECKOUT)
			data["checkouts"] = list()
			var/checkout_len = length(checkouts)
			if(checkout_len)
				for(var/id in ((CHECKOUTS_PER_PAGE * checkout_page) + 1) to min(CHECKOUTS_PER_PAGE * (checkout_page + 1), checkout_len))
					var/checkout_ref = checkouts[id]
					var/datum/borrowbook/loan = checkouts[checkout_ref]
					var/timedue = (loan.duedate - world.time) / (1 MINUTES)
					timedue = max(round(timedue, 0.1), 0)
					data["checkouts"] += list(list(
						"id" = id,
						"ref" = checkout_ref,
						"borrower" = loan.loanedto || "N/A",
						"overdue" = (timedue <= 0),
						"due_in_minutes" = timedue,
						"title" = loan.book_data.get_title(),
						"author" = loan.book_data.get_author()
					))
			data["checking_out"] = buffer_book?.get_title()
			data["has_checkout"] = !!checkout_len
			data["checkout_page"] = checkout_page + 1
			data["checkout_page_count"] = checkout_page_count + 1

		//Copypasta from the visitor console
		if(LIBRARY_ARCHIVE)
			data |= ..() //I am so sorry

		if(LIBRARY_UPLOAD)
			data["upload_categories"] = SSlibrary.upload_categories
			data["default_category"] = DEFAULT_UPLOAD_CATAGORY
			var/obj/machinery/libraryscanner/scan = get_scanner()
			data["has_scanner"] = !!(scan)
			data["has_cache"] = !!(scan?.cache)
			if(scan?.cache)
				data["cache_title"] = scan.cache.get_title()
				data["cache_author"] = scan.cache.get_author()
				data["cache_content"] = scan.cache.get_content()

		if(LIBRARY_PRINT)
			data["deity"] = GLOB.deity || DEFAULT_DEITY
			var/reigion = GLOB.religion || DEFAULT_RELIGION
			data["religion"] = reigion
			var/bible_name = GLOB.bible_name
			if(!bible_name)
				bible_name = DEFAULT_BIBLE_REPLACE(reigion)
			data["bible_name"] = bible_name
			data["bible_sprite"] = "display-[GLOB.bible_icon_state || "bible"]"
			data["posters"] = list()
			for(var/poster_name in SSlibrary.printable_posters)
				data["posters"] += poster_name

	return data

/obj/machinery/computer/libraryconsole/bookmanagement/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/spritesheet/bibles))

/obj/machinery/computer/libraryconsole/bookmanagement/proc/load_nearby_books()
	for(var/datum/book_info/book as anything in SSlibrary.get_area_books(get_area(src)))
		inventory[ref(book)] = book
	inventory_update()

/obj/machinery/computer/libraryconsole/bookmanagement/proc/get_scanner(viewrange)
	if(scanner)
		var/obj/machinery/libraryscanner/potential_scanner = scanner.resolve()
		if(potential_scanner)
			return potential_scanner
		scanner = null

	for(var/obj/machinery/libraryscanner/foundya in range(viewrange, get_turf(src)))
		scanner = WEAKREF(foundya)
		return foundya

/obj/machinery/computer/libraryconsole/bookmanagement/ui_act(action, params)
	//The parent call takes care of stuff like searching, don't forget about that yeah?
	. = ..()
	if(.)
		return
	switch(action)
		if("set_screen")
			var/window = params["screen_index"]
			set_screen_state(window)
			return TRUE
		if("toggle_dropdown")
			show_dropdown = !show_dropdown
			return TRUE
		if("inventory_remove")
			var/id = params["book_id"]
			inventory -= id
			inventory_update()
			return TRUE
		if("switch_inventory_page")
			inventory_page = sanitize_page_input(params["page"], inventory_page, inventory_page_count)
			inventory_update()
			return TRUE
		if("checkout")
			var/datum/borrowbook/loan = new /datum/borrowbook
			var/datum/book_info/book_data = buffer_book?.return_copy() || new /datum/book_info

			book_data.set_title(params["book_name"])
			var/loan_to = copytext(sanitize(params["loaned_to"]), 1, MAX_NAME_LEN)
			var/checkoutperiod = max(params["checkout_time"], 1)

			loan.book_data = book_data.return_copy()
			loan.loanedto = loan_to
			loan.checkout = world.time
			loan.duedate = world.time + (checkoutperiod MINUTES)
			checkouts[ref(loan)] = loan
			checkout_update()
			return TRUE
		if("checkin")
			var/id = params["checked_out_id"]
			checkouts -= id
			checkout_update()
			return TRUE
		if("switch_checkout_page")
			checkout_page = sanitize_page_input(params["page"], checkout_page, checkout_page_count)
			checkout_update()
			return TRUE
		if("set_cache_title")
			var/obj/machinery/libraryscanner/scan = get_scanner()
			if(scan?.cache && params["title"])
				scan.cache.set_title(params["title"])
			return TRUE
		if("set_cache_author")
			var/obj/machinery/libraryscanner/scan = get_scanner()
			if(scan?.cache && params["author"])
				scan.cache.set_author(params["author"])
			return TRUE
		if("upload")
			if(!prevent_db_spam())
				say("Database cables refreshing. Please wait a moment.")
				return
			var/upload_category = params["category"]
			if(!(upload_category in SSlibrary.upload_categories)) //Nice try
				upload_category = DEFAULT_UPLOAD_CATAGORY

			INVOKE_ASYNC(src, PROC_REF(upload_from_scanner), upload_category)
			return TRUE
		if("news_post")
			if(!GLOB.news_network)
				say("No news network found on station. Aborting.")
			var/channelexists = FALSE
			for(var/datum/feed_channel/feed in GLOB.news_network.network_channels)
				if(feed.channel_name == LIBRARY_NEWSFEED)
					channelexists = TRUE
					break
			if(!channelexists)
				GLOB.news_network.create_feed_channel(LIBRARY_NEWSFEED, "Library", "The official station book club!", null)

			var/obj/machinery/libraryscanner/scan = get_scanner()
			if(!scan)
				say("No nearby scanner detected. Aborting.")
				return
			GLOB.news_network.submit_article(scan.cache.content, "[scan.cache.author]: [scan.cache.title]", LIBRARY_NEWSFEED, null)
			say("Upload complete. Your uploaded title is now available on station newscasters.")
			return TRUE
		if("print_book")
			var/id = params["book_id"]
			attempt_print(CALLBACK(src, PROC_REF(print_book), id))
			return TRUE
		if("print_bible")
			attempt_print(CALLBACK(src, PROC_REF(print_bible)))
			return TRUE
		if("print_poster")
			var/poster_name = params["poster_name"]
			attempt_print(CALLBACK(src, PROC_REF(print_poster), poster_name))
			return TRUE
		if("lore_spawn")
			if(obj_flags & EMAGGED && can_spawn_lore)
				print_forbidden_lore(usr)
			set_screen_state(MIN_LIBRARY)
			return TRUE
		if("lore_deny")
			if(obj_flags & EMAGGED && can_spawn_lore)
				shun_the_corp(usr)
			set_screen_state(MIN_LIBRARY)
			return TRUE

/obj/machinery/computer/libraryconsole/bookmanagement/attackby(obj/item/W, mob/user, params)
	if(!istype(W, /obj/item/barcodescanner))
		return ..()
	var/obj/item/barcodescanner/scanner = W
	scanner.computer_ref = WEAKREF(src)
	to_chat(user, span_notice("[scanner]'s associated machine has been set to [src]."))
	audible_message(span_hear("[src] lets out a low, short blip."))

	if(!scanner.book_data)
		return

	var/datum/book_info/scanner_book = scanner.book_data.return_copy()
	switch(scanner.mode)
		if(1)
			buffer_book = scanner_book
			to_chat(user, span_notice("[scanner]'s screen flashes: 'Book title stored in computer buffer.'"))
		if(2)
			for(var/checkout_ref in checkouts)
				var/datum/borrowbook/maybe_ours = checkouts[checkout_ref]
				if(!scanner_book.compare(maybe_ours.book_data))
					continue
				checkouts -= checkout_ref
				checkout_update()
				to_chat(user, span_notice("[scanner]'s screen flashes: 'Book has been checked in.'"))
				return

			to_chat(user, span_notice("[scanner]'s screen flashes: 'No active check-out record found for current title.'"))
		if(3)
			inventory[ref(scanner_book)] = scanner_book
			inventory_update()
			to_chat(user, span_notice("[scanner]'s screen flashes: 'Title added to general inventory.'"))

/obj/machinery/computer/libraryconsole/bookmanagement/emag_act(mob/user)
	if(!density)
		return
	obj_flags |= EMAGGED

/obj/machinery/computer/libraryconsole/bookmanagement/has_anything_changed()
	if(..())
		return TRUE
	if(!ignore_hash)
		return FALSE
	ignore_hash = FALSE
	return TRUE

/obj/machinery/computer/libraryconsole/bookmanagement/proc/set_screen_state(new_state)
	screen_state = clamp(new_state, MIN_LIBRARY, MAX_LIBRARY)

/obj/machinery/computer/libraryconsole/bookmanagement/proc/inventory_update()
	inventory_page_count = round(max(length(inventory) - 1, 0) / INVENTORY_PER_PAGE) //This is just floor()
	inventory_page = clamp(inventory_page, 0, inventory_page_count)

/obj/machinery/computer/libraryconsole/bookmanagement/proc/checkout_update()
	checkout_page_count = round(max(length(checkouts) - 1, 0) / CHECKOUTS_PER_PAGE) //This is just floor()
	checkout_page = clamp(checkout_page, 0, checkout_page_count)

/obj/machinery/computer/libraryconsole/bookmanagement/proc/print_forbidden_lore(mob/user)
	can_spawn_lore = FALSE
	new /obj/item/melee/cultblade/dagger(get_turf(src))
	to_chat(user, span_warning("Your sanity barely endures the seconds spent in the vault's browsing window. The only thing to remind you of this when you stop browsing is a sinister dagger sitting on the desk. You don't even remember where it came from..."))
	user.visible_message(span_warning("[user] stares at the blank screen for a few moments, [user.p_their()] expression frozen in fear. When [user.p_they()] finally awaken[user.p_s()] from it, [user.p_they()] look[user.p_s()] a lot older."), vision_distance = 2)
	if(ishuman(user))
		var/mob/living/carbon/human/fool = user
		fool.age = clamp(fool.age + 10, AGE_MIN, AGE_MAX) //Fuck you

/obj/machinery/computer/libraryconsole/bookmanagement/proc/shun_the_corp(mob/user)
	can_spawn_lore = FALSE
	to_chat(user, span_warning("You click off the page in a rush, and the machine hums back to normal, the tab gone..."))

/obj/machinery/computer/libraryconsole/bookmanagement/proc/upload_from_scanner(upload_category)
	var/obj/machinery/libraryscanner/scan = get_scanner()
	if(!scan)
		say("No nearby scanner detected.")
		return
	if(!scan.cache)
		say("No cached book found. Aborting upload.")
		return
	if (!SSdbcore.Connect())
		say("Connection to Archive has been severed. Aborting.")
		return
	var/datum/book_info/book = scan.cache
	if(!book.title)
		say("No title detected. Aborting")
		return
	if(!book.author)
		say("No author detected. Aborting")
		return
	if(!book.content)
		say("No content detected. Aborting")
		return
	var/msg = "[key_name(usr)] has uploaded the book titled [book.title], [length(book.content)] signs"
	var/datum/db_query/query_library_upload = SSdbcore.NewQuery({"
		INSERT INTO [format_table_name("library")] (author, title, content, category, ckey, datetime, round_id_created)
		VALUES (:author, :title, :content, :category, :ckey, Now(), :round_id)
	"}, list("title" = book.title, "author" = book.author, "content" = book.content, "category" = upload_category, "ckey" = usr.ckey, "round_id" = GLOB.round_id))
	if(!query_library_upload.Execute())
		qdel(query_library_upload)
		say("Database error encountered uploading to Archive")
		return
	log_game(msg)
	qdel(query_library_upload)
	say("Upload Complete. Uploaded title will be available for printing in a moment")
	ignore_hash = TRUE
	update_db_info()

/// Call this proc to attempt a print. It will return false if the print failed, true otherwise, longside some ux
/// Accepts a callback to call when the print "finishes"
/obj/machinery/computer/libraryconsole/bookmanagement/proc/attempt_print(datum/callback/call_after)
	if(!COOLDOWN_FINISHED(src, printer_cooldown))
		say("Printer currently unavailable, please wait a moment.")
		return FALSE
	COOLDOWN_START(src, printer_cooldown, PRINTER_COOLDOWN)
	playsound(src, 'sound/machines/printer.ogg', 50)
	addtimer(call_after, 4.1 SECONDS)
	return TRUE

/obj/machinery/computer/libraryconsole/bookmanagement/proc/print_bible()
	var/obj/item/storage/book/bible/holy_book = new(loc)
	if(!GLOB.bible_icon_state || !GLOB.bible_inhand_icon_state)
		return
	holy_book.icon_state = GLOB.bible_icon_state
	holy_book.inhand_icon_state = GLOB.bible_inhand_icon_state
	holy_book.name = GLOB.bible_name
	holy_book.deity_name = GLOB.deity

/obj/machinery/computer/libraryconsole/bookmanagement/proc/print_poster(poster_name)
	var/poster_type = SSlibrary.printable_posters[poster_name]
	if(!poster_type)
		return

	var/obj/item/poster/random_official/poster = new(loc, new poster_type)
	poster.name = poster_name

/obj/machinery/computer/libraryconsole/bookmanagement/proc/print_book(id)
	if (!SSdbcore.Connect())
		say("Connection to Archive has been severed. Aborting.")
		can_connect = FALSE
		return

	var/datum/db_query/query_library_print = SSdbcore.NewQuery(
		"SELECT * FROM [format_table_name("library")] WHERE id=:id AND isnull(deleted)",
		list("id" = id)
	)
	if(!query_library_print.Execute())
		qdel(query_library_print)
		say("PRINTER ERROR! Failed to print document (0x0000000F)")
		return

	while(query_library_print.NextRow())
		var/author = query_library_print.item[2]
		var/title = query_library_print.item[3]
		var/content = query_library_print.item[4]
		if(!QDELETED(src))
			var/obj/item/book/printed_book = new(get_turf(src))
			printed_book.name = "Book: [title]"
			printed_book.book_data = new()
			var/datum/book_info/fill = printed_book.book_data
			fill.set_title(title, trusted = TRUE)
			fill.set_author(author, trusted = TRUE)
			fill.set_content(content, trusted = TRUE)
			printed_book.gen_random_icon_state()
			visible_message(span_notice("[src]'s printer hums as it produces a completely bound book. How did it do that?"))
		break
	qdel(query_library_print)

/*
 * Library Scanner
 */
/obj/machinery/libraryscanner
	name = "scanner control interface"
	icon = 'icons/obj/library.dmi'
	icon_state = "bigscanner"
	desc = "It's an industrial strength book scanner. Perfect!"
	density = TRUE
	var/obj/item/book/held_book
	///Our scanned-in book
	var/datum/book_info/cache

/obj/machinery/libraryscanner/Destroy()
	held_book = null
	cache = null
	return ..()

/obj/machinery/libraryscanner/attackby(obj/hitby, mob/user, params)
	if(istype(hitby, /obj/item/book))
		user.transferItemToLoc(hitby, src)
		if(held_book)
			user.put_in_hands(held_book)
		held_book = hitby
		playsound(src, 'sound/machines/eject.ogg', 70)
		return TRUE
	return ..()

/obj/machinery/libraryscanner/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == held_book)
		held_book = null

/obj/machinery/libraryscanner/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LibraryScanner")
		ui.open()

/obj/machinery/libraryscanner/ui_data()
	var/list/data = list()
	var/list/cached_info = list()
	data["has_book"] = !!held_book
	data["has_cache"] = !!cache
	if(cache)
		cached_info["title"] = cache.get_title()
		cached_info["author"] = cache.get_author()
	data["book"] = cached_info

	return data

/obj/machinery/libraryscanner/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("scan")
			if(cache?.compare(held_book.book_data))
				say("This book is already in my internal cache")
				return
			cache = held_book.book_data.return_copy()
			return TRUE
		if("clear")
			cache = null
			return TRUE
		if("eject")
			ui.user.put_in_hands(held_book)
			playsound(src, 'sound/machines/eject.ogg', 70)
			return TRUE

/*
 * Book binder
 */
/obj/machinery/bookbinder
	name = "book binder"
	icon = 'icons/obj/library.dmi'
	icon_state = "binder"
	desc = "Only intended for binding paper products."
	density = TRUE
	var/busy = FALSE

/obj/machinery/bookbinder/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/bookbinder/attackby(obj/hitby, mob/user, params)
	if(istype(hitby, /obj/item/paper))
		prebind_book(user, hitby)
		return
	return ..()

/obj/machinery/bookbinder/proc/prebind_book(mob/user, obj/item/paper/draw_from)
	if(machine_stat)
		return
	if(busy)
		to_chat(user, span_warning("The book binder is busy. Please wait for completion of previous operation."))
		return
	if(!user.transferItemToLoc(draw_from, src))
		return
	user.visible_message(span_notice("[user] loads some paper into [src]."), span_notice("You load some paper into [src]."))
	audible_message(span_hear("[src] begins to hum as it warms up its printing drums."))
	busy = TRUE
	playsound(src, 'sound/machines/printer.ogg', 50)
	addtimer(CALLBACK(src, PROC_REF(bind_book), draw_from), 4.1 SECONDS)

/obj/machinery/bookbinder/proc/bind_book(obj/item/paper/draw_from)
	busy = FALSE
	if(!draw_from) //What the fuck did you do
		return
	if(machine_stat)
		draw_from.forceMove(drop_location())
		return
	visible_message(span_notice("[src] whirs as it prints and binds a new book."))
	var/obj/item/book/bound_book = new(loc)
	bound_book.book_data.set_content(draw_from.info)
	bound_book.name = "Print Job #" + "[rand(100, 999)]"
	bound_book.gen_random_icon_state()
	qdel(draw_from)
