local util = require "scripts.musicapi.util"

local Flagset = {}
local class_index = {}
local class_meta = {__index = class_index}
setmetatable(Flagset, class_meta)
local object_index = {}
local object_meta = {__index = object_index, __type = "MusicAPI.Flagset"}

local size = 16 --const

object_index.Init = function(self)
	for i=1,size do
		self[i] = 0
	end
end

object_index.And = function(self, rhs)
	if util.type(rhs) == "MusicAPI.Query" then
		return rhs:And(self)
	end

	local new = Flagset()
	
	for i=1,size do
		new[i] = self[i] & rhs[i]
	end
	
	return new
end

object_index.Or = function(self, rhs)
	if util.type(rhs) == "MusicAPI.Query" then
		return rhs:Or(self)
	end

	local new = Flagset()
	
	for i=1,size do
		new[i] = self[i] | rhs[i]
	end
	
	return new
end

object_index.Not = function(self)
	local new = Flagset()
	
	for i=1,size do
		new[i] = ~self[i]
	end
	
	return new
end

object_index.SetBit = function(self, n, bool)
	local pos1 = math.floor(n / 64)
	local pos2 = n - pos1 * 64
	if bool then
		self[pos1 + 1] = self[pos1 + 1] | (1 << pos2)
	else
		self[pos1 + 1] = self[pos1 + 1] & ~(1 << pos2)
	end
end

object_index.Equals = function(self, rhs)
	for i=1,size do
		if self[i] ~= rhs[i] then
			return false
		end
	end
	return true
end

object_index.Greater = function(self, rhs)
	for i=1,size do
		local n_l = self[i]
		local n_r = rhs[i]
		
		if n_l ~= n_r then
			local highbit_l = n_l >> 63
			local highbit_r = n_r >> 63
			
			if highbit_l ~= highbit_r then return highbit_l > highbit_r end
			
			local lowbits_l = n_l & 0x7FFFFFFFFFFFFFFF
			local lowbits_r = n_r & 0x7FFFFFFFFFFFFFFF
			
			if lowbits_l ~= lowbits_r then return lowbits_l > lowbits_r end
		end
	end
	return false
end

object_index.Lesser = function(self, rhs)
	for i=1,size do
		local n_l = self[i]
		local n_r = rhs[i]
		
		if n_l ~= n_r then
			local highbit_l = n_l >> 63
			local highbit_r = n_r >> 63
			
			if highbit_l ~= highbit_r then return highbit_l < highbit_r end
			
			local lowbits_l = n_l & 0x7FFFFFFFFFFFFFFF
			local lowbits_r = n_r & 0x7FFFFFFFFFFFFFFF
			
			if lowbits_l ~= lowbits_r then return lowbits_l < lowbits_r end
		end
	end
	return false
end

object_index.LesserEqual = function(self, rhs)
	return not self:Greater(rhs)
end

object_index.Compare = function(self, rhs)
	for i=1,size do
		local n_l = self[i]
		local n_r = rhs[i]
		
		if n_l ~= n_r then
			local highbit_l = n_l >> 63
			local highbit_r = n_r >> 63
			
			if highbit_l ~= highbit_r then return highbit_l < highbit_r and -1 or 1 end
			
			local lowbits_l = n_l & 0x7FFFFFFFFFFFFFFF
			local lowbits_r = n_r & 0x7FFFFFFFFFFFFFFF
			
			if lowbits_l ~= lowbits_r then return lowbits_l < lowbits_r and -1 or 1 end
		end
	end
	return 0
end

object_index.Resolve = function(self)
	for i=1,size do
		if self[i] ~= 0 then
			return true
		end
	end
	return false
end

object_meta.__band = function(self, rhs)
	return self:And(rhs)
end

object_meta.__bor = function(self, rhs)
	return self:Or(rhs)
end

object_meta.__bnot = function(self)
	return self:Not()
end

object_meta.__eq = function(self, rhs)
	return self:Equals(rhs)
end

object_meta.__lt = function(self, rhs)
	return self:Lesser(rhs)
end

object_meta.__le = function(self, rhs)
	return self:LesserEqual(rhs)
end

-- do TODO: fix
	-- local f = ("%x"):rep(size)
	-- object_meta.__tostring = function(self)
		-- return string.format(f, table.unpack(self))
	-- end
-- end

class_index.Bit = function(i)
	local new = Flagset()
	new:SetBit(i)
	return new
end

class_meta.__classmt = object_meta

class_meta.__call = function(self, ...)
	local obj = {}
	setmetatable(obj, object_meta)
	obj:Init(...)
	return obj
end

return Flagset