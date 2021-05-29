if MMC then return end

local MusicModCallback = RegisterMod("Music Mod Callback", 1)

local json = require("json")
local modSaveData = {}

MMC = {}
MMC.Mod = MusicModCallback

MMC.Version = "2.0"

Isaac.ConsoleOutput("Loaded Music Mod Callback "..MMC.Version.."\n")

local newmusicenum = {
	MUSIC_NULL = 0,
	MUSIC_BASEMENT = Isaac.GetMusicIdByName("Basement"),
	MUSIC_CAVES = Isaac.GetMusicIdByName("Caves"),
	MUSIC_DEPTHS = Isaac.GetMusicIdByName("Depths"),
	MUSIC_CELLAR = Isaac.GetMusicIdByName("Cellar"),
	MUSIC_CATACOMBS = Isaac.GetMusicIdByName("Catacombs"),
	MUSIC_NECROPOLIS = Isaac.GetMusicIdByName("Necropolis"),
	MUSIC_WOMB_UTERO = Isaac.GetMusicIdByName("Womb"),
	MUSIC_GAME_OVER = Isaac.GetMusicIdByName("Game Over"),
	MUSIC_BOSS = Isaac.GetMusicIdByName("Boss"),
	MUSIC_CATHEDRAL = Isaac.GetMusicIdByName("Cathedral"),
	MUSIC_SHEOL = Isaac.GetMusicIdByName("Sheol"),
	MUSIC_DARK_ROOM = Isaac.GetMusicIdByName("Dark Room"),
	MUSIC_CHEST = Isaac.GetMusicIdByName("Chest"),
	MUSIC_BURNING_BASEMENT = Isaac.GetMusicIdByName("Burning Basement"),
	MUSIC_FLOODED_CAVES = Isaac.GetMusicIdByName("Flooded Caves"),
	MUSIC_DANK_DEPTHS = Isaac.GetMusicIdByName("Dank Depths"),
	MUSIC_SCARRED_WOMB = Isaac.GetMusicIdByName("Scarred Womb"),
	MUSIC_BLUE_WOMB = Isaac.GetMusicIdByName("Blue Womb"),
	MUSIC_MOM_BOSS = Isaac.GetMusicIdByName("Boss (Depths - Mom)"),
	MUSIC_MOMS_HEART_BOSS = Isaac.GetMusicIdByName("Boss (Womb - Mom's Heart)"),
	MUSIC_ISAAC_BOSS = Isaac.GetMusicIdByName("Boss (Cathedral - Isaac)"),
	MUSIC_SATAN_BOSS = Isaac.GetMusicIdByName("Boss (Sheol - Satan)"),
	MUSIC_DARKROOM_BOSS = Isaac.GetMusicIdByName("Boss (Dark Room)"),
	MUSIC_BLUEBABY_BOSS = Isaac.GetMusicIdByName("Boss (Chest - ???)"),
	MUSIC_BOSS2 = Isaac.GetMusicIdByName("Boss (alternate)"),
	MUSIC_HUSH_BOSS = Isaac.GetMusicIdByName("Boss (Blue Womb - Hush)"),
	MUSIC_ULTRAGREED_BOSS = Isaac.GetMusicIdByName("Boss (Ultra Greed)"),
	MUSIC_LIBRARY_ROOM = Isaac.GetMusicIdByName("Library Room"),
	MUSIC_SECRET_ROOM = Isaac.GetMusicIdByName("Secret Room"),
	MUSIC_DEVIL_ROOM = Isaac.GetMusicIdByName("Devil Room"),
	MUSIC_ANGEL_ROOM = Isaac.GetMusicIdByName("Angel Room"),
	MUSIC_SHOP_ROOM = Isaac.GetMusicIdByName("Shop Room"),
	MUSIC_ARCADE_ROOM = Isaac.GetMusicIdByName("Arcade Room"),
	MUSIC_BOSS_OVER = Isaac.GetMusicIdByName("Boss Room (empty)"),
	MUSIC_CHALLENGE_FIGHT = Isaac.GetMusicIdByName("Challenge Room (fight)"),
	MUSIC_CREDITS = Isaac.GetMusicIdByName("Credits"),
	MUSIC_TITLE = Isaac.GetMusicIdByName("Title Screen"),
	MUSIC_TITLE_AFTERBIRTH = Isaac.GetMusicIdByName("Title Screen (Afterbirth)"),
	MUSIC_JINGLE_BOSS = Isaac.GetMusicIdByName("Boss (jingle)"),
	MUSIC_JINGLE_BOSS_OVER = Isaac.GetMusicIdByName("Boss Death (jingle)"),
	MUSIC_JINGLE_HOLYROOM_FIND = Isaac.GetMusicIdByName("Holy Room Find (jingle)"),
	MUSIC_JINGLE_SECRETROOM_FIND = Isaac.GetMusicIdByName("Secret Room Find (jingle)"),
	MUSIC_JINGLE_TREASUREROOM_ENTRY_0 = Isaac.GetMusicIdByName("Treasure Room Entry (jingle) 1"),
	MUSIC_JINGLE_TREASUREROOM_ENTRY_1 = Isaac.GetMusicIdByName("Treasure Room Entry (jingle) 2"),
	MUSIC_JINGLE_TREASUREROOM_ENTRY_2 = Isaac.GetMusicIdByName("Treasure Room Entry (jingle) 3"),
	MUSIC_JINGLE_TREASUREROOM_ENTRY_3 = Isaac.GetMusicIdByName("Treasure Room Entry (jingle) 4"),
	MUSIC_JINGLE_CHALLENGE_ENTRY = Isaac.GetMusicIdByName("Challenge Room Entry (jingle)"),
	MUSIC_JINGLE_CHALLENGE_OUTRO = Isaac.GetMusicIdByName("Challenge Room Outro (jingle)"),
	MUSIC_JINGLE_GAME_OVER = Isaac.GetMusicIdByName("Game Over (jingle)"),
	MUSIC_JINGLE_DEVILROOM_FIND = Isaac.GetMusicIdByName("Devil Room appear (jingle)"),
	MUSIC_JINGLE_GAME_START = Isaac.GetMusicIdByName("Game start (jingle)"),
	MUSIC_JINGLE_NIGHTMARE = Isaac.GetMusicIdByName("Nightmare"),
	MUSIC_JINGLE_BOSS_OVER2 = Isaac.GetMusicIdByName("Boss Death Alternate (jingle)"),
	MUSIC_JINGLE_HUSH_OVER = Isaac.GetMusicIdByName("Boss Hush Death (jingle)"),
	MUSIC_INTRO_VOICEOVER = Isaac.GetMusicIdByName("Intro Voiceover"),
	MUSIC_EPILOGUE_VOICEOVER = Isaac.GetMusicIdByName("Epilogue Voiceover"),
	MUSIC_VOID = Isaac.GetMusicIdByName("Void"),
	MUSIC_VOID_BOSS = Isaac.GetMusicIdByName("Boss (Void)"),
	
	MUSIC_UTERO = Isaac.GetMusicIdByName("Utero"),
	MUSIC_SECRET_ROOM2 = Isaac.GetMusicIdByName("Secret Room Alt"),
	MUSIC_BOSS_RUSH = Isaac.GetMusicIdByName("Boss Rush"),
	MUSIC_JINGLE_BOSS_RUSH_OUTRO = Isaac.GetMusicIdByName("Boss Rush (jingle)"),
	MUSIC_BOSS3 = Isaac.GetMusicIdByName("Boss (alternate alternate)"),
	MUSIC_JINGLE_BOSS_OVER3 = Isaac.GetMusicIdByName("Boss Death Alternate Alternate (jingle)"),
	MUSIC_MOTHER_BOSS = Isaac.GetMusicIdByName("Boss (Mother)"),
	MUSIC_DOGMA_BOSS = Isaac.GetMusicIdByName("Boss (Dogma)"),
	MUSIC_BEAST_BOSS = Isaac.GetMusicIdByName("Boss (Beast)"),
	MUSIC_JINGLE_MOTHER_OVER = Isaac.GetMusicIdByName("Boss Mother Death (jingle)"),
	MUSIC_JINGLE_DOGMA_OVER = Isaac.GetMusicIdByName("Boss Dogma Death (jingle)"),
	MUSIC_JINGLE_BEAST_OVER = Isaac.GetMusicIdByName("Boss Beast Death (jingle)"),
	MUSIC_PLANETARIUM = Isaac.GetMusicIdByName("Planetarium"),
	MUSIC_SECRET_ROOM_ALT_ALT = Isaac.GetMusicIdByName("Secret Room Alt Alt"),
	MUSIC_BOSS_OVER_TWISTED = Isaac.GetMusicIdByName("Boss Room (empty, twisted)"),
	MUSIC_TITLE_REPENTANCE = Isaac.GetMusicIdByName("Title Screen (Repentance)"),
	MUSIC_JINGLE_GAME_START_ALT = Isaac.GetMusicIdByName("Game start (jingle, twisted)"),
	MUSIC_JINGLE_NIGHTMARE_ALT = Isaac.GetMusicIdByName("Nightmare (alt)"),
	MUSIC_MOTHERS_SHADOW_INTRO = Isaac.GetMusicIdByName("Mom's Shadow Intro"),
	MUSIC_DOGMA_INTRO = Isaac.GetMusicIdByName("Dogma Intro"),
	MUSIC_STRANGE_DOOR_JINGLE = Isaac.GetMusicIdByName("Strange Door (jingle)"),
	MUSIC_DARK_CLOSET = Isaac.GetMusicIdByName("Echoes Reverse"),
	MUSIC_CREDITS_ALT = Isaac.GetMusicIdByName("Credits Alt"),
	MUSIC_CREDITS_ALT_FINAL = Isaac.GetMusicIdByName("Credits Alt Final"),
	MUSIC_DOWNPOUR = Isaac.GetMusicIdByName("Downpour"),
	MUSIC_MINES = Isaac.GetMusicIdByName("Mines"),
	MUSIC_MAUSOLEUM = Isaac.GetMusicIdByName("Mausoleum"),
	MUSIC_CORPSE = Isaac.GetMusicIdByName("Corpse"),
	MUSIC_DROSS = Isaac.GetMusicIdByName("Dross"),
	MUSIC_ASHPIT = Isaac.GetMusicIdByName("Ashpit"),
	MUSIC_GEHENNA = Isaac.GetMusicIdByName("Gehenna"),
	MUSIC_MORTIS = (function() -- what the fuck
		local Mortis = Isaac.GetMusicIdByName("Mortis")
		return Mortis >= 0 and Mortis or Isaac.GetMusicIdByName("not done")
	end)(),
	MUSIC_ISAACS_HOUSE = Isaac.GetMusicIdByName("Home"),
	MUSIC_FINAL_VOICEOVER = Isaac.GetMusicIdByName("Final Voiceover"),
	MUSIC_DOWNPOUR_REVERSE = Isaac.GetMusicIdByName("Downpour (reversed)"),
	MUSIC_DROSS_REVERSE = Isaac.GetMusicIdByName("Dross (reversed)"),
	MUSIC_MINESHAFT_AMBIENT = Isaac.GetMusicIdByName("Abandoned Mineshaft"),
	MUSIC_MINESHAFT_ESCAPE = Isaac.GetMusicIdByName("Mineshaft Escape"),
	MUSIC_REVERSE_GENESIS = Isaac.GetMusicIdByName("Genesis (reversed)"),
}

