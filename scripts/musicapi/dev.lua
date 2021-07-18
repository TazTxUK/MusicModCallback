local api = require "scripts.musicapi.api"

local dev = {}

function dev.GenerateTrackMarkdownTable()
	local final = ""
	local categories = {}
	local done_cat = {}
	
	for a,b in pairs(MusicAPI.Tracks) do
		local s = a:sub(1,(a:find("_") or 0) - 1)
		if not done_cat[s] then
			done_cat[s] = true
			categories[#categories + 1] = s
		end
	end
	
	for _, cat in ipairs(categories) do
		final = final .. "## " .. cat
	
		local t = {}
		setmetatable(t, {__index = function(t, key) return rawget(t, key) or "| " end})
		local target_length = 0
		
		local i = 1
		t[i] = t[i] .. "**Name**"
		target_length = math.max(target_length, t[i]:len())
		i = i + 1
		-- t[i] = t[i] .. ""
		target_length = math.max(target_length, t[i]:len())
		i = i + 1
		for a,b in pairs(MusicAPI.Tracks) do
			if a:sub(1,cat:len()) == cat then
				t[i] = t[i] .. "`"..a.."`"
				target_length = math.max(target_length, t[i]:len())
				i = i + 1
			end
		end
		
		t[1] = t[1] .. (" "):rep(target_length - t[1]:len()) .. " | "
		t[2] = t[2]:sub(1,-2) .. ("-"):rep(target_length - t[2]:len() + 2) .. "| "
		for j=3,#t do
			t[j] = t[j] .. (" "):rep(target_length - t[j]:len()) .. " | "
		end
		
		i = 1
		t[i] = t[i] .. "**#IDs**"
		target_length = math.max(target_length, t[i]:len())
		i = i + 1
		-- t[i] = t[i] .. ""
		target_length = math.max(target_length, t[i]:len())
		i = i + 1
		for a,b in pairs(MusicAPI.Tracks) do
			if a:sub(1,cat:len()) == cat then
				local count
				if type(b.Default.Music) == "table" then
					count = #b.Default.Music
				elseif not b.Default.Music then
					count = 0
				else
					count = 1
				end
				t[i] = t[i] .. tostring(count)
				target_length = math.max(target_length, t[i]:len())
				i = i + 1
			end
		end
		
		t[1] = t[1] .. (" "):rep(target_length - t[1]:len()) .. " | "
		t[2] = t[2]:sub(1,-2) .. ("-"):rep(target_length - t[2]:len() + 2) .. "| "
		for j=3,#t do
			t[j] = t[j] .. (" "):rep(target_length - t[j]:len()) .. " | "
		end
		
		i = 1
		t[i] = t[i] .. "**Tags**"
		target_length = math.max(target_length, t[i]:len())
		i = i + 1
		-- t[i] = t[i] .. ""
		target_length = math.max(target_length, t[i]:len())
		i = i + 1
		for a,b in pairs(MusicAPI.Tracks) do
			if a:sub(1,cat:len()) == cat then
				local tags = {}
				
				for tag,_ in pairs(b.Tags) do
					tags[#tags + 1] = "`"..tag.."`"
				end
				
				t[i] = t[i] .. table.concat(tags, ", ")
				target_length = math.max(target_length, t[i]:len())
				i = i + 1
			end
		end
		
		t[1] = t[1] .. (" "):rep(target_length - t[1]:len()) .. " | "
		t[2] = t[2]:sub(1,-2) .. ("-"):rep(target_length - t[2]:len() + 2) .. "| "
		for j=3,#t do
			t[j] = t[j] .. (" "):rep(target_length - t[j]:len()) .. " | "
		end
		
		final = final .. "\n" .. table.concat(t, "\n") .. "\n\n"
	end
	MusicAPI.Save.Game.TrackMarkdownTable = final
	return final
end

function dev.GenerateTagMarkdownTable()
	local final = ""
	
	local tags = {}
	for a,b in pairs(MusicAPI.TagBit) do
		tags[#tags + 1] = a
	end
	table.sort(tags, function(a,b) return a < b end)
	
	do
		local t = {}
		setmetatable(t, {__index = function(t, key) return rawget(t, key) or "| " end})
		local target_length = 0
		
		local i = 1
		t[i] = t[i] .. "**Name**"
		target_length = math.max(target_length, t[i]:len())
		i = i + 1
		-- t[i] = t[i] .. ""
		target_length = math.max(target_length, t[i]:len())
		i = i + 1
		for _,a in pairs(tags) do
			t[i] = t[i] .. "`"..a.."`"
			target_length = math.max(target_length, t[i]:len())
			i = i + 1
		end
		
		t[1] = t[1] .. (" "):rep(target_length - t[1]:len()) .. " | "
		t[2] = t[2]:sub(1,-2) .. ("-"):rep(target_length - t[2]:len() + 2) .. "| "
		for j=3,#t do
			t[j] = t[j] .. (" "):rep(target_length - t[j]:len()) .. " | "
		end
			
		final = final .. "\n" .. table.concat(t, "\n") .. "\n\n"
	end
	
	MusicAPI.Save.Game.FlagMarkdownTable = final
	return final
end

return dev