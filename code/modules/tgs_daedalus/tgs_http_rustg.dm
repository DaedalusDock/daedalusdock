/datum/tgs_http_handler/rustg

/datum/tgs_http_handler/rustg/PerformGet(url)
	var/datum/http_request/request = new()
	request.prepare(RUSTG_HTTP_METHOD_GET, url)
	request.begin_async()

	TGS_DEBUG_LOG("http_rustg: Awaiting response.")
	UNTIL(request.is_complete())
	TGS_DEBUG_LOG("http_rustg: Request complete!")

	var/datum/http_response/response = request.into_response()
	if(response.errored || response.status_code != 200)
		TGS_ERROR_LOG("http_rustg: Failed request: [url] | Code: [response.status_code] | Error: [response.error]")
		return new /datum/tgs_http_result(null, FALSE)

	var/body = response.body
	if(!body)
		TGS_ERROR_LOG("http_rustg: Failed request, missing body!")
		return new /datum/tgs_http_result(null, FALSE)

	return new /datum/tgs_http_result(body, TRUE)
