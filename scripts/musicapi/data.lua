local data = {}

local floors = {}
data.Floors = floors

floors[LevelStage.STAGE1_1] = {
	[StageType.STAGETYPE_ORIGINAL] = Music.MUSIC_BASEMENT,
	[StageType.STAGETYPE_WOTL] = Music.MUSIC_CELLAR,
	[StageType.STAGETYPE_AFTERBIRTH] = Music.MUSIC_BURNING_BASEMENT,
	[StageType.STAGETYPE_REPENTANCE] = Music.MUSIC_DOWNPOUR,
	[StageType.STAGETYPE_REPENTANCE_B] = Music.MUSIC_DROSS,
}

local floors_default = floors[LevelStage.STAGE1_1]

floors[LevelStage.STAGE1_2] = floors[LevelStage.STAGE1_1]

floors[LevelStage.STAGE2_1] = {
	[StageType.STAGETYPE_ORIGINAL] = Music.MUSIC_CAVES,
	[StageType.STAGETYPE_WOTL] = Music.MUSIC_CATACOMBS,
	[StageType.STAGETYPE_AFTERBIRTH] = Music.MUSIC_FLOODED_CAVES,
	[StageType.STAGETYPE_REPENTANCE] = Music.MUSIC_MINES,
	[StageType.STAGETYPE_REPENTANCE_B] = Music.MUSIC_ASHPIT,
}

floors[LevelStage.STAGE2_2] = floors[LevelStage.STAGE2_1]

floors[LevelStage.STAGE3_1] = {
	[StageType.STAGETYPE_ORIGINAL] = Music.MUSIC_DEPTHS,
	[StageType.STAGETYPE_WOTL] = Music.MUSIC_NECROPOLIS,
	[StageType.STAGETYPE_AFTERBIRTH] = Music.MUSIC_DANK_DEPTHS,
	[StageType.STAGETYPE_REPENTANCE] = Music.MUSIC_MAUSOLEUM,
	[StageType.STAGETYPE_REPENTANCE_B] = Music.MUSIC_GEHENNA,
}	

floors[LevelStage.STAGE3_2] = floors[LevelStage.STAGE3_1]

floors[LevelStage.STAGE4_1] = {
	[StageType.STAGETYPE_ORIGINAL] = Music.MUSIC_WOMB_UTERO,
	[StageType.STAGETYPE_WOTL] = Music.MUSIC_UTERO,
	[StageType.STAGETYPE_AFTERBIRTH] = Music.MUSIC_SCARRED_WOMB,
	[StageType.STAGETYPE_REPENTANCE] = Music.MUSIC_CORPSE,
	[StageType.STAGETYPE_REPENTANCE_B] = Music.MUSIC_MORTIS,
}

floors[LevelStage.STAGE4_2] = floors[LevelStage.STAGE4_1]

floors[LevelStage.STAGE4_3] = {
	[StageType.STAGETYPE_ORIGINAL] = Music.MUSIC_BLUE_WOMB,
}

floors[LevelStage.STAGE5] = {
	[StageType.STAGETYPE_ORIGINAL] = Music.MUSIC_SHEOL,
	[StageType.STAGETYPE_WOTL] = Music.MUSIC_CATHEDRAL,
	[StageType.STAGETYPE_AFTERBIRTH] = Music.MUSIC_DARK_ROOM,
}

floors[LevelStage.STAGE6] = {
	[StageType.STAGETYPE_ORIGINAL] = Music.MUSIC_DARK_ROOM,
	[StageType.STAGETYPE_WOTL] = Music.MUSIC_CHEST,
}

floors[LevelStage.STAGE7] = {
	[StageType.STAGETYPE_ORIGINAL] = Music.MUSIC_VOID,
}

floors[LevelStage.STAGE8] = {
	[StageType.STAGETYPE_ORIGINAL] = Music.MUSIC_ISAACS_HOUSE,
	[StageType.STAGETYPE_WOTL] = Music.MUSIC_ISAACS_HOUSE,
}

local floors_greed = {}
data.FloorsGreed = floors_greed

floors_greed[LevelStage.STAGE1_GREED] = floors[LevelStage.STAGE1_1]
floors_greed[LevelStage.STAGE2_GREED] = floors[LevelStage.STAGE2_1]
floors_greed[LevelStage.STAGE3_GREED] = floors[LevelStage.STAGE3_1]
floors_greed[LevelStage.STAGE4_GREED] = floors[LevelStage.STAGE4_1]
floors_greed[LevelStage.STAGE5_GREED] = floors[LevelStage.STAGE5]

floors_greed[LevelStage.STAGE6_GREED] = {
	[StageType.STAGETYPE_ORIGINAL] = Music.MUSIC_SHOP_ROOM,
}

floors_greed[LevelStage.STAGE7_GREED] = floors_greed[LevelStage.STAGE6_GREED]

local bosses = {}
data.Bosses = bosses

bosses[6] = Music.MUSIC_MOM_BOSS
bosses[8] = Music.MUSIC_MOMS_HEART_BOSS
bosses[25] = Music.MUSIC_MOMS_HEART_BOSS
bosses[24] = Music.MUSIC_DEVIL_ROOM
bosses[39] = Music.MUSIC_ISAAC_BOSS
bosses[40] = Music.MUSIC_BLUEBABY_BOSS
bosses[54] = Music.MUSIC_DARKROOM_BOSS
bosses[55] = Music.MUSIC_DEVIL_ROOM
bosses[62] = Music.MUSIC_ULTRAGREED_BOSS
bosses[63] = Music.MUSIC_BLUEBABY_BOSS
bosses[70] = Music.MUSIC_VOID_BOSS
bosses[88] = Music.MUSIC_MOTHER_BOSS

return data