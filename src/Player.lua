local class = require 'middleclass'

local Player = class('Player')
local Projectile = require 'Projectile'

function Player:initialize()
	self.h = 50
	local c = EasyLD.circle:new(-100, 0, 10, EasyLD.color:new(0,100,0))
	self.form = EasyLD.area:new(c)
	self.sprite = EasyLD.area:new(EasyLD.box:new(0,0,self.h,50, EasyLD.color:new(0,0,200)))
	c = c:copy()
	c.r = 30
	self.area = EasyLD.area:new(c)

	self.maxLife = 50
	self.life = self.maxLife
	self.boxMaxLife = EasyLD.box:new(0, 0, 200, 30, EasyLD.color:new(255,255,255), "line")
	self.boxLife = EasyLD.box:new(5, 5, 190, 20, EasyLD.color:new(0,0,0,120), "fill")
	self.boxMaxLife:moveTo(0, WINDOW_HEIGHT/4*3)
	self.boxLife:moveTo(5, WINDOW_HEIGHT/4*3 + 5)
end

function Player:update(dt)
	self.area:moveTo(EasyLD.mouse:getPosition():get())
end

function Player:draw()
	self.area:draw()
end

function Player:drawUI()
	self.boxMaxLife:draw()
	self.boxLife:draw()
	local b = self.boxLife:copy()
	b.w = b.w * self.life/self.maxLife
	b.c = EasyLD.color:new(200,40,40)
	b:draw()
	font:print(math.ceil(self.life) .. "/" .. self.maxLife, 20, self.boxLife, "center", "center", EasyLD.color:new(255,255,255))
end

function Player:moveTo(x, y)
	self.form:moveTo(x, y)
end

function Player:translate(dx, dy, mode)
	self.form:translate(dx, dy, mode)
end

function Player:reset()
	self.isDef = false
	self.sprite.forms[1].c = EasyLD.color:new(0,0,200)
end

function Player:cast()
	self.sprite.forms[1].c.r = 200
end

function Player:def()
	self.isDef = true
	self.sprite.forms[1].c.b = 100
end

function Player:getHit(dmg)
	if self.isDef then
		return
	end
	self.life = self.life - dmg
	if self.life < 0 then
		self.life = 0
		self.isDead = true
	end
end

function Player:restore()
	self.life = self.maxLife
	self.isDead = false
end

function Player:fire(perc)
	self.sprite.forms[1].c = EasyLD.color:new(0, 250, 0)
	table.insert(engine.screen.projectiles, Projectile:new(self.sprite.x + 10, self.sprite.y + self.h/2, 1, perc/10, perc))
end

return Player