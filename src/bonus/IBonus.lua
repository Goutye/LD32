local class = require 'middleclass'

local IBonus = class('IBonus')

function IBonus:initialize()
	self.isGet = false
end

function IBonus:update(dt)
end

function IBonus:draw()
	self.area:draw()
end

function IBonus:collide(area)
	return self.area:collide(area)
end

function IBonus:reset()
	self.isGet = false
	self.area.display = true
end

function IBonus:hide()
	self.isGet = true
	self.area.display = false
end

return IBonus