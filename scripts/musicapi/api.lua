assert(_VERSION == "Lua 5.3", "The game is no longer using Lua 5.3! Alert the mod's developers ASAP!") --LuaJIT will remove integers. Watch for the update!

local MusicAPI = {}

local Flagset = require "scripts.musicapi.flagset"
local Query = require "scripts.musicapi.query"
local util = require "scripts.musicapi.util"
local enums = require "scripts.musicapi.enums"
local cache = require "scripts.musicapi.cache"
local data = require "scripts.musicapi.data"
local tracks = require "scripts.musicapi.tracks"

MusicAPI.APIVersion = {3, 0}

MusicAPI.Flagset = Flagset
MusicAPI.Query = require "scripts.musicapi.query"
MusicAPI.Util = util
local MusicOld = enums.MusicOld
local Music = enums.Music
MusicAPI.MusicOld = MusicOld
MusicAPI.Music = Music
MusicAPI.Cache = cache
MusicAPI.Data = data

MusicAPI.TagBit = {}
MusicAPI.NextTagSlot = 0

MusicAPI.Tracks = {}
MusicAPI.TrackCallbacks = {}

MusicAPI.Manager = MusicManager()
MusicAPI.Queue = {}

MusicAPI.Callbacks = {
	OnPlay = {}
}

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

function MusicAPI.Flag(s)
	local value = MusicAPI.TagBit[s]
	if value then
		return Flagset.Bit(value)
	else
		return Flagset.Bit(MusicAPI.AddTag(s))
	end
end

local MusicTranslatedIDs = {}
MusicAPI.MusicTranslatedIDs = MusicTranslatedIDs
for id, music in pairs(MusicOld) do
	if music ~= Music[id] then
		MusicTranslatedIDs[music] = Music[id]
	end
end

--translates old music ids to new music ids
function MusicAPI.FixID(id)
	return MusicTranslatedIDs[id] or id
end

