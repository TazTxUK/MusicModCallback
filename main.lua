if not REPENTANCE then return end

Isaac.ConsoleOutput("Loading MusicAPI...\n")

local enums = require("scripts.musicapi.enums")
Music = enums.Music
MusicOld = enums.MusicOld
MusicAPI = require("scripts.musicapi.api")
MMC = require("scripts.musicapi.legacy")

require("scripts.musicapi.gamecallbacks")

MusicAPI.ResetTriggers()

Isaac.ConsoleOutput("MusicAPI loaded successfully.\n")

local mod = RegisterMod("", 1)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	local s1 = "???"
	local s2 = "???"
	local current_track = MusicManager():GetCurrentMusicID()
	local queued_track = MusicManager():GetQueuedMusicID()
	for a,b in pairs(Music) do
		if b == current_track then s1 = a end
		if b == queued_track then s2 = a end
	end
	local y = 50
	Isaac.RenderText("MusicManager Queue:", 50, y, 0.4, 0.4, 1.0, 1.0)
	y = y + 12
	Isaac.RenderText(s1, 50, y, 0.8, 0.8, 1.0, 1.0)
	y = y + 12
	Isaac.RenderText(s2, 50, y, 0.8, 0.8, 1.0, 1.0)
	y = y + 12
	-- Isaac.RenderText(MusicAPI.GetRoomTriggerName() or "(NONE)", 50, y, 0.8, 0.8, 1.0, 1.0)
	-- y = y + 12
	Isaac.RenderText("MusicAPI Queue:", 50, y, 0.4, 0.4, 1.0, 1.0)
	y = y + 12
	for _, item in ipairs(MusicAPI.Queue) do
		Isaac.RenderText(item, 50, y, 0.2, 0.2, 1.0, 1.0)
		y = y + 12
	end
end)