for _,n in pairs(newmusicenum) do
	if not newmusicenum.NUM_MUSIC or n > newmusicenum.NUM_MUSIC then
		newmusicenum.NUM_MUSIC = n
	end
end
newmusicenum.NUM_MUSIC = newmusicenum.NUM_MUSIC + 1

local musicmgr = MusicManager()

MusicPreMMC = MusicPreMMC or Music

local redirectmusicenum = {}
for i,v in pairs(MusicPreMMC) do
	if v < MusicPreMMC.NUM_MUSIC and redirectmusicenum[v] ~= newmusicenum[i] then
		redirectmusicenum[v] = newmusicenum[i]
	end
end

Music = newmusicenum

local chapter_music = {}
MMC.ChapterMusic = chapter_music
local chapter_music_greed = {}
MMC.ChapterMusicGreed = chapter_music_greed

chapter_music[LevelStage.STAGE1_1] = {
	[StageType.STAGETYPE_ORIGINAL] = Music.MUSIC_BASEMENT,
	[StageType.STAGETYPE_WOTL] = Music.MUSIC_CELLAR,
	[StageType.STAGETYPE_AFTERBIRTH] = Music.MUSIC_BURNING_BASEMENT,
	[StageType.STAGETYPE_REPENTANCE] = Music.MUSIC_DOWNPOUR,
	[StageType.STAGETYPE_REPENTANCE_B] = Music.MUSIC_DROSS,
}

