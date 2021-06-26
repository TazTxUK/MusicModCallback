local Music = require("scripts.musicapi.enums")

local music_triggers = {
	
	--[[
	Music triggers will replace (or supplement) normal music callbacks.
	
	With the current API, you can only check for a music track and replace it without any context.
	This should rectify that, making music replacements for specific scenarios easier, (Eg. Mega
	Satan, Hush stage 1) especially where music is reused. This also allows mods to simply disable
	trigger tags, for example JINGLE_BOSS, so that no boss jingles ever play, jumping straight into
	the boss theme.
	
	This mostly affects Soundtrack Menu. As of right now, it has a special case for Mega Satan, but
	this update should make it so that no special cases are needed at all.
	
	If you have a surplus of music from another source to put into Isaac, you can use this trigger
	system to add separate tracks to Basement I and Basement II for example rather than add it to
	the entire Basement, if you want.
	Conversely, if you do not have enough music, you can make tracks simply not play or redirect to
	other tracks. For example: Have one track cover all boss music by looking for the "BOSS" tag.
	
	The "REPENTANCE" tag is added to all repentance triggers. If there was a music mod from Afterbirth+
	that you would like to convert into a repentance soundtrack, you can use this tag to determine
	if the music will be replaced successfully or not, and it can be redirected.
	]]
	
	["STAGE_BASEMENT"] = {
		track = Music.MUSIC_BASEMENT,
		tags = {"STAGE", "STAGETYPE_ORIGINAL", "STAGE1_1", "STAGE1_2", "STAGE1", "STAGE1_GREED"},
	},
	["STAGE_CELLAR"] = {
		track = Music.MUSIC_CAVES,
		tags = {"STAGE", "STAGETYPE_WOTL", "STAGE1_1", "STAGE1_2", "STAGE1", "STAGE1_GREED"}
	},
	["STAGE_BURNING_BASEMENT"] = {
		track = Music.MUSIC_BURNING_BASEMENT,
		tags = {"STAGE", "STAGETYPE_AFTERBIRTH", "STAGE1_1", "STAGE1_2", "STAGE1", "STAGE1_GREED"}
	},
	["STAGE_DOWNPOUR"] = {
		track = Music.MUSIC_DOWNPOUR,
		tags = {"STAGE", "REPENTANCE", "DIMENSION_0", "STAGETYPE_REPENTANCE", "STAGE1_1", "STAGE1_2", "STAGE1", "STAGE1_GREED"}
	},
	["STAGE_DROSS"] = {
		track = Music.MUSIC_DROSS,
		tags = {"STAGE", "REPENTANCE", "DIMENSION_0", "STAGETYPE_REPENTANCE_B", "STAGE1_1", "STAGE1_2", "STAGE1", "STAGE1_GREED"}
	},
	["STAGE_MIRROR_DOWNPOUR"] = {
		track = Music.MUSIC_DOWNPOUR_REVERSE,
		tags = {"STAGE", "REPENTANCE", "DIMENSION_1", "STAGETYPE_REPENTANCE", "STAGE1_2", "STAGE1", "STAGE1_GREED",}
	},
	["STAGE_MIRROR_DROSS"] = {
		track = Music.MUSIC_DROSS_REVERSE,
		tags = {"STAGE", "REPENTANCE", "DIMENSION_1", "STAGETYPE_REPENTANCE_B", "STAGE1_2", "STAGE1", "STAGE1_GREED"}
	},
	
	["STAGE_CAVES"] = {
		track = Music.MUSIC_CAVES,
		tags = {"STAGE", "STAGETYPE_ORIGINAL", "STAGE2_1", "STAGE2_2", "STAGE2", "STAGE2_GREED"}
	},
	["STAGE_CATACOMBS"] = {
		track = Music.MUSIC_CATACOMBS,
		tags = {"STAGE", "STAGETYPE_WOTL", "STAGE2_1", "STAGE2_2", "STAGE2", "STAGE2_GREED"}
	},
	["STAGE_FLOODED_CAVES"] = {
		track = Music.MUSIC_FLOODED_CAVES,
		tags = {"STAGE", "STAGETYPE_AFTERBIRTH", "STAGE2_1", "STAGE2_2", "STAGE2", "STAGE2_GREED"}
	},
	["STAGE_MINES"] = {
		track = Music.MUSIC_MINES,
		tags = {"STAGE", "REPENTANCE", "DIMENSION_0", "STAGETYPE_REPENTANCE", "STAGE2_1", "STAGE2_2", "STAGE2", "STAGE2_GREED"}
	},
	["STAGE_ASHPIT"] = {
		track = Music.MUSIC_ASHPIT,
		tags = {"STAGE", "REPENTANCE", "DIMENSION_0", "STAGETYPE_REPENTANCE_B", "STAGE2_1", "STAGE2_2", "STAGE2", "STAGE2_GREED"}
	},
	["STAGE_MINESHAFT"] = {
		track = Music.MUSIC_MINESHAFT_AMBIENT,
		tags = {"STAGE", "REPENTANCE", "DIMENSION_1", "STAGETYPE_REPENTANCE", "STAGETYPE_REPENTANCE_B", "STAGE2_2", "STAGE2"}
	},
	["STAGE_MINESHAFT_ESCAPE"] = {
		track = Music.MUSIC_MINESHAFT_ESCAPE,
		tags = {"STAGE", "REPENTANCE", "DIMENSION_1", "STAGETYPE_REPENTANCE", "STAGETYPE_REPENTANCE_B", "STAGE2_2", "STAGE2"}
	},
	
	["STAGE_DEPTHS"] = {
		track = Music.MUSIC_CAVES,
		tags = {"STAGE", "STAGETYPE_ORIGINAL", "STAGE3_1", "STAGE3_2", "STAGE3", "STAGE3_GREED"}
	},
	["STAGE_NECROPOLIS"] = {
		track = Music.MUSIC_NECROPOLIS,
		tags = {"STAGE", "STAGETYPE_WOTL", "STAGE3_1", "STAGE3_2", "STAGE3", "STAGE3_GREED"}
	},
	["STAGE_DANK_DEPTHS"] = {
		track = Music.MUSIC_DANK_DEPTHS,
		tags = {"STAGE", "STAGETYPE_AFTERBIRTH", "STAGE3_1", "STAGE3_2", "STAGE3", "STAGE3_GREED"}
	},
	["STAGE_MAUSOLEUM"] = {
		track = Music.MUSIC_MAUSOLEUM,
		tags = {"STAGE", "REPENTANCE", "STAGETYPE_REPENTANCE", "STAGE3_1", "STAGE3_2", "STAGE3", "STAGE3_GREED"}
	},
	["STAGE_GEHENNA"] = {
		track = Music.MUSIC_GEHENNA,
		tags = {"STAGE", "REPENTANCE", "STAGETYPE_REPENTANCE_B", "STAGE3_1", "STAGE3_2", "STAGE3", "STAGE3_GREED"}
	},
	
	["STAGE_WOMB"] = {
		track = Music.MUSIC_WOMB_UTERO,
		tags = {"STAGE", "STAGETYPE_ORIGINAL", "STAGE4_1", "STAGE4_2", "STAGE4", "STAGE4_GREED"}
	},
	["STAGE_UTERO"] = {
		track = Music.MUSIC_UTERO,
		tags = {"STAGE", "STAGETYPE_WOTL", "STAGE4_1", "STAGE4_2", "STAGE4", "STAGE4_GREED"}
	},
	["STAGE_SCARRED_WOMB"] = {
		track = Music.MUSIC_SCARRED_WOMB,
		tags = {"STAGE", "STAGETYPE_AFTERBIRTH", "STAGE4_1", "STAGE4_2", "STAGE4", "STAGE4_GREED"}
	},
	["STAGE_CORPSE"] = {
		track = Music.MUSIC_CORPSE,
		tags = {"STAGE", "REPENTANCE", "STAGETYPE_REPENTANCE", "STAGE4_1", "STAGE4_2", "STAGE4", "STAGE4_GREED"}
	},
	["STAGE_MORTIS"] = {
		track = Music.MUSIC_MORTIS,
		tags = {"STAGE", "REPENTANCE", "STAGETYPE_REPENTANCE_B", "STAGE4_1", "STAGE4_2", "STAGE4", "STAGE4_GREED"}
	},
	
	["STAGE_BLUE_WOMB"] = {
		track = Music.MUSIC_BLUE_WOMB,
		tags = {"STAGE", "STAGE4_3", "STAGE4"}
	},
	
	["STAGE_SHEOL"] = {
		track = Music.MUSIC_SHEOL,
		tags = {"STAGE", "STAGETYPE_ORIGINAL", "STAGE5", "STAGE5_GREED"}
	},
	["STAGE_CATHEDRAL"] = {
		track = Music.MUSIC_CATHEDRAL,
		tags = {"STAGE", "STAGETYPE_WOTL", "STAGE5", "STAGE5_GREED"}
	},
	
	["STAGE_DARK_ROOM"] = {
		track = Music.MUSIC_DARK_ROOM,
		tags = {"STAGE", "STAGETYPE_ORIGINAL", "STAGE6"}
	},
	["STAGE_CHEST"] = {
		track = Music.MUSIC_CHEST,
		tags = {"STAGE", "STAGETYPE_WOTL", "STAGE6"}
	},
	["STAGE_SHOP"] = {
		track = Music.MUSIC_SHOP_ROOM,
		tags = {"STAGE", "STAGE6_GREED"}
	},
	
	["STAGE_VOID"] = {
		track = Music.MUSIC_VOID,
		tags = {"STAGE", "STAGE7"}
	},
	["STAGE_ULTRA_GREED"] = {
		track = Music.MUSIC_SHOP_ROOM,
		tags = {"STAGE", "STAGE7_GREED"}
	},
	
	["STAGE_HOME"] = {
		track = Music.MUSIC_ISAACS_HOUSE,
		tags = {"STAGE", "STAGETYPE_ORIGINAL", "STAGE8"}
	},
	["STAGE_DARK_HOME"] = {
		track = Music.MUSIC_DARK_CLOSET,
		tags = {"STAGE", "STAGETYPE_WOTL", "STAGE8"}
	},
	
	["BOSS"] = {
		track = Music.MUSIC_BOSS,
		tags = {"BOSS", "BOSS_GENERIC"}
	},
	["BOSS_ALTERNATE"] = {
		track = Music.MUSIC_BOSS2,
		tags = {"BOSS", "BOSS_GENERIC"}
	},
	["BOSS_REPENTANCE"] = {
		track = Music.MUSIC_BOSS3,
		tags = {"BOSS", "BOSS_GENERIC", "REPENTANCE"}
	},
	["BOSS_MOM"] = {
		track = Music.MUSIC_MOM_BOSS,
		tags = {"BOSS", "STAGE3_2"}
	},
	["BOSS_MOMS_HEART_WOMB"] = {
		track = Music.MUSIC_MOMS_HEART_BOSS,
		tags = {"BOSS", "STAGE4_2", "BOSS_MOMS_HEART"}
	},
	["BOSS_MOMS_HEART_MAUSOLEUM"] = {
		track = Music.MUSIC_MOMS_HEART_BOSS,
		tags = {"BOSS", "STAGE3_2", "REPENTANCE", "BOSS_MOMS_HEART"}
	},
	["BOSS_ISAAC"] = {
		track = Music.MUSIC_ISAAC_BOSS,
		tags = {"BOSS", "STAGE5", "STAGETYPE_WOTL"}
	},
	["BOSS_SATAN"] = {
		track = Music.MUSIC_SATAN_BOSS,
		tags = {"BOSS", "STAGE5", "STAGETYPE_ORIGINAL"}
	},
	["BOSS_LAMB"] = {
		track = Music.MUSIC_DARKROOM_BOSS,
		tags = {"BOSS", "STAGE6", "STAGETYPE_ORIGINAL"}
	},
	["BOSS_BLUE_BABY_CHEST"] = {
		track = Music.MUSIC_BLUEBABY_BOSS,
		tags = {"BOSS", "STAGE6", "STAGETYPE_WOTL", "BOSS_BLUE_BABY"}
	},
	["BOSS_BLUE_BABY_BLUE_WOMB"] = {
		track = Music.MUSIC_BLUEBABY_BOSS,
		tags = {"BOSS", "STAGE4_3", "BOSS_BLUE_BABY"}
	},
	["BOSS_HUSH"] = {
		track = Music.MUSIC_BLUEBABY_BOSS,
		tags = {"BOSS", "STAGE4_3"}
	},
	["BOSS_ULTRA_GREED"] = {
		track = Music.MUSIC_ULTRAGREED_BOSS,
		tags = {"BOSS", "STAGE7_GREED", "BOSS_ULTRA_GREED"}
	},
	["BOSS_ULTRA_GREEDIER"] = {
		track = Music.MUSIC_ULTRAGREED_BOSS,
		tags = {"BOSS", "STAGE7_GREED", "BOSS_ULTRA_GREED"}
	},
	["BOSS_DELIRIUM"] = {
		track = Music.MUSIC_VOID_BOSS,
		tags = {"BOSS", "STAGE7"}
	},
	["BOSS_MOTHER"] = {
		track = Music.MUSIC_MOTHER_BOSS,
		tags = {"BOSS", "STAGE4_2", "REPENTANCE"}
	},
	["BOSS_DOGMA"] = {
		track = Music.MUSIC_DOGMA_BOSS,
		tags = {"BOSS", "STAGE8", "REPENTANCE"}
	},
	["BOSS_BEAST"] = {
		track = Music.MUSIC_BEAST_BOSS,
		tags = {"BOSS", "STAGE8", "REPENTANCE"}
	},
	
	["ROOM_SHOP"] = {
		track = Music.MUSIC_SHOP_ROOM,
		tags = {}
	},
	["ROOM_TREASURE"] = {
		tags = {},
	},
	["ROOM_BOSS_CLEAR"] = {
		track = Music.MUSIC_BOSS_OVER,
		tags = {"BOSS_CLEAR"},
	},
	["ROOM_BOSS_CLEAR_TWISTED"] = {
		track = Music.MUSIC_BOSS_OVER_TWISTED,
		tags = {},
	},
	["ROOM_MINIBOSS_ACTIVE"] = {
		tags = {},
	},
	["ROOM_MINIBOSS_CLEAR"] = {
		tags = {"BOSS_CLEAR"},
	},
	["ROOM_SECRET"] = {
		track = Music.MUSIC_SECRET_ROOM,
		tags = {"ROOM_SECRET"}
	},
	["ROOM_SUPER_SECRET"] = {
		track = Music.MUSIC_SECRET_ROOM2,
		tags = {"ROOM_SECRET"}
	},
	["ROOM_ULTRA_SECRET"] = {
		track = Music.MUSIC_SECRET_ROOM_ALT_ALT,
		tags = {"ROOM_SECRET", "REPENTANCE"}
	},
	["ROOM_ARCADE"] = {
		track = Music.MUSIC_ARCADE_ROOM,
		tags = {}
	},
	["ROOM_CURSE"] = {
		tags = {}
	},
	["ROOM_CHALLENGE_NORMAL_INACTIVE"] = {
		tags = {"ROOM_CHALLENGE_INACTIVE"}
	},
	["ROOM_CHALLENGE_NORMAL_ACTIVE"] = {
		track = Music.MUSIC_CHALLENGE_FIGHT,
		tags = {"ROOM_CHALLENGE_ACTIVE"}
	},
	["ROOM_CHALLENGE_NORMAL_CLEAR"] = {
		track = Music.MUSIC_BOSS_OVER,
		tags = {"ROOM_CHALLENGE_CLEAR", "BOSS_CLEAR"}
	},
	["ROOM_CHALLENGE_BOSS_INACTIVE"] = {
		tags = {"ROOM_CHALLENGE_INACTIVE"}
	},
	["ROOM_CHALLENGE_BOSS_ACTIVE"] = {
		track = Music.MUSIC_CHALLENGE_FIGHT,
		tags = {"ROOM_CHALLENGE_ACTIVE"}
	},
	["ROOM_CHALLENGE_BOSS_CLEAR"] = {
		track = Music.MUSIC_BOSS_OVER,
		tags = {"ROOM_CHALLENGE_CLEAR", "BOSS_CLEAR"}
	},
	["ROOM_LIBRARY"] = {
		track = Music.MUSIC_LIBRARY_ROOM,
		tags = {}
	},
	["ROOM_SACRIFICE"] = {
		tags = {}
	},
	["ROOM_DEVIL"] = {
		track = Music.MUSIC_DEVIL_ROOM,
		tags = {}
	},
	["ROOM_ANGEL"] = {
		track = Music.MUSIC_ANGEL_ROOM,
		tags = {}
	},
	["ROOM_DUNGEON"] = {
		track = Music.MUSIC_DUNGEON,
		tags = {}
	},
	["ROOM_BOSS_RUSH_INACTIVE"] = {
		tags = {}
	},
	["ROOM_BOSS_RUSH_ACTIVE"] = {
		track = Music.MUSIC_BOSS_RUSH,
		tags = {}
	},
	["ROOM_BOSS_RUSH_CLEAR"] = {
		track = Music.MUSIC_BOSS_OVER,
		tags = {"BOSS_CLEAR"}
	},
	["ROOM_ISAACS"] = {
		tags = {"ROOM_ISAACS"}
	},
	["ROOM_BARREN"] = {
		tags = {"ROOM_ISAACS"}
	},
	["ROOM_CHEST"] = {
		tags = {"ROOM_DOUBLE_KEY"},
	},
	["ROOM_DICE"] = {
		tags = {"ROOM_DOUBLE_KEY"},
	},
	["ROOM_BLACK_MARKET"] = {
		tags = {},
	},
	["ROOM_GREED_EXIT"] = {
		tags = {},
	},
	["ROOM_PLANETARIUM"] = {
		track = Music.MUSIC_PLANETARIUM,
		tags = {"REPENTANCE"},
	},
	["ROOM_TELEPORTER"] = {
		tags = {"REPENTANCE"},
	},
	["ROOM_TELEPORTER_EXIT"] = {
		tags = {"REPENTANCE"},
	},
	["ROOM_OTHER"] = {
		tags = {},
	},
	
	["JINGLE_BOSS"] = {
		track = Music.MUSIC_JINGLE_BOSS,
		tags = {"JINGLE"},
	},
	["JINGLE_BOSS_OVER_REBIRTH"] = {
		track = Music.MUSIC_JINGLE_BOSS_OVER,
		tags = {"JINGLE", "JINGLE_BOSS_OVER"},
	},
	["JINGLE_BOSS_OVER_AFTERBIRTH"] = {
		track = Music.MUSIC_JINGLE_BOSS_OVER2,
		tags = {"JINGLE", "JINGLE_BOSS_OVER"},
	},
	["JINGLE_BOSS_OVER_REPENTANCE"] = {
		track = Music.MUSIC_JINGLE_BOSS_OVER3,
		tags = {"JINGLE", "JINGLE_BOSS_OVER", "REPENTANCE"},
	},
	["JINGLE_ANGEL_ROOM"] = {
		track = Music.MUSIC_JINGLE_HOLYROOM_FIND,
		tags = {"JINGLE", "JINGLE_DEAL_ROOM"},
	},
	["JINGLE_SECRET_ROOM"] = {
		track = Music.MUSIC_JINGLE_SECRETROOM_FIND,
		tags = {"JINGLE"},
	},
	["JINGLE_TREASURE_ROOM_0"] = {
		track = Music.MUSIC_JINGLE_TREASUREROOM_ENTRY_0,
		tags = {"JINGLE", "JINGLE_TREASURE_ROOM"},
	},
	["JINGLE_TREASURE_ROOM_1"] = {
		track = Music.MUSIC_JINGLE_TREASUREROOM_ENTRY_1,
		tags = {"JINGLE", "JINGLE_TREASURE_ROOM"},
	},
	["JINGLE_TREASURE_ROOM_2"] = {
		track = Music.MUSIC_JINGLE_TREASUREROOM_ENTRY_2,
		tags = {"JINGLE", "JINGLE_TREASURE_ROOM"},
	},
	["JINGLE_TREASURE_ROOM_3"] = {
		track = Music.MUSIC_JINGLE_TREASUREROOM_ENTRY_3,
		tags = {"JINGLE", "JINGLE_TREASURE_ROOM"},
	},
	["JINGLE_CHALLENGE_NORMAL_OUTRO"] = {
		track = Music.MUSIC_JINGLE_CHALLENGE_OUTRO,
		tags = {"JINGLE", "JINGLE_CHALLENGE_OUTRO"},
	},
	["JINGLE_CHALLENGE_BOSS_OUTRO"] = {
		track = Music.MUSIC_JINGLE_CHALLENGE_OUTRO,
		tags = {"JINGLE", "JINGLE_CHALLENGE_OUTRO"},
	},
	["JINGLE_GAME_OVER"] = {
		track = Music.MUSIC_JINGLE_GAME_OVER,
		tags = {"JINGLE"},
	},
	["JINGLE_DEVIL_ROOM"] = {
		track = Music.MUSIC_JINGLE_DEVILROOM_FIND,
		tags = {"JINGLE", "JINGLE_DEAL_ROOM"},
	},
	["JINGLE_BOSS_RUSH_OUTRO"] = {
		track = Music.MUSIC_JINGLE_BOSS_OVER, --check
		tags = {"JINGLE", "JINGLE_BOSS_OVER"},
	},
	["JINGLE_MOTHER_OVER"] = {
		track = Music.MUSIC_JINGLE_MOTHER_OVER,
		tags = {"JINGLE"},
	},
	["JINGLE_DOGMA_OVER"] = {
		track = Music.MUSIC_JINGLE_DOGMA_OVER,
		tags = {"JINGLE"},
	},
	["JINGLE_BEAST_OVER"] = {
		track = Music.MUSIC_JINGLE_BEAST_OVER,
		tags = {"JINGLE"},
	},
	["JINGLE_STRANGE_DOOR"] = {
		track = Music.MUSIC_STRANGE_DOOR_JINGLE,
		tags = {"JINGLE"},
	},
	
	["INTRO_MOTHERS_SHADOW"] = {
		track = Music.MUSIC_MOTHERS_SHADOW_INTRO,
		tags = {"INTRO"},
	},
	["INTRO_DOGMA"] = {
		track = Music.MUSIC_DOGMA_INTRO,
		tags = {"INTRO"},
	},
	
	["STATE_GAME_OVER"] = {
		track = Music.MUSIC_GAME_OVER,
		tags = {},
	},
	["STATE_ASCENT"] = {
		track = Music.MUSIC_REVERSE_GENESIS,
		tags = {},
	},
	
	["DIMENSION_DEATH_CERTIFICATE"] = {
		track = Music.MUSIC_DARK_CLOSET,
		tags = {},
	},
}

