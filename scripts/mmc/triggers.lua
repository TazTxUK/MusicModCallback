local music_triggers = {
	
	--[[
	Music triggers will replace normal music callbacks.
	
	With the current API, you can only check for a music track and replace it without any context.
	This should rectify that, making music replacements for specific scenarios easier, (Eg. Mega
	Satan, Hush stage 1) especially where music is reused. This also allows mods to simply disable
	trigger tags, for example JINGLE_BOSS, so that no boss jingles ever play, jumping straight into
	the boss theme.
	
	This mostly affects Soundtrack Menu. As of right now, it has a special case for Mega Satan, but
	this update should make it so that no special cases are needed at all.
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
		tags = {"STAGE", "REPENTANCE", "STAGETYPE_REPENTANCE", "STAGE1_1", "STAGE1_2", "STAGE1", "STAGE1_GREED"}
	},
	["STAGE_DROSS"] = {
		track = Music.MUSIC_DROSS,
		tags = {"STAGE", "REPENTANCE", "STAGETYPE_REPENTANCE_B", "STAGE1_1", "STAGE1_2", "STAGE1", "STAGE1_GREED"}
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
		tags = {"STAGE", "REPENTANCE", "STAGETYPE_REPENTANCE", "STAGE2_1", "STAGE2_2", "STAGE2", "STAGE2_GREED"}
	},
	["STAGE_ASHPIT"] = {
		track = Music.MUSIC_ASHPIT,
		tags = {"STAGE", "REPENTANCE", "STAGETYPE_REPENTANCE_B", "STAGE2_1", "STAGE2_2", "STAGE2", "STAGE2_GREED"}
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
	
	
	--temporary enum reference
	-- MUSIC_NULL = 0,
	-- MUSIC_BASEMENT = Isaac.GetMusicIdByName("Basement"),
	-- MUSIC_CAVES = Isaac.GetMusicIdByName("Caves"),
	-- MUSIC_DEPTHS = Isaac.GetMusicIdByName("Depths"),
	-- MUSIC_CELLAR = Isaac.GetMusicIdByName("Cellar"),
	-- MUSIC_CATACOMBS = Isaac.GetMusicIdByName("Catacombs"),
	-- MUSIC_NECROPOLIS = Isaac.GetMusicIdByName("Necropolis"),
	-- MUSIC_WOMB_UTERO = Isaac.GetMusicIdByName("Womb"),
	-- MUSIC_GAME_OVER = Isaac.GetMusicIdByName("Game Over"),
	-- MUSIC_BOSS = Isaac.GetMusicIdByName("Boss"),
	-- MUSIC_CATHEDRAL = Isaac.GetMusicIdByName("Cathedral"),
	-- MUSIC_SHEOL = Isaac.GetMusicIdByName("Sheol"),
	-- MUSIC_DARK_ROOM = Isaac.GetMusicIdByName("Dark Room"),
	-- MUSIC_CHEST = Isaac.GetMusicIdByName("Chest"),
	-- MUSIC_BURNING_BASEMENT = Isaac.GetMusicIdByName("Burning Basement"),
	-- MUSIC_FLOODED_CAVES = Isaac.GetMusicIdByName("Flooded Caves"),
	-- MUSIC_DANK_DEPTHS = Isaac.GetMusicIdByName("Dank Depths"),
	-- MUSIC_SCARRED_WOMB = Isaac.GetMusicIdByName("Scarred Womb"),
	-- MUSIC_BLUE_WOMB = Isaac.GetMusicIdByName("Blue Womb"),
	-- MUSIC_MOM_BOSS = Isaac.GetMusicIdByName("Boss (Depths - Mom)"),
	-- MUSIC_MOMS_HEART_BOSS = Isaac.GetMusicIdByName("Boss (Womb - Mom's Heart)"),
	-- MUSIC_ISAAC_BOSS = Isaac.GetMusicIdByName("Boss (Cathedral - Isaac)"),
	-- MUSIC_SATAN_BOSS = Isaac.GetMusicIdByName("Boss (Sheol - Satan)"),
	-- MUSIC_DARKROOM_BOSS = Isaac.GetMusicIdByName("Boss (Dark Room)"),
	-- MUSIC_BLUEBABY_BOSS = Isaac.GetMusicIdByName("Boss (Chest - ???)"),
	-- MUSIC_BOSS2 = Isaac.GetMusicIdByName("Boss (alternate)"),
	-- MUSIC_HUSH_BOSS = Isaac.GetMusicIdByName("Boss (Blue Womb - Hush)"),
	-- MUSIC_ULTRAGREED_BOSS = Isaac.GetMusicIdByName("Boss (Ultra Greed)"),
	-- MUSIC_LIBRARY_ROOM = Isaac.GetMusicIdByName("Library Room"),
	-- MUSIC_SECRET_ROOM = Isaac.GetMusicIdByName("Secret Room"),
	-- MUSIC_DEVIL_ROOM = Isaac.GetMusicIdByName("Devil Room"),
	-- MUSIC_ANGEL_ROOM = Isaac.GetMusicIdByName("Angel Room"),
	-- MUSIC_SHOP_ROOM = Isaac.GetMusicIdByName("Shop Room"),
	-- MUSIC_ARCADE_ROOM = Isaac.GetMusicIdByName("Arcade Room"),
	-- MUSIC_BOSS_OVER = Isaac.GetMusicIdByName("Boss Room (empty)"),
	-- MUSIC_CHALLENGE_FIGHT = Isaac.GetMusicIdByName("Challenge Room (fight)"),
	-- MUSIC_CREDITS = Isaac.GetMusicIdByName("Credits"),
	-- MUSIC_TITLE = Isaac.GetMusicIdByName("Title Screen"),
	-- MUSIC_TITLE_AFTERBIRTH = Isaac.GetMusicIdByName("Title Screen (Afterbirth)"),
	-- MUSIC_JINGLE_BOSS = Isaac.GetMusicIdByName("Boss (jingle)"),
	-- MUSIC_JINGLE_BOSS_OVER = Isaac.GetMusicIdByName("Boss Death (jingle)"),
	-- MUSIC_JINGLE_HOLYROOM_FIND = Isaac.GetMusicIdByName("Holy Room Find (jingle)"),
	-- MUSIC_JINGLE_SECRETROOM_FIND = Isaac.GetMusicIdByName("Secret Room Find (jingle)"),
	-- MUSIC_JINGLE_TREASUREROOM_ENTRY_0 = Isaac.GetMusicIdByName("Treasure Room Entry (jingle) 1"),
	-- MUSIC_JINGLE_TREASUREROOM_ENTRY_1 = Isaac.GetMusicIdByName("Treasure Room Entry (jingle) 2"),
	-- MUSIC_JINGLE_TREASUREROOM_ENTRY_2 = Isaac.GetMusicIdByName("Treasure Room Entry (jingle) 3"),
	-- MUSIC_JINGLE_TREASUREROOM_ENTRY_3 = Isaac.GetMusicIdByName("Treasure Room Entry (jingle) 4"),
	-- MUSIC_JINGLE_CHALLENGE_ENTRY = Isaac.GetMusicIdByName("Challenge Room Entry (jingle)"),
	-- MUSIC_JINGLE_CHALLENGE_OUTRO = Isaac.GetMusicIdByName("Challenge Room Outro (jingle)"),
	-- MUSIC_JINGLE_GAME_OVER = Isaac.GetMusicIdByName("Game Over (jingle)"),
	-- MUSIC_JINGLE_DEVILROOM_FIND = Isaac.GetMusicIdByName("Devil Room appear (jingle)"),
	-- MUSIC_JINGLE_GAME_START = Isaac.GetMusicIdByName("Game start (jingle)"),
	-- MUSIC_JINGLE_NIGHTMARE = Isaac.GetMusicIdByName("Nightmare"),
	-- MUSIC_JINGLE_BOSS_OVER2 = Isaac.GetMusicIdByName("Boss Death Alternate (jingle)"),
	-- MUSIC_JINGLE_HUSH_OVER = Isaac.GetMusicIdByName("Boss Hush Death (jingle)"),
	-- MUSIC_INTRO_VOICEOVER = Isaac.GetMusicIdByName("Intro Voiceover"),
	-- MUSIC_EPILOGUE_VOICEOVER = Isaac.GetMusicIdByName("Epilogue Voiceover"),
	-- MUSIC_VOID = Isaac.GetMusicIdByName("Void"),
	-- MUSIC_VOID_BOSS = Isaac.GetMusicIdByName("Boss (Void)"),
	
	-- MUSIC_UTERO = Isaac.GetMusicIdByName("Utero"),
	-- MUSIC_SECRET_ROOM2 = Isaac.GetMusicIdByName("Secret Room Alt"),
	-- MUSIC_BOSS_RUSH = Isaac.GetMusicIdByName("Boss Rush"),
	-- MUSIC_JINGLE_BOSS_RUSH_OUTRO = Isaac.GetMusicIdByName("Boss Rush (jingle)"),
	-- MUSIC_BOSS3 = Isaac.GetMusicIdByName("Boss (alternate alternate)"),
	-- MUSIC_JINGLE_BOSS_OVER3 = Isaac.GetMusicIdByName("Boss Death Alternate Alternate (jingle)"),
	-- MUSIC_MOTHER_BOSS = Isaac.GetMusicIdByName("Boss (Mother)"),
	-- MUSIC_DOGMA_BOSS = Isaac.GetMusicIdByName("Boss (Dogma)"),
	-- MUSIC_BEAST_BOSS = Isaac.GetMusicIdByName("Boss (Beast)"),
	-- MUSIC_JINGLE_MOTHER_OVER = Isaac.GetMusicIdByName("Boss Mother Death (jingle)"),
	-- MUSIC_JINGLE_DOGMA_OVER = Isaac.GetMusicIdByName("Boss Dogma Death (jingle)"),
	-- MUSIC_JINGLE_BEAST_OVER = Isaac.GetMusicIdByName("Boss Beast Death (jingle)"),
	-- MUSIC_PLANETARIUM = Isaac.GetMusicIdByName("Planetarium"),
	-- MUSIC_SECRET_ROOM_ALT_ALT = Isaac.GetMusicIdByName("Secret Room Alt Alt"),
	-- MUSIC_BOSS_OVER_TWISTED = Isaac.GetMusicIdByName("Boss Room (empty, twisted)"),
	-- MUSIC_TITLE_REPENTANCE = Isaac.GetMusicIdByName("Title Screen (Repentance)"),
	-- MUSIC_JINGLE_GAME_START_ALT = Isaac.GetMusicIdByName("Game start (jingle, twisted)"),
	-- MUSIC_JINGLE_NIGHTMARE_ALT = Isaac.GetMusicIdByName("Nightmare (alt)"),
	-- MUSIC_MOTHERS_SHADOW_INTRO = Isaac.GetMusicIdByName("Mom's Shadow Intro"),
	-- MUSIC_DOGMA_INTRO = Isaac.GetMusicIdByName("Dogma Intro"),
	-- MUSIC_STRANGE_DOOR_JINGLE = Isaac.GetMusicIdByName("Strange Door (jingle)"),
	-- MUSIC_DARK_CLOSET = Isaac.GetMusicIdByName("Echoes Reverse"),
	-- MUSIC_CREDITS_ALT = Isaac.GetMusicIdByName("Credits Alt"),
	-- MUSIC_CREDITS_ALT_FINAL = Isaac.GetMusicIdByName("Credits Alt Final"),
	-- MUSIC_DOWNPOUR = Isaac.GetMusicIdByName("Downpour"),
	-- MUSIC_MINES = Isaac.GetMusicIdByName("Mines"),
	-- MUSIC_MAUSOLEUM = Isaac.GetMusicIdByName("Mausoleum"),
	-- MUSIC_CORPSE = Isaac.GetMusicIdByName("Corpse"),
	-- MUSIC_DROSS = Isaac.GetMusicIdByName("Dross"),
	-- MUSIC_ASHPIT = Isaac.GetMusicIdByName("Ashpit"),
	-- MUSIC_GEHENNA = Isaac.GetMusicIdByName("Gehenna"),
	-- MUSIC_MORTIS = (function() -- what the fuck
		-- local Mortis = Isaac.GetMusicIdByName("Mortis")
		-- return Mortis >= 0 and Mortis or Isaac.GetMusicIdByName("not done")
	-- end)(),
	-- MUSIC_ISAACS_HOUSE = Isaac.GetMusicIdByName("Home"),
	-- MUSIC_FINAL_VOICEOVER = Isaac.GetMusicIdByName("Final Voiceover"),
	-- MUSIC_DOWNPOUR_REVERSE = Isaac.GetMusicIdByName("Downpour (reversed)"),
	-- MUSIC_DROSS_REVERSE = Isaac.GetMusicIdByName("Dross (reversed)"),
	-- MUSIC_MINESHAFT_AMBIENT = Isaac.GetMusicIdByName("Abandoned Mineshaft"),
	-- MUSIC_MINESHAFT_ESCAPE = Isaac.GetMusicIdByName("Mineshaft Escape"),
	-- MUSIC_REVERSE_GENESIS = Isaac.GetMusicIdByName("Genesis (reversed)"),
}