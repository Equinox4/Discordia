local Date = require('utils/Date')

local Container = require('containers/abstract/Container')

local date = os.date
local modf, floor = math.modf, math.floor
local format = string.format

local Snowflake = require('class')('Snowflake', Container)
local get = Snowflake.__getters

function Snowflake:__init(data, parent)
	Container.__init(self, data, parent)
end

function Snowflake:__hash()
	return self._id
end

function get.id(self)
	return self._id
end

function get.createdAt(self)
	return Date.parseSnowflake(self._id)
end

function get.timestamp(self) -- TODO: move to utils or Date or Time class?
	local t, f = modf(self.createdAt)
	local ms = floor(1000 * f + 0.5) / 1000
	if ms == 0 then
		return date('!%FT%T', t) .. '+00:00'
	else
		return date('!%FT%T', t) .. format('%.6f', ms):sub(2) .. '+00:00'
	end
end

return Snowflake