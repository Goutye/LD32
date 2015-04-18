local class = require 'middleclass'

local Projectile = class('Projectile')

function Projectile:initialize(x, y, dx, dmg, perc)
	local c = EasyLD.circle:new(5,5, 7, EasyLD.color:new(255,255,255))
	self.sprite = EasyLD.area:new(c)
	self.sprite:attach(EasyLD.point:new(5, 5))
	self.sprite:moveTo(x, y)
	if dx < 0 then
		self.img = EasyLD.spriteAnimation(self.sprite.forms[2], "assets/tilesets/missile.png", 3, 0.3, 32, 32, 0, -1, "center")
		self.img:play()
	else
		self.sprite.forms[1]:attachImg(EasyLD.image:new("assets/tilesets/star.png"), "center")
		self.timer = EasyLD.timer.every(0.01, self.sprite.rotate, self.sprite, math.pi/64)
	end

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
	if self.timer ~= nil then
		EasyLD.timer.cancel(self.timer)
	end
	if self.img ~= nil then
		self.img:cancel()
	end
end

return Projectile