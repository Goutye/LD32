local class = require 'middleclass'

local ILevel = require 'level.ILevel'
local Level = class('Level', ILevel)

function Level:initialize(time, hMax, player)
	self.xStart = WINDOW_WIDTH + 10
	local point = EasyLD.point:new(self.xStart,10)
	self.startPoint = point
	self.area = EasyLD.area:new(point)
	self.step = 300
	self.length = 0
	self.maxTime = time
	self.slow = 1
	self.slowStart = 3
	self.minPercent = 80
	
	self.player = player

	local seg = EasyLD.segment:new(point:copy(), EasyLD.point:new(self.step + self.xStart, math.random(0, hMax)))
	self.area:attach(seg)
	self.length = self.length + self.step

	for i = 2, 10 do
		seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(i * self.step + self.xStart, math.random(0, hMax)))
		self.area:attach(seg)
		self.length = self.length + self.step
	end

	self.lastPoint = seg.p2

	self.currentTime = 0
	self.isStart = false
	self.isEnd = false
	self.timeOut = 0

	self.gotEnd = false

	self.timeEase = time
	self.easeType = "quadinout"
	self.timeEaseEnd = 2
	self.easeTypeEnd = "quadinout"
	self.prevPercent = nil
	self.levelBack = false
	self.isOut = false
	self.nbOut = 0
	self.player:reset()
	self.bonus = {}

	EasyLD.flux.to(self, 2, {slowStart = 1})
end

return Level