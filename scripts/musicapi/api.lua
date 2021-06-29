assert(_VERSION == "Lua 5.3", "The game is no longer using Lua 5.3! Alert the mod's developers!") --LuaJIT will remove integers. Watch for the update!

local MusicAPI = {}

local Flagset = require "scripts.musicapi.flagset"
local Query = require "scripts.musicapi.query"
local util = require "scripts.musicapi.util"
local enums = require "scripts.musicapi.enums"
local cache = require "scripts.musicapi.cache"
local data = require "scripts.musicapi.data"
local triggers = require "scripts.musicapi.triggers"

MusicAPI.APIVersion = {3, 0}

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
MusicAPI.Queue = {}

MusicAPI.ModMusic = RegisterMod("MusicAPI Music", 1)
local mod = MusicAPI.ModMusic

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

function MusicAPI.Flag(s, force)
	local value = MusicAPI.TagBit[s]
	if value then
		return Flagset.Bit(value)
	else
		if force then
			return Flagset.Bit(MusicAPI.AddTag(s))
		end
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
	-- __gvmrepr = function(self) return string.format("MusicAPI Trigger (%i tags)", #self.tags) end,
	-- __gvmkcolor = KColor(51/255, 231/255, 1.0, 1.0),
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
	local trigger_name = MusicAPI.GetStageTriggerName(levelstage, stagetype)
	local trigger = MusicAPI.Triggers[trigger_name]
	if trigger then return trigger.Music end
	return nil
end

--[[
MusicAPI.GetRoomEntryTriggerName()

Gets the trigger name used for room entry.
Can return multiple values.
]]
function MusicAPI.GetRoomEntryTriggerName()
	local roomtype = cache.Room:GetType()
	local room_trigger_name = data.Rooms[roomtype]
	local room_trigger = MusicAPI.Triggers[room_trigger_name]
	
	if room_trigger and room_trigger.Music then
		return room_trigger_name
	end
	
	if roomtype == RoomType.ROOM_TREASURE then
		return MusicAPI.GetRoomTreasureTriggerName()
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
		cache.Room:IsFirstVisit() and
		(cache.Game:IsGreedMode() or cache.Level:GetStage() ~= LevelStage.STAGE4_3) and
		MusicAPI.GetDimension() == 0 and
		not cache.STATE_BACKWARDS_PATH
	) then
		return "JINGLE_TREASURE_ROOM", MusicAPI.GetStageTriggerName()
	end
	return MusicAPI.GetStageTriggerName()
end

--[[
MusicAPI.PlayTrigger(string trigger_name)

Given a trigger name, MusicAPI will look it up and play or crossfade the track.
If the trigger name doesn't exist, or the trigger has no track associated, then
nothing happens.
]]
function MusicAPI.PlayTrigger(trigger_name)
	if type(trigger_name) == "string" then
		local trigger_music = MusicAPI.GetTriggerMusic(trigger_name)
		if trigger_music then
			MusicAPI.Queue = {trigger_name}
			MusicAPI.Crossfade(trigger_music)
		end
	elseif type(trigger_name) == "table" then
		local n = 1
		while true do
			if n > #trigger_name then return end
			local trigger_music = MusicAPI.GetTriggerMusic(trigger_name[i])
			n = n + 1
			if trigger_music then
				MusicAPI.Queue = {trigger_name}
				MusicAPI.Crossfade(trigger_music)
				break
			end
		end
		for i=n,#trigger_name do
			MusicAPI.QueueTrigger(trigger_name[i])
		end
	end
end

--[[
MusicAPI.PlayTriggers(table trigger_names)

Given trigger names, MusicAPI will look it up and play or crossfade the first track,
and then queue the remaining.
]]
function MusicAPI.PlayTriggers(trigger_names)
	MusicAPI.EmptyQueue(true)
	for _, name in ipairs(trigger_names) do
		MusicAPI.QueueTrigger(name)
	end
end

--[[
MusicAPI.EvaluateTrigger(string trigger_name)

Returns the track ID associated with the trigger. If no tracks are associated,
returns nil.
]]
function MusicAPI.EvaluateTrigger(trigger_name)
	local trigger_music = MusicAPI.GetTriggerMusic(trigger_name)
	if trigger_music then
		return trigger_music
	end
end