local chapter_music_default = chapter_music[LevelStage.STAGE1_1]

chapter_music[LevelStage.STAGE1_2] = chapter_music[LevelStage.STAGE1_1]

chapter_music[LevelStage.STAGE2_1] = {
	[StageType.STAGETYPE_ORIGINAL] = Music.MUSIC_CAVES,
	[StageType.STAGETYPE_WOTL] = Music.MUSIC_CATACOMBS,
	[StageType.STAGETYPE_AFTERBIRTH] = Music.MUSIC_FLOODED_CAVES,
	[StageType.STAGETYPE_REPENTANCE] = Music.MUSIC_MINES,
	[StageType.STAGETYPE_REPENTANCE_B] = Music.MUSIC_ASHPIT,
}

chapter_music[LevelStage.STAGE2_2] = chapter_music[LevelStage.STAGE2_1]

chapter_music[LevelStage.STAGE3_1] = {
	[StageType.STAGETYPE_ORIGINAL] = Music.MUSIC_DEPTHS,
	[StageType.STAGETYPE_WOTL] = Music.MUSIC_NECROPOLIS,
	[StageType.STAGETYPE_AFTERBIRTH] = Music.MUSIC_DANK_DEPTHS,
	[StageType.STAGETYPE_REPENTANCE] = Music.MUSIC_MAUSOLEUM,
	[StageType.STAGETYPE_REPENTANCE_B] = Music.MUSIC_GEHENNA,
}	

chapter_music[LevelStage.STAGE3_2] = chapter_music[LevelStage.STAGE3_1]

chapter_music[LevelStage.STAGE4_1] = {
	[StageType.STAGETYPE_ORIGINAL] = Music.MUSIC_WOMB_UTERO,
	[StageType.STAGETYPE_WOTL] = Music.MUSIC_UTERO,
	[StageType.STAGETYPE_AFTERBIRTH] = Music.MUSIC_SCARRED_WOMB,
	[StageType.STAGETYPE_REPENTANCE] = Music.MUSIC_CORPSE,
	[StageType.STAGETYPE_REPENTANCE_B] = Music.MUSIC_MORTIS,
}

chapter_music[LevelStage.STAGE4_2] = chapter_music[LevelStage.STAGE4_1]

chapter_music[LevelStage.STAGE4_3] = {
	[StageType.STAGETYPE_ORIGINAL] = Music.MUSIC_BLUE_WOMB,
}

chapter_music[LevelStage.STAGE5] = {
	[StageType.STAGETYPE_ORIGINAL] = Music.MUSIC_SHEOL,
	[StageType.STAGETYPE_WOTL] = Music.MUSIC_CATHEDRAL,
	[StageType.STAGETYPE_AFTERBIRTH] = Music.MUSIC_DARK_ROOM,
}

chapter_music[LevelStage.STAGE6] = {
	[StageType.STAGETYPE_ORIGINAL] = Music.MUSIC_DARK_ROOM,
	[StageType.STAGETYPE_WOTL] = Music.MUSIC_CHEST,
}

chapter_music[LevelStage.STAGE7] = {
	[StageType.STAGETYPE_ORIGINAL] = Music.MUSIC_VOID,
}

chapter_music[LevelStage.STAGE8] = {
	[StageType.STAGETYPE_ORIGINAL] = Music.MUSIC_ISAACS_HOUSE,
	[StageType.STAGETYPE_WOTL] = Music.MUSIC_DARK_CLOSET,
}

chapter_music_greed[LevelStage.STAGE1_GREED] = chapter_music[LevelStage.STAGE1_1]
chapter_music_greed[LevelStage.STAGE2_GREED] = chapter_music[LevelStage.STAGE2_1]
chapter_music_greed[LevelStage.STAGE3_GREED] = chapter_music[LevelStage.STAGE3_1]
chapter_music_greed[LevelStage.STAGE4_GREED] = chapter_music[LevelStage.STAGE4_1]
chapter_music_greed[LevelStage.STAGE5_GREED] = chapter_music[LevelStage.STAGE5]

chapter_music_greed[LevelStage.STAGE6_GREED] = {
	[StageType.STAGETYPE_ORIGINAL] = Music.MUSIC_SHOP_ROOM,
}

chapter_music_greed[LevelStage.STAGE7_GREED] = chapter_music_greed[LevelStage.STAGE6_GREED]

local function correctedTrackNum(n)
	if redirectmusicenum[n] then
		return redirectmusicenum[n]
	end
	return n
end

local addMusicCallback
local removeMusicCallback
local musicQueue
local musicCrossfade
local musicPlay

local Callbacks = {}
local usernolayers = false
local roomclearbefore = false
local challengedonebefore = false
local challengeactivebefore = false
local previousgreedwave = 0
local previousbosscount = 0
local waitingforgamestjingle = true
local satanfightstage = 0
local doorprevstates = {}
local inbadstage = false
local hadphotobefore = false
local foundknifepiecebefore = false
-- local treasure_jingle_timer
-- local treasure_volume = false

local stageapiexists = false

local overridemusicmgrfuncs = {
	Play = function(badself, track, vol) return musicPlay(track, nil, true) end,
	Fadein = function(badself, track, vol) return musicCrossfade(track, nil, true) end,
	Crossfade = function(badself, track) return musicCrossfade(track, nil) end,
	Queue = function(badself, track) return musicQueue(track, true) end,
	Fadeout = function(badself, ...) return musicmgr:Fadeout(...) end,
	Pause = function(badself, ...) return musicmgr:Pause(...) end,
	Resume = function(badself, ...) return musicmgr:Resume(...) end,
	EnableLayer = function(badself, ...) return musicmgr:EnableLayer(...) end,
	DisableLayer = function(badself, ...) return musicmgr:DisableLayer(...) end,
	IsLayerEnabled = function(badself, ...) return musicmgr:IsLayerEnabled(...) end,
	Enable = function(badself, ...) return musicmgr:Enable(...) end,
	Disable = function(badself, ...) return musicmgr:Disable(...) end,
	IsEnabled = function(badself, ...) return musicmgr:IsEnabled(...) end,
	PitchSlide = function(badself, ...) return musicmgr:PitchSlide(...) end,
	ResetPitch = function(badself, ...) return musicmgr:ResetPitch(...) end,
	VolumeSlide = function(badself, ...) return musicmgr:VolumeSlide(...) end,
	UpdateVolume = function(badself, ...) return musicmgr:UpdateVolume(...) end,
	GetCurrentMusicID = function(badself, ...) return musicmgr:GetCurrentMusicID(...) end,
	GetQueuedMusicID = function(badself, ...) return musicmgr:GetQueuedMusicID(...) end,
}

