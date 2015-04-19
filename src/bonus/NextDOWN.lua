local class = require 'middleclass'

local IBonus = require 'bonus.IBonus'
local NextDOWN = class('NextDOWN', IBonus)

function NextDOWN:initialize(x, y)
	local c = EasyLD.circle:new(0, 0, 30, EasyLD.color:new(0, 0, 200))
	c:attachImg(EasyLD.image:new("assets/tilesets/bonusDown.png"), "center")
	self.area = EasyLD.area:new(c)
	self.area:moveTo(x, y)
	self.isGet = false
end

function NextDOWN:update(dt)

end

function NextDOWN:get(level)
	if not self.isGet then
		level.next = 2
		self.isGet = true
		self.area.display = false
	end
end

return NextDOWN