--[[
MusicAPI.QueueTrigger(string trigger_name)

MusicAPI queues this trigger to play once the current music is finished playing.
If the trigger name doesn't exist, or the trigger has no track associated, then
nothing happens.
]]
function MusicAPI.QueueTrigger(trigger_name)
	--if MusicAPI.TriggerIsPlayable(trigger_name) then
	
	if #MusicAPI.Queue == 0 then
		MusicAPI.PlayTrigger(trigger_name)
	else
		table.insert(MusicAPI.Queue, trigger_name)
	end
end

--[[
MusicAPI.PopTriggerQueue()

Forces the next item in the trigger queue to play.

Returns the previously playing trigger.
]]
function MusicAPI.PopTriggerQueue()
	local current = MusicAPI.Queue[1]
	table.remove(MusicAPI.Queue, 1)
	local queue_1 = MusicAPI.Queue[1]
	if queue_1 then
		MusicAPI.Crossfade(MusicAPI.EvaluateTrigger(queue_1))
	else
		MusicAPI.Manager:Crossfade(Music.MUSIC_MUSICAPI_NOTHING)
	end
	return current
end

--[[
MusicAPI.EmptyQueue(bool dontStopPlaying)

Empties the trigger queue. If dontStopPlaying is true, then the music
will not be stopped despite the queue being empty.
]]
function MusicAPI.EmptyQueue(dontStopPlaying)
	MusicAPI.Queue = {}
	if not dontStopPlaying then
		MusicAPI.Manager:Crossfade(Music.MUSIC_MUSICAPI_NOTHING)
	end
end

--[[
MusicAPI.UseQueue()

Make MusicAPI play the track at the front of the queue.
Use after editing the queue directly.
]]

--[[
MusicAPI.Crossfade(Music trackid)

Calls the MusicManager's crossfade for this track id.
]]
function MusicAPI.Crossfade(trackid)
	MusicAPI.Manager:Crossfade(trackid)
	MusicAPI.Manager:Queue(Music.MUSIC_MUSICAPI_QUEUE_POP)
end

--[[
MusicAPI.ResetTriggers()

Resets all triggers back to their default values.
]]
function MusicAPI.ResetTriggers()
	for trigger_name, trigger in pairs(triggers) do
		MusicAPI.AddTrigger(trigger_name, trigger.tags, trigger.track)
	end
end

--[[
MusicAPI.ResetTrigger(string trigger_name)

Resets the named trigger back to its default values.
]]
function MusicAPI.ResetTrigger(trigger_name)
	local trigger = triggers[trigger_name]
	if trigger then
		MusicAPI.AddTrigger(trigger_name, trigger.tags, trigger.track)
	end
end


--[[
MusicAPI.GetTriggerMusic(string trigger_name)

Gets a music id from the given trigger name.
Only one can be returned, so if multiple music IDs are stored, a
random one is returned.
]]
function MusicAPI.GetTriggerMusic(trigger_name)
	local trigger = MusicAPI.Triggers[trigger_name]
	if trigger then
		local trigger_music_type = type(trigger.Music)
		GVM.Print(trigger_name.." "..trigger_music_type)
		if trigger_music_type == "number" then
			return trigger.Music
		elseif trigger_music_type == "table" then
			return trigger.Music[math.random(#trigger.Music)]
		end
	end
end

local isJingle = Query() & MusicAPI.Flag("JINGLE", true)
function MusicAPI.TestQueueAllJingles()
	MusicAPI.EmptyQueue(true)
	for trigger_name, trigger in pairs(MusicAPI.Triggers) do
		if isJingle(trigger.Flags) then
			MusicAPI.QueueTrigger(trigger_name)
		end
	end
end

-------------------------------- GAME CALLBACKS --------------------------------

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	local manager = MusicAPI.Manager
	if manager:GetCurrentMusicID() == Music.MUSIC_MUSICAPI_QUEUE_POP then
		MusicAPI.PopTriggerQueue()
	end
end)

-------------------------------- NON MUSIC RELATED FUNCTIONS BELOW --------------------------------

--[[
MusicAPI.GetDimension()

Gets the game's current dimension.
0 - Normal
1 - Mirror World/Mineshaft
2 - Death Certificate
]]
function MusicAPI.GetDimension()
	return 0
end

return MusicAPI