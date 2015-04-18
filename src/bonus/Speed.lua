local class = require 'middleclass'

local IBonus = require 'bonus.IBonus'
local Speed = class('Speed', IBonus)

function Speed:initialize(x, y)
	self.area = EasyLD.area:new(EasyLD.circle:new(0, 0, 30, EasyLD.color:new(200, 0, 0)))
	self.area:moveTo(x, y)
	self.isGet = false
end

function Speed:update(dt)

end

function Speed:get(level)
	if not self.isGet then
		level.slow = level.slow / 2
		self.isGet = true
		self.area.display = false
	end
end

return Speed