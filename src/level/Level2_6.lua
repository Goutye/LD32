local class = require 'middleclass'

local ILevel = require 'level.ILevel'
local Level = class('Level', ILevel)

local bNextDOWN = require 'bonus.NextDOWN'
local bNextUP = require 'bonus.NextUP'
local bKey = require 'bonus.Key'
local bDeath = require 'bonus.Death'
local bSpeed = require 'bonus.Speed'
local bSlow = require 'bonus.Slow'

function Level:initialize(time, hMax, player, upDown)
	self.xStart = WINDOW_WIDTH+10
	self.length = 0
	self.maxTime = 10 - (time-1)
	self.player = player
	self.slow = 1
	self.slowStart = 3
	self.minPercent = 80
	self.bonus = {}
	self.key = 0
	self.maxKey = 2
	self.maxOut = 3
	self.num = 4
	self.timer = {}
	-----------------------------------


	local point = EasyLD.point:new(self.xStart, hMax/2)
	self.startPoint = point
	self.area = EasyLD.area:new(point)

	self.step = 300

	local seg = EasyLD.segment:new(point:copy(), EasyLD.point:new(self.step + self.xStart, hMax/3*2))
	self.area:attach(seg)
	self.length = self.length + self.step

	for i = 2, 10 do
		if i == 3 then
			local p = EasyLD.point:new(i * self.step + self.xStart, hMax/2)
			self.area:attach(p)
			seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(i * self.step + self.xStart, hMax/2))
			local a = EasyLD.area:new(seg)
			a:follow(p)
			self.moveArea1 = a
			self.area:attach(a)
			table.insert(self.bonus, bDeath:new(i * self.step + self.xStart, hMax/2))
			table.insert(self.bonus, bKey:new(i * self.step + self.xStart, hMax-50))
			table.insert(self.bonus, bSlow:new((4 + 2) * self.step + self.xStart, seg.p2.y))
			table.insert(self.bonus, bSpeed:new(i * self.step + self.xStart, hMax/2+50))
			i = i + 1
			a:rotateTo(math.pi/8*7)
			self.timer[1] = EasyLD.timer.every(0.02, a.rotate, a, -math.pi/150)
		elseif i == 7 then
			table.insert(self.bonus, bDeath:new(i * self.step + self.xStart, hMax/2))
			table.insert(self.bonus, bKey:new(i * self.step + self.xStart, 50))
			table.insert(self.bonus, bSlow:new(2 * self.step + self.xStart, seg.p2.y))
			table.insert(self.bonus, bSpeed:new(i * self.step + self.xStart, hMax/2-50))
			local p = EasyLD.circle:new(i * self.step + self.xStart, hMax/2, 30, EasyLD.color:new(255,255,255))
			self.area:attach(p)
			i = i + 1
			seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(i * self.step + self.xStart, math.random(30, hMax-30)))
			local a = EasyLD.area:new(seg)
			a:follow(p)
			self.moveArea2 = a
			self.area:attach(a)
			a:rotate(math.pi/3*2)
			self.timer[2] = EasyLD.timer.every(0.02, a.rotate, a, math.pi/250)
		else
			seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(i * self.step + self.xStart, hMax/2))
			self.area:attach(seg)
			self.length = self.length + self.step
		end
	end

	self.lastPoint = seg.p2


	---------------------------
	self.currentTime = 0
	self.isStart = false
	self.isEnd = false
	self.timeOut = 0
	self.isOut = false
	self.nbOut = 0

	self.gotEnd = false

	self.timeEase = self.maxTime
	self.easeType = "quadinout"
	self.timeEaseEnd = 2
	self.easeTypeEnd = "quadinout"
	self.prevPercent = nil
	self.levelBack = false
	self.player:reset()
	self.bonusArea = self:createAreaBonus()

	EasyLD.flux.to(self, 2, {slowStart = 1})
end

function Level:resetArea()
	self.moveArea1:rotateTo(math.pi/6*5)
	self.moveArea2:rotateTo(math.pi/3*2)
end

return Level