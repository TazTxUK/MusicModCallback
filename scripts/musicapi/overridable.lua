--[[
This file is here to define simple functions that read the game's state.

The purpose of this is to allow rewrite mods to redefine them for easy
compatability. For example: Sentinel's Open World mod rewrites almost the
entire game, and Isaac stays in one room for the entirety of the floor, so
tracking Room's visit state would be difficult.

(This file may be removed later if not needed, its only a concept at the moment)
]]

local overridable = {}

overridable.RoomIsFirstVisit = function()
	return Game():GetRoom():IsFirstVisit()
end

return overridable