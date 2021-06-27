if not REPENTANCE then return end

Music = require("scripts.musicapi.enums")
MusicAPI = require("scripts.musicapi.api")
MMC = require("scripts.musicapi.legacy")

require("scripts.musicapi.triggers")

Isaac.ConsoleOutput("Loaded "..MusicAPI.Mod.Name.." V"..MusicAPI.APIVersion.."\n")

MusicAPI.AddCallback(1, function(...)
	GVM.Print("Hello!",...)
end, 1)