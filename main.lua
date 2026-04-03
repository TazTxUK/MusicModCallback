--fix dev stupidity
if REPENTANCE_PLUS and not REPENTANCE then
    REPENTANCE = true
end
if REPENTANCE then
	require("scripts.mmc.repentance")
end
