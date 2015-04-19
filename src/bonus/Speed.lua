local class = require 'middleclass'

local IBonus = require 'bonus.IBonus'
local Speed = class('Speed', IBonus)

function Speed:initialize(x, y)
	local c = EasyLD.circle:new(0, 0, 30, EasyLD.color:new(0, 0, 200))
	c:attachImg(EasyLD.image:new("assets/tilesets/bonusSpeed.png"), "center")
	self.area = EasyLD.area:new(c)
	self.area:moveTo(x, y)
	self.isGet = false
end

function Speed:update(dt)

end

function Speed:get(level)
	if not self.isGet then
		level.text = "SPEED"
		engine.sfx.speed:play()
		level.slow = level.slow / 2
		self.isGet = true
		self.area.display = false
	end
end

return Speed