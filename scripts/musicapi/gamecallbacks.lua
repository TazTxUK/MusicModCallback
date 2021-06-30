local MusicAPI = require("scripts.musicapi.api")
local cache = require("scripts.musicapi.cache")

local json = require("json")

MusicAPI.Mod = RegisterMod("MusicAPI", 1)
local mod = MusicAPI.Mod

mod.SaveData = {}
mod.Manager = MusicManager()

MusicAPI.BeforeStart = true

--Callbacks that control the music flow. Callbacks assisting the actual API
--are still in api.lua.

local PostNewRoom_JumpTable = {
	[RoomType.ROOM_BOSS] = function()
		if not cache.Room:IsClear() then
			MusicAPI.StartBossState(not MusicAPI.BeforeStart)
		end
	end,
	[RoomType.ROOM_MINIBOSS] = function()
		if not cache.Room:IsClear() then
			MusicAPI.StartMinibossState()
		end
	end,
}

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	local track_names = {MusicAPI.GetRoomEntryTrack()}
	MusicAPI.SetRoomTrack(track_names[1])
	MusicAPI.PlayTracks(track_names)
	
	MusicAPI.ClearState()
	
	local j = PostNewRoom_JumpTable[cache.RoomType]
	if j then j() end
	
	MusicAPI.BeforeStart = false
end)

local PostRender_State_JumpTable = {
	Boss = function()
		if MusicAPI.State.Phase == 1 then
			if cache.Room:GetFrameCount() > 0 then
				MusicAPI.State.Phase = 2
				MusicAPI.PlayTrack(MusicAPI.State.TrackMain)
			end
		end
		
		if MusicAPI.State.Phase == 2 then
			if cache.CountBosses == 0 and cache.Room:IsClear() then
				MusicAPI.PlayTracks{MusicAPI.State.TrackEnd, "ROOM_BOSS_CLEAR"}
				MusicAPI.ClearState()
			end
		end
	end,
	Miniboss = function()
		if MusicAPI.State.Phase == 2 then
			if cache.CountBosses == 0 and cache.Room:IsClear() then
				MusicAPI.PlayTracks{"JINGLE_MINIBOSS_CLEAR", "ROOM_MINIBOSS_CLEAR"}
				MusicAPI.ClearState()
			end
		end
	end,
}

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	if MusicAPI.State then
		local j = PostRender_State_JumpTable[MusicAPI.State.Type]
		if j then j() end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(self, ent) -- Hush thinks
	if ent.Variant == 2 then
		MusicAPI.PlayTrack("BOSS_HUSH_FINAL")
	end
end, EntityType.ENTITY_ISAAC)

mod:AddCallback(ModCallbacks.MC_POST_GAME_END, function(self, game_over)
	if game_over then
		MusicAPI.PlayTracks{MusicAPI.GetGameOverTrack()}
	end
end)

mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function(self, should_save)
	MusicAPI.BeforeStart = true
end)