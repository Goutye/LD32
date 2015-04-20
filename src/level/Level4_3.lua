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
	self.maxOut = 4
	self.num = 3
	-----------------------------------

	local point = EasyLD.point:new(self.xStart, hMax/2)
	self.startPoint = point
	self.area = EasyLD.area:new(point)

	self.step = 300

	local seg = EasyLD.segment:new(point:copy(), EasyLD.point:new(self.step + self.xStart, hMax/2))
	self.area:attach(seg)
	self.length = self.length + self.step

	local sign = 1

	seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(self.length + self.step + self.xStart, hMax-30))
	self.area:attach(seg)
	self.length = self.length + self.step

	seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(self.length + self.step/2 + self.xStart, hMax/4*3))
	self.area:attach(seg)
	seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(self.length + self.step/2 + self.xStart, hMax/3*2))
	self.area:attach(seg)
	self.length = self.length + self.step

	seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(self.length + self.step + self.xStart, hMax/2))
	self.area:attach(seg)
	self.length = self.length + self.step
	seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(self.length + self.step + self.xStart, hMax/3))
	self.area:attach(seg)
	self.length = self.length + self.step

	seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(self.length + self.step + self.xStart, 30))
	self.area:attach(seg)
	self.length = self.length + self.step
	seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(self.length + self.step + self.xStart, 30))
	self.area:attach(seg)
	self.length = self.length + self.step
	seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(self.length + self.xStart, hMax/3))
	self.area:attach(seg)

	table.insert(self.bonus, bDeath:new(self.length - self.step*2.3 + self.xStart, hMax/2+150))
	table.insert(self.bonus, bDeath:new(self.length - self.step*2 + self.xStart, hMax/2+100))
	table.insert(self.bonus, bDeath:new(self.length - self.step*1.5 + self.xStart, hMax/2))
	table.insert(self.bonus, bDeath:new(self.length - self.step*1.7 + self.xStart, hMax/2+50))
	table.insert(self.bonus, bDeath:new(self.length - self.step*1.3 + self.xStart, hMax/2-50))
	table.insert(self.bonus, bDeath:new(self.length - self.step*1 + self.xStart, hMax/2-100))
	table.insert(self.bonus, bDeath:new(self.length - self.step*0.75 + self.xStart, 110))
	seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(self.length - self.step + self.xStart, hMax/2))
	table.insert(self.bonus, bKey:new(self.length - self.step + self.xStart, hMax/2))
	self.area:attach(seg)

	seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(self.length + self.xStart, hMax/3*2))
	self.area:attach(seg)
	table.insert(self.bonus, bDeath:new(self.length + self.step*0.5 + self.xStart, hMax/3*2-25))
	table.insert(self.bonus, bDeath:new(self.length + self.step*0.7 + self.xStart, hMax/3*2))

	seg = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(self.length + self.step + self.xStart, hMax-30))
	self.area:attach(seg)
	self.length = self.length + self.step
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