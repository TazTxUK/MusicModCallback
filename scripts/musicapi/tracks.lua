local Query = require "scripts.musicapi.query"

local enums = require "scripts.musicapi.enums"
local Music = enums.Music

-- local queryIsStage = Query() & MusicAPI.Flag("STAGE")

--[[
Music tracks will replace (or supplement) normal music ids.

With the current API, you can only check for a music id and replace it without any context.
This should rectify that, making music replacements for specific scenarios easier, (Eg. Mega
Satan, Hush stage 1) especially where music is reused. This also allows mods to simply disable
music tags, for example JINGLE_BOSS, so that no boss jingles ever play, jumping straight into
the boss theme.

This mostly affects Soundtrack Menu. As of right now, it has a special case for Mega Satan, but
this update should make it so that no special cases are needed at all.

If you have a surplus of music from another source to put into Isaac, you can use this music
system to add separate tracks to Basement I and Basement II for example rather than add it to
the entire Basement, if you want.
Conversely, if you do not have enough music, you can make tracks simply not play or redirect to
other tracks. For example: Have one track cover all boss music by looking for the "BOSS" tag.

The "REPENTANCE" tag is added to all repentance tracks. If there was a music mod from Afterbirth+
that you would like to convert into a repentance soundtrack, you can use this tag to determine
if the music will be replaced successfully or not, and it can be redirected.

Persistence:
1 - If a persistence 1 jingle is playing with a track queued after it, and you attempt to play
the track again, then the track will not override the jingle.
2 - If a persistence 2 jingle is playing, any music to be played will be queued after it.

For example if the game start theme is playing, and the player enters a planetarium, the planetarium music
will be queued after the game start jingle is finished.
]]

