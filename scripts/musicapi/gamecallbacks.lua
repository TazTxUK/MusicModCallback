local MusicAPI = require("scripts.musicapi.api")
local cache = require("scripts.musicapi.cache")

local json = require("json")

MusicAPI.Mod = RegisterMod("MusicAPI", 1)
local mod = MusicAPI.Mod

mod.SaveData = {}
mod.Manager = MusicManager()

--Callbacks that control the music flow. Callbacks assisting the actual API
--are still in api.lua.

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	MusicAPI.ReloadRoomTrack()
end)

local PostRender_State_JumpTable = { -- TAZ: Jump tables are used instead of having loads of elseifs. In theory, runs faster.
	Boss = function()
		if MusicAPI.State.Phase == 1 then
			if cache.Room:GetFrameCount() > 0 then
				MusicAPI.State.Phase = 2
				MusicAPI.PlayTrack(MusicAPI.State.TrackMain)
			end
		end
		
		if MusicAPI.State.Phase == 2 then
			if cache.CountBosses == 0 then
				MusicAPI.PlayTrack(MusicAPI.State.TrackEnd, "ROOM_BOSS_CLEAR")
				MusicAPI.ClearState()
			end
		end
	end,
	SatanBoss = function()
		if MusicAPI.State.Phase == 1 then
			if MusicAPI.State.Entity.StateFrame == 1 then
				MusicAPI.State.Phase = 2
				MusicAPI.PlayTrack(MusicAPI.State.TrackInactive)
			end
		end
		
		if MusicAPI.State.Phase == 2 then
			if MusicAPI.State.Entity.StateFrame == 0 then
				MusicAPI.State.Phase = 3
				MusicAPI.PlayTrack(MusicAPI.State.TrackPhase1)
			end
		end
		
		if MusicAPI.State.Phase == 3 then
			if MusicAPI.State.Entity.StateFrame == 25 then
				MusicAPI.State.Phase = 4
				MusicAPI.PlayTrack(MusicAPI.State.TrackPhase2)
			end
		end
		
		if MusicAPI.State.Phase > 1 then
			if cache.CountBosses == 0 then
				MusicAPI.PlayTrack(MusicAPI.State.TrackEnd, "ROOM_BOSS_CLEAR")
				MusicAPI.ClearState()
			end
		end
	end,
	MegaSatanBoss = function()
		if MusicAPI.State.Phase == 1 then
			if cache.Room:GetFrameCount() > 0 then
				MusicAPI.State.Phase = 2
				MusicAPI.PlayTrack(MusicAPI.State.TrackInactive)
			end
		end
		
		if MusicAPI.State.Phase == 2 then
			if cache.Room:GetFrameCount() > 0 then
				for _, player in ipairs(Isaac.FindByType(1, 0)) do --TAZ: This is a bodge!
					if player.Position.Y < 540 then
						MusicAPI.State.Phase = 3
						MusicAPI.PlayTrack(MusicAPI.State.TrackMain)
						break
					end
				end
			end
		end
		
		if MusicAPI.State.Phase > 1 then
			if cache.CountBosses == 0 then
				MusicAPI.PlayTrack(MusicAPI.State.TrackEnd, "ROOM_BOSS_CLEAR")
				MusicAPI.ClearState()
			end
		end
	end,
	Miniboss = function()
		if MusicAPI.State.Phase == 2 then
			if cache.CountBosses == 0 and cache.Room:IsClear() then
				MusicAPI.PlayTrack("JINGLE_MINIBOSS_CLEAR", "ROOM_MINIBOSS_CLEAR")
				MusicAPI.ClearState()
			end
		end
	end,
	Ambush = function()
		if MusicAPI.State.Phase == 1 then
			if cache.Room:IsAmbushActive() then
				MusicAPI.State.Phase = 2
				MusicAPI.PlayTrack(MusicAPI.State.TrackMain)
			end
		end
	
		if MusicAPI.State.Phase == 2 then
			if cache.Room:IsAmbushDone() then
				MusicAPI.PlayTracks{MusicAPI.State.TrackEnd, MusicAPI.State.TrackClear}
				MusicAPI.ClearState()
			end
		end
	end,
}

local PostRender_MusicIDEqQueueID_JumpTable = {
	[Music.MUSIC_JINGLE_NIGHTMARE] = function()
		if cache.HUD:IsVisible() then
			MusicAPI.ReloadRoomTrack()
		end
	end,
	[Music.MUSIC_JINGLE_NIGHTMARE_ALT] = function()
		if cache.HUD:IsVisible() then
			MusicAPI.ReloadRoomTrack()
		end
	end,
}

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	if MusicAPI.State then
		local j = PostRender_State_JumpTable[MusicAPI.State.Type]
		if j then j() end
	end
	
	if MusicAPI.Manager:GetCurrentMusicID() == MusicAPI.Manager:GetQueuedMusicID() then
		--This can happen in some situations where the game tries to control the music again
		local f = PostRender_MusicIDEqQueueID_JumpTable[MusicAPI.Manager:GetCurrentMusicID()]
		if f then
			f()
		else
			MusicAPI.Manager:Queue(Music.MUSIC_MUSICAPI_QUEUE_POP)
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(self, ent) -- Hush thinks
	if ent.Variant == 2 then
		MusicAPI.PlayTrack("BOSS_HUSH_FINAL")
	end
end, EntityType.ENTITY_ISAAC)

mod:AddCallback(ModCallbacks.MC_POST_GAME_END, function(self, game_over)
	if game_over then
		MusicAPI.PlayTrack(MusicAPI.GetGameOverTrack())
	end
end)

mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, MusicAPI.PreGameStart)