local class = require 'middleclass'

local IBonus = require 'bonus.IBonus'
local Slow = class('Slow', IBonus)

function Slow:initialize(x, y)
	self.area = EasyLD.area:new(EasyLD.circle:new(0, 0, 30, EasyLD.color:new(0, 0, 200)))
	self.area:moveTo(x, y)
	self.isGet = false
end

function Slow:update(dt)

end

function Slow:get(level)
	if not self.isGet then
		level.slow = level.slow * 2
		self.isGet = true
		self.area.display = false
	end
end

return Slow