--Metatable for tracks (for Global Variable Menu mod)
local mt_track = {
	-- __gvmrepr = function(self) return string.format("MusicAPI Track (%i tags)", #self.tags) end,
	-- __gvmkcolor = KColor(51/255, 231/255, 1.0, 1.0),
}

function MusicAPI.AddTrack(name, tags, music, persistence)
	local track = {}
	
	--Set metatable
	setmetatable(track, mt_track)
	
	--Some automatic steps:
		--  Assign a capital case name for each track, in case it appears in a menu
		--  Add its own name as a tag
		--  Add its track enum as a tag

	--Name
	local underscore_pos = name:find("_")
	if underscore_pos then
		track.Name = util.capitalCase(name:sub(underscore_pos + 1, -1)) .. " " .. util.capitalCase(name:sub(1, underscore_pos - 1))
	else
		track.Name = util.capitalCase(name)
	end
	
	--Music
	track.Music = music
	
	--Flags
	track.Flags = Flagset()
	
	--Persistence
	track.Persistence = persistence
	
	--Assign Tags to Flags
	for _, tag in ipairs(tags) do
		track.Flags:SetBit(MusicAPI.AddTag(tag), true)
	end
	
	--Assign own name as tag
	track.Flags:SetBit(MusicAPI.AddTag(name), true)
	
	--Add music enum as a tag
	if music then
		for music_name, music_id in pairs(Music) do
			if music == music_id then
				track.Flags:SetBit(MusicAPI.AddTag(music_name), true)
				break
			end
		end
	else
		track.Flags:SetBit(MusicAPI.AddTag("MUSIC_UNDEFINED"), true)
	end
	
	MusicAPI.Tracks[name] = track
end

--[[
MusicAPI.GetStageTrack(LevelStage levelstage, StageType stagetype, Dimension dimension, boolean glitched)

Returns the track name of the given stage (eg. "STAGE_BASEMENT"), regardless of room.
Arguments omitted will use the current level as default.

If glitched is true, then a different track is selected for the floor and is returned instead.
(for the Delete This challenge). False to force disable the effect, nil to use default value.
]]
function MusicAPI.GetStageTrack(levelstage, stagetype, dimension, glitched)
	if not levelstage then levelstage = cache.Stage end
	if not stagetype then stagetype = cache.StageType end
	if not dimension then dimension = cache.Dimension end
	if glitched == nil then glitched = cache.CHALLENGE_DELETE_THIS end
	
	if glitched then
		local seed = cache.Seeds:GetStartSeed()
		local rng = RNG()
		rng:SetSeed(seed + levelstage << 8 + stagetype << 2, 0x1C)
		return data.FloorsRand[rng:RandomInt(#data.FloorsRand) + 1]
	end
	
	local f
	if cache.Game:IsGreedMode() then
		f = data.FloorsGreed[levelstage]
	elseif dimension == 0 then
		f = data.Floors[levelstage]
	elseif dimension == 1 then
		f = data.FloorsAlternate[levelstage]
	elseif dimension == 2 then
		return "DIMENSION_DEATH_CERTIFICATE"
	end
	
	if f then
		local track_name = f[stagetype]
		if track_name then
			return track_name
		end
	end
	
	return "STAGE_NULL"
end

--[[
MusicAPI.GetMusicID(LevelStage levelstage, StageType stagetype)

Returns the music ID of the given stage (eg. 24), regardless of room.
If no arguments are given, the function will use the current stage.
]]
function MusicAPI.GetMusicID(levelstage, stagetype, apitype)
	local track_name = MusicAPI.GetStageTrack(levelstage, stagetype)
	local track = MusicAPI.Tracks[track_name]
	if track then return track.Music end
	return nil
end

--[[
MusicAPI.GetMainMenuTrack(number|nil dlc)

nil: Current
1: Rebirth
2: Afterbirth
3: Afterbirth+
4: Repentance

Afterbirth+ returns the same as repentance

UNUSED: Didn't implement main menu tracks (I tried ma vereh best, honest)
]]
do
	local t = {
		"MENU_MAIN_MENU_REBIRTH",
		"MENU_MAIN_MENU_AFTERBIRTH",
		"MENU_MAIN_MENU_AFTERBIRTH",
		"MENU_MAIN_MENU_REPENTANCE",
	}

	function MusicAPI.GetMainMenuTrack(dlc)
		if not dlc then
			dlc = REPENTANCE and 4 or 3
		end
		return t[dlc]
	end
end

--[[
MusicAPI.GetTreasureRoomTrack()

Get the tracks used as if the current room was a treasure room.
This is used internally, but can also be used by modders if they want to
recreate the music queue of a treasure room without actually being in one.
]]
function MusicAPI.GetTreasureRoomTrack()
	if (
		cache.Room:IsFirstVisit() and
		(cache.Game:IsGreedMode() or cache.Level:GetStage() ~= LevelStage.STAGE4_3) and
		cache.Dimension == 0 and
		not cache.STATE_BACKWARDS_PATH
	) then
		return "JINGLE_TREASURE_ROOM", MusicAPI.GetStageTrack()
	end
	return MusicAPI.GetStageTrack()
end

--[[
MusicAPI.GetBossRoomEntryTrack()

Get the tracks used as if the current room was a boss room.
Used internally.
]]
function MusicAPI.GetBossRoomEntryTrack()
	if cache.STATE_MAUSOLEUM_HEART_KILLED then
		if cache.Room:GetBossID() == 8 then
			return "ROOM_BOSS_CLEAR_NULL"
		else
			return "ROOM_BOSS_CLEAR_TWISTED"
		end
	end
	return "ROOM_BOSS_CLEAR"
end

--[[
MusicAPI.GetBossJingle(BossID|nil boss_id, ...)

If no arguments are given:
Get the boss jingle used as if the current room was a boss room.
Used in a non-boss room will return a generic boss jingle.

If given boss_id:
Get the boss track used for the boss id given.

Any arguments given after are passed to MusicAPI_GetGenericBossJingle if there
is no specific boss theme for this boss.
]]
function MusicAPI.GetBossJingle(boss_id, ...)
	boss_id = boss_id or cache.Room:GetBossID()
	-- level_stage = level_stage or cache.Stage
	-- local boss_idx = boss_id + level_stage << 16
	-- return data.Bosses[boss_idx] or data.Bosses[boss_id] or MusicAPI.GetGenericBossTrack(...)
	return data.BossJingles[boss_id] or MusicAPI.GetGenericBossJingle(...)
end

--[[
MusicAPI.GetBossTrack(BossID|nil boss_id, ...)

If no arguments are given:
Get the boss track used as if the current room was a boss room.
Used in a non-boss room will return a generic boss track.

If given boss_id:
Get the boss track used for the boss id given.

Any arguments given after are passed to MusicAPI_GetGenericBossTrack if there
is no specific boss theme for this boss.
]]
function MusicAPI.GetBossTrack(boss_id, ...)
	boss_id = boss_id or cache.Room:GetBossID()
	-- TAZ: This is for floor specific boss tracks, eg. BOSS_MOMS_HEART_MAUSOLEUM and BOSS_MOMS_HEART_WOMB. Feature is disabled for now.
	-- level_stage = level_stage or cache.Stage
	-- local boss_idx = boss_id + level_stage << 16
	-- return data.Bosses[boss_idx] or data.Bosses[boss_id] or MusicAPI.GetGenericBossTrack(...)
	return data.Bosses[boss_id] or MusicAPI.GetGenericBossTrack(...)
end

--[[
MusicAPI.GetBossClearJingle(BossID|nil boss_id, ...)

If no arguments are given:
Get the boss clear jingle used as if the current room was a boss room.
Used in a non-boss room will return a generic boss jingle.

If given boss_id:
Get the boss track used for the boss id given.

Any arguments given after are passed to MusicAPI_GetGenericBossClearJingle if there
is no specific boss theme for this boss.
]]
function MusicAPI.GetBossClearJingle(boss_id, ...)
	boss_id = boss_id or cache.Room:GetBossID()
	-- level_stage = level_stage or cache.Stage
	-- local boss_idx = boss_id + level_stage << 16
	-- return data.Bosses[boss_idx] or data.Bosses[boss_id] or MusicAPI.GetGenericBossTrack(...)
	return data.BossClearJingles[boss_id] or MusicAPI.GetGenericBossClearJingle(...)
end

--[[
MusicAPI.GetGenericBossJingle()

Gets the generic boss jingle.
]]
function MusicAPI.GetGenericBossJingle(stage_type, decoration_seed)
	return "JINGLE_BOSS"
end

--[[
MusicAPI.GetGenericBossTrack(StageType|nil stage_type, number|nil decoration_seed)

Gets a generic boss theme.

Returns a theme based on the given floor type (eg STAGETYPE_ORIGINAL could
return Rebirth or Afterbirth themes, STAGETYPE_REPENTANCE only returns
Repentance theme. If no floor type is given, uses the current floor type.

If -1 is given as the stage_type, any theme can be returned.

decoration_seed, which determines random choices. Leave this as nil to use the current room descriptor.
]]
do
	local generic_boss_tracks = {
		"BOSS_REBIRTH",
		"BOSS_AFTERBIRTH",
		"BOSS_REPENTANCE"
	}
	
	local stagetype_boss_tracks = {
		[StageType.STAGETYPE_REPENTANCE] = "BOSS_REPENTANCE",
		[StageType.STAGETYPE_REPENTANCE_B] = "BOSS_REPENTANCE",
	}
	
	function MusicAPI.GetGenericBossTrack(stage_type, room_descriptor)
		stage_type = stage_type or cache.StageType
		local stage_type_track = stagetype_boss_tracks[stage_type]
		decoration_seed = decoration_seed or cache.RoomDescriptor.DecorationSeed
		
		if stage_type_track then
			return stage_type_track
		elseif stage_type == -1 then
			return generic_boss_tracks[decoration_seed % 3 + 1]
		else
			return generic_boss_tracks[decoration_seed % 2 + 1]
		end
	end
end

--[[
MusicAPI.GetGenericBossClearJingle(StageType|nil stage_type, number|nil decoration_seed)

Gets a generic boss clear jingle.

Returns a theme based on the given floor type (eg STAGETYPE_ORIGINAL could
return Rebirth or Afterbirth themes, STAGETYPE_REPENTANCE only returns
Repentance theme. If no floor type is given, uses the current floor type.

If -1 is given as the stage_type, any theme can be returned.

decoration_seed, which determines random choices. Leave this as nil to use the current room descriptor.
]]
do
	local generic_boss_tracks = {
		"JINGLE_BOSS_CLEAR_REBIRTH",
		"JINGLE_BOSS_CLEAR_AFTERBIRTH",
		"JINGLE_BOSS_CLEAR_REPENTANCE"
	}
	
	local stagetype_boss_tracks = {
		[StageType.STAGETYPE_REPENTANCE] = "JINGLE_BOSS_CLEAR_REPENTANCE",
		[StageType.STAGETYPE_REPENTANCE_B] = "JINGLE_BOSS_CLEAR_REPENTANCE",
	}
	
	function MusicAPI.GetGenericBossClearJingle(stage_type, room_descriptor)
		stage_type = stage_type or cache.StageType
		local stage_type_track = stagetype_boss_tracks[stage_type]
		decoration_seed = decoration_seed or cache.RoomDescriptor.DecorationSeed
		
		if stage_type_track then
			return stage_type_track
		elseif stage_type == -1 then
			return generic_boss_tracks[decoration_seed % 3 + 1]
		else
			return generic_boss_tracks[decoration_seed % 2 + 1]
		end
	end
end

--[[
MusicAPI.GetMinibossRoomEntryTrack()

Get the boss track used as if the current room was a miniboss room.
]]
function MusicAPI.GetMinibossRoomEntryTrack(boss_id, level_stage, ...)
	if cache.Room:IsClear() then
		return "ROOM_BOSS_CLEAR"
	else
		return "ROOM_MINIBOSS_ACTIVE"
	end
end

--[[
MusicAPI.GetChallengeRoomTrack()

Get the tracks used as if the current room was a challenge room.
Used internally.
]]
function MusicAPI.GetChallengeRoomTrack()
	-- TAZ: This IF is a quick way of getting this to work for vanilla but may need to be changed later
	if cache.Stage ~= cache.AbsoluteStage then 
		if cache.RoomDescriptor.ChallengeDone then
			return "ROOM_CHALLENGE_BOSS_CLEAR"
		else
			return "ROOM_CHALLENGE_BOSS_INACTIVE"
		end
	else
		if cache.RoomDescriptor.ChallengeDone then
			return "ROOM_CHALLENGE_NORMAL_CLEAR"
		else
			return "ROOM_CHALLENGE_NORMAL_INACTIVE"
		end
	end
end

--[[
MusicAPI.GetRoomEntryTrack(RoomType|nil room_type)

Gets the track name used for room entry.
Can return multiple values.

You can manually specify the room type. If not specified, the current room
type is used.
]]
do
	local jump_table = {
		[RoomType.ROOM_TREASURE] = MusicAPI.GetTreasureRoomTrack,
		[RoomType.ROOM_BOSS] = MusicAPI.GetBossRoomEntryTrack,
		[RoomType.ROOM_MINIBOSS] = MusicAPI.GetMinibossRoomEntryTrack,
		[RoomType.ROOM_CHALLENGE] = MusicAPI.GetChallengeRoomTrack,
	}

	function MusicAPI.GetRoomEntryTrack(room_type, dimension)
		local room_type = room_type or cache.Room:GetType()
		local room_track_name = data.Rooms[room_type]
		local room_track = MusicAPI.Tracks[room_track_name]
		
		if cache.STATE_BACKWARDS_PATH then
			return "STATE_ASCENT"
		elseif cache.STATE_MINESHAFT_ESCAPE then
			return "STATE_MINESHAFT_ESCAPE"
		end
		
		if cache.CurrentRoomIndex == -10 then -- Hardcoded beast
			if cache.Stage == LevelStage.STAGE8 then
				return "BOSS_BEAST"
			end
		end
		
		if data.GridRooms[cache.CurrentRoomIndex] then -- Special grid rooms
			return data.GridRooms[cache.CurrentRoomIndex]
		end
		
		if cache.Dimension == 0 or room_type == RoomType.ROOM_BOSS then
			if room_track and room_track.Music then -- Special rooms in data.lua
				return room_track_name
			end
			
			local jump_table_func = jump_table[room_type] -- Special rooms mapped to functions
			if jump_table_func then
				local a, b, c, d, e, f = jump_table_func()
				if MusicAPI.IsTrackPlayable(a) then
					return a, b, c, d, e, f
				end
			end
		end
		
		-- RANDOM FLOOR THEMES
		-- local v1 = (cache.RoomDescriptor.DecorationSeed % 8) + 1
		-- local v2 = (cache.RoomDescriptor.DecorationSeed >> 8) % 5
		-- if v2 >= 3 then v2 = v2 + 1 end
		-- return MusicAPI.GetStageTrack(v1, v2)
		
		-- MAUSO ALL DAY EVERY DAY
		-- return "STAGE_MAUSOLEUM"
		
		return MusicAPI.GetStageTrack()
	end
end

--[[
MusicAPI.GetGameOverTrack()
]]
function MusicAPI.GetGameOverTrack()
	-- TAZ: Maybe some spicy new floor will add new game over music
	return "JINGLE_GAME_OVER", "STATE_GAME_OVER"
end

--[[
MusicAPI.GetGreedFightTrack(LevelStage level_stage)
]]
function MusicAPI.GetGreedFightTrack(level_stage)
	return data.GreedThemes[level_stage or cache.Stage]
end

--[[
MusicAPI.GetGreedFightOutro(LevelStage level_stage)
]]
function MusicAPI.GetGreedFightOutro(level_stage)
	return data.GreedThemeOutros[level_stage or cache.Stage]
end

--[[
MusicAPI.StartBossState(number|boolean start_jingle)

Sets MusicAPI to treat the current room like a boss fight.

Bosses have to be in the room, or else the state will jump straight
to the boss defeat jingle.
]]
function MusicAPI.StartBossState(start_jingle, theme, end_jingle)
	if start_jingle == true then
		start_jingle = MusicAPI.GetBossJingle()
	end

	MusicAPI.State = {
		Type = "Boss",
		Phase = start_jingle and 1 or 2,
		TrackStart = start_jingle,
		TrackMain = theme or MusicAPI.GetBossTrack(),
		TrackEnd = end_jingle or MusicAPI.GetBossClearJingle(),
	}
	MusicAPI.PlayTrack(start_jingle or MusicAPI.State.TrackMain)
end

--[[
MusicAPI.StartUltraGreedPreBossState(theme, end_jingle)
]]
function MusicAPI.StartUltraGreedPreBossState(theme, end_jingle)
	MusicAPI.State = {
		Type = "UltraGreedPreBoss",
		Phase = 1,
		Tracks = {
			theme or MusicAPI.GetBossTrack(),
			end_jingle or MusicAPI.GetBossClearJingle(),
		}
	}
end

--[[
MusicAPI.StartSatanBossState(number|boolean start_jingle)
]]
function MusicAPI.StartSatanBossState(start_jingle, theme_inactive, theme_phase1, theme_phase2, end_jingle)
	if start_jingle == true then
		start_jingle = MusicAPI.GetBossJingle()
	end

	local ent = Isaac.FindByType(EntityType.ENTITY_SATAN)[1]
	if ent then
		ent = ent:ToNPC()
		if not ent then
			return MusicAPI.StartBossState(start_jingle, theme_phase1, end_jingle)
		end
	end

	MusicAPI.State = {
		Type = "SatanBoss",
		Phase = start_jingle and 1 or 2,
		TrackStart = start_jingle,
		TrackInactive = theme_inactive or "BOSS_SATAN_INACTIVE",
		TrackPhase1 = theme_phase1 or MusicAPI.GetGenericBossTrack(),
		TrackPhase2 = theme_phase2 or "BOSS_SATAN",
		TrackEnd = end_jingle or MusicAPI.GetBossClearJingle(),
		Entity = ent,
	}
	
	MusicAPI.PlayTrack(start_jingle or MusicAPI.State.TrackInactive)
end

--[[
MusicAPI.StartMegaSatanBossState(number|boolean start_jingle)
]]
function MusicAPI.StartMegaSatanBossState(start_jingle, theme_inactive, theme_main, end_jingle)
	if start_jingle == true then
		start_jingle = MusicAPI.GetBossJingle()
	end
	
	theme_inactive = theme_inactive or "BOSS_SATAN_INACTIVE"

	MusicAPI.State = {
		Type = "MegaSatanBoss",
		Phase = start_jingle and 1 or 2,
		TrackStart = start_jingle,
		TrackInactive = theme_inactive or theme_inactive,
		TrackMain = theme_main or MusicAPI.GetBossTrack(),
		TrackEnd = end_jingle or MusicAPI.GetBossClearJingle(),
	}
	
	MusicAPI.PlayTrack(start_jingle or MusicAPI.State.TrackInactive)
end

--[[
MusicAPI.StartDogmaBossState(number|boolean start_jingle)
]]
function MusicAPI.StartDogmaBossState(intro_theme, theme_main, end_jingle)
	local ent = Isaac.FindByType(EntityType.ENTITY_DOGMA, 0)[1]
	if ent then
		ent = ent:ToNPC()
	end
	if not ent then return end
	
	if intro_theme == true then
		intro_theme = "INTRO_DOGMA"
	end

	MusicAPI.State = {
		Type = "DogmaBoss",
		Phase = intro_theme and 1 or 2,
		TrackIntro = intro_theme,
		TrackMain = theme_main or "BOSS_DOGMA",
		TrackEnd = end_jingle or "JINGLE_BOSS_DOGMA_CLEAR",
		Entity = ent,
	}
	
	if not intro_theme then
		MusicAPI.PlayTrack(MusicAPI.State.TrackMain)
	else
		MusicAPI.PlayTrack(MusicAPI.State.TrackIntro)
	end
end

--[[
MusicAPI.StartAngelBossState()

Sets MusicAPI to treat the current room like an angel boss fight.

Bosses have to be in the room, or else the state will jump straight
to the boss defeat jingle.
]]
function MusicAPI.StartAngelBossState(theme, end_jingle)
	MusicAPI.State = {
		Type = "AngelBoss",
		Phase = 1,
		TrackMain = theme or MusicAPI.GetBossTrack(),
		TrackEnd = end_jingle or MusicAPI.GetBossClearJingle(),
	}
end

--[[
MusicAPI.StartUltraGreedBossState(start_jingle, theme_main, end_jingle)
]]
function MusicAPI.StartUltraGreedBossState(start_jingle, theme_main, end_jingle)
	if start_jingle == true then
		start_jingle = MusicAPI.GetBossJingle()
	end

	MusicAPI.State = {
		Type = "UltraGreedBoss",
		Phase = start_jingle and 1 or 2,
		Tracks = {
			start_jingle,
			theme_main or MusicAPI.GetBossTrack(),
			end_jingle or MusicAPI.GetBossClearJingle(),
		}
	}
	MusicAPI.PlayTrack(start_jingle or MusicAPI.State.Tracks[2])
end

--[[
MusicAPI.StartMinibossState()

Sets MusicAPI to treat the current room like a miniboss fight.

Bosses have to be in the room, or else the state will jump straight
to the ambush clear jingle.
]]
function MusicAPI.StartMinibossState()
	MusicAPI.State = {
		Type = "Miniboss",
		Phase = 2, --starts on 2 like boss without jingle
	}
end

--[[
MusicAPI.StartBossAmbushState(string ambush_theme, string ambush_end_jingle, boolean waiting)

Sets MusicAPI to treat the current room like a boss ambush (boss challenge room).

If waiting is true, MusicAPI waits for Room_IsAmbushActive before starting, otherwise the ambush
is started straight away.
]]
function MusicAPI.StartAmbushState(ambush_theme, ambush_end_jingle, ambush_clear, waiting)
	MusicAPI.State = {
		Type = "Ambush",
		Phase = waiting and 1 or 2,
		TrackMain = ambush_theme,
		TrackEnd = ambush_end_jingle,
		TrackClear = ambush_clear,
	}
	
	if not waiting then
		MusicAPI.PlayTrack(ambush_theme)
	end
end

--[[
MusicAPI.StartGreedState(enemy_theme, enemy_end_jingle, boss_theme, boss_end_jingle, final_boss_theme, calm)
]]
function MusicAPI.StartGreedState(enemy_theme, enemy_end_jingle, boss_theme, boss_end_jingle, final_boss_theme, calm)
	MusicAPI.State = {
		Type = "Greed",
		Phase = 0,
		Tracks = {
			enemy_theme or MusicAPI.GetGreedFightTrack(),
			enemy_end_jingle or MusicAPI.GetGreedFightOutro(),
			boss_theme or MusicAPI.GetGenericBossTrack(),
			boss_end_jingle or MusicAPI.GetGenericBossClearJingle(),
			final_boss_theme or "BOSS_GREEDMODE_EXTRA",
			calm or "ROOM_BOSS_CLEAR"
		}
		--[[
			PHASES:
			0 - INACTIVE
			1 - ENEMIES
			2 - BOSS 1-2
			3 - BOSS 3
		]]
	}
end

--[[
MusicAPI.ClearState()

Stops MusicAPI from automatically changing the music mid-room.
]]
function MusicAPI.ClearState()
	MusicAPI.State = nil
end

--[[
MusicAPI.GetRoomTrack()

Returns the value of MusicAPI.CurrentTrack. This value is set every new
room to the equivalent of MusicAPI.GetRoomEntryTrack(), and for some
bosses like Hush and Satan where the music changes mid-fight.

This is so that users can get the intended track for a room at any time.
]]
function MusicAPI.GetRoomTrack()
	return MusicAPI.CurrentTrack
end

--[[
MusicAPI.SetRoomTrack(track_name)

Used internally only. Used to set MusicAPI.CurrentTrack.
]]
function MusicAPI.SetRoomTrack(track_name)
	local track = MusicAPI.Tracks[track_name]
	if track then
		MusicAPI.CurrentTrack = track_name
	end
end

--[[
MusicAPI.PlayJingle(string track_name)

Inserts a jingle before the current queue.
]]
function MusicAPI.PlayJingle(track_name)
	table.insert(MusicAPI.Queue, 1, track_name)
	MusicAPI.UseQueue()
end

--[[
MusicAPI.PlayTrack(string track_name, ...)

Given a track name, MusicAPI will look it up and play or crossfade the music ID.
If the track name doesn't exist, or the track has no music ID associated, then
nothing happens.

Multiple tracks can be given. In this case, all further tracks are queued.

Important edge cases:
- If a persistence 1 jingle is playing in the first queue slot, and the track in
  the first argument is already queued after it, this function will do nothing.
- If a persistence 2 jingle is playing in the first queue slot, then the tracks will
  be queued after it regardless.
]]
function MusicAPI.PlayTrack(...)
	local queued_first = MusicAPI.Tracks[MusicAPI.Queue[1]]
	local track_names = {...}
	
	if queued_first then
		if queued_first.Persistence == 1 and track_names[1] == MusicAPI.Queue[2] then
			-- No action
			return
		elseif queued_first.Persistence == 2 then
			-- Removes all but the persistence 2 track
			MusicAPI.Queue = {MusicAPI.Queue[1]}
		else
			-- Empty queue
			MusicAPI.EmptyQueue(#track_names > 0)
		end
	end

	for _, name in ipairs(track_names) do
		MusicAPI.QueueTrack(name)
	end
end

--[[
MusicAPI.PlayJingle(string track_name)

Given a track name, MusicAPI will look it up and play or crossfade the music ID.
If the track name doesn't exist, or the track has no music ID associated, then
nothing happens.
]]
function MusicAPI.PlayJingle(track_name)
	if MusicAPI.Queue[1] == track_name then
		return
	end

	table.insert(MusicAPI.Queue, 1, track_name)
	MusicAPI.UseQueue()
end

--[[
MusicAPI.ForcePlayTrack(string track_name)

Used internally.
]]
function MusicAPI.ForcePlayTrack(track_name)
	local music = MusicAPI.GetTrackMusic(track_name)
	if music then
		MusicAPI.Queue = {track_name}
		MusicAPI.Crossfade(music)
	end
end

--[[
MusicAPI.ReloadRoomTrack()

Calculates the room track to be used and plays it.
]]
do
	local ReloadRoomTrack_JumpTable = {
		[RoomType.ROOM_BOSS] = function()
			if cache.Game:IsGreedMode() then
				if cache.Room:GetBossID() == 0 then
					return MusicAPI.StartUltraGreedPreBossState()
				end
			end
			
			if not cache.Room:IsClear() then
				local jingle = not MusicAPI.BeforeStart
				if cache.Room:GetBossID() == 24 then
					MusicAPI.StartSatanBossState(jingle)
				elseif cache.Room:GetBossID() == 55 then
					MusicAPI.StartMegaSatanBossState(jingle)
				elseif cache.Room:GetBossID() == 62 then
					MusicAPI.StartUltraGreedBossState(jingle)
				else
					MusicAPI.StartBossState(jingle)
				end
			end
		end,
		[RoomType.ROOM_MINIBOSS] = function()
			if not cache.Room:IsClear() then
				MusicAPI.StartMinibossState()
			end
		end,
		[RoomType.ROOM_CHALLENGE] = function()
			if not cache.RoomDescriptor.ChallengeDone then
				if cache.Stage ~= cache.AbsoluteStage then 
					MusicAPI.StartAmbushState("ROOM_CHALLENGE_BOSS_ACTIVE", "JINGLE_CHALLENGE_BOSS_CLEAR", "ROOM_CHALLENGE_BOSS_CLEAR", true)
				else
					MusicAPI.StartAmbushState("ROOM_CHALLENGE_NORMAL_ACTIVE", "JINGLE_CHALLENGE_NORMAL_CLEAR", "ROOM_CHALLENGE_NORMAL_CLEAR", true)
				end
			end
		end,
	}

	function MusicAPI.ReloadRoomTrack()
		local track_names = {MusicAPI.GetRoomEntryTrack()}
		MusicAPI.SetRoomTrack(track_names[1])
		MusicAPI.PlayTrack(table.unpack(track_names))
		
		if MusicAPI.ContinueState == true then
			MusicAPI.ContinueState = nil
		else
			MusicAPI.ClearState()
		end
		
		local j = ReloadRoomTrack_JumpTable[cache.RoomType]
		if j then j() end
		
		if not MusicAPI.State then
			if cache.Game:IsGreedMode() then
				for i=1,cache.Room:GetGridSize() do
					local gridentity = cache.Room:GetGridEntity(i)
					if gridentity and gridentity:GetType() == GridEntityType.GRID_PRESSURE_PLATE and gridentity:GetVariant() == 2 then
						MusicAPI.StartGreedState()
						break
					end
				end
			end
		end
		
		MusicAPI.BeforeStart = false
	end
end

--[[
MusicAPI.IsTrackPlayable(string track_name)

Returns true if the track has music associated with it. False otherwise.
]]
function MusicAPI.IsTrackPlayable(track_name)
	local track = MusicAPI.Tracks[track_name]
	if track then
		if type(track.Music) == "number" then
			return true
		elseif type(track.Music) == "table" then
			return #track.Music > 0
		end
	end
	return false
end

--[[
MusicAPI.QueueTrack(string track_name)

MusicAPI queues this track to play once the current music is finished playing.
If the track name doesn't exist, or the track has no music ID associated, then
nothing happens.
]]
function MusicAPI.QueueTrack(track_name)
	--if MusicAPI.TrackIsPlayable(track_name) then
	if #MusicAPI.Queue == 0 then
		MusicAPI.ForcePlayTrack(track_name)
	else
		table.insert(MusicAPI.Queue, track_name)
	end
end

--[[
MusicAPI.PopTrackQueue()

Forces the next item in the track queue to play.

Returns the previously playing track.
]]
function MusicAPI.PopTrackQueue()
	local current = MusicAPI.Queue[1]
	table.remove(MusicAPI.Queue, 1)
	MusicAPI.UseQueue()
	return current
end

--[[
MusicAPI.EmptyQueue(bool dontStopPlaying)

Empties the track queue. If dontStopPlaying is true, then the music
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
function MusicAPI.UseQueue()
	local queue_1 = MusicAPI.Queue[1]
	if queue_1 then
		MusicAPI.Crossfade(MusicAPI.GetTrackMusic(queue_1))
	else
		MusicAPI.Manager:Crossfade(Music.MUSIC_MUSICAPI_NOTHING)
	end
end

--[[
MusicAPI.Crossfade(Music music_id)

Calls the MusicManager's crossfade for this music id.
]]
function MusicAPI.Crossfade(music_id)
	MusicAPI.Manager:Crossfade(music_id)
	MusicAPI.Manager:Queue(Music.MUSIC_MUSICAPI_QUEUE_POP)
	MusicAPI.RunOnPlayCallbacks()
end

--[[
MusicAPI.ResetTracks()

Resets all tracks back to their default values.
]]
function MusicAPI.ResetTracks()
	for track_name, track in pairs(tracks) do
		MusicAPI.AddTrack(track_name, track.tags, track.music, track.persistence)
	end
end

--[[
MusicAPI.ResetTrack(string track_name)

Resets the named track back to its default values.
]]
function MusicAPI.ResetTrack(track_name)
	local track = tracks[track_name]
	if track then
		MusicAPI.AddTrack(track_name, track.tags, track.music)
	end
end

--[[
MusicAPI.PreGameStart()

To be called before a run starts. Sets up some variables, plays main menu music.
]]
function MusicAPI.PreGameStart()
	MusicAPI.BeforeStart = true -- set to false in gamecallbacks.lua on new room
	-- MusicAPI.PlayTrack(MusicAPI.GetMainMenuTrack())
	MusicAPI.Queue = {"API_GAME_START"}
end

--[[
MusicAPI.GetTrackMusic(string track_name)

Gets a music id from the given track name.
Only one can be returned, so if multiple music IDs are stored, a
random one is returned.
]]
function MusicAPI.GetTrackMusic(track_name)
	local track = MusicAPI.Tracks[track_name]
	if track then
		local track_music_type = type(track.Music)
		if track_music_type == "number" then
			return track.Music
		elseif track_music_type == "table" then
			return track.Music[math.random(#track.Music)]
		end
	end
end

--[[
MusicAPI.TestQueueAllJingles()

A test. Queues all tracks with the JINGLE flag.
]]
local isJingle = Query() & MusicAPI.Flag("JINGLE")
function MusicAPI.TestQueueAllJingles()
	MusicAPI.EmptyQueue(true)
	for track_name, track in pairs(MusicAPI.Tracks) do
		if isJingle(track.Flags) then
			MusicAPI.QueueTrack(track_name)
		end
	end
end

local AddCallbackAssert1 = util.assertTypeFn({"function"}, 1)

--[[
MusicAPI.AddOnPlayCallback(function<void(string|nil, number)> func)

Takes a function that takes a string (track name) and a number (track id).
The function given will be called every time a track is played. The function's
return value is ignored.
]]
function MusicAPI.AddOnPlayCallback(func)
	AddCallbackAssert1(func)
	local callbacks = MusicAPI.Callbacks.OnPlay
	callbacks[#callbacks + 1] = func
end

--[[
MusicAPI.RunOnPlayCallbacks([string], [number])

Arguments are optional. If being run without arguments, it must be
called AFTER MusicManager_Play/Crossfade

Runs all OnPlay callbacks.
]]
function MusicAPI.RunOnPlayCallbacks(track_name, track_id)
	if not track_name then
		track_name = MusicAPI.Queue[1]
		if MusicAPI.IsTrackPlayable(track_name) then
			track_id = MusicAPI.Manager:GetCurrentMusicID()
		else
			track_id = 0
		end
	end
	
	for _, callback in ipairs(MusicAPI.Callbacks.OnPlay) do
		callback(track_name, track_id)
	end
end

--[[
MusicAPI.AddOnTrackCallback(func)

TAZ: Thinking of adding a priority number here, so mods can choose how important their callback is.
]]
-- local AddCallbackAssert2 = util.assertTypeFn({"MusicAPI.Query", "MusicAPI.Flagset", "number", "nil"}, 3)
function MusicAPI.AddOnTrackCallback(func, req)
	AddCallbackAssert1(func)
	local callbacks = MusicAPI.Callbacks.OnTrack
	callbacks[#callbacks + 1] = func
end

MusicAPI.Save = {Game = {}}

--[[
MusicAPI.SaveData()
]]
function MusicAPI.SaveData()
	local json = require "json"
	local d = {
		Mod = {
			Version = 3,
			VersionMinor = 0,
			Name = "MusicAPI"
		},
		Data = MusicAPI.Save
	}
	d = json.encode(d)
	Isaac.SaveModData(MusicAPI.ModMusic, d)
end

--[[
MusicAPI.LoadData()
]]
function MusicAPI.LoadData()
	local json = require "json"
	MusicAPI.Save = {}
	
	local s, err = pcall(function()
		if Isaac.HasModData(MusicAPI.ModMusic) then
			local d = Isaac.LoadModData(MusicAPI.ModMusic)
			d = json.decode(d)
			if d.Mod and d.Mod.Version == 3 and d.Mod.Name == "MusicAPI" then
				MusicAPI.Save = d.Data
			end
		end
	end)
	-- if not s then GVM.Print(err) end
	
	MusicAPI.Save.Game = MusicAPI.Save.Game or {}
end

-------------------------------- FUNCTIONS FOR ALTERING DATA --------------------------------

--[[
MusicAPI.SetBossTrack(BossID boss_id, string track_name)

Boss fights in rooms with this boss id will use the given track.
]]
function MusicAPI.SetBossTrack(boss_id, track_name)
	-- if level_stage then
		-- data.Bosses[boss_id + level_stage << 16] = track_name
	-- else
		data.Bosses[boss_id] = track_name
	-- end
end

-------------------------------- GAME CALLBACKS --------------------------------

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	local manager = MusicAPI.Manager
	
	if MusicAPI.Queue[1] == "API_GAME_START" then
		local current_id = manager:GetCurrentMusicID()
		if not (current_id == Music.MUSIC_JINGLE_GAME_START or current_id == Music.MUSIC_JINGLE_GAME_START_ALT) then
			MusicAPI.PopTrackQueue()
		else
			manager:Queue(Music.MUSIC_MUSICAPI_QUEUE_POP)
		end
	end
	
	if manager:GetCurrentMusicID() == Music.MUSIC_MUSICAPI_QUEUE_POP then
		MusicAPI.PopTrackQueue()
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(self, is_continued)
	MusicAPI.LoadData()
	if not is_continued then
		MusicAPI.Save.Game = {}
	end
end)

mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function(self, should_save)
	if not should_save then
		MusicAPI.Save.Game = nil
	end
	MusicAPI.SaveData()
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
	return cache.Dimension
end

return MusicAPI