local track_table = {
	--Don't add callbacks to API tracks
	["API_NOTHING"] = {
		music = Music.MUSIC_MUSICAPI_NOTHING,
		tags = {"API"},
	},
	["API_GAME_START"] = {
		tags = {"API"},
		persistence = 2,
	},
	["API_STAGE_TRANSITION"] = {
		tags = {"API"},
		persistence = 2,
	},

	["STAGE_NULL"] = {
		music = Music.MUSIC_MUSICAPI_NOTHING,
		tags = {"STAGE"},
	},
	
	["STAGE_BASEMENT"] = {
		music = Music.MUSIC_BASEMENT,
		tags = {"STAGE", "STAGETYPE_ORIGINAL", "STAGE1_1", "STAGE1_2", "STAGE1", "STAGE1_GREED"},
	},
	["STAGE_CELLAR"] = {
		music = Music.MUSIC_CELLAR,
		tags = {"STAGE", "STAGETYPE_WOTL", "STAGE1_1", "STAGE1_2", "STAGE1", "STAGE1_GREED"}
	},
	["STAGE_BURNING_BASEMENT"] = {
		music = Music.MUSIC_BURNING_BASEMENT,
		tags = {"STAGE", "STAGETYPE_AFTERBIRTH", "STAGE1_1", "STAGE1_2", "STAGE1", "STAGE1_GREED"}
	},
	["STAGE_DOWNPOUR"] = {
		music = Music.MUSIC_DOWNPOUR,
		tags = {"STAGE", "REPENTANCE", "DIMENSION_MAIN", "STAGETYPE_REPENTANCE", "STAGE1_1", "STAGE1_2", "STAGE1", "STAGE1_GREED"}
	},
	["STAGE_DROSS"] = {
		music = Music.MUSIC_DROSS,
		tags = {"STAGE", "REPENTANCE", "DIMENSION_MAIN", "STAGETYPE_REPENTANCE_B", "STAGE1_1", "STAGE1_2", "STAGE1", "STAGE1_GREED"}
	},
	["STAGE_MIRROR_DOWNPOUR"] = {
		music = Music.MUSIC_DOWNPOUR_REVERSE,
		tags = {"STAGE", "REPENTANCE", "DIMENSION_ALTERNATE", "STAGETYPE_REPENTANCE", "STAGE1_2", "STAGE1", "STAGE1_GREED",}
	},
	["STAGE_MIRROR_DROSS"] = {
		music = Music.MUSIC_DROSS_REVERSE,
		tags = {"STAGE", "REPENTANCE", "DIMENSION_ALTERNATE", "STAGETYPE_REPENTANCE_B", "STAGE1_2", "STAGE1", "STAGE1_GREED"}
	},
	
	["STAGE_CAVES"] = {
		music = Music.MUSIC_CAVES,
		tags = {"STAGE", "STAGETYPE_ORIGINAL", "STAGE2_1", "STAGE2_2", "STAGE2", "STAGE2_GREED"}
	},
	["STAGE_CATACOMBS"] = {
		music = Music.MUSIC_CATACOMBS,
		tags = {"STAGE", "STAGETYPE_WOTL", "STAGE2_1", "STAGE2_2", "STAGE2", "STAGE2_GREED"}
	},
	["STAGE_FLOODED_CAVES"] = {
		music = Music.MUSIC_FLOODED_CAVES,
		tags = {"STAGE", "STAGETYPE_AFTERBIRTH", "STAGE2_1", "STAGE2_2", "STAGE2", "STAGE2_GREED"}
	},
	["STAGE_MINES"] = {
		music = Music.MUSIC_MINES,
		tags = {"STAGE", "REPENTANCE", "DIMENSION_MAIN", "STAGETYPE_REPENTANCE", "STAGE2_1", "STAGE2_2", "STAGE2", "STAGE2_GREED"}
	},
	["STAGE_ASHPIT"] = {
		music = Music.MUSIC_ASHPIT,
		tags = {"STAGE", "REPENTANCE", "DIMENSION_MAIN", "STAGETYPE_REPENTANCE_B", "STAGE2_1", "STAGE2_2", "STAGE2", "STAGE2_GREED"}
	},
	["STAGE_MINESHAFT_AMBIENT"] = {
		music = Music.MUSIC_MINESHAFT_AMBIENT,
		tags = {"STAGE", "REPENTANCE", "DIMENSION_ALTERNATE", "STAGETYPE_REPENTANCE", "STAGETYPE_REPENTANCE_B", "STAGE2_2", "STAGE2", "MINESHAFT"}
	},
	
	["STAGE_DEPTHS"] = {
		music = Music.MUSIC_DEPTHS,
		tags = {"STAGE", "STAGETYPE_ORIGINAL", "STAGE3_1", "STAGE3_2", "STAGE3", "STAGE3_GREED"}
	},
	["STAGE_NECROPOLIS"] = {
		music = Music.MUSIC_NECROPOLIS,
		tags = {"STAGE", "STAGETYPE_WOTL", "STAGE3_1", "STAGE3_2", "STAGE3", "STAGE3_GREED"}
	},
	["STAGE_DANK_DEPTHS"] = {
		music = Music.MUSIC_DANK_DEPTHS,
		tags = {"STAGE", "STAGETYPE_AFTERBIRTH", "STAGE3_1", "STAGE3_2", "STAGE3", "STAGE3_GREED"}
	},
	["STAGE_MAUSOLEUM"] = {
		music = Music.MUSIC_MAUSOLEUM,
		tags = {"STAGE", "REPENTANCE", "STAGETYPE_REPENTANCE", "STAGE3_1", "STAGE3_2", "STAGE3", "STAGE3_GREED"}
	},
	["STAGE_GEHENNA"] = {
		music = Music.MUSIC_GEHENNA,
		tags = {"STAGE", "REPENTANCE", "STAGETYPE_REPENTANCE_B", "STAGE3_1", "STAGE3_2", "STAGE3", "STAGE3_GREED"}
	},
	
	["STAGE_WOMB"] = {
		music = Music.MUSIC_WOMB_UTERO,
		tags = {"STAGE", "STAGETYPE_ORIGINAL", "STAGE4_1", "STAGE4_2", "STAGE4", "STAGE4_GREED"}
	},
	["STAGE_UTERO"] = {
		music = Music.MUSIC_UTERO,
		tags = {"STAGE", "STAGETYPE_WOTL", "STAGE4_1", "STAGE4_2", "STAGE4", "STAGE4_GREED"}
	},
	["STAGE_SCARRED_WOMB"] = {
		music = Music.MUSIC_SCARRED_WOMB,
		tags = {"STAGE", "STAGETYPE_AFTERBIRTH", "STAGE4_1", "STAGE4_2", "STAGE4", "STAGE4_GREED"}
	},
	["STAGE_CORPSE"] = {
		music = Music.MUSIC_CORPSE,
		tags = {"STAGE", "REPENTANCE", "STAGETYPE_REPENTANCE", "STAGE4_1", "STAGE4_2", "STAGE4", "STAGE4_GREED"}
	},
	["STAGE_MORTIS"] = {
		music = Music.MUSIC_MORTIS,
		tags = {"STAGE", "REPENTANCE", "STAGETYPE_REPENTANCE_B", "STAGE4_1", "STAGE4_2", "STAGE4", "STAGE4_GREED"}
	},
	
	["STAGE_BLUE_WOMB"] = {
		music = Music.MUSIC_BLUE_WOMB,
		tags = {"STAGE", "STAGE4_3", "STAGE4"}
	},
	
	["STAGE_SHEOL"] = {
		music = Music.MUSIC_SHEOL,
		tags = {"STAGE", "STAGETYPE_ORIGINAL", "STAGE5", "STAGE5_GREED"}
	},
	["STAGE_CATHEDRAL"] = {
		music = Music.MUSIC_CATHEDRAL,
		tags = {"STAGE", "STAGETYPE_WOTL", "STAGE5", "STAGE5_GREED"}
	},
	
	["STAGE_DARK_ROOM"] = {
		music = Music.MUSIC_DARK_ROOM,
		tags = {"STAGE", "STAGETYPE_ORIGINAL", "STAGE6"}
	},
	["STAGE_CHEST"] = {
		music = Music.MUSIC_CHEST,
		tags = {"STAGE", "STAGETYPE_WOTL", "STAGE6"}
	},
	["STAGE_SHOP"] = {
		music = Music.MUSIC_SHOP_ROOM,
		tags = {"STAGE", "STAGE6_GREED"}
	},
	
	["STAGE_VOID"] = {
		music = Music.MUSIC_VOID,
		tags = {"STAGE", "STAGE7"}
	},
	["STAGE_ULTRA_GREED"] = {
		music = Music.MUSIC_SHOP_ROOM,
		tags = {"STAGE", "STAGE7_GREED"}
	},
	
	["STAGE_HOME"] = {
		music = Music.MUSIC_ISAACS_HOUSE,
		tags = {"STAGE", "STAGETYPE_ORIGINAL", "STAGE8"}
	},
	["STAGE_DARK_HOME"] = {
		music = Music.MUSIC_DARK_CLOSET,
		tags = {"STAGE", "STAGETYPE_WOTL", "STAGE8"}
	},
	
	["BOSS_REBIRTH"] = {
		music = Music.MUSIC_BOSS,
		tags = {"BOSS", "BOSS_GENERIC"}
	},
	["BOSS_AFTERBIRTH"] = {
		music = Music.MUSIC_BOSS2,
		tags = {"BOSS", "BOSS_GENERIC"}
	},
	["BOSS_REPENTANCE"] = {
		music = Music.MUSIC_BOSS3,
		tags = {"BOSS", "BOSS_GENERIC", "REPENTANCE"}
	},
	["BOSS_MOM"] = {
		music = Music.MUSIC_MOM_BOSS,
		tags = {"BOSS", "STAGE3_2"}
	},
	["BOSS_MOMS_HEART"] = {
		music = Music.MUSIC_MOMS_HEART_BOSS,
		tags = {"BOSS", "STAGE4_2"}
	},
	["BOSS_IT_LIVES"] = {
		music = Music.MUSIC_MOMS_HEART_BOSS,
		tags = {"BOSS", "STAGE4_2"}
	},
	-- ["BOSS_MOMS_HEART_MAUSOLEUM"] = {
		-- music = Music.MUSIC_MOMS_HEART_BOSS,
		-- tags = {"BOSS", "STAGE3_2", "REPENTANCE", "BOSS_MOMS_HEART"}
	-- },
	["BOSS_ISAAC"] = {
		music = Music.MUSIC_ISAAC_BOSS,
		tags = {"BOSS", "STAGE5", "STAGETYPE_WOTL"}
	},
	["BOSS_SATAN_INACTIVE"] = {
		music = Music.MUSIC_DEVIL_ROOM,
		tags = {"BOSS", "STAGE5", "STAGETYPE_ORIGINAL"}
	},
	["BOSS_SATAN"] = {
		music = Music.MUSIC_SATAN_BOSS,
		tags = {"BOSS", "STAGE5", "STAGETYPE_ORIGINAL"}
	},
	["BOSS_MEGA_SATAN_INACTIVE"] = {
		music = Music.MUSIC_DEVIL_ROOM,
		tags = {"BOSS", "STAGE6"}
	},
	["BOSS_MEGA_SATAN"] = {
		music = Music.MUSIC_SATAN_BOSS,
		tags = {"BOSS", "STAGE6"}
	},
	["BOSS_GREEDMODE_EXTRA"] = {
		music = Music.MUSIC_SATAN_BOSS,
		tags = {"BOSS"}
	},
	["BOSS_LAMB"] = {
		music = Music.MUSIC_DARKROOM_BOSS,
		tags = {"BOSS", "STAGE6", "STAGETYPE_ORIGINAL"}
	},
	["BOSS_BLUE_BABY"] = {
		music = Music.MUSIC_BLUEBABY_BOSS,
		tags = {"BOSS", "STAGE6", "STAGETYPE_WOTL"}
	},
	["BOSS_HUSH_FIRST"] = {
		music = Music.MUSIC_BLUEBABY_BOSS,
		tags = {"BOSS", "STAGE4_3", "BOSS_HUSH"}
	},
	["BOSS_HUSH_FINAL"] = {
		music = Music.MUSIC_HUSH_BOSS,
		tags = {"BOSS", "STAGE4_3", "BOSS_HUSH"}
	},
	["BOSS_ULTRA_GREED"] = {
		music = Music.MUSIC_ULTRAGREED_BOSS,
		tags = {"BOSS", "STAGE7_GREED", "BOSS_ULTRA_GREED"}
	},
	-- ["BOSS_ULTRA_GREEDIER"] = {
		-- music = Music.MUSIC_ULTRAGREED_BOSS,
		-- tags = {"BOSS", "STAGE7_GREED", "BOSS_ULTRA_GREED"}
	-- },
	["BOSS_DELIRIUM"] = {
		music = Music.MUSIC_VOID_BOSS,
		tags = {"BOSS", "STAGE7"}
	},
	["BOSS_MOTHER"] = {
		music = Music.MUSIC_MOTHER_BOSS,
		tags = {"BOSS", "STAGE4_2", "REPENTANCE"}
	},
	["BOSS_DOGMA"] = {
		music = Music.MUSIC_DOGMA_BOSS,
		tags = {"BOSS", "STAGE8", "REPENTANCE"}
	},
	["BOSS_BEAST"] = {
		music = Music.MUSIC_BEAST_BOSS,
		tags = {"BOSS", "STAGE8", "REPENTANCE"}
	},
	["ROOM_SHOP"] = {
		music = Music.MUSIC_SHOP_ROOM,
		tags = {}
	},
	["ROOM_TREASURE"] = {
		tags = {},
	},
	["ROOM_BOSS_CLEAR"] = {
		music = Music.MUSIC_BOSS_OVER,
		tags = {"BOSS_CLEAR"},
	},
	["ROOM_BOSS_CLEAR_NULL"] = {
		music = Music.MUSIC_NULL,
		tags = {"REPENTANCE"},
	},
	["ROOM_BOSS_CLEAR_TWISTED"] = {
		music = Music.MUSIC_BOSS_OVER_TWISTED,
		tags = {"REPENTANCE"},
	},
	["ROOM_MINIBOSS_ACTIVE"] = {
		music = Music.MUSIC_CHALLENGE_FIGHT,
		tags = {},
	},
	["ROOM_MINIBOSS_CLEAR"] = {
		music = Music.MUSIC_BOSS_OVER,
		tags = {"BOSS_CLEAR"},
	},
	["ROOM_SECRET"] = {
		music = Music.MUSIC_SECRET_ROOM,
		tags = {"ROOM_SECRET"}
	},
	["ROOM_SUPER_SECRET"] = {
		music = Music.MUSIC_SECRET_ROOM2,
		tags = {"ROOM_SECRET"}
	},
	["ROOM_ULTRA_SECRET"] = {
		music = Music.MUSIC_SECRET_ROOM_ALT_ALT,
		tags = {"ROOM_SECRET", "REPENTANCE"}
	},
	["ROOM_ARCADE"] = {
		music = Music.MUSIC_ARCADE_ROOM,
		tags = {}
	},
	["ROOM_CURSE"] = {
		tags = {}
	},
	["ROOM_CHALLENGE_NORMAL_INACTIVE"] = {
		tags = {"ROOM_CHALLENGE_INACTIVE"}
	},
	["ROOM_CHALLENGE_NORMAL_ACTIVE"] = {
		music = Music.MUSIC_CHALLENGE_FIGHT,
		tags = {"ROOM_CHALLENGE_ACTIVE"}
	},
	["ROOM_CHALLENGE_NORMAL_CLEAR"] = {
		music = Music.MUSIC_BOSS_OVER,
		tags = {"ROOM_CHALLENGE_CLEAR", "BOSS_CLEAR"}
	},
	["ROOM_CHALLENGE_BOSS_INACTIVE"] = {
		tags = {"ROOM_CHALLENGE_INACTIVE"}
	},
	["ROOM_CHALLENGE_BOSS_ACTIVE"] = {
		music = Music.MUSIC_CHALLENGE_FIGHT,
		tags = {"ROOM_CHALLENGE_ACTIVE"}
	},
	["ROOM_CHALLENGE_BOSS_CLEAR"] = {
		music = Music.MUSIC_BOSS_OVER,
		tags = {"ROOM_CHALLENGE_CLEAR", "BOSS_CLEAR"}
	},
	["ROOM_LIBRARY"] = {
		music = Music.MUSIC_LIBRARY_ROOM,
		tags = {}
	},
	["ROOM_SACRIFICE"] = {
		tags = {}
	},
	["ROOM_DEVIL"] = {
		music = Music.MUSIC_DEVIL_ROOM,
		tags = {}
	},
	["ROOM_ANGEL"] = {
		music = Music.MUSIC_ANGEL_ROOM,
		tags = {}
	},
	["ROOM_DUNGEON"] = {
		music = Music.MUSIC_DUNGEON,
		tags = {}
	},
	["ROOM_BOSS_RUSH_INACTIVE"] = {
		tags = {}
	},
	["ROOM_BOSS_RUSH_ACTIVE"] = {
		music = Music.MUSIC_BOSS_RUSH,
		tags = {}
	},
	["ROOM_BOSS_RUSH_CLEAR"] = {
		music = Music.MUSIC_BOSS_OVER,
		tags = {"BOSS_CLEAR"}
	},
	["ROOM_ISAACS"] = {
		tags = {"ROOM_BEDROOM"}
	},
	["ROOM_BARREN"] = {
		tags = {"ROOM_BEDROOM"}
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
		music = Music.MUSIC_PLANETARIUM,
		tags = {"REPENTANCE"},
	},
	["ROOM_TELEPORTER"] = {
		tags = {"REPENTANCE"},
	},
	["ROOM_TELEPORTER_EXIT"] = {
		tags = {"REPENTANCE"},
	},
	["ROOM_SECRET_EXIT"] = {
		music = Music.MUSIC_BOSS_OVER,
		tags = {"REPENTANCE", "BOSS_CLEAR"},
	},
	["ROOM_BLUE"] = {
		tags = {"REPENTANCE"},
	},
	["ROOM_OTHER"] = {
		tags = {},
	},
	
	["JINGLE_BOSS"] = {
		music = Music.MUSIC_JINGLE_BOSS,
		tags = {"JINGLE"},
	},
	["JINGLE_BOSS_CLEAR_REBIRTH"] = {
		music = Music.MUSIC_JINGLE_BOSS_OVER,
		tags = {"JINGLE", "JINGLE_BOSS_CLEAR"},
	},
	["JINGLE_BOSS_CLEAR_AFTERBIRTH"] = {
		music = Music.MUSIC_JINGLE_BOSS_OVER2,
		tags = {"JINGLE", "JINGLE_BOSS_CLEAR"},
	},
	["JINGLE_BOSS_CLEAR_REPENTANCE"] = {
		music = Music.MUSIC_JINGLE_BOSS_OVER3,
		tags = {"JINGLE", "JINGLE_BOSS_CLEAR", "REPENTANCE"},
	},
	["JINGLE_MINIBOSS_CLEAR"] = {
		music = Music.MUSIC_JINGLE_CHALLENGE_OUTRO,
		tags = {"JINGLE"},
	},
	["JINGLE_CHALLENGE_NORMAL_CLEAR"] = {
		music = Music.MUSIC_JINGLE_CHALLENGE_OUTRO,
		tags = {"JINGLE", "JINGLE_CHALLENGE_CLEAR"},
	},
	["JINGLE_CHALLENGE_BOSS_CLEAR"] = {
		music = Music.MUSIC_JINGLE_CHALLENGE_OUTRO,
		tags = {"JINGLE", "JINGLE_CHALLENGE_CLEAR"},
	},
	["JINGLE_ANGEL_ROOM"] = {
		music = Music.MUSIC_JINGLE_HOLYROOM_FIND,
		tags = {"JINGLE", "JINGLE_DEAL_ROOM"},
	},
	["JINGLE_SECRET_ROOM"] = {
		music = Music.MUSIC_JINGLE_SECRETROOM_FIND,
		tags = {"JINGLE"},
		persistence = 1
	},
	["JINGLE_TREASURE_ROOM"] = {
		music = {
			Music.MUSIC_JINGLE_TREASUREROOM_ENTRY_0,
			Music.MUSIC_JINGLE_TREASUREROOM_ENTRY_1,
			Music.MUSIC_JINGLE_TREASUREROOM_ENTRY_2,
			Music.MUSIC_JINGLE_TREASUREROOM_ENTRY_3
		},
		tags = {"JINGLE", "JINGLE_TREASURE_ROOM"},
		persistence = 1,
	},
	["JINGLE_GAME_OVER"] = {
		music = Music.MUSIC_JINGLE_GAME_OVER,
		tags = {"JINGLE"},
		persistence = 1,
	},
	["JINGLE_DEVIL_ROOM"] = {
		music = Music.MUSIC_JINGLE_DEVILROOM_FIND,
		tags = {"JINGLE", "JINGLE_DEAL_ROOM"},
	},
	["JINGLE_BOSS_RUSH_OUTRO"] = {
		music = Music.MUSIC_JINGLE_BOSS_OVER, --check
		tags = {"JINGLE", "JINGLE_BOSS_CLEAR"},
	},
	["JINGLE_BOSS_MOTHER_CLEAR"] = {
		music = Music.MUSIC_JINGLE_MOTHER_OVER,
		tags = {"JINGLE", "REPENTANCE"},
	},
	["JINGLE_BOSS_DOGMA_CLEAR"] = {
		music = Music.MUSIC_JINGLE_DOGMA_OVER,
		tags = {"JINGLE", "REPENTANCE"},
	},
	["JINGLE_BOSS_BEAST_CLEAR"] = {
		music = Music.MUSIC_JINGLE_BEAST_OVER,
		tags = {"JINGLE", "REPENTANCE"},
	},
	["JINGLE_STRANGE_DOOR"] = {
		music = Music.MUSIC_STRANGE_DOOR_JINGLE,
		tags = {"JINGLE", "REPENTANCE"},
	},
	
	["INTRO_MOTHERS_SHADOW"] = {
		music = Music.MUSIC_MOTHERS_SHADOW_INTRO,
		tags = {"INTRO", "REPENTANCE"},
	},
	["INTRO_DOGMA"] = {
		music = Music.MUSIC_DOGMA_INTRO,
		tags = {"INTRO", "REPENTANCE"},
	},
	
	["STATE_GAME_OVER"] = {
		music = Music.MUSIC_GAME_OVER,
		tags = {},
	},
	["STATE_ASCENT"] = {
		music = Music.MUSIC_REVERSE_GENESIS,
		tags = {"REPENTANCE"},
	},
	["STATE_MINESHAFT_ESCAPE"] = {
		music = Music.MUSIC_MINESHAFT_ESCAPE,
		tags = {"STAGE", "REPENTANCE", "DIMENSION_ALTERNATE", "STAGETYPE_REPENTANCE", "STAGETYPE_REPENTANCE_B", "STAGE2_2", "STAGE2", "MINESHAFT"}
	},
	
	["MENU_MAIN_MENU_REBIRTH"] = {
		music = Music.MUSIC_TITLE,
		tags = {"MENU", "MENU_MAIN_MENU"},
	},
	["MENU_MAIN_MENU_AFTERBIRTH"] = {
		music = Music.MUSIC_TITLE_AFTERBIRTH,
		tags = {"MENU", "MENU_MAIN_MENU"},
	},
	["MENU_MAIN_MENU_REPENTANCE"] = {
		music = Music.MUSIC_TITLE_REPENTANCE,
		tags = {"MENU", "MENU_MAIN_MENU"},
	},
	
	["DIMENSION_DEATH_CERTIFICATE"] = {
		music = Music.MUSIC_DARK_CLOSET,
		tags = {"REPENTANCE"},
	},
	
	-- Extra greed themes for The Shop floor
	["GREED_INACTIVE"] = {
		tags = {"GREED"}
	},
	["GREED_ACTIVE"] = {
		music = Music.MUSIC_CHALLENGE_FIGHT,
		tags = {"GREED"}
	},
	["GREED_CLEAR"] = {
		music = Music.MUSIC_BOSS_OVER,
		tags = {"GREED", "BOSS_CLEAR"}
	},
	["JINGLE_GREED_CLEAR"] = {
		music = Music.MUSIC_JINGLE_CHALLENGE_OUTRO,
		tags = {"JINGLE"},
	},
}

return track_table 