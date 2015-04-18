local class = require 'middleclass'

local Boss = class('Boss')
local Projectile = require 'Projectile'

function Boss:initialize(level)
	self.h = 70
	local c = EasyLD.box:new(0,0, 40, self.h, EasyLD.color:new(200,0,0))
	self.sprite = EasyLD.area:new(c)

	self.maxLife = 10 + level * 20
	self.life = self.maxLife
	self.boxMaxLife = EasyLD.box:new(0, 0, 200, 30, EasyLD.color:new(255,255,255), "line")
	self.boxLife = EasyLD.box:new(5, 5, 190, 20, EasyLD.color:new(0,0,0,120), "fill")
	self.boxMaxLife:moveTo(WINDOW_WIDTH-200, WINDOW_HEIGHT/4*3)
	self.boxLife:moveTo(WINDOW_WIDTH-200 + 5, WINDOW_HEIGHT/4*3 + 5)

	self.timeBeforeCast = 10 - (level -1)

	self.timer = EasyLD.timer.after(math.random(5, 7) + self.timeBeforeCast, self.fire, self)
	self.timerCast = EasyLD.timer.after(self.timeBeforeCast, self.cast, self)
end

function Boss:update(dt)
end

function Boss:fire()
	table.insert(engine.screen.projectiles, Projectile:new(self.sprite.x - 10, self.sprite.y+ self.h/2, -1, 10))
	self.timer = EasyLD.timer.after(self.timeBeforeCast + math.random(5, 7), self.fire, self)
	self.timerCast = EasyLD.timer.after(self.timeBeforeCast, self.cast, self)
	self.sprite.forms[1].c = EasyLD.color:new(200,0,0)
end

function Boss:cast()
	self.sprite.forms[1].c = EasyLD.color:new(200,0,200)
end

function Boss:draw()
	self.sprite:draw()
end

function Boss:drawUI()
	self.boxMaxLife:draw()
	self.boxLife:draw()
	local b = self.boxLife:copy()
	b.w = b.w * self.life/self.maxLife
	b.c = EasyLD.color:new(200,40,40)
	b:draw()
	font:print(math.ceil(self.life) .. "/" .. self.maxLife, 20, self.boxLife, "center", "center", EasyLD.color:new(255,255,255))
end

function Boss:reset()
	self.life = self.maxLife
end

function Boss:moveTo(x, y)
	self.sprite:moveTo(x, y)
end

function Boss:translate(dx, dy, mode)
	self.form:sprite(dx, dy, mode)
end

function Boss:getHit(dmg)
	self.life = self.life - dmg
	if self.life < 0 then
		self.life = 0
		self.isDead = true
	end
	self.life = self.life + dmg
	EasyLD.flux.to(self, 0.8, {life = -dmg}, "relative")
end

return Boss