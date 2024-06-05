/datum/asset/holomaps

/datum/asset/holomaps/send(client)
	for(var/asset_name in SSholomap.holomaps_by_z)
		if(isnull(asset_name))
			continue
		SSassets.transport.send_assets(client, asset_name)

/datum/asset/holomaps/get_url_mappings(client)
	. = list()
	var/i = 0
	for(var/asset_name in SSholomap.holomaps_by_z)
		i++
		if(isnull(asset_name))
			continue

		.["holomap_z[i].png"] = SSassets.transport.get_asset_url(asset_name)

/datum/asset/holomaps/ensure_ready()
	UNTIL(SSholomap.initialized)
	return ..()
