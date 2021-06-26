--ideas for API (temporary file, remove later)
local MyMod = Isaac.RegisterMod("My Mod", 1)

MusicAPI.AddCallback(MyMod, function()
	
end, MusicAPI.CallFlags & MusicAPI.Flag("JINGLE") > 0)

MusicAPI.AddCallback(MyMod, function()
	
end, MusicAPI.CallFlags & MusicAPI.Flag("JINGLE"))

MusicAPI.AddCallback(MyMod, function()
	
end, MusicAPI.Flag("JINGLE"))

--[[

(MusicAPI.CallArgument(1) & (MusicAPI.Flag("JINGLE") | MusicAPI.Flag("ROOM_LIBRARY"))) | (MusicAPI.CallArgument(1) | MusicAPI.Flag("STAGE"):Not()) > 0
| Stored as
V
MusicAPI.Query<arg 1 is (bits)> | MusicAPI.Query<arg 1 is (bits)>

(RESOLVE)
flags are passed in
CallArgument(1) is now a value



if (JINGLE or ROOM_LIBRARY) or NOT (STAGE)

MusicAPI.Query() & 

]]

MusicAPI.AddLegacyCallback(MyMod, function() --V2 callback
	
end, Music.MUSIC_BASEMENT)
-- same functionality as:
MusicAPI.AddCallback(MyMod, function() --V3 callback
	
end, MusicAPI.Flag("STAGE_BASEMENT"))