overridemusicmgrfuncs.__index = overridemusicmgrfuncs
local overridemusicmgr = {}
setmetatable(overridemusicmgr, overridemusicmgrfuncs)

local weakfunc = function() return end
local weakmusicmgrfuncs = {
	Play = weakfunc,
	Fadein = weakfunc,
	Crossfade = weakfunc,
	Queue = weakfunc
}

weakmusicmgrfuncs.__index = weakmusicmgrfuncs
local weakmusicmgr = {}
setmetatable(weakmusicmgr, weakmusicmgrfuncs)
setmetatable(weakmusicmgrfuncs, overridemusicmgrfuncs)

--it seems that if this code runs on game start, it only looks at save file 1
--it will look at the correct save file after enabling the mod from the Mod menu of a particular save file
--nonetheless, I think we should load this info again upon starting or continuing a run
if Isaac.HasModData(MusicModCallback) then
	local dat = Isaac.LoadModData(MusicModCallback)
	--handles legacy data system
	if dat == "0" then
		usernolayers = true
	elseif dat == "1" then
		usernolayers = false
	else
		modSaveData = json.decode(dat)
		usernolayers = (modSaveData["usernolayers"] or false)
	end
	modSaveData["usernolayers"] = usernolayers
else
	modSaveData["usernolayers"] = false
end

local function getChapterMusic(floor_type, floor_variant, greed)
	local music_table = greed and chapter_music_greed or chapter_music
	local chapter = music_table[floor_type] or chapter_music_default
	return chapter[floor_variant] or chapter[StageType.STAGETYPE_ORIGINAL] or Music.MUSIC_TITLE_REPENTANCE
end

local function getStageMusic()
	local game = Game()
	local level = game:GetLevel()
	local stage = level:GetStage()
	local stage_type = level:GetStageType()
	return getChapterMusic(stage, stage_type, game:IsGreedMode())
end

local function getGenericBossMusic()
	local game = Game()
	local level = game:GetLevel()
	local stage_type = level:GetStageType()
	local room = game:GetRoom()
	if stage_type == StageType.STAGETYPE_REPENTANCE or stage_type == StageType.STAGETYPE_REPENTANCE_B then
		return Music.MUSIC_BOSS3
	else
		if room:GetDecorationSeed() % 2 == 0 then
			return Music.MUSIC_BOSS
		else
			return Music.MUSIC_BOSS2
		end
	end
end

local function getGenericBossDeathJingle()
	local game = Game()
	local level = game:GetLevel()
	local stage_type = level:GetStageType()
	local room = game:GetRoom()
	if stage_type == StageType.STAGETYPE_REPENTANCE or stage_type == StageType.STAGETYPE_REPENTANCE_B then
		return Music.MUSIC_JINGLE_BOSS_OVER3
	else
		if room:GetDecorationSeed() % 2 == 0 then
			return Music.MUSIC_JINGLE_BOSS_OVER
		else
			return Music.MUSIC_JINGLE_BOSS_OVER2
		end
	end
end

local function getBossMusic()
	local room = Game():GetRoom()
	local boss_id = room:GetBossID()
	
	if boss_id == 6 then
		return Music.MUSIC_MOM_BOSS
	elseif boss_id == 8 then
		return Music.MUSIC_MOMS_HEART_BOSS
	elseif boss_id == 25 then
		return Music.MUSIC_MOMS_HEART_BOSS
	elseif boss_id == 24 then
		return Music.MUSIC_DEVIL_ROOM
	elseif boss_id == 39 then
		return Music.MUSIC_ISAAC_BOSS
	elseif boss_id == 40 then
		return Music.MUSIC_BLUEBABY_BOSS
	elseif boss_id == 54 then
		return Music.MUSIC_DARKROOM_BOSS
	elseif boss_id == 55 then
		return Music.MUSIC_DEVIL_ROOM
	elseif boss_id == 62 then
		return Music.MUSIC_ULTRAGREED_BOSS
	elseif boss_id == 63 then
		return Music.MUSIC_BLUEBABY_BOSS
	elseif boss_id == 70 then
		return Music.MUSIC_VOID_BOSS
	elseif boss_id == 88 then
		return Music.MUSIC_MOTHER_BOSS
	end
	
	return getGenericBossMusic()
end

