local class = require 'middleclass'

local Player = class('Player')
local Projectile = require 'Projectile'

function Player:initialize(i)
	self.h = 50
	local c = EasyLD.circle:new(-100, 0, 10, EasyLD.color:new(0,150,0))
	self.form = EasyLD.area:new(c)
	c:attachImg(EasyLD.image:new("assets/anim8/head.png"), "center")
	self.sprite = EasyLD.area:new(EasyLD.box:new(0,0,self.h,50, EasyLD.color:new(0,0,200)))
	c = c:copy()
	c.r = 30
	self.area = EasyLD.area:new(c)

	self.maxLife = 5 + (i or 1) * 10
	self.life = self.maxLife
	self.boxMaxLife = EasyLD.box:new(0, 0, 200, 30, EasyLD.color:new(255,255,255), "line")
	self.boxLife = EasyLD.box:new(5, 5, 190, 20, EasyLD.color:new(0,0,0,120), "fill")
	self.boxMaxLife:moveTo(0, WINDOW_HEIGHT/4*3)
	self.boxLife:moveTo(5, WINDOW_HEIGHT/4*3 + 5)

	self.dmg = 10

	------
	point = EasyLD.point:new(25,50)
	pointChest = EasyLD.point:new(25,35)
	pointChest.display = false
	point.display = false
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
	pointWrist2.display = false
	pointWrist.display = false
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
	pointGlobal.display = false
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
		return false
	end

	if self.life - dmg <= 0 then
		self.isDead = true
		dmg = self.life
		engine.sfx.youaredead:play()
	end
	engine.sfx.explode:play()
	EasyLD.flux.to(self, 0.8, {life = -dmg}, "relative")
	EasyLD.flux.to(self.areaAnim, 0.3, {x = -10}, "relative"):ease("backout"):after(0.8, {x = self.areaAnim.x})
	return true
end

function Player:restore()
	self.life = self.maxLife
	self.isDead = false
end

function Player:fire(perc)
	engine.sfx.star:play()
	self:changeAnim8("normal")
	self.sprite.forms[1].c = EasyLD.color:new(0, 250, 0)
	table.insert(engine.screen.projectiles, Projectile:new(self.sprite.x + 30, self.sprite.y + self.h/2, 1, perc/100*self.dmg, perc))
end

function Player:changeCursor(i)
	self.currentCursor = i

	if self.timerCursor ~= nil then
		EasyLD.timer.cancel(EasyLD.timerCursor)
		EasyLD.timerCursor = nil
	end
	if self.tweenTimer3 ~= nil then
		self.tweenTimer3:stop()
	end

	if i == 1 then
		local c = EasyLD.circle:new(0,0, 30, EasyLD.color:new(0,150,0))
		self.areaSeg = EasyLD.area:new(c)
		self.aera = a
	elseif i == 2 then
		local c = EasyLD.circle:new(0,0, 30, EasyLD.color:new(0,150,0))
		self.areaSeg = nil
		self.aera = EasyLD.area:new(c)
		self:tween2()
	elseif i == 3 then
		local p = EasyLD.circle:new(0, 0, 2, EasyLD.color:new(0,150,0))
		local a = EasyLD.area:new(p)
		local seg = EasyLD.box:new(-70, -4, 140, 8, EasyLD.color:new(0,150,0))
		self.areaSeg = EasyLD.area:new(seg)
		self.areaSeg:follow(p)
		a:attach(self.areaSeg)
		self.timerCursor = EasyLD.timer.every(0.02, self.areaSeg.rotate, self.areaSeg, math.pi/256)
		self.area = a
	elseif i == 4 then
		local p = EasyLD.point:new(0, 0, 2, EasyLD.color:new(0,150,0))
		p.display = false
		p.checkCollide = false
		local a = EasyLD.area:new(p)
		local seg = EasyLD.box:new(0, 50, 100, 50, EasyLD.color:new(0,150,0))
		self.areaSeg = EasyLD.area:new(seg)
		self.areaSeg:follow(p)
		a:attach(self.areaSeg)
		self.area = a
		self:tween3()
	end
end

function Player:tween3()
	self.tweenTimer3 = EasyLD.flux.to(self.areaSeg, 1.5, {y = -100}, "relative"):ease("quadin"):after(1.5, {y = 100}, "relative"):ease("quadin"):oncomplete(function() self:tween3() end)
end

function Player:tween2()
	if self.currentCursor == 2 then
		self.tweenTimer3 = EasyLD.flux.to(self.area.forms[1], 2, {r = 15}):ease("quintinout"):after(2, {r = 50}):ease("quintinout"):oncomplete(function () self:tween2() end) 
	end
end

return Player