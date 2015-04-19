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
	self.maxTime = 8 - (time-1)
	self.player = player
	self.slow = 1
	self.slowStart = 3
	self.minPercent = 80
	self.bonus = {}
	self.key = 0
	self.maxKey = 0
	self.num = 6
	self.maxOut = -1
	-----------------------------------


	local point1, point2 = EasyLD.point:new(self.xStart, hMax/3), EasyLD.point:new(self.xStart, hMax/3*2)
	self.startPoint = point1
	self.area = EasyLD.area:new(point1)

	self.step = 300

	for i = 1, 10 do
		seg = EasyLD.segment:new(point1:copy(), EasyLD.point:new(i * self.step + self.xStart, hMax/3))
		seg2 = EasyLD.segment:new(point2:copy(), EasyLD.point:new(i * self.step + self.xStart, hMax/3*2))
		self.area:attach(seg)
		self.area:attach(seg2)
		point1 = seg.p2
		point2 = seg2.p2

		table.insert(self.bonus, bDeath:new(i * self.step + self.xStart, math.random(1,2) * hMax/3))
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