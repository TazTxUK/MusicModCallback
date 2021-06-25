local Flagset = {}
local class_index = {}
local class_meta = {__index = class_index}
setmetatable(Flagset, class_meta)
local object_index = {}
local object_meta = {__index = object_index}

local size = 64 --const

object_index.Init = function(self)
	for i=1,size do
		self[i] = 0
	end
end

object_index.And = function(self, rhs)
	local new = Flagset()
	
	for i=1,size do
		new[i] = self[i] & rhs[i]
	end
	
	return new
end

object_index.Or = function(self, rhs)
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
	self[pos1 + 1] = self[pos1 + 1] | (1 << pos2)
end

object_index.Equals = function(self, rhs)
	for i=1,size do
		if self[i] ~= rhs[i] then
			return false
		end
	end
	return true
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
	assert(self, "???")
	return self:Equals(rhs)
end

do
	local f = ("%x"):rep(size)
	object_meta.__tostring = function(self)
		return string.format(f, table.unpack(self))
	end
end

class_index.Bit = function(i)
	local new = Flagset()
	new:SetBit(i)
	return new
end

class_meta.__class = object_meta

class_meta.__call = function(...)
	local obj = {}
	setmetatable(obj, object_meta)
	obj:Init(...)
	return obj
end

return Flagset