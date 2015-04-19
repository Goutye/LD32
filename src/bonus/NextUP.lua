local class = require 'middleclass'

local IBonus = require 'bonus.IBonus'
local NextUP = class('NextUP', IBonus)

function NextUP:initialize(x, y)
	local c = EasyLD.circle:new(0, 0, 30, EasyLD.color:new(0, 0, 200))
	c:attachImg(EasyLD.image:new("assets/tilesets/bonusUp.png"), "center")
	self.area = EasyLD.area:new(c)
	self.area:moveTo(x, y)
	self.isGet = false
end

function NextUP:update(dt)

end

function NextUP:get(level)
	if not self.isGet then
		level.next = 1
		level.text = "WAY UP!"
		self.isGet = true
		self.area.display = false
	end
end

return NextUP