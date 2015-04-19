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
	self.maxTime = 20 - (time-1)
	self.player = player
	self.slow = 1
	self.slowStart = 3
	self.minPercent = 80
	self.bonus = {}
	self.key = 0
	self.maxKey = 1
	self.maxOut = 3
	self.num = 4
	-----------------------------------


	local point = EasyLD.point:new(self.xStart, hMax/2)
	self.startPoint = point
	self.area = EasyLD.area:new(point)

	self.step = 300

	local seg = EasyLD.segment:new(point:copy(), EasyLD.point:new(self.step + self.xStart, hMax/3*2))
	self.area:attach(seg)
	self.length = self.length + self.step

	for i = 2, 4 do
		if i % 2 == 0 then
			seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(i * self.step + self.xStart, math.random(30, hMax/3-100)))
		else
			seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(i * self.step + self.xStart, math.random(hMax/3*2, hMax-30)))
		end
		self.area:attach(seg)
		self.length = self.length + self.step
	end
	table.insert(self.bonus, bSlow:new(3 * self.step + self.xStart, hMax/2))

	i = 4
	local b = EasyLD.box:new(i * self.step + self.xStart - 20, hMax/3+50, 40, hMax/3)
	self.area:attach(b)
	table.insert(self.bonus, bDeath:new(4 * self.step + self.xStart-60, hMax/2))
	table.insert(self.bonus, bDeath:new(4 * self.step + self.xStart+60, hMax/2))
	table.insert(self.bonus, bDeath:new(4 * self.step + self.xStart-60, hMax/3*2))
	table.insert(self.bonus, bDeath:new(4 * self.step + self.xStart+60, hMax/3*2))
	table.insert(self.bonus, bKey:new(4 * self.step + self.xStart, hMax/3*2 + 30))
	table.insert(self.bonus, bSpeed:new(5 * self.step + self.xStart, hMax/2))

	for i = 5, 8 do
		if i % 2 == 0 then
			seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(i * self.step + self.xStart, math.random(30, hMax/3)))
		else
			seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(i * self.step + self.xStart, math.random(hMax/3*2, hMax-30)))
		end
		self.area:attach(seg)
		self.length = self.length + self.step
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

return Level