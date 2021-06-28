local data = {}

local floors = {}
data.Floors = floors

floors[LevelStage.STAGE1_1] = {
	[StageType.STAGETYPE_ORIGINAL] = "STAGE_BASEMENT",
	[StageType.STAGETYPE_WOTL] = "STAGE_CELLAR",
	[StageType.STAGETYPE_AFTERBIRTH] = "STAGE_BURNING_BASEMENT",
	[StageType.STAGETYPE_REPENTANCE] = "STAGE_DOWNPOUR",
	[StageType.STAGETYPE_REPENTANCE_B] = "STAGE_DROSS",
}

local floors_default = floors[LevelStage.STAGE1_1]

floors[LevelStage.STAGE1_2] = floors[LevelStage.STAGE1_1]

floors[LevelStage.STAGE2_1] = {
	[StageType.STAGETYPE_ORIGINAL] = "STAGE_CAVES",
	[StageType.STAGETYPE_WOTL] = "STAGE_CATACOMBS",
	[StageType.STAGETYPE_AFTERBIRTH] = "STAGE_FLOODED_CAVES",
	[StageType.STAGETYPE_REPENTANCE] = "STAGE_MINES",
	[StageType.STAGETYPE_REPENTANCE_B] = "STAGE_ASHPIT",
}

floors[LevelStage.STAGE2_2] = floors[LevelStage.STAGE2_1]

floors[LevelStage.STAGE3_1] = {
	[StageType.STAGETYPE_ORIGINAL] = "STAGE_DEPTHS",
	[StageType.STAGETYPE_WOTL] = "STAGE_NECROPOLIS",
	[StageType.STAGETYPE_AFTERBIRTH] = "STAGE_DANK_DEPTHS",
	[StageType.STAGETYPE_REPENTANCE] = "STAGE_MAUSOLEUM",
	[StageType.STAGETYPE_REPENTANCE_B] = "STAGE_GEHENNA",
}	

floors[LevelStage.STAGE3_2] = floors[LevelStage.STAGE3_1]

floors[LevelStage.STAGE4_1] = {
	[StageType.STAGETYPE_ORIGINAL] = "STAGE_WOMB",
	[StageType.STAGETYPE_WOTL] = "STAGE_UTERO",
	[StageType.STAGETYPE_AFTERBIRTH] = "STAGE_SCARRED_WOMB",
	[StageType.STAGETYPE_REPENTANCE] = "STAGE_CORPSE",
	[StageType.STAGETYPE_REPENTANCE_B] = "STAGE_MORTIS",
}

floors[LevelStage.STAGE4_2] = floors[LevelStage.STAGE4_1]

floors[LevelStage.STAGE4_3] = {
	[StageType.STAGETYPE_ORIGINAL] = "STAGE_BLUE_WOMB",
}

floors[LevelStage.STAGE5] = {
	[StageType.STAGETYPE_ORIGINAL] = "STAGE_SHEOL",
	[StageType.STAGETYPE_WOTL] = "STAGE_CATHEDRAL",
	[StageType.STAGETYPE_AFTERBIRTH] = "STAGE_DARK_ROOM",
}

floors[LevelStage.STAGE6] = {
	[StageType.STAGETYPE_ORIGINAL] = "STAGE_DARK_ROOM",
	[StageType.STAGETYPE_WOTL] = "STAGE_CHEST",
}

floors[LevelStage.STAGE7] = {
	[StageType.STAGETYPE_ORIGINAL] = "STAGE_VOID",
}

floors[LevelStage.STAGE8] = {
	[StageType.STAGETYPE_ORIGINAL] = "STAGE_HOME",
	[StageType.STAGETYPE_WOTL] = "STAGE_HOME",
}

local floors_greed = {}
data.FloorsGreed = floors_greed

