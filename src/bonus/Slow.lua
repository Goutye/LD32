local class = require 'middleclass'

local IBonus = require 'bonus.IBonus'
local Slow = class('Slow', IBonus)

function Slow:initialize(x, y)
	local c = EasyLD.circle:new(0, 0, 30, EasyLD.color:new(0, 0, 200))
	c:attachImg(EasyLD.image:new("assets/tilesets/bonusSlow.png"), "center")
	self.area = EasyLD.area:new(c)
	self.area:moveTo(x, y)
	self.isGet = false
end

function Slow:update(dt)

end

function Slow:get(level)
	if not self.isGet then
		level.slow = level.slow * 2
		level.text = "SLOW"
		self.isGet = true
		self.area.display = false
	end
end

return Slow