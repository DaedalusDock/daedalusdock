/datum/newspanel
	/// If null, this is an admin UI and requires admin to view.
	var/obj/machinery/newscaster/parent

	///Reference to the currently logged in user.
	var/datum/bank_account/current_user
	///What newscaster channel is currently being viewed by the player?
	var/datum/feed_channel/current_channel
	///What newscaster feed_message is currently having a comment written for it?
	var/datum/feed_message/current_message
	///The message that's currently being written for a feed story.
	var/feed_channel_message
	///The current image that will be submitted with the newscaster story.
	var/datum/picture/current_image
	///Is the current user creating a new channel at the moment?
	var/creating_channel = FALSE
	///Is the current user creating a new comment at the moment?
	var/creating_comment = FALSE
	///Is the current user editing or viewing a new wanted issue at the moment?
	var/viewing_wanted  = FALSE
	///What is the user submitted, criminal name for the new wanted issue?
	var/criminal_name
	///What is the user submitted, crime description for the new wanted issue?
	var/crime_description
	///What is the current, in-creation channel's name going to be?
	var/channel_name
	///What is the current, in-creation channel's description going to be?
	var/channel_desc
	///What is the current, in-creation comment's body going to be?
	var/comment_text

	///The station request datum being affected by UI actions.
	var/datum/station_request/active_request
	///Value of the currently bounty input
	var/bounty_value = 1
	///Text of the currently written bounty
	var/bounty_text = ""

/datum/newspanel/Destroy(force, ...)
	parent = null
	current_channel = null
	current_image = null
	active_request = null
	current_user = null
	return ..()

/datum/newspanel/ui_state(mob/user)
	return parent ? GLOB.default_state : GLOB.admin_state

/datum/newspanel/ui_host(mob/user)
	return parent || src

/datum/newspanel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PhysicalNewscaster")
		ui.open()

	parent?.alert = FALSE
	parent?.update_appearance()

