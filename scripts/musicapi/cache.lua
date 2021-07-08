local cache = {}

cache.Mod = RegisterMod("MusicAPI Cache", 1)
local mod = cache.Mod

cache.Game = Game()
cache.HUD = cache.Game:GetHUD()

local STAGE3_2 = LevelStage.STAGE3_2
local STAGETYPE_REPENTANCE = StageType.STAGETYPE_REPENTANCE
local STAGETYPE_REPENTANCE_B = StageType.STAGETYPE_REPENTANCE_B

function cache.ReloadRoomCache()
	cache.Level = cache.Game:GetLevel()
	cache.Room = cache.Game:GetRoom()
	cache.RoomDescriptor = cache.Level:GetCurrentRoomDesc()
	cache.Stage = cache.Level:GetStage()
	cache.AbsoluteStage = cache.Level:GetAbsoluteStage()
	cache.StageType = cache.Level:GetStageType()
	cache.CurrentRoomIndex = cache.Level:GetCurrentRoomIndex()
	cache.RoomType = cache.Room:GetType()
	cache.Seeds = cache.Game:GetSeeds()
	
	--Dimension
	if GetPtrHash(cache.RoomDescriptor) == GetPtrHash(cache.Level:GetRoomByIdx(cache.CurrentRoomIndex, 0)) then
		cache.Dimension = 0
	elseif GetPtrHash(cache.RoomDescriptor) == GetPtrHash(cache.Level:GetRoomByIdx(cache.CurrentRoomIndex, 2)) then
		cache.Dimension = 2
	else
		cache.Dimension = 1
	end
	
	--Game states
	cache.STATE_BACKWARDS_PATH = cache.Game:GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH) and cache.Stage <= 6
	cache.STATE_MINESHAFT_ESCAPE = cache.Level:GetStateFlag(LevelStateFlag.STATE_MINESHAFT_ESCAPE) and cache.Dimension == 1
	
	cache.STATE_MAUSOLEUM_HEART_KILLED =
		cache.Game:GetStateFlag(GameStateFlag.STATE_MAUSOLEUM_HEART_KILLED) and 
		cache.Stage == STAGE3_2 and
		(cache.StageType == STAGETYPE_REPENTANCE or cache.StageType == STAGETYPE_REPENTANCE_B)
		
	--Additional
	cache.CHALLENGE_DELETE_THIS = cache.Game.Challenge == Challenge.CHALLENGE_DELETE_THIS
end
cache.ReloadRoomCache()

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, cache.ReloadRoomCache)

function cache.ReloadRenderCache()
	cache.CountBosses = Isaac.CountBosses()
end
cache.ReloadRenderCache()

mod:AddCallback(ModCallbacks.MC_POST_RENDER, cache.ReloadRenderCache)

return cache