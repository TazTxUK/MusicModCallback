local Query = require "scripts.musicapi.query"

local enums = require "scripts.musicapi.enums"
local Music = enums.Music

-- local queryIsStage = Query() & MusicAPI.Flag("STAGE")

--[[
Music tracks will replace (or supplement) normal Music ids.

With the current API, you can only check for a Music id and replace it without any context.
This should rectify that, making Music replacements for specific scenarios easier, (Eg. Mega
Satan, Hush stage 1) especially where Music is reused. This also allows mods to simply disable
Music Flags, for example JINGLE_BOSS, so that no boss jingles ever play, jumping straight into
the boss theme.

This mostly affects Soundtrack Menu. As of right now, it has a special case for Mega Satan, but
this update should make it so that no special cases are needed at all.

If you have a surplus of Music from another source to put into Isaac, you can use this Music
system to add separate tracks to Basement I and Basement II for example rather than add it to
the entire Basement, if you want.
Conversely, if you do not have enough Music, you can make tracks simply not play or redirect to
other tracks. For example: Have one track cover all boss Music by looking for the "BOSS" tag.

The "REPENTANCE" tag is added to all repentance tracks. If there was a Music mod from Afterbirth+
that you would like to convert into a repentance soundtrack, you can use this tag to determine
if the Music will be replaced successfully or not, and it can be redirected.

Persistence:
1 - If a Persistence 1 jingle is playing with a track queued after it, and you attempt to play
the track again, then the track will not override the jingle.
2 - If a Persistence 2 jingle is playing, any Music to be played will be queued after it.

For example if the game start theme is playing, and the player enters a planetarium, the planetarium Music
will be queued after the game start jingle is finished.
]]

