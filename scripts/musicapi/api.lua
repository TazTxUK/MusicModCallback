assert(_VERSION == "Lua 5.3", "The game is no longer using Lua 5.3! Alert the mod's developers!") --LuaJIT will remove integers. Watch for the update!

local M = {} --MusicModCallback
local Flagset = require "scripts.musicapi.flagset"

M.TagBit = {}
M.NextTagSlot = 0

M.Triggers = {}

function M.AddTag(tagname)
	M.TagBit[tagname] = M.NextTagSlot
	M.NextTagSlot = M.NextTagSlot + 1
end

function M.Flag(s)
	local value = M.TagBit[s]
	if value then
		return Flagset.Bit(value)
	else
		return Flagset()
	end
end

for _, t in pairs(require "scripts.musicapi.triggers") do
	for _, tag in ipairs(t.tags) do
		M.AddTag(tag)
	end
end

local Query = require "scripts.musicapi.query"
local util = require "scripts.musicapi.util"

--TEST REMOVE LATER
local Q1 = Query() & M.Flag("STAGE1_2")
local Q2 = Query() & M.Flag("REPENTANCE")
local Q3 = Query() & M.Flag("JINGLE") & ~M.Flag("JINGLE_DEAL_ROOM")

util.cout(Q1("STAGE1_1"))
util.cout(Q1("STAGE1_2"))
util.cout(Q2("REPENTANCE"))

return M