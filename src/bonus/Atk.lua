local class = require 'middleclass'

local IBonus = require 'bonus.IBonus'
local Atk = class('Atk', IBonus)

function Atk:initialize(x, y)
	self.area = EasyLD.area:new(EasyLD.box:new(0, 0, 80, 30, EasyLD.color:new(255,0,0)))
	self.area:moveTo(x, y)
	self.isGet = false
end

function Atk:update(dt)

end

function Atk:get(level)
	if not self.isGet then
		level:startAtk()
		level.bonus[#level.bonus]:reset()
		for i = 1, #level.bonus - 1 do
			level.bonus[i]:hide()
		end
	end
end

function Atk:draw()
	if self.area.display then
		self.area:draw()
		font:print("Atk", 20, self.area.forms[1], "center", "center", EasyLD.color:new(255,255,255))
	end
end

return Atk