/datum/newspanel/ui_data(mob/user)
	var/list/data = list()
	var/list/message_list = list()

	//Code displaying name and Job Information, taken from the player mob's ID card if one exists.
	var/obj/item/card/id/card
	if(isliving(user))
		var/mob/living/living_user = user
		card = living_user.get_idcard(hand_first = TRUE)
	if(card?.registered_account)
		current_user = card.registered_account
		data["user"] = list()
		data["user"]["name"] = card.registered_account.account_holder
		if(card?.registered_account.account_job)
			data["user"]["job"] = card.registered_account.account_job.title
			data["user"]["department"] = card.registered_account.account_job.paycheck_department
		else
			data["user"]["job"] = "No Job"
			data["user"]["department"] = "No Department"
	else
		data["user"] = list()
		data["user"]["name"] = user.name
		data["user"]["job"] = "N/A"
		data["user"]["department"] = "N/A"

	data["security_mode"] = (ACCESS_ARMORY in card?.GetAccess())
	data["photo_data"] = !isnull(current_image)
	data["creating_channel"] = creating_channel
	data["creating_comment"] = creating_comment

	//Here is all the UI_data sent about the current wanted issue, as well as making a new one in the UI.
	data["criminal_name"] = criminal_name
	data["crime_description"] = crime_description
	var/list/wanted_info = list()

	if(length(GLOB.news_network.wanted_issues))
		for(var/datum/wanted_message/wanted_issue as anything in GLOB.news_network.wanted_issues)
			var/image_name = "wanted_photo_[ref(wanted_issue)].png"
			if(wanted_issue.img)
				user << browse_rsc(wanted_issue.img, image_name)

			wanted_info += list(list(
				"active" = wanted_issue.active,
				"criminal" = wanted_issue.criminal,
				"crime" = wanted_issue.body,
				"author" = wanted_issue.scanned_user,
				"image" = wanted_issue.img && image_name,
				"id" = wanted_issue.id,
			))

	//Code breaking down the channels that have been made on-station thus far. ha
	//Then, breaks down the messages that have been made on those channels.
	if(current_channel)
		for(var/datum/feed_message/feed_message as anything in current_channel.messages)
			var/photo_ID = null
			var/list/comment_list
			if(feed_message.img)
				user << browse_rsc(feed_message.img, "tmp_photo[feed_message.message_ID].png")
				photo_ID = "tmp_photo[feed_message.message_ID].png"
			for(var/datum/feed_comment/comment_message as anything in feed_message.comments)
				comment_list += list(list(
					"auth" = comment_message.author,
					"body" = comment_message.body,
					"time" = comment_message.time_stamp,
				))
			message_list += list(list(
				"auth" = feed_message.author,
				"body" = feed_message.body,
				"time" = feed_message.time_stamp,
				"channel_num" = feed_message.parent_ID,
				"censored_message" = feed_message.body_censor,
				"censored_author" = feed_message.author_censor,
				"ID" = feed_message.message_ID,
				"photo" = photo_ID,
				"comments" = comment_list
			))


	data["viewing_channel"] = current_channel?.channel_ID
	data["paper"] = parent?.paper_remaining || 0
	//Here we display all the information about the current channel.
	data["channelName"] = current_channel?.channel_name
	data["channelAuthor"] = current_channel?.author

	if(!current_channel)
		data["channelAuthor"] = "Daedalus Industries"
		data["channelDesc"] = "Welcome to Newscaster Net. Interface & News networks Operational."
		data["channelLocked"] = TRUE
	else
		data["channelDesc"] = current_channel.channel_desc
		data["channelLocked"] = current_channel.locked
		data["channelCensored"] = current_channel.censored

	//We send all the information about all messages in existance.
	data["messages"] = message_list
	data["wanted"] = wanted_info

	var/list/formatted_requests = list()
	var/list/formatted_applicants = list()
	for (var/datum/station_request/request as anything in GLOB.request_list)
		formatted_requests += list(list("owner" = request.owner, "value" = request.value, "description" = request.description, "acc_number" = request.req_number))
		if(request.applicants)
			for(var/datum/bank_account/applicant_bank_account as anything in request.applicants)
				formatted_applicants += list(list("name" = applicant_bank_account.account_holder, "request_id" = request.owner_account.account_id, "requestee_id" = applicant_bank_account.account_id))

	data["requests"] = formatted_requests
	data["applicants"] = formatted_applicants
	data["bountyValue"] = bounty_value
	data["bountyText"] = bounty_text

	return data

/datum/newspanel/ui_static_data(mob/user)
	var/list/data = list()
	var/list/channel_list = list()
	for(var/datum/feed_channel/channel as anything in GLOB.news_network.network_channels)
		channel_list += list(list(
			"name" = channel.channel_name,
			"author" = channel.author,
			"censored" = channel.censored,
			"locked" = channel.locked,
			"ID" = channel.channel_ID,
		))

	data["channels"] = channel_list
	return data

