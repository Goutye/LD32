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
	self.maxTime = 18
	self.player = player
	self.slow = 1
	self.slowStart = 3
	self.minPercent = 80
	self.bonus = {}
	self.key = 0
	self.maxKey = 0
	self.maxOut = 3
	self.num = 4
	-----------------------------------


	local point = EasyLD.point:new(self.xStart, math.random(math.floor(hMax/4),math.floor(hMax/4)*3))
	self.startPoint = point
	self.area = EasyLD.area:new(point)

	self.step = 300

	local seg = EasyLD.segment:new(point:copy(), EasyLD.point:new(self.step + self.xStart, hMax/2))
	self.area:attach(seg)
	self.length = self.length + self.step
	local seg2 = seg

	for i = 2,10  do
		if i % 2 == 0 then
			local yTmp = hMax-30-50
			if i%4 == 0 then yTmp = 30+50 end
			table.insert(self.bonus, bSpeed:new(i * self.step + self.xStart, yTmp))
			seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(i * self.step + self.xStart, math.random(30, hMax/2/5)))
			seg2 = EasyLD.segment:new(seg2.p2:copy(), EasyLD.point:new(i * self.step + self.xStart, math.random(hMax/5*4, hMax-30)))
		else
			seg2 = EasyLD.segment:new(seg2.p2:copy(), EasyLD.point:new(i * self.step + self.xStart, math.random(hMax/2, math.floor(hMax/2 + hMax/2/5))))
			seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(i * self.step + self.xStart, math.random(math.floor(hMax/2/5*4), hMax/2)))
		end
		if i == 8 then
			table.insert(self.bonus, bDeath:new(i * self.step + self.xStart, math.random(30, hMax-30)))
		end
		self.area:attach(seg)
		self.area:attach(seg2)
		self.length = self.length + self.step
	end

	i = 11
	seg2 = EasyLD.segment:new(seg2.p2:copy(), EasyLD.point:new(i * self.step + self.xStart, hMax/2))
	seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(i * self.step + self.xStart, hMax/2))
	self.length = self.length + self.step
	self.lastPoint = seg.p2
	self.area:attach(seg)
	self.area:attach(seg2)


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

return Level