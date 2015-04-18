local class = require 'middleclass'

local IBonus = require 'bonus.IBonus'
local Def = class('Def', IBonus)

function Def:initialize(x, y)
	self.area = EasyLD.area:new(EasyLD.box:new(0, 0, 80, 30, EasyLD.color:new(0,0,255)))
	self.area:moveTo(x, y)
	self.isGet = false
end

function Def:update(dt)

end

function Def:get(level)
	if not self.isGet then
		level:def()
		self.isGet = true
		self.area.display = false
	end
end

function Def:draw()
	if self.area.display then
		self.area:draw()
		font:print("Def", 20, self.area.forms[1], "center", "center", EasyLD.color:new(255,255,255))
	end
end

return Def