/datum/newspanel/ui_act(action, params)
	. = ..()
	if(.)
		return

	var/current_ref_num = params["request"]
	var/current_app_num = params["applicant"]
	var/datum/bank_account/request_target

	if(current_ref_num)
		for(var/datum/station_request/iterated_station_request as anything in GLOB.request_list)
			if(iterated_station_request.req_number == current_ref_num)
				active_request = iterated_station_request
				break

	if(active_request)
		for(var/datum/bank_account/iterated_bank_account as anything in active_request.applicants)
			if(iterated_bank_account.account_id == current_app_num)
				request_target = iterated_bank_account
				break

	switch(action)
		if("setChannel")
			var/prototype_channel = params["channel"]
			if(isnull(prototype_channel))
				return TRUE
			for(var/datum/feed_channel/potential_channel as anything in GLOB.news_network.network_channels)
				if(prototype_channel == potential_channel.channel_ID)
					current_channel = potential_channel

		if("createStory")
			if(!current_channel)
				return TRUE
			var/prototype_channel = params["current"]
			create_story(channel_name = prototype_channel)

		if("togglePhoto")
			toggle_photo(usr)
			return TRUE

		if("startCreateChannel")
			start_create_channel()
			return TRUE

		if("setChannelName")
			var/pre_channel_name = params["channeltext"]
			if(!pre_channel_name)
				return TRUE
			channel_name = pre_channel_name

		if("setChannelDesc")
			var/pre_channel_desc = params["channeldesc"]
			if(!pre_channel_desc)
				return TRUE
			channel_desc = pre_channel_desc

		if("createChannel")
			var/locked = params["lockedmode"]
			create_channel(locked)
			return TRUE

		if("cancelCreation")
			creating_channel = FALSE
			creating_comment = FALSE
			criminal_name = null
			crime_description = null
			return TRUE

		if("storyCensor")
			var/obj/item/card/id/id_card
			if(isliving(usr))
				var/mob/living/living_user = usr
				id_card = living_user.get_idcard(hand_first = TRUE)

			if(parent && !(ACCESS_ARMORY in id_card?.GetAccess()))
				parent.say("Clearance not found.")
				return TRUE

			var/questionable_message = params["messageID"]
			for(var/datum/feed_message/iterated_feed_message as anything in current_channel.messages)
				if(iterated_feed_message.message_ID == questionable_message)
					iterated_feed_message.toggle_censor_body()
					break

		if("authorCensor")
			var/obj/item/card/id/id_card
			if(isliving(usr))
				var/mob/living/living_user = usr
				id_card = living_user.get_idcard(hand_first = TRUE)

			if(parent && !(ACCESS_ARMORY in id_card?.GetAccess()))
				parent.say("Clearance not found.")
				return TRUE

			var/questionable_message = params["messageID"]
			for(var/datum/feed_message/iterated_feed_message in current_channel.messages)
				if(iterated_feed_message.message_ID == questionable_message)
					iterated_feed_message.toggle_censor_author()
					break

		if("channelDNotice")
			var/obj/item/card/id/id_card
			if(isliving(usr))
				var/mob/living/living_user = usr
				id_card = living_user.get_idcard(hand_first = TRUE)
			if(parent && !(ACCESS_ARMORY in id_card?.GetAccess()))
				parent.say("Clearance not found.")
				return TRUE

			var/prototype_channel = (params["channel"])
			for(var/datum/feed_channel/potential_channel in GLOB.news_network.network_channels)
				if(prototype_channel == potential_channel.channel_ID)
					current_channel = potential_channel
					break
			current_channel.toggle_censor_D_class()

		if("startComment")
			if(!current_user)
				creating_comment = FALSE
				return TRUE
			creating_comment = TRUE
			var/commentable_message = params["messageID"]
			if(!commentable_message)
				return TRUE
			for(var/datum/feed_message/iterated_feed_message as anything in current_channel.messages)
				if(iterated_feed_message.message_ID == commentable_message)
					current_message = iterated_feed_message
			return TRUE

		if("setCommentBody")
			var/pre_comment_text = params["commenttext"]
			if(!pre_comment_text)
				return TRUE
			comment_text = pre_comment_text
			return TRUE

		if("createComment")
			create_comment()
			return TRUE

		if("viewWanted")
			parent?.alert = FALSE
			parent?.update_appearance()
			return TRUE

		if("setCriminalName")
			var/temp_name = tgui_input_text(usr, "Write the Criminal's Name", "Warrent Alert Handler", "John Doe", MAX_NAME_LEN, multiline = FALSE)
			if(!temp_name)
				return TRUE
			criminal_name = temp_name
			return TRUE

		if("setCrimeData")
			var/temp_desc = tgui_input_text(usr, "Write the Criminal's Crimes", "Warrent Alert Handler", "Unknown", MAX_BROADCAST_LEN, multiline = TRUE)
			if(!temp_desc)
				return TRUE

			crime_description = temp_desc
			return TRUE

		if("submitWantedIssue")
			if(!crime_description || !criminal_name)
				return TRUE

			GLOB.news_network.submit_wanted(criminal_name, crime_description, current_user?.account_holder, current_image, adminMsg = FALSE, newMessage = TRUE)
			current_image = null
			criminal_name = null
			crime_description = null
			return TRUE

		if("clearWantedIssue")
			var/id = params["id"]
			if(!id)
				return

			clear_wanted_issue(usr, id)
			return TRUE

		if("printNewspaper")
			print_paper()
			return TRUE

		if("createBounty")
			create_bounty()
			return TRUE

		if("apply")
			apply_to_bounty()
			return TRUE

		if("payApplicant")
			pay_applicant(payment_target = request_target)
			return TRUE

		if("clear")
			if(current_user)
				current_user = null
				parent?.say("Account Reset.")
				return TRUE

		if("deleteRequest")
			delete_bounty_request()
			return TRUE

		if("bountyVal")
			bounty_value = text2num(params["bountyval"])
			if(!bounty_value)
				bounty_value = 1
			bounty_value = clamp(bounty_value, 1, 1000)

		if("bountyText")
			var/pre_bounty_text = params["bountytext"]
			if(!pre_bounty_text)
				return
			bounty_text = pre_bounty_text
	return TRUE

