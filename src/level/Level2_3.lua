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
	self.maxTime = 18 - (time-1)
	self.player = player
	self.slow = 1
	self.slowStart = 3
	self.minPercent = 80
	self.bonus = {}
	self.key = 0
	self.maxKey = 2
	self.maxOut = 2
	self.num = 3
	-----------------------------------


	local point = EasyLD.point:new(self.xStart, hMax/2)
	self.startPoint = point
	self.area = EasyLD.area:new(point)

	self.step = 300

	local seg = EasyLD.segment:new(point:copy(), EasyLD.point:new(self.step + self.xStart, hMax/3*2))
	self.area:attach(seg)
	self.length = self.length + self.step

	for i = 2, 3 do
		seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(i * self.step + self.xStart, math.random(hMax/2-200, hMax/2)))
		self.area:attach(seg)
		self.length = self.length + self.step
	end
	table.insert(self.bonus, bKey:new(3 * self.step + self.xStart, seg.p2.y + 90))

	for i = 4, 5 do
		seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(i * self.step + self.xStart, hMax/2))
		self.area:attach(seg)
		self.length = self.length + self.step
	end

	i = 5
	seg = EasyLD.segment:new(EasyLD.point:new(seg.p1.x, seg.p1.y - 70), EasyLD.point:new(i * self.step + self.xStart, hMax/2-70))
	self.area:attach(seg)
	self.length = self.length + self.step

	for i = 6, 7 do
		seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(i * self.step + self.xStart, math.random(30, hMax/2-70)))
		self.area:attach(seg)
		self.length = self.length + self.step
	end
	table.insert(self.bonus, bKey:new(7 * self.step + self.xStart, seg.p2.y + 90))
	for i = 8, 9 do
		seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(i * self.step + self.xStart, hMax/2))
		self.area:attach(seg)
		self.length = self.length + self.step
	end

	i = 9
	seg = EasyLD.segment:new(EasyLD.point:new(seg.p1.x, seg.p1.y + 70), EasyLD.point:new(i * self.step + self.xStart, hMax/2+70))
	self.area:attach(seg)
	self.length = self.length + self.step

	for i = 10, 13 do
		seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(i * self.step + self.xStart, math.random(30, hMax/2-70)))
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