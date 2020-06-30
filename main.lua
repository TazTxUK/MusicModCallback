if MMC then return end

local MusicModCallback = RegisterMod("Music Mod Callback", 1)

MMC = {}

MMC.Version = "1.2"

local newmusicenum = {
	MUSIC_NULL = 0,
	MUSIC_BASEMENT = Isaac.GetMusicIdByName("Basement"),
	MUSIC_CAVES = Isaac.GetMusicIdByName("Caves"),
	MUSIC_DEPTHS = Isaac.GetMusicIdByName("Depths"),
	MUSIC_CELLAR = Isaac.GetMusicIdByName("Cellar"),
	MUSIC_CATACOMBS = Isaac.GetMusicIdByName("Catacombs"),
	MUSIC_NECROPOLIS = Isaac.GetMusicIdByName("Necropolis"),
	MUSIC_WOMB_UTERO = Isaac.GetMusicIdByName("Womb/Utero"),
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
	MUSIC_JINGLE_DEVILROOM_FIND = Isaac.GetMusicIdByName("Challenge Room Outro (jingle)"),
	MUSIC_JINGLE_GAME_START = Isaac.GetMusicIdByName("Game start (jingle)"),
	MUSIC_JINGLE_NIGHTMARE = Isaac.GetMusicIdByName("Nightmare"),
	MUSIC_JINGLE_BOSS_OVER2 = Isaac.GetMusicIdByName("Boss Death Alternate (jingle)"),
	MUSIC_JINGLE_HUSH_OVER = Isaac.GetMusicIdByName("Boss Hush Death (jingle)"),
	MUSIC_INTRO_VOICEOVER = Isaac.GetMusicIdByName("Intro Voiceover"),
	MUSIC_EPILOGUE_VOICEOVER = Isaac.GetMusicIdByName("Epilogue Voiceover"),
	MUSIC_VOID = Isaac.GetMusicIdByName("Void"),
	MUSIC_VOID_BOSS = Isaac.GetMusicIdByName("Boss (Void)"),
	NUM_MUSIC = Isaac.GetMusicIdByName("Boss (Void)") + 1,
}

local musicmgr = MusicManager()

MusicPreMMC = MusicPreMMC or Music

local redirectmusicenum = {}
for i,v in pairs(MusicPreMMC) do
	if v < MusicPreMMC.NUM_MUSIC and redirectmusicenum[v] ~= newmusicenum[i] then
		redirectmusicenum[v] = newmusicenum[i]
	end
end

Music = newmusicenum

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

if Isaac.HasModData(MusicModCallback) then
	local dat = Isaac.LoadModData(MusicModCallback)
	if dat == "0" then
		usernolayers = true
	elseif dat == "1" then
		usernolayers = false
	end
end

local function getStageMusic()
	local level = Game():GetLevel()
	local stage = level:GetStage()
	local stage_type = level:GetStageType()
	if stage_type == StageType.STAGETYPE_GREEDMODE then
		if stage == LevelStage.STAGE1_GREED then
			return Music.MUSIC_BURNING_BASEMENT
		elseif stage == LevelStage.STAGE2_GREED then
			return Music.MUSIC_FLOODED_CAVES
		elseif stage == LevelStage.STAGE3_GREED then
			return Music.MUSIC_DANK_DEPTHS
		elseif stage == LevelStage.STAGE4_GREED then
			return Music.MUSIC_WOMB_UTERO
		elseif stage == LevelStage.STAGE5_GREED then
			return Music.MUSIC_SHEOL
		elseif stage == LevelStage.STAGE6_GREED then
			return Music.MUSIC_SHOP_ROOM
		elseif stage == LevelStage.STAGE7_GREED then
			return Music.MUSIC_SHOP_ROOM
		end
	else
		if stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE1_2 then
			if stage_type == StageType.STAGETYPE_ORIGINAL then
				return Music.MUSIC_BASEMENT
			elseif stage_type == StageType.STAGETYPE_WOTL then
				return Music.MUSIC_CELLAR
			elseif stage_type == StageType.STAGETYPE_AFTERBIRTH then
				return Music.MUSIC_BURNING_BASEMENT
			end
		elseif stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2 then
			if stage_type == StageType.STAGETYPE_ORIGINAL then
				return Music.MUSIC_CAVES
			elseif stage_type == StageType.STAGETYPE_WOTL then
				return Music.MUSIC_CATACOMBS
			elseif stage_type == StageType.STAGETYPE_AFTERBIRTH then
				return Music.MUSIC_FLOODED_CAVES
			end
		elseif stage == LevelStage.STAGE3_1 or stage == LevelStage.STAGE3_2 then
			if stage_type == StageType.STAGETYPE_ORIGINAL then
				return Music.MUSIC_DEPTHS
			elseif stage_type == StageType.STAGETYPE_WOTL then
				return Music.MUSIC_NECROPOLIS
			elseif stage_type == StageType.STAGETYPE_AFTERBIRTH then
				return Music.MUSIC_DANK_DEPTHS
			end
		elseif stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2 then
			if stage_type == StageType.STAGETYPE_ORIGINAL then
				return Music.MUSIC_WOMB_UTERO
			elseif stage_type == StageType.STAGETYPE_WOTL then
				return Music.MUSIC_WOMB_UTERO
			elseif stage_type == StageType.STAGETYPE_AFTERBIRTH then
				return Music.MUSIC_SCARRED_WOMB
			end
		elseif stage == LevelStage.STAGE4_3 then
			return Music.MUSIC_BLUE_WOMB
		elseif stage == LevelStage.STAGE5 then
			if stage_type == StageType.STAGETYPE_ORIGINAL then
				return Music.MUSIC_SHEOL
			elseif stage_type == StageType.STAGETYPE_WOTL then
				return Music.MUSIC_CATHEDRAL
			end
		elseif stage == LevelStage.STAGE6 then
			if stage_type == StageType.STAGETYPE_ORIGINAL then
				return Music.MUSIC_DARK_ROOM
			elseif stage_type == StageType.STAGETYPE_WOTL then
				return Music.MUSIC_CHEST
			end
		elseif stage == LevelStage.STAGE7 then
			return Music.MUSIC_VOID
		end
	end
	
	return Music.MUSIC_TITLE