/**
 * Sends photo data to build the newscaster article.
 */
/datum/newspanel/proc/send_photo_data()
	if(!current_image)
		return null
	return current_image

/**
 * This takes a held photograph, and updates the current_image variable with that of the held photograph's image.
 * *user: The mob who is being checked for a held photo object.
 */
/datum/newspanel/proc/attach_photo(mob/user)
	var/obj/item/photo/photo = user?.is_holding_item_of_type(/obj/item/photo)
	if(photo)
		current_image = photo.picture
		return TRUE

	if(!issilicon(user))
		return FALSE

	var/obj/item/camera/siliconcam/targetcam
	if(isAI(user))
		var/mob/living/silicon/ai/R = user
		targetcam = R.aicamera
	else if(ispAI(user))
		var/mob/living/silicon/pai/R = user
		targetcam = R.aicamera
	else if(iscyborg(user))
		var/mob/living/silicon/robot/R = user
		if(R.connected_ai)
			targetcam = R.connected_ai.aicamera
		else
			targetcam = R.aicamera
	else
		to_chat(user, span_warning("You can not interface with silicon photo uploading."))

	if(!targetcam.stored.len)
		to_chat(user, span_boldannounce("No images saved."))
		return

	var/datum/picture/selection = targetcam.selectpicture(user)
	if(selection)
		current_image = selection
		return TRUE

	return FALSE

/**
 * This takes all current feed stories and messages, and prints them onto a newspaper, after checking that the newscaster has been loaded with paper.
 * The newscaster then prints the paper to the floor.
 */
/datum/newspanel/proc/print_paper()
	if(!parent)
		return FALSE

	if(parent.paper_remaining <= 0)
		parent.visible_message(span_warning("[parent]'s printer clunks."), blind_message = span_hear("You hear a mechanical clunk."))
		return TRUE

	SSblackbox.record_feedback("amount", "newspapers_printed", 1)

	var/obj/item/newspaper/new_newspaper = new /obj/item/newspaper
	for(var/datum/feed_channel/iterated_feed_channel in GLOB.news_network.network_channels)
		new_newspaper.news_content += iterated_feed_channel

	// Hello. Kapu here. I just finished adding support for having multiple wanted persons at once to newscasters.
	// I am not touching newspaper code. Sorry, not sorry!
	if(length(GLOB.news_network.wanted_issues))
		var/datum/wanted_message/wanted_person = GLOB.news_network.wanted_issues[1]
		new_newspaper.wantedAuthor = wanted_person.scanned_user
		new_newspaper.wantedCriminal = wanted_person.criminal
		new_newspaper.wantedBody = wanted_person.body
		if(wanted_person.img)
			new_newspaper.wantedPhoto = wanted_person.img

	new_newspaper.forceMove(parent.drop_location())
	new_newspaper.creation_time = GLOB.news_network.last_action
	parent.paper_remaining--

