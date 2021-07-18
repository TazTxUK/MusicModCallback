-- EXAMPLES! This file isn't loaded in to the game at any time, just use it to teach yourself how to use the API.
-- All examples (should) work copy and pasted.
-- The demo music is included with MusicAPI.
-- I've written code to be the simplest as possible, not the fastest. Cache your userdatas :)


--1: Shops on Repentance floors play a custom track

MusicAPI.AddOnMusicCallback(function(track_name, music_id)
	if track_name == "ROOM_SHOP" then
		if Game():GetLevel():GetStageType() == StageType.STAGETYPE_REPENTANCE or Game():GetLevel():GetStageType() == StageType.STAGETYPE_REPENTANCE_B then
			return Music.MUSIC_MUSICAPI_DEMO_TRACK
		end
	end
end)

--2: Treasure room and curse room use custom music
MusicAPI.TrackAddMusic("ROOM_TREASURE", Music.MUSIC_MUSICAPI_DEMO_TRACK)
MusicAPI.TrackAddMusic("ROOM_CURSE", Music.MUSIC_MUSICAPI_DEMO_TRACK)

--3: Music playing is printed into the console
MusicAPI.AddOnPlayCallback(function(track_name, music_id)
	if MusicAPI.ShowDebugInfo then
		Isaac.ConsoleOutput("Now playing:\n Track: "..track_name.."\n ID: "..music_id.."\n")
	end
end)

--4: Music playing is printed into the console
MusicAPI.AddOnPlayCallback(function(track_name, music_id)
	if MusicAPI.ShowDebugInfo then
		Isaac.ConsoleOutput("Now playing:\n Track: "..track_name.."\n ID: "..music_id.."\n")
	end
end)

--5: Add jingles to the treasure room that could be chosen along with the normal ones.
MusicAPI.TrackAddMusic("JINGLE_TREASURE_ROOM", Music.MUSIC_MUSICAPI_DEMO_JINGLE_IN, Music.MUSIC_MUSICAPI_DEMO_JINGLE_OUT)

--6: Convert the devil room and angel room sounds into music jingles
--The game USED to have them as jingles but turned them into sound effects. They still remain in the game as jingles too, and I added tracks for them.
--DEV TODO: Add this feature!
MusicAPI.PostBossDealJingles = true
