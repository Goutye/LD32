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

	------
	point = EasyLD.point:new(25,50)
	pointChest = EasyLD.point:new(25,35)
	feet = EasyLD.point:new(20,60)
	feet2 = EasyLD.point:new(30,60)
	feet:attachImg(EasyLD.image:new("assets/anim8/feet.png"), "center")
	feet2:attachImg(EasyLD.image:new("assets/anim8/feet.png"), "center")
	line = EasyLD.segment:new(EasyLD.point:new(25,50), feet:copy())
	line2 = EasyLD.segment:new(EasyLD.point:new(25,50), feet2:copy())
	areaJambe1 = EasyLD.area:new(line)
	areaJambe1:attach(feet)
	areaJambe2 = EasyLD.area:new(line2)
	areaJambe2:attach(feet2)
	areaJambe1:follow(point)
	areaJambe2:follow(point)

	hand = EasyLD.point:new(5, 35)
	hand:attachImg(EasyLD.image:new("assets/anim8/handfront.png"), "center")
	hand2 = EasyLD.point:new(45, 35)
	hand2:attachImg(EasyLD.image:new("assets/anim8/hand.png"), "center")
	pointWrist = EasyLD.point:new(10, 35)
	pointWrist2 = EasyLD.point:new(40, 35)
	areaWrist = EasyLD.area:new(hand)
	areaWrist2 = EasyLD.area:new(hand2)
	areaWrist:follow(pointWrist)
	areaWrist2:follow(pointWrist2)
	areaArm = EasyLD.area:new(pointWrist)
	areaArm2 = EasyLD.area:new(pointWrist2)
	areaArm:attach(areaWrist)
	areaArm2:attach(areaWrist2)
	areaArm:follow(pointChest)
	areaArm2:follow(pointChest)
	
	pointGlobal = EasyLD.point:new(0,0)
	box = EasyLD.box:new(10,20, 30, 30)
	box:attachImg(EasyLD.image:new("assets/anim8/chest.png"), "center")
	tete = EasyLD.point:new(25,10)
	tete:attachImg(EasyLD.image:new("assets/anim8/head.png"), "center")
	areaGlobal = EasyLD.area:new(pointGlobal)
	areaGlobal:attach(tete)
	areaGlobal:attach(box)
	areaGlobal:attach(pointChest)
	areaGlobal:attach(point)
	areaGlobal:attach(areaJambe1)
	areaGlobal:attach(areaJambe2)
	areaGlobal:attach(areaArm)
	areaGlobal:attach(areaArm2)
	self.areaAnim = areaGlobal
	self.areaAnim:follow(self.sprite)

	self.anim8 = {}
	self.anim8.atk = EasyLD.areaAnimation:new(EasyLD.point:new(0,0), self.areaAnim, nil, "assets/anim8/magic.anim8", true)
	self.anim8.def =  EasyLD.areaAnimation:new(EasyLD.point:new(0,0), self.areaAnim, nil, "assets/anim8/def.anim8", false, self.changeAnim8, {self, "normal"})
	self.anim8.yeah = EasyLD.areaAnimation:new(EasyLD.point:new(0,0), self.areaAnim, nil, "assets/anim8/yeah.anim8", false, self.changeAnim8, {self, "normal"})
	self.anim8.normal = EasyLD.areaAnimation:new(EasyLD.point:new(0,0), self.areaAnim, nil, "assets/anim8/normal.anim8", true)
	self.currentAnim8 = self.anim8.normal
	self.currentAnim8:play()
end

function Player:update(dt)
	self.area:moveTo(EasyLD.mouse:getPosition():get())
end

function Player:changeAnim8(key)
	self.currentAnim8:pause()
	self.currentAnim8 = self.anim8[key]
	self.currentAnim8:init()
	self.currentAnim8:play()
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
	self:changeAnim8("normal")
	self.isDef = false
	self.sprite.forms[1].c = EasyLD.color:new(0,0,200)
end

function Player:cast()
	self.sprite.forms[1].c.r = 200
	self:changeAnim8("atk")
end

function Player:def()
	self.isDef = true
	self.sprite.forms[1].c.b = 100
	self:changeAnim8("def")
end

function Player:getHit(dmg)
	EasyLD.camera:shake({x = 5}, 0.5)
	if self.isDef then
		self:changeAnim8("yeah")
		return
	end

	if self.life - dmg < 0 then
		self.isDead = true
		dmg = self.life
	end

	EasyLD.flux.to(self, 0.8, {life = -dmg}, "relative")
end

function Player:restore()
	self.life = self.maxLife
	self.isDead = false
end

function Player:fire(perc)
	self:changeAnim8("normal")
	self.sprite.forms[1].c = EasyLD.color:new(0, 250, 0)
	table.insert(engine.screen.projectiles, Projectile:new(self.sprite.x + 10, self.sprite.y + self.h/2, 1, perc/10, perc))
end

return Player