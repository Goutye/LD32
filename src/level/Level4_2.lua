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
	self.maxKey = 2
	self.maxOut = 4
	self.num = 2
	-----------------------------------

	local point = EasyLD.point:new(self.xStart, hMax/2)
	self.startPoint = point
	self.area = EasyLD.area:new(point)

	self.step = 300
	self.nbSlow = 0

	local seg = EasyLD.segment:new(point:copy(), EasyLD.point:new(self.step + self.xStart, hMax/2))
	self.area:attach(seg)
	self.length = self.length + self.step

	local sign = 1

	for i = 2, 20 do
		if i % 4 == 2 then
			if sign < 0 or self.nbSlow > 1 then
				self.nbSlow = 0
				table.insert(self.bonus, bSpeed:new(self.length + self.xStart, hMax/2 + hMax/3 * sign))
			else
				self.nbSlow = self.nbSlow + 1
				table.insert(self.bonus, bSlow:new(self.length + self.xStart, hMax/2 + hMax/3 * sign))
			end
			seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(self.length + self.xStart, hMax/2 + hMax/3 * sign))
			self.area:attach(seg)
			sign = math.random(-1,1)
			while sign == 0 do sign = math.random(-1,1) end
		elseif i % 4 == 0 then
			seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(self.length + self.xStart, hMax/2))
			self.area:attach(seg)
		else
			seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(self.length + self.step + self.xStart, seg.p2.y))
			self.area:attach(seg)
			self.length = self.length + self.step
		end
	end

	table.insert(self.bonus, bKey:new(self.step * 8 + self.xStart, hMax/2))
	table.insert(self.bonus, bKey:new(self.step * 4 + self.xStart, hMax/2))

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