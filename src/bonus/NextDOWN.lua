local class = require 'middleclass'

local IBonus = require 'bonus.IBonus'
local NextDOWN = class('NextDOWN', IBonus)

function NextDOWN:initialize(x, y)
	self.area = EasyLD.area:new(EasyLD.circle:new(0, 0, 30, EasyLD.color:new(0, 0, 200)))
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