end

local function getGenericBossMusic()
	local room = Game():GetRoom()
	if room:GetDecorationSeed() % 2 == 0 then
		return Music.MUSIC_BOSS
	else
		return Music.MUSIC_BOSS2
	end
end

local function getBossMusic()
	local room = Game():GetRoom()
	
	if room:GetBossID() == 6 then
		return Music.MUSIC_MOM_BOSS
	elseif room:GetBossID() == 8 then
		return Music.MUSIC_MOMS_HEART_BOSS
	elseif room:GetBossID() == 25 then
		return Music.MUSIC_MOMS_HEART_BOSS
	elseif room:GetBossID() == 24 then
		return Music.MUSIC_DEVIL_ROOM
	elseif room:GetBossID() == 39 then
		return Music.MUSIC_ISAAC_BOSS
	elseif room:GetBossID() == 40 then
		return Music.MUSIC_BLUEBABY_BOSS
	elseif room:GetBossID() == 54 then
		return Music.MUSIC_DARKROOM_BOSS
	elseif room:GetBossID() == 55 then
		return Music.MUSIC_DEVIL_ROOM
	elseif room:GetBossID() == 62 then
		return Music.MUSIC_ULTRAGREED_BOSS
	elseif room:GetBossID() == 63 then
		return Music.MUSIC_BLUEBABY_BOSS
	elseif room:GetBossID() == 70 then
		return Music.MUSIC_VOID_BOSS
	end
	
	return getGenericBossMusic()
end

local function getMusicTrack()
	local game = Game()
	local room = game:GetRoom()
	local roomtype = room:GetType()
	local level = game:GetLevel()
	local roomdesc = level:GetCurrentRoomDesc()
	
	if roomtype == RoomType.ROOM_DEFAULT then
		return getStageMusic()
	elseif roomtype == RoomType.ROOM_SHOP then
		if (game:IsGreedMode() or level:GetStage() ~= StageType.STAGE4_3) then
			return Music.MUSIC_SHOP_ROOM
		else
			return getStageMusic()
		end
	elseif roomtype == RoomType.ROOM_TREASURE then
		if room:IsFirstVisit() and (game:IsGreedMode() or level:GetStage() ~= StageType.STAGE4_3) then
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
			return Music.MUSIC_BOSS_OVER
		else
			if room:GetBossID() == 0 then
				return getGenericBossMusic()
			else
				return Music.MUSIC_JINGLE_BOSS
			end
		end
	elseif roomtype == RoomType.ROOM_MINIBOSS or roomdesc.SurpriseMiniboss then
		if room:IsClear() then
			return Music.MUSIC_BOSS_OVER
		else
			return getGenericBossMusic()
		end
	elseif roomtype == RoomType.ROOM_SECRET then
		return Music.MUSIC_SECRET_ROOM
	elseif roomtype == RoomType.ROOM_SUPERSECRET then
		return Music.MUSIC_SECRET_ROOM
	elseif roomtype == RoomType.ROOM_ARCADE then
		return Music.MUSIC_ARCADE_ROOM
	elseif roomtype == RoomType.ROOM_DEVIL then
		return Music.MUSIC_DEVIL_ROOM
	elseif roomtype == RoomType.ROOM_ANGEL then
		return Music.MUSIC_ANGEL_ROOM
	elseif roomtype == RoomType.ROOM_LIBRARY then
		return Music.MUSIC_LIBRARY_ROOM
	elseif roomtype == RoomType.ROOM_CHALLENGE then
		return Music.MUSIC_BOSS_OVER
	elseif roomtype == RoomType.ROOM_BOSSRUSH then
		return Music.MUSIC_BOSS_OVER
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
	local id, id2 = iterateThroughCallbacks(track or false)
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

MusicModCallback:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
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
end)