local function getMusicTrack()
	local game = Game()
	local room = game:GetRoom()
	local roomtype = room:GetType()
	local level = game:GetLevel()
	local roomdesc = level:GetCurrentRoomDesc()
	local stage = level:GetStage()
	local stagetype = level:GetStageType()
	local roomidx = level:GetCurrentRoomIndex()
	local ascent = game:GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH) and stage <= 6
	local inrepstage = stagetype == StageType.STAGETYPE_REPENTANCE or stagetype == StageType.STAGETYPE_REPENTANCE_B
	
	if modSaveData["inmirroredworld"] then
		if roomtype ~= RoomType.ROOM_BOSS then
			local stage_type = level:GetStageType()
			if stage_type == StageType.STAGETYPE_REPENTANCE then
				return Music.MUSIC_DOWNPOUR_REVERSE --in vanilla, the reversed track is slowly faded in on top of the normal track (this is a low priority stretch goal)
			elseif stage_type == StageType.STAGETYPE_REPENTANCE_B then
				return Music.MUSIC_DROSS_REVERSE
			end
		end
	elseif modSaveData["inmineshaft"] then
		if level:GetStateFlag(LevelStateFlag.STATE_MINESHAFT_ESCAPE) then --this flag doesn't seem to be set until leaving the room after Mom's Shadow spawns
			return Music.MUSIC_MINESHAFT_ESCAPE
		else
			return Music.MUSIC_MINESHAFT_AMBIENT
		end
	end
	
	if ascent then
		return Music.MUSIC_REVERSE_GENESIS
	elseif roomtype == RoomType.ROOM_MINIBOSS or roomdesc.SurpriseMiniboss then
		if room:IsClear() then
			return Music.MUSIC_BOSS_OVER
		else
			return Music.MUSIC_CHALLENGE_FIGHT --Minibosses play Challenge music in Repentance
		end
	elseif roomtype == RoomType.ROOM_DEFAULT then
		return getStageMusic()
	elseif roomtype == RoomType.ROOM_SHOP then
		if (game:IsGreedMode() or level:GetStage() ~= LevelStage.STAGE4_3) then
			return Music.MUSIC_SHOP_ROOM
		else
			return getStageMusic()
		end
	elseif roomtype == RoomType.ROOM_TREASURE then
		if room:IsFirstVisit() and (game:IsGreedMode() or level:GetStage() ~= LevelStage.STAGE4_3) then
			local rng = math.random(0,3)
			local jingle
			if rng == 0 then
				jingle = Music.MUSIC_JINGLE_TREASUREROOM_ENTRY_0
			elseif rng == 1 then
				jingle = Music.MUSIC_JINGLE_TREASUREROOM_ENTRY_1
			elseif rng == 2 then
				jingle = Music.MUSIC_JINGLE_TREASUREROOM_ENTRY_2
			elseif rng == 3 then
				jingle = Music.MUSIC_JINGLE_TREASUREROOM_ENTRY_3
			end
			return jingle, getStageMusic()
		else
			return getStageMusic()
		end
	elseif roomtype == RoomType.ROOM_BOSS then
		if room:IsClear() then
			if inrepstage and stage == LevelStage.STAGE3_2 then
				if game:GetStateFlag(GameStateFlag.STATE_MAUSOLEUM_HEART_KILLED) then
					if room:GetBossID() == 8 then
						return Music.MUSIC_NULL --No music plays here
					else
						return Music.MUSIC_BOSS_OVER_TWISTED
					end
				end
			end
			return Music.MUSIC_BOSS_OVER
		else
			if room:GetBossID() == 0 then
				return getGenericBossMusic()
			else
				return Music.MUSIC_JINGLE_BOSS
			end
		end
	elseif roomtype == RoomType.ROOM_SECRET then
		return Music.MUSIC_SECRET_ROOM
	elseif roomtype == RoomType.ROOM_SUPERSECRET then
		return Music.MUSIC_SECRET_ROOM2
	elseif roomtype == RoomType.ROOM_ARCADE then
		return Music.MUSIC_ARCADE_ROOM
	elseif roomtype == RoomType.ROOM_DEVIL then
		return Music.MUSIC_DEVIL_ROOM
	elseif roomtype == RoomType.ROOM_ANGEL then
		return Music.MUSIC_ANGEL_ROOM
	elseif roomtype == RoomType.ROOM_LIBRARY then
		return Music.MUSIC_LIBRARY_ROOM
	elseif roomtype == RoomType.ROOM_CHALLENGE then
		if room:IsAmbushDone() then	
			return Music.MUSIC_BOSS_OVER
		elseif room:IsAmbushActive() then
			return Music.MUSIC_CHALLENGE_FIGHT
		else
			return getStageMusic()
		end
	elseif roomtype == RoomType.ROOM_BOSSRUSH then
		if room:IsAmbushDone() then	
			return Music.MUSIC_BOSS_OVER
		elseif room:IsAmbushActive() then
			return Music.MUSIC_BOSS_RUSH
		else
			return getStageMusic()
		end
	elseif roomtype == RoomType.ROOM_PLANETARIUM then
		return Music.MUSIC_PLANETARIUM
	elseif roomtype == RoomType.ROOM_ULTRASECRET then
		return Music.MUSIC_SECRET_ROOM_ALT_ALT
	elseif roomtype == (RoomType.ROOM_SECRET_EXIT or 27) then --RoomType.ROOM_SECRET_EXIT is not currently defined in enums.lua
		return Music.MUSIC_BOSS_OVER --the rooms with the exits to the Repentance alt floors
	elseif roomidx == -10 then
		return Music.MUSIC_BEAST_BOSS
	elseif roomidx == -14 then
		return getGenericBossMusic()
	elseif roomidx == -15 then
		return getGenericBossMusic()
	else
		return getStageMusic()
	end
	
	-- ROOM_DUNGEON 	
end

