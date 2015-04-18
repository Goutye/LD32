local class = require 'middleclass'

local Projectile = class('Projectile')

function Projectile:initialize(x, y, dx, dmg, perc)
	local c = EasyLD.box:new(0,0, 10, 10, EasyLD.color:new(255,255,255))
	self.sprite = EasyLD.area:new(c)
	self.sprite:moveTo(x, y)

	local p = perc or 100
	p = p / 100
	local angle = math.acos(p) / 8
	local r = math.random()
	angle = angle * 2 * r - angle
	self.dir = EasyLD.vector:new(dx * math.cos(angle), math.sin(angle))
	self.dmg = dmg
	self.power = 150
end

function Projectile:update(dt)
	self.sprite:translate(dt * self.dir.x * self.power,dt * self.dir.y * self.power)
end

function Projectile:draw()
	self.sprite:draw()
end

function Projectile:collide(area)
	return self.sprite:collide(area)
end

function Projectile:onEnd(x, y)
	--explode
end

return Projectile