/**
 * Performs a series of sanity checks before giving the user confirmation to create a new feed_channel using channel_name, and channel_desc.
 * *channel_locked: This variable determines if other users than the author can make comments and new feed_stories on this channel.
 */
/datum/newspanel/proc/create_channel(channel_locked)
	if(!channel_name)
		return
	for(var/datum/feed_channel/iterated_feed_channel as anything in GLOB.news_network.network_channels)
		if(iterated_feed_channel.channel_name == channel_name)
			tgui_alert(usr, "ERROR: Feed channel with that name already exists on the Network.", list("Okay"))
			return TRUE

	if(!channel_desc)
		return TRUE

	if(isnull(channel_locked))
		return TRUE

	var/choice = tgui_alert(usr, "Please confirm feed channel creation","Network Channel Handler", list("Confirm","Cancel"))
	if(choice == "Confirm")
		GLOB.news_network.create_feed_channel(channel_name, current_user.account_holder, channel_desc, locked = channel_locked)
		SSblackbox.record_feedback("text", "newscaster_channels", 1, "[channel_name]")

	creating_channel = FALSE
	update_static_data(usr)

/**
 * Constructs a comment to attach to the currently selected feed_message of choice, assuming that a user can be found and that a message body has been written.
 */
/datum/newspanel/proc/create_comment()
	if(!comment_text)
		creating_comment = FALSE
		return TRUE

	if(!current_user)
		creating_comment = FALSE
		return TRUE

	var/datum/feed_comment/new_feed_comment = new/datum/feed_comment
	new_feed_comment.author = current_user.account_holder
	new_feed_comment.body = comment_text
	new_feed_comment.time_stamp = stationtime2text()
	current_message.comments += new_feed_comment
	usr.log_message("(as [current_user.account_holder]) commented on message [current_message.return_body(-1)] -- [current_message.body]", LOG_COMMENT)
	creating_comment = FALSE

/**
 * This proc performs checks before enabling the creating_channel var on the newscaster, such as preventing a user from having multiple channels,
 * preventing an un-ID'd user from making a channel, and preventing censored authors from making a channel.
 * Otherwise, sets creating_channel to TRUE.
 */
/datum/newspanel/proc/start_create_channel()
	//This first block checks for pre-existing reasons to prevent you from making a new channel, like being censored, or if you have a channel already.
	var/list/existing_authors = list()
	for(var/datum/feed_channel/iterated_feed_channel as anything in GLOB.news_network.network_channels)
		if(iterated_feed_channel.author_censor)
			existing_authors += GLOB.news_network.redacted_text
		else
			existing_authors += iterated_feed_channel.author

	if(!current_user?.account_holder || current_user.account_holder == "Unknown" || (current_user.account_holder in existing_authors))
		creating_channel = FALSE
		tgui_alert(usr, "ERROR: User cannot be found or already has an owned feed channel.", list("Okay"))
		return TRUE

	creating_channel = TRUE
	return TRUE

/**
 * Creates a new feed story to the global newscaster network.
 * Verifies that the message is being written to a real feed_channel, then provides a text input for the feed story to be written into.
 * Finally, it submits the message to the network, is logged globally, and clears all message-specific variables from the machine.
 */
/datum/newspanel/proc/create_story(channel_name)
	for(var/datum/feed_channel/potential_channel as anything in GLOB.news_network.network_channels)
		if(channel_name == potential_channel.channel_ID)
			current_channel = potential_channel
			break
	var/temp_message = tgui_input_text(usr, "Write your Feed story", "Network Channel Handler", feed_channel_message, multiline = TRUE)
	if(length(temp_message) <= 1)
		return TRUE
	if(temp_message)
		feed_channel_message = temp_message
	GLOB.news_network.submit_article("<font face=\"[PEN_FONT]\">[parsemarkdown(feed_channel_message, usr)]</font>", current_user?.account_holder, current_channel.channel_name, send_photo_data(), adminMessage = FALSE, allow_comments = TRUE)
	SSblackbox.record_feedback("amount", "newscaster_stories", 1)
	feed_channel_message = ""
	current_image = null