MusicModCallback:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	if not inbadstage then
		local room = Game():GetRoom()
		
		previousgreedwave = 0
		previousbosscount = 0
		satanfightstage = 0
		
		challengeactivebefore = room:IsAmbushActive()
		challengedonebefore = room:IsAmbushDone()
		roomclearbefore = room:IsClear()

		if not waitingforgamestjingle then
			musicCrossfade(getMusicTrack())
		end
		
		if usernolayers or MMC.DisableMusicLayers then
			musicmgr:DisableLayer()
		end
		
		for i=0,7 do
			local door = room:GetDoor(i)
			if door then
				doorprevstates[i] = door.State
			end
		end
	end
end)

MusicModCallback:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(self, ent)
	if ent.Type == 102 and ent.Variant == 2 then
		musicCrossfade(Music.MUSIC_HUSH_BOSS)
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
end)

MusicModCallback:AddCallback(ModCallbacks.MC_EXECUTE_CMD, function(self, cmd, params)
	if cmd == "mmclayer" then
		if params == "0" then
			usernolayers = true
			Isaac.SaveModData(MusicModCallback, "0")
			musicmgr:DisableLayer()
			return "Disabled music layers.\n"
		elseif params == "1" then
			usernolayers = false
			Isaac.SaveModData(MusicModCallback, "1")
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
	
	if waitingforgamestjingle and room:GetFrameCount() > 10 then
		if room:GetType() == RoomType.ROOM_BOSS and not room:IsClear() then
			musicCrossfade(getBossMusic())
		else
			musicCrossfade(getMusicTrack())
		end
		waitingforgamestjingle = false
		return
	end
	
	if Game():IsGreedMode() then
		local currentgreedwave = Game():GetLevel().GreedModeWave
		
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
					local bossjingle
					if room:GetDecorationSeed() % 2 == 0 then
						bossjingle = Music.MUSIC_JINGLE_BOSS_OVER
					else
						bossjingle = Music.MUSIC_JINGLE_BOSS_OVER2
					end
					musicCrossfade(bossjingle, Music.MUSIC_BOSS_OVER)
				end
			end
			
			previousbosscount = currentbosscount
		else
			if level:GetStage() == LevelStage.STAGE6_GREED then
				if room:GetType() == RoomType.ROOM_DEFAULT then
					if currentgreedwave < 9 then
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
					if currentgreedwave == 9 or currentgreedwave == 10 then
						musicCrossfade(Music.MUSIC_BOSS2)
					elseif currentgreedwave == 11 then
						musicCrossfade(Music.MUSIC_SATAN_BOSS)
					end
				elseif roomclearnow and not roomclearbefore then
					if currentgreedwave >= 9 then
						musicCrossfade(Music.MUSIC_JINGLE_BOSS_OVER2, Music.MUSIC_BOSS_OVER)
					end
				end
			end
		end
		
		previousgreedwave = currentgreedwave
	else
		if room:GetType() == RoomType.ROOM_CHALLENGE or room:GetType() == RoomType.ROOM_BOSSRUSH then
			if challengeactivenow and not challengeactivebefore then
				musicCrossfade(Music.MUSIC_CHALLENGE_FIGHT)
			end
			if challengedonenow and not challengedonebefore then
				musicCrossfade(Music.MUSIC_JINGLE_CHALLENGE_OUTRO, Music.MUSIC_BOSS_OVER)
			end
		elseif room:GetType() == RoomType.ROOM_TREASURE then
			if room:GetFrameCount() == 1 then
				musicQueue(getStageMusic())
			end
		elseif room:GetType() == RoomType.ROOM_BOSS then
			local currentbosscount = Isaac.CountBosses()
			
			if currentbosscount > 0 and room:GetFrameCount() == 1 then
				musicCrossfade(getBossMusic())
			end
			
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
			
			if currentbosscount == 0 and previousbosscount > 0 then
				local bossjingle
				if room:GetDecorationSeed() % 2 == 0 then
					bossjingle = Music.MUSIC_JINGLE_BOSS_OVER
				else
					bossjingle = Music.MUSIC_JINGLE_BOSS_OVER2
				end
				musicCrossfade(bossjingle, Music.MUSIC_BOSS_OVER)
			end
			
			previousbosscount = currentbosscount
		elseif room:GetType() == RoomType.ROOM_MINIBOSS or roomdesc.SurpriseMiniboss then
			local currentbosscount = Isaac.CountBosses()
			
			if currentbosscount == 0 and previousbosscount > 0 then
				local bossjingle
				if room:GetDecorationSeed() % 2 == 0 then
					bossjingle = Music.MUSIC_JINGLE_BOSS_OVER
				else
					bossjingle = Music.MUSIC_JINGLE_BOSS_OVER2
				end
				musicCrossfade(bossjingle, Music.MUSIC_BOSS_OVER)
			end
			
			previousbosscount = currentbosscount
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
-- MMC.GetCallbacks = function() return Callbacks end
MMC.InCustomStage = function() return inbadstage end
MMC.Manager = function() return overridemusicmgr end
MMC.DisableMusicLayers = false
MMC.Initialised = true