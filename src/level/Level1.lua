local class = require 'middleclass'

local ILevel = require 'level.ILevel'
local Level = class('Level', ILevel)

function Level:initialize(time, hMax, player, upDown)
	self.xStart = WINDOW_WIDTH+10
	self.length = 0
	self.maxTime = time
	self.player = player
	self.slow = 1
	self.slowStart = 3
	self.minPercent = 80
	-----------------------------------


	local point = EasyLD.point:new(self.xStart,10)
	self.startPoint = point
	self.area = EasyLD.area:new(point)

	self.step = 300

	local seg = EasyLD.segment:new(point:copy(), EasyLD.point:new(self.step + self.xStart, math.random(0, hMax)))
	self.area:attach(seg)
	self.length = self.length + self.step

	for i = 2, 10 do
		if i == 4 or i == 7 then
			local p = seg.p2
			local dist = math.random(0, hMax)
			local seg1 = EasyLD.segment:new(p:copy(), EasyLD.point:new(i * self.step + self.xStart, dist))
			self.area:attach(seg1)

			local dist2 = math.random(0, hMax)
			while math.abs(dist - dist2) < hMax/4 do
				dist2 = math.random(0, hMax)
			end
			local seg2 = EasyLD.segment:new(p:copy(), EasyLD.point:new(i * self.step + self.xStart, dist2))
			self.area:attach(seg2)
			local t = {seg1, seg2}
			seg = t[math.random(1,2)]
			self.length = self.length + self.step
		else
			seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(i * self.step + self.xStart, math.random(0, hMax)))
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

	self.timeEase = time
	self.easeType = "quadinout"
	self.timeEaseEnd = 2
	self.easeTypeEnd = "quadinout"
	self.prevPercent = nil
	self.levelBack = false
	self.player:reset()
	self.bonus = {}

	EasyLD.flux.to(self, 2, {slowStart = 1})
end

return Level