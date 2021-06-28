local cache = {}

cache.Mod = RegisterMod("MusicAPI Cache", 1)
local mod = cache.Mod

cache.Game = Game()
cache.Level = Game():GetLevel()
cache.Room = Game():GetRoom()

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
	cache.Game = Game()
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	cache.Level = Game():GetLevel()
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	cache.Room = cache.Game:GetRoom()
	cache.STATE_BACKWARDS_PATH = cache.Game:GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH) and cache.Level:GetStage() <= 6
end)

return cache