local track_table = {
	--Don't add callbacks to API tracks
	["API_NOTHING"] = {
		Music = Music.MUSIC_MUSICAPI_NOTHING,
		Flags = {"API"},
	},
	["API_GAME_START"] = {
		Flags = {"API"},
		Persistence = 2,
	},
	["API_STAGE_TRANSITION"] = {
		Flags = {"API"},
		Persistence = 2,
	},

	["STAGE_NULL"] = {
		Music = Music.MUSIC_MUSICAPI_NOTHING,
		Flags = {"STAGE"},
	},
	
	["STAGE_BASEMENT"] = {
		Music = Music.MUSIC_BASEMENT,
		Flags = {"STAGE", "STAGETYPE_ORIGINAL", "STAGE1_1", "STAGE1_2", "STAGE1", "STAGE1_GREED"},
	},
	["STAGE_CELLAR"] = {
		Music = Music.MUSIC_CELLAR,
		Flags = {"STAGE", "STAGETYPE_WOTL", "STAGE1_1", "STAGE1_2", "STAGE1", "STAGE1_GREED"}
	},
	["STAGE_BURNING_BASEMENT"] = {
		Music = Music.MUSIC_BURNING_BASEMENT,
		Flags = {"STAGE", "STAGETYPE_AFTERBIRTH", "STAGE1_1", "STAGE1_2", "STAGE1", "STAGE1_GREED"}
	},
	["STAGE_DOWNPOUR"] = {
		Music = Music.MUSIC_DOWNPOUR,
		Flags = {"STAGE", "REPENTANCE", "DIMENSION_MAIN", "STAGETYPE_REPENTANCE", "STAGE1_1", "STAGE1_2", "STAGE1", "STAGE1_GREED"}
	},
	["STAGE_DROSS"] = {
		Music = Music.MUSIC_DROSS,
		Flags = {"STAGE", "REPENTANCE", "DIMENSION_MAIN", "STAGETYPE_REPENTANCE_B", "STAGE1_1", "STAGE1_2", "STAGE1", "STAGE1_GREED"}
	},
	["STAGE_MIRROR_DOWNPOUR"] = {
		Music = Music.MUSIC_DOWNPOUR_REVERSE,
		Flags = {"STAGE", "REPENTANCE", "DIMENSION_ALTERNATE", "STAGETYPE_REPENTANCE", "STAGE1_2", "STAGE1"},
		FadeSpeed = 0.01,
	},
	["STAGE_MIRROR_DROSS"] = {
		Music = Music.MUSIC_DROSS_REVERSE,
		Flags = {"STAGE", "REPENTANCE", "DIMENSION_ALTERNATE", "STAGETYPE_REPENTANCE_B", "STAGE1_2", "STAGE1"},
		FadeSpeed = 0.01,
	},
	
	["STAGE_CAVES"] = {
		Music = Music.MUSIC_CAVES,
		Flags = {"STAGE", "STAGETYPE_ORIGINAL", "STAGE2_1", "STAGE2_2", "STAGE2", "STAGE2_GREED"}
	},
	["STAGE_CATACOMBS"] = {
		Music = Music.MUSIC_CATACOMBS,
		Flags = {"STAGE", "STAGETYPE_WOTL", "STAGE2_1", "STAGE2_2", "STAGE2", "STAGE2_GREED"}
	},
	["STAGE_FLOODED_CAVES"] = {
		Music = Music.MUSIC_FLOODED_CAVES,
		Flags = {"STAGE", "STAGETYPE_AFTERBIRTH", "STAGE2_1", "STAGE2_2", "STAGE2", "STAGE2_GREED"}
	},
	["STAGE_MINES"] = {
		Music = Music.MUSIC_MINES,
		Flags = {"STAGE", "REPENTANCE", "DIMENSION_MAIN", "STAGETYPE_REPENTANCE", "STAGE2_1", "STAGE2_2", "STAGE2", "STAGE2_GREED"}
	},
	["STAGE_ASHPIT"] = {
		Music = Music.MUSIC_ASHPIT,
		Flags = {"STAGE", "REPENTANCE", "DIMENSION_MAIN", "STAGETYPE_REPENTANCE_B", "STAGE2_1", "STAGE2_2", "STAGE2", "STAGE2_GREED"}
	},
	["STAGE_MINESHAFT_AMBIENT"] = {
		Music = Music.MUSIC_MINESHAFT_AMBIENT,
		Flags = {"STAGE", "REPENTANCE", "DIMENSION_ALTERNATE", "STAGETYPE_REPENTANCE", "STAGETYPE_REPENTANCE_B", "STAGE2_2", "STAGE2", "MINESHAFT"}
	},
	
	["STAGE_DEPTHS"] = {
		Music = Music.MUSIC_DEPTHS,
		Flags = {"STAGE", "STAGETYPE_ORIGINAL", "STAGE3_1", "STAGE3_2", "STAGE3", "STAGE3_GREED"}
	},
	["STAGE_NECROPOLIS"] = {
		Music = Music.MUSIC_NECROPOLIS,
		Flags = {"STAGE", "STAGETYPE_WOTL", "STAGE3_1", "STAGE3_2", "STAGE3", "STAGE3_GREED"}
	},
	["STAGE_DANK_DEPTHS"] = {
		Music = Music.MUSIC_DANK_DEPTHS,
		Flags = {"STAGE", "STAGETYPE_AFTERBIRTH", "STAGE3_1", "STAGE3_2", "STAGE3", "STAGE3_GREED"}
	},
	["STAGE_MAUSOLEUM"] = {
		Music = Music.MUSIC_MAUSOLEUM,
		Flags = {"STAGE", "REPENTANCE", "STAGETYPE_REPENTANCE", "STAGE3_1", "STAGE3_2", "STAGE3", "STAGE3_GREED"}
	},
	["STAGE_GEHENNA"] = {
		Music = Music.MUSIC_GEHENNA,
		Flags = {"STAGE", "REPENTANCE", "STAGETYPE_REPENTANCE_B", "STAGE3_1", "STAGE3_2", "STAGE3", "STAGE3_GREED"}
	},
	
	["STAGE_WOMB"] = {
		Music = Music.MUSIC_WOMB_UTERO,
		Flags = {"STAGE", "STAGETYPE_ORIGINAL", "STAGE4_1", "STAGE4_2", "STAGE4", "STAGE4_GREED"}
	},
	["STAGE_UTERO"] = {
		Music = Music.MUSIC_UTERO,
		Flags = {"STAGE", "STAGETYPE_WOTL", "STAGE4_1", "STAGE4_2", "STAGE4", "STAGE4_GREED"}
	},
	["STAGE_SCARRED_WOMB"] = {
		Music = Music.MUSIC_SCARRED_WOMB,
		Flags = {"STAGE", "STAGETYPE_AFTERBIRTH", "STAGE4_1", "STAGE4_2", "STAGE4", "STAGE4_GREED"}
	},
	["STAGE_CORPSE"] = {
		Music = Music.MUSIC_CORPSE,
		Flags = {"STAGE", "REPENTANCE", "STAGETYPE_REPENTANCE", "STAGE4_1", "STAGE4_2", "STAGE4", "STAGE4_GREED"}
	},
	["STAGE_MORTIS"] = {
		Music = Music.MUSIC_MORTIS,
		Flags = {"STAGE", "REPENTANCE", "STAGETYPE_REPENTANCE_B", "STAGE4_1", "STAGE4_2", "STAGE4", "STAGE4_GREED"}
	},
	
	["STAGE_BLUE_WOMB"] = {
		Music = Music.MUSIC_BLUE_WOMB,
		Flags = {"STAGE", "STAGE4_3", "STAGE4"}
	},
	
	["STAGE_SHEOL"] = {
		Music = Music.MUSIC_SHEOL,
		Flags = {"STAGE", "STAGETYPE_ORIGINAL", "STAGE5", "STAGE5_GREED"}
	},
	["STAGE_CATHEDRAL"] = {
		Music = Music.MUSIC_CATHEDRAL,
		Flags = {"STAGE", "STAGETYPE_WOTL", "STAGE5", "STAGE5_GREED"}
	},
	
	["STAGE_DARK_ROOM"] = {
		Music = Music.MUSIC_DARK_ROOM,
		Flags = {"STAGE", "STAGETYPE_ORIGINAL", "STAGE6"}
	},
	["STAGE_CHEST"] = {
		Music = Music.MUSIC_CHEST,
		Flags = {"STAGE", "STAGETYPE_WOTL", "STAGE6"}
	},
	["STAGE_SHOP"] = {
		Music = Music.MUSIC_SHOP_ROOM,
		Flags = {"STAGE", "STAGE6_GREED"}
	},
	
	["STAGE_VOID"] = {
		Music = Music.MUSIC_VOID,
		Flags = {"STAGE", "STAGE7"}
	},
	["STAGE_ULTRA_GREED"] = {
		Music = Music.MUSIC_SHOP_ROOM,
		Flags = {"STAGE", "STAGE7_GREED"}
	},
	
	["STAGE_HOME"] = {
		Music = Music.MUSIC_ISAACS_HOUSE,
		Flags = {"STAGE", "STAGETYPE_ORIGINAL", "STAGE8"}
	},
	["STAGE_DARK_HOME"] = {
		Music = Music.MUSIC_ISAACS_HOUSE,
		Flags = {"STAGE", "STAGETYPE_WOTL", "STAGE8"},
		FadeSpeed = 1,
	},
	
	["BOSS_REBIRTH"] = {
		Music = Music.MUSIC_BOSS,
		Flags = {"BOSS", "BOSS_GENERIC"}
	},
	["BOSS_AFTERBIRTH"] = {
		Music = Music.MUSIC_BOSS2,
		Flags = {"BOSS", "BOSS_GENERIC"}
	},
	["BOSS_REPENTANCE"] = {
		Music = Music.MUSIC_BOSS3,
		Flags = {"BOSS", "BOSS_GENERIC", "REPENTANCE"}
	},
	["BOSS_MOM"] = {
		Music = Music.MUSIC_MOM_BOSS,
		Flags = {"BOSS", "STAGE3_2"}
	},
	["BOSS_MOMS_HEART"] = {
		Music = Music.MUSIC_MOMS_HEART_BOSS,
		Flags = {"BOSS", "STAGE4_2"}
	},
	["BOSS_IT_LIVES"] = {
		Music = Music.MUSIC_MOMS_HEART_BOSS,
		Flags = {"BOSS", "STAGE4_2"}
	},
	["BOSS_ANGEL"] = {
		Flags = {"BOSS"}
	},
	-- ["BOSS_MOMS_HEART_MAUSOLEUM"] = {
		-- Music = Music.MUSIC_MOMS_HEART_BOSS,
		-- Flags = {"BOSS", "STAGE3_2", "REPENTANCE", "BOSS_MOMS_HEART"}
	-- },
	["BOSS_ISAAC"] = {
		Music = Music.MUSIC_ISAAC_BOSS,
		Flags = {"BOSS", "STAGE5", "STAGETYPE_WOTL"}
	},
	["BOSS_SATAN_INACTIVE"] = {
		Music = Music.MUSIC_DEVIL_ROOM,
		Flags = {"BOSS", "STAGE5", "STAGETYPE_ORIGINAL"}
	},
	["BOSS_SATAN"] = {
		Music = Music.MUSIC_SATAN_BOSS,
		Flags = {"BOSS", "STAGE5", "STAGETYPE_ORIGINAL"}
	},
	["BOSS_MEGA_SATAN_INACTIVE"] = {
		Music = Music.MUSIC_DEVIL_ROOM,
		Flags = {"BOSS", "STAGE6"}
	},
	["BOSS_MEGA_SATAN"] = {
		Music = Music.MUSIC_SATAN_BOSS,
		Flags = {"BOSS", "STAGE6"}
	},
	["BOSS_GREEDMODE_EXTRA"] = {
		Music = Music.MUSIC_SATAN_BOSS,
		Flags = {"BOSS"}
	},
	["BOSS_LAMB"] = {
		Music = Music.MUSIC_DARKROOM_BOSS,
		Flags = {"BOSS", "STAGE6", "STAGETYPE_ORIGINAL"}
	},
	["BOSS_BLUE_BABY"] = {
		Music = Music.MUSIC_BLUEBABY_BOSS,
		Flags = {"BOSS", "STAGE6", "STAGETYPE_WOTL"}
	},
	["BOSS_HUSH_FIRST"] = {
		Music = Music.MUSIC_BLUEBABY_BOSS,
		Flags = {"BOSS", "STAGE4_3", "BOSS_HUSH"}
	},
	["BOSS_HUSH_FINAL"] = {
		Music = Music.MUSIC_HUSH_BOSS,
		Flags = {"BOSS", "STAGE4_3", "BOSS_HUSH"}
	},
	["BOSS_ULTRA_GREED"] = {
		Music = Music.MUSIC_ULTRAGREED_BOSS,
		Flags = {"BOSS", "STAGE7_GREED", "BOSS_ULTRA_GREED"}
	},
	-- ["BOSS_ULTRA_GREEDIER"] = {
		-- Music = Music.MUSIC_ULTRAGREED_BOSS,
		-- Flags = {"BOSS", "STAGE7_GREED", "BOSS_ULTRA_GREED"}
	-- },
	["BOSS_DELIRIUM"] = {
		Music = Music.MUSIC_VOID_BOSS,
		Flags = {"BOSS", "STAGE7"}
	},
	["BOSS_MOTHER"] = {
		Music = Music.MUSIC_MOTHER_BOSS,
		Flags = {"BOSS", "STAGE4_2", "REPENTANCE"}
	},
	["BOSS_DOGMA"] = {
		Music = Music.MUSIC_DOGMA_BOSS,
		Flags = {"BOSS", "STAGE8", "REPENTANCE"},
		FadeSpeed = 1,
	},
	["BOSS_BEAST"] = {
		Music = Music.MUSIC_BEAST_BOSS,
		Flags = {"BOSS", "STAGE8", "REPENTANCE"}
	},
	["ROOM_SHOP"] = {
		Music = Music.MUSIC_SHOP_ROOM,
		Flags = {}
	},
	["ROOM_TREASURE"] = {
		Flags = {},
	},
	["ROOM_BOSS_CLEAR"] = {
		Music = Music.MUSIC_BOSS_OVER,
		Flags = {"BOSS_CLEAR"},
	},
	["ROOM_BOSS_CLEAR_NULL"] = {
		Music = Music.MUSIC_NULL,
		Flags = {"REPENTANCE"},
	},
	["ROOM_BOSS_CLEAR_TWISTED"] = {
		Music = Music.MUSIC_BOSS_OVER_TWISTED,
		Flags = {"REPENTANCE"},
	},
	["ROOM_MINIBOSS_ACTIVE"] = {
		Music = Music.MUSIC_CHALLENGE_FIGHT,
		Flags = {},
	},
	["ROOM_MINIBOSS_CLEAR"] = {
		Music = Music.MUSIC_BOSS_OVER,
		Flags = {"BOSS_CLEAR"},
	},
	["ROOM_SECRET"] = {
		Music = Music.MUSIC_SECRET_ROOM,
		Flags = {"ROOM_SECRET"}
	},
	["ROOM_SUPER_SECRET"] = {
		Music = Music.MUSIC_SECRET_ROOM2,
		Flags = {"ROOM_SECRET"}
	},
	["ROOM_ULTRA_SECRET"] = {
		Music = Music.MUSIC_SECRET_ROOM_ALT_ALT,
		Flags = {"ROOM_SECRET", "REPENTANCE"}
	},
	["ROOM_ARCADE"] = {
		Music = Music.MUSIC_ARCADE_ROOM,
		Flags = {}
	},
	["ROOM_CURSE"] = {
		Flags = {}
	},
	["ROOM_CHALLENGE_NORMAL_INACTIVE"] = {
		Flags = {"ROOM_CHALLENGE_INACTIVE"}
	},
	["ROOM_CHALLENGE_NORMAL_ACTIVE"] = {
		Music = Music.MUSIC_CHALLENGE_FIGHT,
		Flags = {"ROOM_CHALLENGE_ACTIVE"}
	},
	["ROOM_CHALLENGE_NORMAL_CLEAR"] = {
		Music = Music.MUSIC_BOSS_OVER,
		Flags = {"ROOM_CHALLENGE_CLEAR", "BOSS_CLEAR"}
	},
	["ROOM_CHALLENGE_BOSS_INACTIVE"] = {
		Flags = {"ROOM_CHALLENGE_INACTIVE"}
	},
	["ROOM_CHALLENGE_BOSS_ACTIVE"] = {
		Music = Music.MUSIC_CHALLENGE_FIGHT,
		Flags = {"ROOM_CHALLENGE_ACTIVE"}
	},
	["ROOM_CHALLENGE_BOSS_CLEAR"] = {
		Music = Music.MUSIC_BOSS_OVER,
		Flags = {"ROOM_CHALLENGE_CLEAR", "BOSS_CLEAR"}
	},
	["ROOM_LIBRARY"] = {
		Music = Music.MUSIC_LIBRARY_ROOM,
		Flags = {}
	},
	["ROOM_SACRIFICE"] = {
		Flags = {}
	},
	["ROOM_DEVIL"] = {
		Music = Music.MUSIC_DEVIL_ROOM,
		Flags = {}
	},
	["ROOM_ANGEL"] = {
		Music = Music.MUSIC_ANGEL_ROOM,
		Flags = {}
	},
	["ROOM_DUNGEON"] = {
		Music = Music.MUSIC_DUNGEON,
		Flags = {}
	},
	["ROOM_BOSS_RUSH_INACTIVE"] = {
		Flags = {}
	},
	["ROOM_BOSS_RUSH_ACTIVE"] = {
		Music = Music.MUSIC_BOSS_RUSH,
		Flags = {}
	},
	["ROOM_BOSS_RUSH_CLEAR"] = {
		Music = Music.MUSIC_BOSS_OVER,
		Flags = {"BOSS_CLEAR"}
	},
	["ROOM_ISAACS"] = {
		Flags = {"ROOM_BEDROOM"}
	},
	["ROOM_BARREN"] = {
		Flags = {"ROOM_BEDROOM"}
	},
	["ROOM_CHEST"] = {
		Flags = {"ROOM_DOUBLE_KEY"},
	},
	["ROOM_DICE"] = {
		Flags = {"ROOM_DOUBLE_KEY"},
	},
	["ROOM_BLACK_MARKET"] = {
		Flags = {},
	},
	["ROOM_GREED_EXIT"] = {
		Flags = {},
	},
	["ROOM_PLANETARIUM"] = {
		Music = Music.MUSIC_PLANETARIUM,
		Flags = {"REPENTANCE"},
	},
	["ROOM_TELEPORTER"] = {
		Flags = {"REPENTANCE"},
	},
	["ROOM_TELEPORTER_EXIT"] = {
		Flags = {"REPENTANCE"},
	},
	["ROOM_SECRET_EXIT"] = {
		Music = Music.MUSIC_BOSS_OVER,
		Flags = {"REPENTANCE", "BOSS_CLEAR"},
	},
	["ROOM_BLUE"] = {
		Flags = {"REPENTANCE"},
	},
	["ROOM_OTHER"] = {
		Flags = {},
	},
	
	["JINGLE_BOSS"] = {
		Music = Music.MUSIC_JINGLE_BOSS,
		Flags = {"JINGLE"},
	},
	["JINGLE_BOSS_CLEAR_REBIRTH"] = {
		Music = Music.MUSIC_JINGLE_BOSS_OVER,
		Flags = {"JINGLE", "JINGLE_BOSS_CLEAR"},
	},
	["JINGLE_BOSS_CLEAR_AFTERBIRTH"] = {
		Music = Music.MUSIC_JINGLE_BOSS_OVER2,
		Flags = {"JINGLE", "JINGLE_BOSS_CLEAR"},
	},
	["JINGLE_BOSS_CLEAR_REPENTANCE"] = {
		Music = Music.MUSIC_JINGLE_BOSS_OVER3,
		Flags = {"JINGLE", "JINGLE_BOSS_CLEAR", "REPENTANCE"},
	},
	["JINGLE_MINIBOSS_CLEAR"] = {
		Music = Music.MUSIC_JINGLE_CHALLENGE_OUTRO,
		Flags = {"JINGLE"},
	},
	["JINGLE_CHALLENGE_NORMAL_CLEAR"] = {
		Music = Music.MUSIC_JINGLE_CHALLENGE_OUTRO,
		Flags = {"JINGLE", "JINGLE_CHALLENGE_CLEAR"},
	},
	["JINGLE_CHALLENGE_BOSS_CLEAR"] = {
		Music = Music.MUSIC_JINGLE_CHALLENGE_OUTRO,
		Flags = {"JINGLE", "JINGLE_CHALLENGE_CLEAR"},
	},
	["JINGLE_ANGEL_ROOM"] = {
		Music = Music.MUSIC_JINGLE_HOLYROOM_FIND,
		Flags = {"JINGLE", "JINGLE_DEAL_ROOM"},
	},
	["JINGLE_SECRET_ROOM"] = {
		Music = Music.MUSIC_JINGLE_SECRETROOM_FIND,
		Flags = {"JINGLE"},
		Persistence = 1
	},
	["JINGLE_TREASURE_ROOM"] = {
		Music = {
			Music.MUSIC_JINGLE_TREASUREROOM_ENTRY_0,
			Music.MUSIC_JINGLE_TREASUREROOM_ENTRY_1,
			Music.MUSIC_JINGLE_TREASUREROOM_ENTRY_2,
			Music.MUSIC_JINGLE_TREASUREROOM_ENTRY_3
		},
		Flags = {"JINGLE", "JINGLE_TREASURE_ROOM"},
		Persistence = 1,
		FadeSpeed = 1,
	},
	["JINGLE_GAME_OVER"] = {
		Music = Music.MUSIC_JINGLE_GAME_OVER,
		Flags = {"JINGLE"},
		Persistence = 1,
	},
	["JINGLE_DEVIL_ROOM"] = {
		Music = Music.MUSIC_JINGLE_DEVILROOM_FIND,
		Flags = {"JINGLE", "JINGLE_DEAL_ROOM"},
	},
	["JINGLE_BOSS_RUSH_OUTRO"] = {
		Music = Music.MUSIC_JINGLE_BOSS_OVER, --check
		Flags = {"JINGLE", "JINGLE_BOSS_CLEAR"},
	},
	["JINGLE_BOSS_DOGMA_CLEAR"] = {
		Music = Music.MUSIC_JINGLE_DOGMA_OVER,
		Flags = {"JINGLE", "REPENTANCE"},
		FadeSpeed = 1,
	},
	["JINGLE_STRANGE_DOOR"] = {
		Music = Music.MUSIC_STRANGE_DOOR_JINGLE,
		Flags = {"JINGLE", "REPENTANCE"},
		FadeSpeed = 1,
	},
	
	["INTRO_MOTHERS_SHADOW"] = {
		Music = Music.MUSIC_MOTHERS_SHADOW_INTRO,
		Flags = {"INTRO", "REPENTANCE"},
		FadeSpeed = 1,
	},
	["INTRO_DOGMA"] = {
		Music = Music.MUSIC_DOGMA_INTRO,
		Flags = {"INTRO", "REPENTANCE"},
	},
	
	["STATE_GAME_OVER"] = {
		Music = Music.MUSIC_GAME_OVER,
		Flags = {},
	},
	["STATE_ASCENT"] = {
		Music = Music.MUSIC_REVERSE_GENESIS,
		Flags = {"REPENTANCE"},
	},
	["STATE_MINESHAFT_ESCAPE"] = {
		Music = Music.MUSIC_MINESHAFT_ESCAPE,
		Flags = {"STAGE", "REPENTANCE", "DIMENSION_ALTERNATE", "STAGETYPE_REPENTANCE", "STAGETYPE_REPENTANCE_B", "STAGE2_2", "STAGE2", "MINESHAFT"}
	},
	
	["MENU_MAIN_MENU_REBIRTH"] = {
		Music = Music.MUSIC_TITLE,
		Flags = {"MENU", "MENU_MAIN_MENU"},
	},
	["MENU_MAIN_MENU_AFTERBIRTH"] = {
		Music = Music.MUSIC_TITLE_AFTERBIRTH,
		Flags = {"MENU", "MENU_MAIN_MENU"},
	},
	["MENU_MAIN_MENU_REPENTANCE"] = {
		Music = Music.MUSIC_TITLE_REPENTANCE,
		Flags = {"MENU", "MENU_MAIN_MENU"},
	},
	
	["DIMENSION_DEATH_CERTIFICATE"] = {
		Music = Music.MUSIC_DARK_CLOSET,
		Flags = {"REPENTANCE"},
	},
	
	-- Extra greed themes for The Shop floor
	["GREED_INACTIVE"] = {
		Flags = {"GREED"}
	},
	["GREED_ACTIVE"] = {
		Music = Music.MUSIC_CHALLENGE_FIGHT,
		Flags = {"GREED"}
	},
	["GREED_CLEAR"] = {
		Music = Music.MUSIC_BOSS_OVER,
		Flags = {"GREED", "BOSS_CLEAR"}
	},
	["JINGLE_GREED_CLEAR"] = {
		Music = Music.MUSIC_JINGLE_CHALLENGE_OUTRO,
		Flags = {"JINGLE"},
	},
}

return track_table 