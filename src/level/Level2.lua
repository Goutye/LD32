local class = require 'middleclass'

local ILevel = require 'level.ILevel'
local Level = class('Level', ILevel)

local bSpeed = require 'bonus.Speed'
local bSlow = require 'bonus.Slow'

function Level:initialize(time, hMax, player)
	self.xStart = WINDOW_WIDTH+10
	self.length = 0
	self.maxTime = time
	self.player = player
	self.slow = 1
	self.slowStart = 3
	self.minPercent = 80
	self.bonus = {}
	-----------------------------------


	local point = EasyLD.point:new(self.xStart,10)
	self.startPoint = point
	self.area = EasyLD.area:new(point)

	self.step = 300

	local seg = EasyLD.segment:new(point:copy(), EasyLD.point:new(self.step + self.xStart, math.random(0, hMax)))
	self.area:attach(seg)
	self.length = self.length + self.step

	for i = 2, 3 do
		seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(i * self.step + self.xStart, math.random(0, hMax)))
		self.area:attach(seg)
		self.length = self.length + self.step
	end

	i = 4
	local p = seg.p2
	local dist = math.random(0, hMax)
	local seg1 = EasyLD.segment:new(p:copy(), EasyLD.point:new(i * self.step + self.xStart, dist))
	self.area:attach(seg1)

	local dist2 = math.random(0, hMax)
	while math.abs(dist - dist2) < hMax/4 do
		dist2 = math.random(0, hMax)
	end

	local t = {dist, dist2}
	local r = math.random(1,2)
	table.insert(self.bonus, bSpeed:new(i * self.step + self.xStart, t[r]))
	if r == 1 then r = 2 else r = 1 end
	table.insert(self.bonus, bSlow:new(i * self.step + self.xStart, t[r]))

	local seg2 = EasyLD.segment:new(p:copy(), EasyLD.point:new(i * self.step + self.xStart, dist2))
	self.area:attach(seg2)

	self.length = self.length + self.step

	i = 5
	seg = EasyLD.segment:new(seg1.p2:copy(), EasyLD.point:new(i * self.step + self.xStart, dist2))
	self.area:attach(seg)
	seg = EasyLD.segment:new(seg2.p2:copy(), EasyLD.point:new(i * self.step + self.xStart, dist2))
	self.area:attach(seg)
	self.length = self.length + self.step

	self.step = 150
	for i = 6, 20 do
		if i % 2 == 0 then
			seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(self.length + self.step + self.xStart, math.random(0, math.floor(hMax/4))))
		else
			seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(self.length + self.step + self.xStart, math.random(math.floor(hMax/4)*3, hMax)))
		end
		self.area:attach(seg)
		self.length = self.length + self.step
	end

	self.step = 300
	seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(self.length + self.step + self.xStart, hMax/2))
	self.area:attach(seg)
	self.length = self.length + self.step

	self.lastPoint = seg.p2


	---------------------------
	self.currentTime = 0
	self.isStart = false
	self.isEnd = false
	self.timeOut = 0
	self.isOut = false
	self.nbOut = 0

	self.gotEnd = false

	self.timeEase = time
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