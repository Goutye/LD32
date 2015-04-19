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
	self.maxKey = 9
	self.maxOut = 2
	self.num = 5
	self.timer = {}
	-----------------------------------


	local point = EasyLD.point:new(self.xStart, hMax/2)
	self.startPoint = point
	self.area = EasyLD.area:new(point)

	self.step = 300

	local seg = EasyLD.segment:new(point:copy(), EasyLD.point:new(self.step + self.xStart, hMax/3*2))
	self.area:attach(seg)
	self.length = self.length + self.step

	--L
	i = 2
	local seg = EasyLD.box:new(i * self.step + self.xStart, hMax/3, 20, hMax/3)
	self.area:attach(seg)
	local seg = EasyLD.box:new(i * self.step + self.xStart, hMax/3*2, self.step, 20)
	self.area:attach(seg)
	self.length = self.length + self.step*2
	table.insert(self.bonus, bKey:new(i * self.step + self.xStart, hMax/3))

	--U
	i = 4
	local seg = EasyLD.box:new(i * self.step + self.xStart, hMax/3, 20, hMax/3)
	self.area:attach(seg)
	local seg = EasyLD.box:new((i+1) * self.step + self.xStart, hMax/3, 20, hMax/3)
	self.area:attach(seg)
	local seg = EasyLD.box:new(i * self.step + self.xStart, hMax/3*2, self.step + 20, 20)
	self.area:attach(seg)
	self.length = self.length + self.step*2
	table.insert(self.bonus, bKey:new((i+1) * self.step + self.xStart, hMax/3))

	--D
	i = 6
	local seg = EasyLD.box:new(i * self.step + self.xStart, hMax/3, 20, hMax/3)
	self.area:attach(seg)
	local seg = EasyLD.box:new(i * self.step + self.xStart, hMax/3+20, 20, hMax/3)
	self.area:attach(seg)
	seg:rotate(-math.pi/4*1.3, seg.x, seg.y)
	local seg = EasyLD.box:new(i * self.step + self.xStart, hMax/3*2, 20, hMax/3)
	self.area:attach(seg)
	seg:rotate(-math.pi/4*2.7, seg.x, seg.y)
	self.length = self.length + self.step*2
	table.insert(self.bonus, bKey:new((i+0.5) * self.step + self.xStart, hMax/2))

	--U
	i = 8
	local seg = EasyLD.box:new(i * self.step + self.xStart, hMax/3, 20, hMax/3)
	self.area:attach(seg)
	local seg = EasyLD.box:new((i+1) * self.step + self.xStart, hMax/3, 20, hMax/3)
	self.area:attach(seg)
	local seg = EasyLD.box:new(i * self.step + self.xStart, hMax/3*2, self.step + 20, 20)
	self.area:attach(seg)
	self.length = self.length + self.step*2
	table.insert(self.bonus, bKey:new((i+0.7) * self.step + self.xStart, hMax/2))

	--M
	i = 10
	local seg = EasyLD.box:new(i * self.step + self.xStart, hMax/3, 20, hMax/3)
	self.area:attach(seg)
	local seg = EasyLD.box:new(i * self.step + self.xStart, hMax/3, 20, hMax/2)
	self.area:attach(seg)
	seg:rotate(-math.pi/3, seg.x, seg.y)
	local seg = EasyLD.box:new((i+1) * self.step + self.xStart, hMax/3, 20, hMax/2)
	self.area:attach(seg)
	seg:rotate(math.pi/3, seg.x, seg.y)
	local seg = EasyLD.box:new((i+1) * self.step + self.xStart, hMax/3, 20, hMax/3)
	self.area:attach(seg)
	table.insert(self.bonus, bKey:new((i+0.5) * self.step + self.xStart, hMax/2-20))

	i = 12
	local seg = EasyLD.segment:new(EasyLD.point:new(i * self.step + self.xStart, hMax/3*2), EasyLD.point:new( (i+1) * self.step + self.xStart, hMax/3*2))
	self.area:attach(seg)
	self.length = self.length + self.step*2

	--D
	i = 14
	local seg = EasyLD.box:new(i * self.step + self.xStart, hMax/3, 20, hMax/3)
	self.area:attach(seg)
	local seg = EasyLD.box:new(i * self.step + self.xStart, hMax/3+20, 20, hMax/3)
	self.area:attach(seg)
	seg:rotate(-math.pi/4*1.3, seg.x, seg.y)
	local seg = EasyLD.box:new(i * self.step + self.xStart, hMax/3*2, 20, hMax/3)
	self.area:attach(seg)
	seg:rotate(-math.pi/4*2.7, seg.x, seg.y)
	self.length = self.length + self.step*2
	table.insert(self.bonus, bKey:new((i+0.5) * self.step + self.xStart, hMax/2))

	--A
	i = 16
	local seg = EasyLD.box:new(i * self.step + self.xStart, hMax/3, 20, hMax/3)
	self.area:attach(seg)
	local seg = EasyLD.box:new((i+1) * self.step + self.xStart, hMax/3, 20, hMax/3)
	self.area:attach(seg)
	local seg = EasyLD.box:new(i * self.step + self.xStart, hMax/3, self.step + 20, 20)
	self.area:attach(seg)
	local seg = EasyLD.box:new(i * self.step + self.xStart, hMax/2, self.step + 20, 20)
	self.area:attach(seg)
	self.length = self.length + self.step*2
	table.insert(self.bonus, bKey:new((i+0.7) * self.step + self.xStart, hMax/3))

	--R
	i = 18
	local seg = EasyLD.box:new(i * self.step + self.xStart, hMax/3, 20, hMax/3)
	self.area:attach(seg)
	local seg = EasyLD.box:new((i+1) * self.step + self.xStart, hMax/3, 20, hMax/2 - hMax/3)
	self.area:attach(seg)
	local seg = EasyLD.box:new(i * self.step + self.xStart, hMax/3, self.step + 20, 20)
	self.area:attach(seg)
	local seg = EasyLD.box:new(i * self.step + self.xStart, hMax/2, self.step + 20, 20)
	self.area:attach(seg)
	local seg = EasyLD.box:new(i * self.step + self.xStart, hMax/2, 20, hMax/3)
	self.area:attach(seg)
	seg:rotate(-math.pi/3, seg.x, seg.y)
	self.length = self.length + self.step*2
	table.insert(self.bonus, bKey:new((i+0.5) * self.step + self.xStart, hMax/3+20))

	--E
	i = 20
	local seg = EasyLD.box:new(i * self.step + self.xStart, hMax/3, 20, hMax/3)
	self.area:attach(seg)
	local seg = EasyLD.box:new(i * self.step + self.xStart, hMax/3*2, self.step + 20, 20)
	self.area:attach(seg)
	local seg = EasyLD.box:new(i * self.step + self.xStart, hMax/3, self.step + 20, 20)
	self.area:attach(seg)
	local seg = EasyLD.box:new(i * self.step + self.xStart, hMax/2, self.step + 20, 20)
	self.area:attach(seg)
	self.length = self.length + self.step*2
	table.insert(self.bonus, bKey:new((i+1) * self.step + self.xStart, hMax/3))

	i = 22
	local seg = EasyLD.segment:new(EasyLD.point:new(self.step + self.xStart, hMax/3*2), EasyLD.point:new( (i+1) * self.step + self.xStart, hMax/3*2))
	self.area:attach(seg)
	self.length = self.length + self.step*2


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