function addMusicCallback(ref, func, ...)
	assert(type(ref) == "table" and ref.Name, "Expected registered mod table for 1st argument, got "..type(ref))
	assert(type(func) == "function", "Expected function for 2nd argument, got "..type(func))
	local tracks = {...}
	for i=1,#tracks do
		local v = tracks[i]
		tracks[i] = tonumber(v)
	end
	if #tracks == 0 then tracks = nil end
	Callbacks[#Callbacks + 1] = {ref = ref.Name, func = func, tracks = tracks}
end

function removeMusicCallback(ref)
	assert(type(ref) == "table" and ref.Name, "Expected registered mod table for 1st argument, got "..type(ref))
	for i=1,#Callbacks do
		local v = Callbacks[i]
		if v.ref == ref.Name then
			table.remove(Callbacks, i)
			i = i - 1
		end
	end
end

local function iterateThroughCallbacks(track) -- returns correct track
	for i=1,#Callbacks do
		local v = Callbacks[i]
		
		local trackincallback = false
		if v.tracks then
			for j,k in ipairs(v.tracks) do
				if k == track then
					trackincallback = true
					break
				end
			end
		else
			trackincallback = true
		end
		
		if trackincallback then
			local s, res, res2 = pcall(v.func, v.ref, track)
			if s then
				res = tonumber(res)
				if res then
					return res, tonumber(res2)
				end
			else
				Isaac.ConsoleOutput("Error in music mod callback: "..res.."\n")
			end
		end
	end
	return track
end

function musicCrossfade(track, track2)
	local replacedtrack2 = false
	local id, id2 = iterateThroughCallbacks(track)
	if id2 then replacedtrack2 = true end
	id2 = id2 or track2
	if not id then
		return
	elseif id > 0 then
		if musicmgr:GetCurrentMusicID() ~= id then
			musicmgr:Crossfade(correctedTrackNum(id))
		end
		if id2 and id2 > 0 then
			if replacedtrack2 then
				musicmgr:Queue(correctedTrackNum(id2))
			else
				musicQueue(id2)
			end
		end
	elseif id < 0 then
		if id2 then
			if id2 == 0 then
				return
			elseif id2 < 0 then
				musicmgr:Fadeout()
				return
			end
			if replacedtrack2 then
				musicmgr:Crossfade(correctedTrackNum(id2))
			else
				musicCrossfade(id2, nil)
			end
		else
			musicmgr:Fadeout()
		end
	end
end

function musicPlay(track, track2)
	local replacedtrack2 = false
	local id, id2 = iterateThroughCallbacks(track or false)
	if id2 then replacedtrack2 = true end
	id2 = id2 or track2
	if id and id > 0 then
		if musicmgr:GetCurrentMusicID() ~= id then
			musicmgr:Play(correctedTrackNum(id),1)
			musicmgr:UpdateVolume()
		end
	elseif id == 0 then
		return
	elseif id < 0 then
		if id2 then
			if id2 == 0 then
				return
			elseif id2 < 0 then
				musicmgr:Fadeout()
				return
			end
			if replacedtrack2 then
				musicmgr:Play(correctedTrackNum(id2),1)
				musicmgr:UpdateVolume()
			else
				musicPlay(id2, nil)
			end
		else
			musicmgr:Fadeout()
		end
		return
	end
	if id2 and id2 > 0 then
		if replacedtrack2 then
			musicmgr:Queue(correctedTrackNum(id2))
		else
			musicQueue(id2)
		end
	end
end

function musicQueue(track)
	local id = iterateThroughCallbacks(track or false)
	if id and id > 0 then
		musicmgr:Queue(correctedTrackNum(id))
	end
end

function MusicModCallback:StageAPIcheck()
	if StageAPI and StageAPI.Loaded then
		stageapiexists = true
	else
		stageapiexists = false
	end
	
	if stageapiexists then
		if StageAPI.InNewStage() then
			inbadstage = true
			-- musicmgr:Play(getStageMusic(),1) -- StageAPI waits for other music to play.
			-- StageAPI.Music = overridemusicmgr
			StageAPI.Music = overridemusicmgr
		else
			inbadstage = false
			StageAPI.Music = weakmusicmgr
		end
	else
		inbadstage = false
	end
end

function MusicModCallback:LoadSaveData(isContinued)
	--run this when we start a game so we get the correct data for this save file
	if Isaac.HasModData(MusicModCallback) then
		local dat = Isaac.LoadModData(MusicModCallback)
		
		--handles legacy data system
		if dat == "0" then
			usernolayers = true
		elseif dat == "1" then
			usernolayers = false
		else
			modSaveData = json.decode(dat)
			usernolayers = (modSaveData["usernolayers"] or false)
		end
		
		modSaveData["usernolayers"] = usernolayers
		modSaveData["inmirrorroom"] = (modSaveData["inmirrorroom"] or false)
		modSaveData["inmirroredworld"] = (modSaveData["inmirroredworld"] or false)
		modSaveData["inmineroom"] = (modSaveData["inmineroom"] or false)
		modSaveData["inmineshaft"] = (modSaveData["inmineshaft"] or false)
		
		if not isContinued then --when starting a new run, of course we are not in mirror room or mirrored world!
			modSaveData["inmirrorroom"] = false
			modSaveData["inmirroredworld"] = false
			modSaveData["inmineroom"] = false
			modSaveData["inmineshaft"] = false
		end
	else
		modSaveData["usernolayers"] = false
		modSaveData["inmirrorroom"] = false
		modSaveData["inmirroredworld"] = false
		modSaveData["inmineroom"] = false
		modSaveData["inmineshaft"] = false
	end
end

function MusicModCallback:UpdateSaveValuesForNewFloor()
	modSaveData["inmirrorroom"] = false
	modSaveData["inmirroredworld"] = false
	modSaveData["inmineroom"] = false
	modSaveData["inmineshaft"] = false
end

MusicModCallback:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, MusicModCallback.StageAPIcheck)
MusicModCallback:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, MusicModCallback.UpdateSaveValuesForNewFloor)
MusicModCallback:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, MusicModCallback.StageAPIcheck)
MusicModCallback:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, MusicModCallback.LoadSaveData)

MusicModCallback:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	if not inbadstage then
		local room = Game():GetRoom()
		
		local previousinmirrorroom = modSaveData["inmirrorroom"]
		modSaveData["inmirrorroom"] = false
		
		local previousinmineroom = modSaveData["inmineroom"]
		modSaveData["inmineroom"] = false
		
		previousgreedwave = 0
		previousbosscount = 0
		satanfightstage = 0
		
		challengeactivebefore = room:IsAmbushActive()
		challengedonebefore = room:IsAmbushDone()
		roomclearbefore = room:IsClear()
		
		for i=0,7 do
			local door = room:GetDoor(i)
			if door then
				doorprevstates[i] = door.State
				
				if door.TargetRoomIndex == -100 then --the Mirror
					modSaveData["inmirrorroom"] = true
				elseif door.TargetRoomIndex == -101 then --the door to the Mineshaft
					modSaveData["inmineroom"] = true
				end
			end
		end
		
		if previousinmirrorroom and modSaveData["inmirrorroom"] then
			--this isn't ideal, but I can't find a GameStateFlag or something similar for being in the mirrored world
			if SFXManager():IsPlaying(SoundEffect.SOUND_MIRROR_ENTER) or SFXManager():IsPlaying(SoundEffect.SOUND_MIRROR_EXIT) then
				modSaveData["inmirroredworld"] = (not modSaveData["inmirroredworld"])
			end
		elseif previousinmineroom and modSaveData["inmineroom"] then
			--I'm concerned that a teleporting item or the D7 (restart room) could trigger this
			modSaveData["inmineshaft"] = (not modSaveData["inmineshaft"])
		end
		
		--NOTE: moved this below the door loop because we need to play Mirror Music immediately, and getMusicTrack() does not use doorprevstates
		if not waitingforgamestjingle then
			musicCrossfade(getMusicTrack())
		end
		
		if usernolayers or MMC.DisableMusicLayers then
			musicmgr:DisableLayer()
		end
		
		-- if room:GetType() == RoomType.ROOM_TREASURE and room:IsFirstVisit() then
			-- treasure_jingle_timer = 180
			-- treasure_volume = false
		-- end
	end
end)

MusicModCallback:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(self, ent)
	if ent.Variant == 2 then
		musicCrossfade(Music.MUSIC_HUSH_BOSS)
	end
end, EntityType.ENTITY_ISAAC)

