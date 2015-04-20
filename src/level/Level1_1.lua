local class = require 'middleclass'

local ILevel = require 'level.ILevel'
local Level = class('Level', ILevel)

local bNextDOWN = require 'bonus.NextDOWN'
local bNextUP = require 'bonus.NextUP'
local bKey = require 'bonus.Key'
local bDeath = require 'bonus.Death'

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
	self.maxOut = 3
	self.num = 1
	-----------------------------------


	local point = EasyLD.point:new(self.xStart, hMax/2)
	self.startPoint = point
	self.area = EasyLD.area:new(point)

	self.step = 300

	local seg = EasyLD.segment:new(point:copy(), EasyLD.point:new(self.step + self.xStart, hMax/2))
	self.area:attach(seg)
	self.length = self.length + self.step

	for i = 2, 4 do
		seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(i * self.step + self.xStart, math.random(math.floor(hMax/2)-100, math.floor(hMax/2)+100)))
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