floors_greed[LevelStage.STAGE1_GREED] = floors[LevelStage.STAGE1_1]
floors_greed[LevelStage.STAGE2_GREED] = floors[LevelStage.STAGE2_1]
floors_greed[LevelStage.STAGE3_GREED] = floors[LevelStage.STAGE3_1]
floors_greed[LevelStage.STAGE4_GREED] = floors[LevelStage.STAGE4_1]
floors_greed[LevelStage.STAGE5_GREED] = floors[LevelStage.STAGE5]

floors_greed[LevelStage.STAGE6_GREED] = {
	[StageType.STAGETYPE_ORIGINAL] = "STAGE_SHOP",
}

floors_greed[LevelStage.STAGE7_GREED] = floors_greed[LevelStage.STAGE6_GREED]

local bosses = {}
data.Bosses = bosses

bosses[6] = "BOSS_MOM"
-- bosses[8] = "BOSS_MOMS_HEART_WOMB"
bosses[25] = "BOSS_IT_LIVES"
bosses[24] = "BOSS_SATAN"
bosses[39] = "BOSS_ISAAC"
bosses[40] = "BOSS_BLUE_BABY_CHEST"
bosses[54] = "BOSS_LAMB"
bosses[55] = "BOSS_SATAN_INACTIVE"
bosses[62] = "BOSS_ULTRA_GREED"
bosses[63] = "BOSS_BLUE_BABY_BLUE_WOMB"
bosses[70] = "BOSS_DELIRIUM"
bosses[88] = "BOSS_MOTHER"

local rooms = {}
data.Rooms = rooms

-- rooms[RoomType.ROOM_NULL] = "ROOM_NULL"
-- rooms[RoomType.ROOM_DEFAULT] = "ROOM_DEFAULT"
rooms[RoomType.ROOM_SHOP] = "ROOM_SHOP"
rooms[RoomType.ROOM_ERROR] = "ROOM_ERROR"
-- rooms[RoomType.ROOM_TREASURE] = "ROOM_TREASURE"
-- rooms[RoomType.ROOM_BOSS] = "ROOM_BOSS"
-- rooms[RoomType.ROOM_MINIBOSS] = "ROOM_MINIBOSS"
rooms[RoomType.ROOM_SECRET] = "ROOM_SECRET"
rooms[RoomType.ROOM_SUPERSECRET] = "ROOM_SUPERSECRET"
rooms[RoomType.ROOM_ARCADE] = "ROOM_ARCADE"
rooms[RoomType.ROOM_CURSE] = "ROOM_CURSE"
-- rooms[RoomType.ROOM_CHALLENGE] = "ROOM_CHALLENGE"
rooms[RoomType.ROOM_LIBRARY] = "ROOM_LIBRARY"
rooms[RoomType.ROOM_SACRIFICE] = "ROOM_SACRIFICE"
rooms[RoomType.ROOM_DEVIL] = "ROOM_DEVIL"
rooms[RoomType.ROOM_ANGEL] = "ROOM_ANGEL"
rooms[RoomType.ROOM_DUNGEON] = "ROOM_DUNGEON"
rooms[RoomType.ROOM_BOSSRUSH] = "ROOM_BOSSRUSH"
rooms[RoomType.ROOM_ISAACS] = "ROOM_ISAACS"
rooms[RoomType.ROOM_BARREN] = "ROOM_BARREN"
rooms[RoomType.ROOM_CHEST] = "ROOM_CHEST"
rooms[RoomType.ROOM_DICE] = "ROOM_DICE"
rooms[RoomType.ROOM_BLACK_MARKET] = "ROOM_BLACK_MARKET"
rooms[RoomType.ROOM_GREED_EXIT] = "ROOM_GREED_EXIT"
rooms[RoomType.ROOM_PLANETARIUM] = "ROOM_PLANETARIUM"
rooms[RoomType.ROOM_TELEPORTER] = "ROOM_TELEPORTER"
rooms[RoomType.ROOM_TELEPORTER_EXIT] = "ROOM_TELEPORTER_EXIT"
rooms[RoomType.ROOM_ULTRASECRET] = "ROOM_ULTRASECRET"

return data