/**
 * Selects a currently held photo from the user's hand and makes it the current_image held by the newscaster.
 * If a photo is still held in the newscaster, it will otherwise clear it from the machine.
 */
/datum/newspanel/proc/toggle_photo(mob/user)
	if(current_image)
		current_image = null
		return TRUE

	if(!attach_photo(user))
		to_chat(user, span_warning("There is no photo in [parent]."))
		return FALSE
	return TRUE

/datum/newspanel/proc/clear_wanted_issue(user, wanted_id)
	var/obj/item/card/id/id_card
	if(isliving(user))
		var/mob/living/living_user = user
		id_card = living_user.get_idcard(hand_first = TRUE)

	if(parent && !(ACCESS_ARMORY in id_card?.GetAccess()))
		parent.say("Clearance not found.")
		return TRUE

	GLOB.news_network.delete_wanted(wanted_id)
	return TRUE

/**
 * This proc removes a station_request from the global list of requests, after checking that the owner of that request is the one who is trying to remove it.
 */
/datum/newspanel/proc/delete_bounty_request()
	if(!active_request || !current_user)
		playsound(parent, 'sound/machines/buzz-sigh.ogg', 20, TRUE)
		return TRUE
	if(active_request?.owner != current_user?.account_holder)
		playsound(parent, 'sound/machines/buzz-sigh.ogg', 20, TRUE)
		return TRUE

	parent?.say("Deleted current request.")
	GLOB.request_list.Remove(active_request)

/**
 * This creates a new bounty to the global list of bounty requests, alongisde the provided value of the request, and the owner of the request.
 * For more info, see datum/station_request.
 */
/datum/newspanel/proc/create_bounty()
	if(!current_user || !bounty_text)
		playsound(parent, 'sound/machines/buzz-sigh.ogg', 20, TRUE)
		return TRUE

	for(var/datum/station_request/iterated_station_request as anything in GLOB.request_list)
		if(iterated_station_request.req_number == current_user.account_id)
			parent?.say("Account already has active bounty.")
			return TRUE

	var/datum/station_request/curr_request = new /datum/station_request(current_user.account_holder, bounty_value,bounty_text,current_user.account_id, current_user)
	GLOB.request_list += curr_request

	for(var/obj/iterated_bounty_board as anything in GLOB.allbountyboards)
		iterated_bounty_board.say("New bounty added!")
		playsound(iterated_bounty_board.loc, 'sound/effects/cashregister.ogg', 30, TRUE)
/**
 * This sorts through the current list of bounties, and confirms that the intended request found is correct.
 * Then, adds the current user to the list of applicants to that bounty.
 */
/datum/newspanel/proc/apply_to_bounty()
	if(!current_user)
		parent?.say("Please equip a valid ID first.")
		return TRUE

	if(current_user.account_holder == active_request.owner)
		playsound(parent, 'sound/machines/buzz-sigh.ogg', 20, TRUE)
		return TRUE

	for(var/new_apply in active_request?.applicants)
		if(current_user.account_holder == active_request?.applicants[new_apply])
			playsound(parent, 'sound/machines/buzz-sigh.ogg', 20, TRUE)
			return TRUE

	active_request.applicants += list(current_user)

/**
 * This pays out the current request_target the amount held by the active request's assigned value, and then clears the active request from the global list.
 */
/datum/newspanel/proc/pay_applicant(datum/bank_account/payment_target)
	if(!current_user)
		return TRUE

	if(!current_user.has_money(active_request.value) || (current_user.account_holder != active_request.owner))
		playsound(parent, 'sound/machines/buzz-sigh.ogg', 30, TRUE)
		return TRUE

	payment_target.transfer_money(current_user, active_request.value)
	parent?.say("Paid out [active_request.value] marks.")
	GLOB.request_list.Remove(active_request)
	qdel(active_request)
