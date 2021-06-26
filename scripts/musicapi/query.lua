local util = require "scripts.musicapi.util"

local Query = {}
local class_index = {}
local class_meta = {__index = class_index}
setmetatable(Query, class_meta)
local object_index = {}
local object_meta = {__index = object_index, __type = "MusicAPI.Query"}

local size = 64 --const

local AssertArg1 = util.assertTypeFn({"MusicAPI.Query"}, 1)
local AssertArg2 = util.assertTypeFn({"MusicAPI.Query", "MusicAPI.Flagset"}, 2)

object_index.Init = function(self, num)
	self.c1 = num or 1
	--c1: comparate 1: stores an arg number or Query
	--c2: comparate 2: nil if no operator, otherwise same as c1
	--operator: "And", "Or", nil. 
end

local disallowed_encapsulations = {
	["Lesser"] = true,
	["LesserEqual"] = true,
	["Compare"] = true,
}

object_index.And = function(self, rhs)
	AssertArg1(self); AssertArg2(rhs)
	util.assert(not disallowed_encapsulations[self.operator], "Not allowed to encapsulate MusicAPI.Query with non-queryable result", 2)
	util.assert(not disallowed_encapsulations[rhs.operator], "Not allowed to encapsulate MusicAPI.Query with non-queryable result", 2)
	
	local new = Query()
	if self.operator then
		new.operator = "And"
		new.c1 = self
		new.c2 = rhs
	else
		new.operator = "And"
		new.c1 = self.c1
		new.c2 = rhs
		-- if util.type(rhs) == "MusicAPI.Query" then
			-- if not rhs.operator then
				-- new.c2 = rhs.c1
			-- else
				-- if self.operator == rhs.operator then
					-- if rhs.c1 == self.c1 then
						-- new.c2 = rhs.c2
					-- elseif rhs.c2 == self.c1 then
						-- new.c2 = rhs.c1
					-- end
				-- end
			-- end
		-- end
	end
	return new
end

object_index.Lesser = function(self, rhs)
	AssertArg1(self); AssertArg2(rhs)
	util.assert(not disallowed_encapsulations[self.operator], "Not allowed to encapsulate MusicAPI.Query with non-queryable result", 2)
	util.assert(not disallowed_encapsulations[rhs.operator], "Not allowed to encapsulate MusicAPI.Query with non-queryable result", 2)
	
	local new = Query()
	if self.operator then
		new.operator = "Lesser"
		new.c1 = self
		new.c2 = rhs
	else
		new.operator = "Lesser"
		new.c1 = self.c1
		new.c2 = rhs
		-- if util.type(rhs) == "MusicAPI.Query" then
			-- if not rhs.operator then
				-- new.c2 = rhs.c1
			-- else
				-- if self.operator == rhs.operator then
					-- if rhs.c1 == self.c1 then
						-- new.c2 = rhs.c2
					-- elseif rhs.c2 == self.c1 then
						-- new.c2 = rhs.c1
					-- end
				-- end
			-- end
		-- end
	end
	return new
end

object_index.LesserEqual = function(self, rhs)
	AssertArg1(self); AssertArg2(rhs)
	util.assert(not disallowed_encapsulations[self.operator], "Not allowed to encapsulate MusicAPI.Query with non-queryable result", 2)
	util.assert(not disallowed_encapsulations[rhs.operator], "Not allowed to encapsulate MusicAPI.Query with non-queryable result", 2)
	
	local new = Query()
	if self.operator then
		new.operator = "LesserEqual"
		new.c1 = self
		new.c2 = rhs
	else
		new.operator = "LesserEqual"
		new.c1 = self.c1
		new.c2 = rhs
		-- if util.type(rhs) == "MusicAPI.Query" then
			-- if not rhs.operator then
				-- new.c2 = rhs.c1
			-- else
				-- if self.operator == rhs.operator then
					-- if rhs.c1 == self.c1 then
						-- new.c2 = rhs.c2
					-- elseif rhs.c2 == self.c1 then
						-- new.c2 = rhs.c1
					-- end
				-- end
			-- end
		-- end
	end
	return new
end

-- object_index.Or = function(self, rhs)
	-- local new = Query()
	
	-- for i=1,size do
		-- new[i] = self[i] | rhs[i]
	-- end
	
	-- return new
-- end

-- object_index.Not = function(self)
	-- local new = Query()
	
	-- for i=1,size do
		-- new[i] = ~self[i]
	-- end
	
	-- return new
-- end

object_index.Compare = function(self, rhs)
	AssertArg1(self); AssertArg2(rhs)
	util.assert(not disallowed_encapsulations[self.operator], "Not allowed to encapsulate MusicAPI.Query with non-queryable result", 2)
	util.assert(not disallowed_encapsulations[rhs.operator], "Not allowed to encapsulate MusicAPI.Query with non-queryable result", 2)
	
	local new = Query()
	if self.operator then
		new.operator = "Compare"
		new.c1 = self
		new.c2 = rhs
	else
		new.operator = "Compare"
		new.c1 = self.c1
		new.c2 = rhs
		-- if util.type(rhs) == "MusicAPI.Query" then
			-- if not rhs.operator then
				-- new.c2 = rhs.c1
			-- else
				-- if self.operator == rhs.operator then
					-- if rhs.c1 == self.c1 then
						-- new.c2 = rhs.c2
					-- elseif rhs.c2 == self.c1 then
						-- new.c2 = rhs.c1
					-- end
				-- end
			-- end
		-- end
	end
	return new
end

object_index.Resolve = function(self, ...)
	local result = self:Evaluate(...)
	if util.type(result) == "MusicAPI.Flagset" then
		return result:Resolve()
	else
		return result
	end
end

object_index.Evaluate = function(self, a, b, c, d)
	local args = {a, b, c, d}
	
	local function eval_arg(n)
		if type(n) == "number" then
			return args[n]
		elseif util.type(n) == "MusicAPI.Query" then
			return n:Evaluate(a, b, c, d)
		else
			return n
		end
	end
	
	if self.operator then
		local c1 = eval_arg(self.c1)
		local c2 = eval_arg(self.c2)
		return c1[self.operator](c1, c2)
	else
		return eval_arg(self.c1)
	end
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

object_meta.__call = function(self, ...)
	return self:Resolve(...)
end

class_index.Bit = function(i)
	local new = Query()
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

return Query