MusicModCallback:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN,
function(self, type, variant, subtype, position, velocity, spawner, seed)
	if type == EntityType.ENTITY_DOGMA and variant == 1 then
		musicCrossfade(Music.MUSIC_DOGMA_INTRO, Music.MUSIC_DOGMA_BOSS)
	elseif type == EntityType.ENTITY_BEAST then
		musicCrossfade(Music.MUSIC_BEAST_BOSS)
	end
end)

MusicModCallback:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function()
	waitingforgamestjingle = true
	roomclearbefore = false
	challengedonebefore = false
	challengeactivebefore = false
	previousgreedwave = 0
	previousbosscount = 0
	satanfightstage = 0
	hadphotobefore = false
	foundknifepiecebefore = false
	Isaac.SaveModData(MusicModCallback, json.encode(modSaveData))
end)

MusicModCallback:AddCallback(ModCallbacks.MC_EXECUTE_CMD, function(self, cmd, params)
	if cmd == "mmclayer" then
		if params == "0" then
			usernolayers = true
			modSaveData["usernolayers"] = usernolayers
			Isaac.SaveModData(MusicModCallback, json.encode(modSaveData))
			--Isaac.SaveModData(MusicModCallback, "0") --legacy
			musicmgr:DisableLayer()
			return "Disabled music layers.\n"
		elseif params == "1" then
			usernolayers = false
			modSaveData["usernolayers"] = usernolayers
			Isaac.SaveModData(MusicModCallback, json.encode(modSaveData))
			--Isaac.SaveModData(MusicModCallback, "1") --legacy
			return "Enabled music layers.\n"
		end
	end
end)

