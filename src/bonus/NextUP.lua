local class = require 'middleclass'

local IBonus = require 'bonus.IBonus'
local NextUP = class('NextUP', IBonus)

function NextUP:initialize(x, y)
	self.area = EasyLD.area:new(EasyLD.circle:new(0, 0, 30, EasyLD.color:new(200, 0, 200)))
	self.area:moveTo(x, y)
	self.isGet = false
end

function NextUP:update(dt)

end

function NextUP:get(level)
	if not self.isGet then
		level.next = 1
		self.isGet = true
		self.area.display = false
	end
end

return NextUP