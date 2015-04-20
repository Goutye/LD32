local class = require 'middleclass'

local Boss = class('Boss')
local Projectile = require 'Projectile'

function Boss:initialize(level)
	self.h = 70
	local c = EasyLD.box:new(0,0, 40, self.h, EasyLD.color:new(200,0,0))
	self.sprite = EasyLD.area:new(c)

	self.maxLife = 5--10 + level * 10
	self.life = self.maxLife
	self.boxMaxLife = EasyLD.box:new(0, 0, 200, 30, EasyLD.color:new(255,255,255), "line")
	self.boxLife = EasyLD.box:new(5, 5, 190, 20, EasyLD.color:new(0,0,0,120), "fill")
	self.boxMaxLife:moveTo(WINDOW_WIDTH-200, WINDOW_HEIGHT/4*3)
	self.boxLife:moveTo(WINDOW_WIDTH-200 + 5, WINDOW_HEIGHT/4*3 + 5)

	self.timeBeforeCast = 12 - (level - 1) 

	self.timer = EasyLD.timer.after(math.random(5, 7) + self.timeBeforeCast, self.fire, self)
	self.timerCast = EasyLD.timer.after(self.timeBeforeCast, self.cast, self)

	-----
	pointChest = EasyLD.point:new(25,35)

	hand = EasyLD.point:new(15, 30)
	hand:attachImg(EasyLD.image:new("assets/anim8/armMissile.png"), "center")
	hand2 = EasyLD.point:new(35, 40)
	hand2:attachImg(EasyLD.image:new("assets/anim8/armMissile.png"), "center")
	areaArm = EasyLD.area:new(hand)
	areaArm2 = EasyLD.area:new(hand2)
	areaArm:follow(pointChest)
	areaArm2:follow(pointChest)
	
	pointGlobal = EasyLD.point:new(0,0)
	box = EasyLD.box:new(10,10, 30, 30)
	box:attachImg(EasyLD.image:new("assets/anim8/boss.png"), "center")
	areaGlo = EasyLD.area:new(pointChest)
	areaGlo:attach(areaArm)
	areaGlo:attach(box)
	areaGlo:attach(areaArm2)
	areaGlo:follow(pointGlobal)
	pointGlobal.display = false
	
	areaa2 = EasyLD.area:new(pointGlobal)
	areaa2:attach(areaGlo)
	self.areaAnim = areaa2

	self.anim8 = {}
	self.anim8.atk = EasyLD.areaAnimation:new(EasyLD.point:new(0,0), self.areaAnim, nil, "assets/anim8/atk.anim8", true)
	self.anim8.fire =  EasyLD.areaAnimation:new(EasyLD.point:new(0,0), self.areaAnim, nil, "assets/anim8/fire.anim8", false, self.changeAnim8, {self, "normal"})
	self.anim8.normal = EasyLD.areaAnimation:new(EasyLD.point:new(0,0), self.areaAnim, nil, "assets/anim8/normalBoss.anim8", true)
	self.currentAnim8 = self.anim8.normal
	self.currentAnim8:play()

end

function Boss:update(dt)
end

function Boss:stop()
	if self.timer ~= nil then
		EasyLD.timer.cancel(self.timer)
		self.timer = nil
	end
	if self.timerCast ~= nil then
		EasyLD.timer.cancel(self.timerCast)
		self.timerCast = nil
	end
end

function Boss:changeAnim8(key)
	self.currentAnim8:pause()
	self.currentAnim8 = self.anim8[key]
	self.currentAnim8:init()
	self.currentAnim8:play()
end

function Boss:fire()
	engine.sfx.missileOut:play()
	self:changeAnim8("fire")
	table.insert(engine.screen.projectiles, Projectile:new(self.sprite.x - 10, self.sprite.y+ self.h/2, -1, 10))
	self.timer = EasyLD.timer.after(self.timeBeforeCast + math.random(5, 7), self.fire, self)
	self.timerCast = EasyLD.timer.after(self.timeBeforeCast, self.cast, self)
	self.sprite.forms[1].c = EasyLD.color:new(200,0,0)
end

function Boss:cast()
	engine.sfx.bossCast:play()
	self:changeAnim8("atk")
	self.sprite.forms[1].c = EasyLD.color:new(200,0,200)
	self.timerCast = nil
end

function Boss:draw()
	self.areaAnim:draw()
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
	self.areaAnim:moveTo(x, y + 5)
end

function Boss:translate(dx, dy, mode)
	self.form:sprite(dx, dy, mode)
end

function Boss:getHit(dmg)
	if self.life - dmg <= 0 then
		self.isDead = true
		engine.sfx.bossDead:play()
		engine.sfx.KO:play()
		dmg = self.life
	else
		engine.sfx.bossHit:play()
	end
	EasyLD.flux.to(self, 0.8, {life = -dmg}, "relative")
end

return Boss