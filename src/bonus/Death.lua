local class = require 'middleclass'

local IBonus = require 'bonus.IBonus'
local Death = class('Death', IBonus)

function Death:initialize(x, y)
	local c = EasyLD.circle:new(0, 0, 30, EasyLD.color:new(0, 0, 200))
	c:attachImg(EasyLD.image:new("assets/tilesets/bonusDeath.png"), "center")
	self.area = EasyLD.area:new(c)
	self.area:moveTo(x, y)
	self.isGet = false
end

function Death:update(dt)

end

function Death:get(level)
	if not self.isGet then
		level.timeOut = level.currentTime
		level.isEnd = true
		self.isGet = true
		self.area.display = false
	end
end

return Death