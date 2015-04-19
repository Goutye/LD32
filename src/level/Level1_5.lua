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
	self.maxOut = 3
	self.num = 5
	-----------------------------------


	local point = EasyLD.point:new(self.xStart, hMax/2)
	self.startPoint = point
	self.area = EasyLD.area:new(point)

	self.step = 300

	local seg = EasyLD.segment:new(point:copy(), EasyLD.point:new(self.step + self.xStart, hMax/2))
	self.area:attach(seg)
	self.length = self.length + self.step

	for i = 2, 10 do
		if i == 4 or i == 7 then
			local p = seg.p2
			local dist = math.random(30, hMax-30)
			local seg1 = EasyLD.segment:new(p:copy(), EasyLD.point:new(i * self.step + self.xStart, dist))
			self.area:attach(seg1)

			local dist2 = math.random(30, hMax-30)
			while math.abs(dist - dist2) < hMax/4 do
				dist2 = math.random(30, hMax-30)
			end

			if i == 7 and upDown then
				table.insert(self.bonus, bNextUP:new(i * self.step + self.xStart, dist2))
			end
			if i == 4 and upDown then
				table.insert(self.bonus, bNextDOWN:new(i * self.step + self.xStart, dist))
			end

			local seg2 = EasyLD.segment:new(p:copy(), EasyLD.point:new(i * self.step + self.xStart, dist2))
			self.area:attach(seg2)
			local t = {seg1, seg2}
			seg = t[math.random(1,2)]
			self.length = self.length + self.step
		else
			seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(i * self.step + self.xStart, math.random(30, hMax-30)))
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

return Level