MusicModCallback:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	if inbadstage then return end
	
	local room = Game():GetRoom()
	local level = Game():GetLevel()
	local roomclearnow = room:IsClear()
	local challengedonenow = room:IsAmbushDone()
	local challengeactivenow = room:IsAmbushActive()
	local roomdesc = Game():GetLevel():GetCurrentRoomDesc()
	local currentMusicId = musicmgr:GetCurrentMusicID()
	local ispaused = Game():IsPaused()
	
	--play music even if pause within first 10 frames (except on frame zero)
	if ispaused and room:GetFrameCount() > 0 and (currentMusicId == Music.MUSIC_JINGLE_GAME_START or currentMusicId == Music.MUSIC_JINGLE_GAME_START_ALT) then
		currentMusicId = 0
	end
	
	--if starting from menu, wait for start jingle to end 
	--upon reset, play new music immediately
	if waitingforgamestjingle and (room:GetFrameCount() > 10 or (currentMusicId ~= Music.MUSIC_JINGLE_GAME_START and currentMusicId ~= Music.MUSIC_JINGLE_GAME_START_ALT)) then
		if room:GetType() == RoomType.ROOM_BOSS and not room:IsClear() then
			musicCrossfade(getBossMusic())
		else
			musicCrossfade(getMusicTrack())
		end
		waitingforgamestjingle = false
		return
	end
	
	-- if treasure_jingle_timer then
		-- if treasure_jingle_timer > 0 then
			-- if not treasure_volume then
				-- musicmgr:VolumeSlide(0.1)
				-- treasure_volume = true
			-- end
			-- treasure_jingle_timer = treasure_jingle_timer - 1
		-- else
			-- treasure_jingle_timer = nil
			-- treasure_volume = false
			-- musicmgr:VolumeSlide(1)
		-- end	
	-- end
	
	--Angel Statue fight and minibosses; works for Normal and Greed Mode
	if room:GetType() == RoomType.ROOM_ANGEL then
		if roomclearbefore and not roomclearnow then
			musicCrossfade(getGenericBossMusic())
		elseif roomclearnow and not roomclearbefore then
			musicCrossfade(getGenericBossDeathJingle(), Music.MUSIC_BOSS_OVER)
		end
	elseif room:GetType() == RoomType.ROOM_MINIBOSS or roomdesc.SurpriseMiniboss then
		local currentbosscount = Isaac.CountBosses()
		
		if currentbosscount == 0 and previousbosscount > 0 then
			musicCrossfade(Music.MUSIC_JINGLE_CHALLENGE_OUTRO, Music.MUSIC_BOSS_OVER) --minibosses play Challenge music in Repentance
		end
		
		previousbosscount = currentbosscount
	end
	
	if Game():IsGreedMode() then
		local currentgreedwave = Game():GetLevel().GreedModeWave
		local totalWaves
		
		if Game().Difficulty == Difficulty.DIFFICULTY_GREEDIER then
			totalWaves = 12
		else
			totalWaves = 11
		end
		
		if room:GetType() == RoomType.ROOM_BOSS then
			local currentbosscount = Isaac.CountBosses()
			
			if room:GetBossID() == 62 then
				if satanfightstage == 0 then
					if currentbosscount == 0 then
						satanfightstage = 2
						musicCrossfade(Music.MUSIC_BOSS_OVER)
						return
					end
					satanfightstage = 1
					musicCrossfade(getBossMusic())
				elseif satanfightstage == 1 then
					for i,v in ipairs(Isaac.GetRoomEntities()) do
						if v.Type == EntityType.ENTITY_ULTRA_GREED then
							if v:ToNPC().State == 9001 then
								satanfightstage = 2
								musicCrossfade(Music.MUSIC_JINGLE_BOSS_OVER, Music.MUSIC_BOSS_OVER)
							end
							break
						end
					end
				end
			else
				if currentbosscount > 0 and room:GetFrameCount() == 1 then
					musicCrossfade(getBossMusic())
				end
				
				if currentbosscount == 0 and previousbosscount > 0 then
					musicCrossfade(getGenericBossDeathJingle(), Music.MUSIC_BOSS_OVER)
				end
			end
			
			previousbosscount = currentbosscount
		else
			if level:GetStage() == LevelStage.STAGE6_GREED then
				if room:GetType() == RoomType.ROOM_DEFAULT then
					if currentgreedwave < (totalWaves - 2) then
						if roomclearbefore and not roomclearnow then
							musicCrossfade(Music.MUSIC_CHALLENGE_FIGHT)
						end
						if roomclearnow and not roomclearbefore then
							musicCrossfade(Music.MUSIC_JINGLE_CHALLENGE_OUTRO, Music.MUSIC_SHOP_ROOM)
						end
					end
				end
			end
			
			if room:GetType() == RoomType.ROOM_DEFAULT then
				if roomclearbefore and not roomclearnow then
					if currentgreedwave == (totalWaves - 2) or currentgreedwave == (totalWaves - 1) then
						musicCrossfade(getGenericBossMusic())
					elseif currentgreedwave == totalWaves then
						musicCrossfade(Music.MUSIC_SATAN_BOSS)
					end
				elseif roomclearnow and not roomclearbefore then
					if currentgreedwave == (totalWaves - 2) or currentgreedwave == (totalWaves - 1) then
						musicCrossfade(getGenericBossDeathJingle(), Music.MUSIC_BOSS_OVER)
					elseif currentgreedwave == totalWaves then
						musicCrossfade(Music.MUSIC_BOSS_OVER) --no boss over jingle after Devil Deal Wave
					end
				end
			end
		end
		
		previousgreedwave = currentgreedwave
	else
		if room:GetType() == RoomType.ROOM_CHALLENGE or room:GetType() == RoomType.ROOM_BOSSRUSH then
			--for some reason boss rush music wasnt being triggered here
			--but was working fine in getMusicTrack()
			if challengeactivenow and not challengeactivebefore then
				local challengeMusicToPlay
				if room:GetType() == RoomType.ROOM_BOSSRUSH then
					challengeMusicToPlay = Music.MUSIC_BOSS_RUSH
				else
					challengeMusicToPlay = Music.MUSIC_CHALLENGE_FIGHT
				end
				musicCrossfade(challengeMusicToPlay)
			end
			--make sure boss rush music is played, not challenge music
			if challengeactivenow and not challengedonenow and room:GetType() == RoomType.ROOM_BOSSRUSH then
				musicCrossfade(Music.MUSIC_BOSS_RUSH)
			end
			if challengedonenow and not challengedonebefore then
				if room:GetType() == RoomType.ROOM_BOSSRUSH then
					musicCrossfade(Music.MUSIC_JINGLE_BOSS_RUSH_OUTRO, Music.MUSIC_BOSS_OVER)
				else
					musicCrossfade(Music.MUSIC_JINGLE_CHALLENGE_OUTRO, Music.MUSIC_BOSS_OVER)
				end
			end
		elseif room:GetType() == RoomType.ROOM_BOSS then
			local currentbosscount = Isaac.CountBosses()
			
			if currentbosscount > 0 and room:GetFrameCount() == 1 then
				satanfightstage = 0
				musicCrossfade(getBossMusic())
			end
			
			if room:GetFrameCount() > 1 then
				if room:GetBossID() == 24 then
					if satanfightstage == 0 and currentbosscount > 1 then
						musicCrossfade(getGenericBossMusic())
						satanfightstage = 1
					elseif satanfightstage == 1 and currentbosscount == 1 then
						musicCrossfade(Music.MUSIC_SATAN_BOSS)
						satanfightstage = 2
					end
				elseif room:GetBossID() == 55 then
					if Isaac.GetPlayer(0).Position.Y < 540 and satanfightstage == 0 and room:GetFrameCount() > 10 then
						musicCrossfade(Music.MUSIC_SATAN_BOSS)
						satanfightstage = 3
					end
				else
					satanfightstage = 0
				end
			end
			
			if currentbosscount == 0 and previousbosscount > 0 then
				if level:GetStage() == LevelStage.STAGE3_2 and level:GetStageType() == StageType.STAGETYPE_REPENTANCE_B then
					musicCrossfade(getGenericBossDeathJingle(), Music.MUSIC_BOSS_OVER_TWISTED)
				else
					musicCrossfade(getGenericBossDeathJingle(), Music.MUSIC_BOSS_OVER)
				end
			end
			
			previousbosscount = currentbosscount
		elseif level:GetStage() == LevelStage.STAGE3_2 and level:GetStageType() < StageType.STAGETYPE_REPENTANCE then
			local topDoor = room:GetDoor(DoorSlot.UP0)
			if topDoor and topDoor.TargetRoomType == (RoomType.ROOM_SECRET_EXIT or 27) then
				local player = Game():GetPlayer(0)
				local havephotonow = (player:HasCollectible(CollectibleType.COLLECTIBLE_POLAROID,true) or player:HasCollectible(CollectibleType.COLLECTIBLE_NEGATIVE,true))
				
				if hadphotobefore and not havephotonow then
					musicPlay(Music.MUSIC_STRANGE_DOOR_JINGLE, getMusicTrack())
				end
				
				hadphotobefore = havephotonow
			end
		elseif modSaveData["inmineshaft"] then
			local foundknifepiecenow
			
			local knifetable = Isaac.FindByType(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,CollectibleType.COLLECTIBLE_KNIFE_PIECE_2)
			if next(knifetable) == nil then
				foundknifepiecenow = false
			else
				foundknifepiecenow = true
			end
			
			if foundknifepiecebefore and not foundknifepiecenow then
				musicPlay(Music.MUSIC_MOTHERS_SHADOW_INTRO, Music.MUSIC_MINESHAFT_ESCAPE)
			end
			
			foundknifepiecebefore = foundknifepiecenow
		end
	end
	
	--SECRET ROOM DOORS
	for i=0,7 do
		local door = room:GetDoor(i)
		if door then
			if door.TargetRoomType == RoomType.ROOM_SECRET or door.TargetRoomType == RoomType.ROOM_SUPERSECRET then
				if door.State == 2 and doorprevstates[i] == 1 then
					if Game():GetLevel():GetRoomByIdx(door.TargetRoomIndex).VisitedCount == 0 then
						musicPlay(Music.MUSIC_JINGLE_SECRETROOM_FIND, getMusicTrack())
					end
				end
			end
		end
	end
	
	for i=0,7 do
		local door = room:GetDoor(i)
		if door then
			doorprevstates[i] = door.State
		end
	end
	challengedonebefore = challengedonenow
	challengeactivebefore = challengeactivenow
	roomclearbefore = roomclearnow
end)

MMC.GetMusicTrack = getMusicTrack
MMC.GetBossTrack = getBossMusic
MMC.GetStageTrack = getStageMusic
MMC.GetGenericBossTrack = getGenericBossMusic
MMC.AddMusicCallback = addMusicCallback
MMC.RemoveMusicCallback = removeMusicCallback
MMC.GetCorrectedTrackNum = correctedTrackNum
-- MMC.GetCallbacks = function() return Callbacks end
MMC.InCustomStage = function() return inbadstage end
MMC.Manager = function() return overridemusicmgr end
MMC.DisableMusicLayers = false
MMC.Initialised = true
