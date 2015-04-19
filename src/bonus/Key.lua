local class = require 'middleclass'

local IBonus = require 'bonus.IBonus'
local Key = class('Key', IBonus)

function Key:initialize(x, y)
	local c = EasyLD.circle:new(0, 0, 30, EasyLD.color:new(0, 0, 200))
	c:attachImg(EasyLD.image:new("assets/tilesets/bonusKey.png"), "center")
	self.area = EasyLD.area:new(c)
	self.area:moveTo(x, y)
	self.isGet = false
end

function Key:update(dt)

end

function Key:get(level)
	if not self.isGet then
		engine.sfx.ok:play()
		level.key = level.key + 1
		self.isGet = true
		self.area.display = false
	end
end

return Key