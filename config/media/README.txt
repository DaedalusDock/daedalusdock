The enclosed /sounds folder holds the sound files for various systems. A wide range of sound types are supported.

Using unnecessarily huge sounds can cause client side lag and should be avoided.


All title music entries require an accompanying json in the /jsons folder. These contain information such as the name of the song and the author, as well as if the song is "rare" or map-specific.
The following media_tags are supported, Mutually exclusive tags are marked with <>, A sound may have multiple tags.
+++

LOBBY<>LOBBY_RARE: Common or Rare lobby tracks. The JSON key "map" can be used to restrict their usage to a specific map.

ROUNDEND<>ROUNDEND_RARE: Common or Rare roundend stingers. The JSON key "map" can be used to restrict their usage to a specific map.

JUKEBOX: Makes this track available in the jukebox.


