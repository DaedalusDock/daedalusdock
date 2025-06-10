Job spawning happens in two different ways, Roundstart and Late-join. The markers present on the map, and variables on the job both influence where a player will spawn under either type.

## Roundstart
There are "phases" of spawn selection. Forced Random, Fixed, Fallback Random, and Last Resort. The `spawn_logic` variable on Jobs determines which are viable methods.

If random spawns are forced, the spawner will use `latejoin_trackers`, which is created by `/obj/effect/landmark/latejoin`. If there are no late-join markers present, the last resort spawn point will be used instead. Random spawn is cyclical, meaning a spawn wont be re-used until all other viable late-join markers have been used.

If random spawns are not forced (either allowed or disallowed), first the fixed spawn point will be attempted. By *default*, this uses the job landmarks (`/obj/effect/landmark/start`)(at time of writing, the AI uses it's late join spawn point, which is special because AI.). Roundstart spawn points are **single use**, if there are no unused spawn points left, it will continue to Random selection. There is a concept of "High Priority Spawns", which are normal spawn markers that are consumed before ones that do not have `high_priority = 1`. These should not be used in normal mapping unless you have a very good reason, as they are intended for random events like station traits.

Random selection is identical to forced-random, the only difference is it occurs after checking for a fixed spawn point. If it fails, it continues to the last resort spawn.

The last resort spawn should only occur if the game is broken in some way, either through code or mapping error. The last resort spawn at time of writing will spawn the player on a random turf inside of `/area/shuttle/arrival`, prioritizing turfs with chairs.

## Late-Join
Late-join mob spawning is identical to roundstart's random logic, with one small difference. Late-join spawning uses the High Priority Spawn system, described in the Roundstart section.