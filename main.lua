if not REPENTANCE then return end

Isaac.ConsoleOutput("Loading MusicAPI...\n")

local enums = require("scripts.musicapi.enums")
Music = enums.Music
MusicOld = enums.MusicOld
MusicAPI = require("scripts.musicapi.api")
MMC = require("scripts.musicapi.legacy")

require("scripts.musicapi.triggers")
require("scripts.musicapi.gamecallbacks")

Isaac.ConsoleOutput("MusicAPI loaded successfully.\n")

MusicAPI.AddCallback(1, function(...)
	GVM.Print("Hello!",...)
end, 1)

local mod = RegisterMod("", 1)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	local s = "(NONE)"
	local current_track = MusicManager():GetCurrentMusicID()
	for a,b in pairs(Music) do
		if b == current_track then s = a end
	end
	Isaac.RenderText(s, 50, 50, 0.8, 0.8, 1.0, 1.0)
	Isaac.RenderText(MusicAPI.GetRoomTriggerName() or "(NONE)", 50, 62, 0.8, 0.8, 1.0, 1.0)
end)