--Metatable for triggers (for Global Variable Menu)
local mt_trigger = {
	__gvmrepr = function(self) return string.format("MMC Trigger (%i tags)", #self.tags) end,
	__gvmkcolor = KColor(51/255, 231/255, 1.0, 1.0),
}

--Some automatic steps:
--  Assign a capital case name for each trigger, in case it appears in a menu
--  Add its own name as a tag
--  Add its track enum as a tag

local function capitalCase(s)
	--This MIGHT be optimisable using patterns.
	local str = s:lower():gsub("_", " ")
	local next_letter = 1
	while true do
		str = str:sub(1, next_letter - 1) .. str:sub(next_letter, next_letter):upper() .. str:sub(next_letter + 1, -1)
		next_letter = str:find(" ", next_letter + 1)
		if next_letter == nil then break end
		next_letter = next_letter + 1
	end
	return str
end

for trigger_name, trigger in pairs(music_triggers) do
	--Set metatable
	setmetatable(trigger, mt_trigger)

	--Name
	local underscore_pos = trigger_name:find("_")
	if underscore_pos then
		trigger.name = capitalCase(trigger_name:sub(underscore_pos + 1, -1)) .. " " .. capitalCase(trigger_name:sub(1, underscore_pos - 1))
	else
		trigger.name = capitalCase(trigger_name)
	end
	
	--Assign own name as tag
	--(This assumes the trigger name isnt already a tag, although it may not matter later)
	table.insert(trigger.tags, trigger_name)
	
	--Add track enum as a tag
	if trigger.track then
		for music_name, music_id in pairs(Music) do
			if trigger.track == music_id then
				table.insert(trigger.tags, music_name)
				break
			end
		end
	end
end

--temp
local tags = {}
for trigger_name, trigger in pairs(music_triggers) do
	for _, tag in ipairs(trigger.tags) do
		tags[tag] = true
	end
end

local tag_count = 0
for _,_ in pairs(tags) do
	tag_count = tag_count + 1
end

Isaac.ConsoleOutput("Tag Count: "..tag_count.."\n")
MMCTags = tags

--end temp

return music_triggers