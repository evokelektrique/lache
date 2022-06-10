--- Lache main module

--- `lache` Main table
lache = {}

--- Inheritance
lache.__index = lache

--- Initialize new instance
--
-- @string directory Directory Path 
-- @return New instance with meta methods
lache.new = function(directory)
	return setmetatable({directory = directory}, lache)
end

-- Lache main metatable, And also make it callable without `.new` method
return setmetatable(lache, {
	__call = function(self, ...)
		return lache.new(...)
	end
})