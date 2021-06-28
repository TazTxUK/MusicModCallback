assert(_VERSION == "Lua 5.3", "The game is no longer using Lua 5.3! Alert the mod's developers!") --LuaJIT will remove integers. Watch for the update!

local MusicAPI = {}

local Flagset = require "scripts.musicapi.flagset"
local util = require "scripts.musicapi.util"
local enums = require "scripts.musicapi.enums"
local cache = require "scripts.musicapi.cache"
local data = require "scripts.musicapi.data"
local triggers = require "scripts.musicapi.triggers"

MusicAPI.APIVersion = 3

MusicAPI.Flagset = Flagset
MusicAPI.Query = require "scripts.musicapi.query"
MusicAPI.Util = util
local MusicOld = enums.MusicOld
local Music = enums.Music
MusicAPI.MusicOld = MusicOld
MusicAPI.Music = Music

MusicAPI.TagBit = {}
MusicAPI.NextTagSlot = 0

MusicAPI.Triggers = {}
MusicAPI.TriggerCallbacks = {}

MusicAPI.Manager = MusicManager()

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

function MusicAPI.AddTrigger(name, tags, track)
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

--[[
MusicAPI.GetStageTriggerName(LevelStage levelstage, StageType stagetype)

Returns the trigger name of the given stage (eg. "STAGE_BASEMENT"), regardless of room.
If no arguments are given, the function will use the current stage.
]]
function MusicAPI.GetStageTriggerName(levelstage, stagetype)
	if not levelstage then levelstage = cache.Level:GetStage() end
	if not stagetype then stagetype = cache.Level:GetStageType() end
	
	local f = data.Floors[levelstage]
	if f then
		local trigger_name = f[stagetype]
		if trigger_name then
			return trigger_name
		end
	end
	return "STAGE_NULL"
end

--[[
MusicAPI.GetStageTrack(LevelStage levelstage, StageType stagetype)

Returns the track ID of the given stage (eg. 24), regardless of room.
If no arguments are given, the function will use the current stage.
]]
function MusicAPI.GetStageTrack(levelstage, stagetype, apitype)
	local trigger_name = MusicAPI.GetStageTrackTrigger(levelstage, stagetype)
	local trigger = MusicAPI.Triggers[trigger_name]
	if trigger then return trigger.Music end
	return nil
end

--[[
MusicAPI.GetRoomEntryTriggerName()

Gets the trigger name used for room entry. For example, for a first time
treasure room, this would return "JINGLE_TREASURE_ROOM_n" where n is 0-3.

For boss rooms, this would return the boss jingle.
]]
function MusicAPI.GetRoomEntryTriggerName()
	local roomtype = cache.Room:GetType()
	local special_room_trigger = data.Rooms[roomtype]
	
	if special_room_trigger and special_room_trigger.Music then
		return special_room_trigger
	end
	
	return MusicAPI.GetStageTriggerName()
end

--[[
MusicAPI.GetRoomTriggerName()

Returns the value of MusicAPI.CurrentTrigger. This value is set every new
room to the equivalent of MusicAPI.GetRoomEntryTriggerName(), and for some
bosses like Hush and Satan where the music changes mid-fight.

This is so that users can get the intended track for a room at any time.
]]
function MusicAPI.GetRoomTriggerName()
	return MusicAPI.CurrentTrigger
end

--[[
MusicAPI.SetRoomTriggerName()

Used internally only. Used to set MusicAPI.CurrentTrigger.
]]
function MusicAPI.SetRoomTriggerName(trigger_name)
	local trigger = MusicAPI.Triggers[trigger_name]
	if trigger then
		MusicAPI.CurrentTrigger = trigger_name
	end
end

--[[
MusicAPI.GetRoomTreasureTriggerName()

Get the triggers used if the current room was a treasure room.
This is used internally, but can also be used by modders if they want to
recreate the music queue of a treasure room without actually being in one.
]]
function MusicAPI.GetRoomTreasureTriggerName()
	if (
		room:IsFirstVisit() and
		(cache.Game:IsGreedMode() or level:GetStage() ~= LevelStage.STAGE4_3) and
		MusicAPI.GetDimension() == 0 and
		not cache.STATE_BACKWARDS_PATH
	) then
		return ""
	end
end

--[[
MusicAPI.PlayTrigger(string trigger_name)

Given a trigger name, MusicAPI will look it up and play or crossfade the track.
If the trigger name doesn't exist, or the trigger has no track associated, then
nothing happens.
]]
function MusicAPI.PlayTrigger(trigger_name)
	local trigger = MusicAPI.Triggers[trigger_name]
	if trigger and trigger.Music then
		MusicAPI.Crossfade(trigger.Music)
	end
end

--[[
MusicAPI.PlayTrigger(Music trackid)

Calls the MusicManager's crossfade for this track id.
]]
function MusicAPI.Crossfade(trackid)
	MusicAPI.Manager:Crossfade(trackid)
end

function MusicAPI.ResetTriggers()
	for trigger_name, trigger in pairs(triggers) do
		MusicAPI.AddTrigger(trigger_name, trigger.tags, trigger.track)
	end
end

function MusicAPI.ResetTrigger(trigger_name)
	local trigger = triggers[trigger_name]
	if trigger then
		MusicAPI.AddTrigger(trigger_name, trigger.tags, trigger.track)
	end
end

-------------------------------- NON MUSIC RELATED FUNCTIONS BELOW --------------------------------

--[[
MusicAPI.GetDimension()

Gets the game's current dimension.
0 - Normal
1 - Mirror World/Mineshaft
2 - Death Certificate
]]
function MusicAPI.GetDimension()
	
end

return MusicAPI