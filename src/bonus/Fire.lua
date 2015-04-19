local class = require 'middleclass'

local IBonus = require 'bonus.IBonus'
local Fire = class('Fire', IBonus)

function Fire:initialize(x, y)
	self.area = EasyLD.area:new(EasyLD.box:new(0, 0, 80, 30, EasyLD.color:new(150,155,0)))
	self.area:moveTo(x, y)
	self.isGet = false
end

function Fire:update(dt)

end

function Fire:get(level)
	if not self.isGet then
		level:fire()
		level.text = "FIRE!"
		self.isGet = true
		self.area.display = false
	end
end

function Fire:draw()
	if self.area.display then
		self.area:draw()
		font:print("Fire!", 20, self.area.forms[1], "center", "center", EasyLD.color:new(255,255,255))
	end
end

return Fire