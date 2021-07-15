if not REPENTANCE then return end

Isaac.ConsoleOutput("Loading MusicAPI...\n")

local enums = require("scripts.musicapi.enums")
Music = enums.Music
MusicAPI = require("scripts.musicapi.api")
MusicAPI.Dev = require("scripts.musicapi.dev")
MMC = require("scripts.musicapi.legacy")

require("scripts.musicapi.gamecallbacks")

MusicAPI.ResetTracks()
MusicAPI.PreGameStart()

Isaac.ConsoleOutput("MusicAPI loaded successfully.\n")

local mod = RegisterMod("", 1)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	if MusicAPI.ShowDebugInfo then
		local current_track = MusicManager():GetCurrentMusicID()
		local queued_track = MusicManager():GetQueuedMusicID()
		local s1 = tostring(current_track)
		local s2 = tostring(queued_track)
		for a,b in pairs(Music) do
			if b == current_track then s1 = a end
			if b == queued_track then s2 = a end
		end
		local y = 50
		Isaac.RenderText("MusicManager Queue:", 50, y, 0.2, 0.2, 1.0, 1.0)
		y = y + 12
		Isaac.RenderText(s1, 50, y, 0.8, 0.8, 0.8, 1.0)
		y = y + 12
		Isaac.RenderText(s2, 50, y, 0.8, 0.8, 0.8, 1.0)
		y = y + 12
		Isaac.RenderText("MusicAPI Queue:", 50, y, 0.2, 0.2, 1.0, 1.0)
		y = y + 12
		for i=1,4 do
			local item = MusicAPI.Queue[i]
			if item then
				Isaac.RenderText(tostring(item), 50, y, 0.8, 0.8, 0.8, 1.0)
			end
			y = y + 12
		end
		if MusicAPI.State then
			Isaac.RenderText("MusicAPI State:", 50, y, 0.2, 0.2, 1.0, 1.0)
			y = y + 12
			for a,b in pairs(MusicAPI.State) do
				Isaac.RenderText(tostring(a), 50, y, 1, 1, 1, 1.0)
				Isaac.RenderText(tostring(b), 100, y, 1, 1, 1, 1.0)
				y = y + 12
			end
		end
	end
end)

MusicAPI.AddOnPlayCallback(function(trigger_name, track_id)
	if MusicAPI.ShowDebugInfo then
		Isaac.ConsoleOutput("Now Playing: "..trigger_name.." ("..track_id..")\n")
	end
end)