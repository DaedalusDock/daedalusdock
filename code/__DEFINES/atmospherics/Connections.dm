
#define WOOSH \
	if(connecting_turfs.len && (REALTIMEOFDAY > last_woosh + 2 SECONDS)){ \
		playsound(pick(connecting_turfs),abs(differential) > zas_settings.airflow_heavy_pressure ? 'sound/effects/space_wind_big.ogg' : 'sound/effects/space_wind.ogg',100,TRUE,null,pressure_affected = FALSE); \
		last_woosh = REALTIMEOFDAY;\
	} \
