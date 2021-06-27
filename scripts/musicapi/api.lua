assert(_VERSION == "Lua 5.3", "The game is no longer using Lua 5.3! Alert the mod's developers!") --LuaJIT will remove integers. Watch for the update!

local MusicAPI = {}

local Flagset = require "scripts.musicapi.flagset"
local util = require "scripts.musicapi.util"

MusicAPI.APIVersion = 3

MusicAPI.Flagset = Flagset
MusicAPI.Query = require "scripts.musicapi.query"
MusicAPI.Util = util
local Music, MusicOld = require "scripts.musicapi.enums"
MusicAPI.MusicOld = MusicOld
MusicAPI.Music = Music

MusicAPI.TagBit = {}
MusicAPI.NextTagSlot = 0

MusicAPI.Triggers = {}
MusicAPI.TriggerCallbacks = {}

function MusicAPI.AddTag(tagname)
	if not MusicAPI.TagBit[tagname] then
		MusicAPI.TagBit[tagname] = MusicAPI.NextTagSlot
		MusicAPI.NextTagSlot = MusicAPI.NextTagSlot + 1
	end
	return MusicAPI.TagBit[tagname]
end

function MusicAPI.TagIsUsed(tagname)
	return MusicAPI.TagBit[tagname] and true
end

function MusicAPI.Flag(s)
	local value = MusicAPI.TagBit[s]
	if value then
		return Flagset.Bit(value)
	else
		return Flagset()
	end
end


local MusicTranslatedIDs = {}
MusicAPI.MusicTranslatedIDs = MusicTranslatedIDs
for id, track in pairs(MusicOld) do
	MusicTranslatedIDs[track] = Music[id]
end

--translates old music ids to new music ids
function MusicAPI.FixID(id)
	return MusicTranslatedIDs[id] or id
end

--Metatable for triggers (for Global Variable Menu mod)
local mt_trigger = {
	__gvmrepr = function(self) return string.format("MusicAPI Trigger (%i tags)", #self.tags) end,
	__gvmkcolor = KColor(51/255, 231/255, 1.0, 1.0),
}

function MusicAPI.AddTrigger(name, track, tags)
	local trigger = {}
	
	--Set metatable
	setmetatable(trigger, mt_trigger)
	
	--Some automatic steps:
		--  Assign a capital case name for each trigger, in case it appears in a menu
		--  Add its own name as a tag
		--  Add its track enum as a tag

	--Name
	local underscore_pos = name:find("_")
	if underscore_pos then
		trigger.Name = util.capitalCase(name:sub(underscore_pos + 1, -1)) .. " " .. util.capitalCase(name:sub(1, underscore_pos - 1))
	else
		trigger.Name = util.capitalCase(name)
	end
	
	--Track
	trigger.Music = track
	
	--Flags
	trigger.Flags = Flagset()
	
	--Assign Tags to Flags
	for _, tag in ipairs(tags) do
		trigger.Flags:SetBit(MusicAPI.AddTag(tag), true)
	end
	
	--Assign own name as tag
	trigger.Flags:SetBit(MusicAPI.AddTag(name), true)
	
	--Add track enum as a tag
	if track then
		for music_name, music_id in pairs(Music) do
			if track == music_id then
				trigger.Flags:SetBit(MusicAPI.AddTag(music_name), true)
				break
			end
		end
	else
		trigger.Flags:SetBit(MusicAPI.AddTag("MUSIC_UNDEFINED"), true)
	end
	
	MusicAPI.Triggers[name] = trigger
end

local AddCallbackAssert2 = util.assertTypeFn({"function"}, 2)
local AddCallbackAssert3 = util.assertTypeFn({"MusicAPI.Query", "MusicAPI.Flagset", "number", "nil"}, 3)
function MusicAPI.AddCallback(id, func, req)
	AddCallbackAssert2(func); AddCallbackAssert3(req)
	MusicAPI.TriggerCallbacks[#MusicAPI.TriggerCallbacks + 1] = func
end

return MusicAPI