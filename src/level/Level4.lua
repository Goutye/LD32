local class = require 'middleclass'

local ILevel = require 'level.ILevel'
local Level = class('Level', ILevel)

local bAtk = require 'bonus.Atk'
local bDef = require 'bonus.Def'
local bFire = require 'bonus.Fire'

function Level:initialize(time, hMax, player, upDown, bottom)
	self.xStart = WINDOW_WIDTH+10
	self.length = 0
	self.maxTime = 9.5 + time / 2
	self.player = player
	self.slow = 1
	self.slowStart = 1
	self.minPercent = 80
	self.bonus = {}
	self.bottom = bottom
	self.num = "BOSS"
	self.maxOut = -1
	-----------------------------------


	local point = EasyLD.point:new(self.xStart,hMax/2)
	self.startPoint = point
	self.area = EasyLD.area:new(point)

	self.step = 300

	local seg = EasyLD.segment:new(point:copy(), EasyLD.point:new(self.step + self.xStart, hMax/2))
	self.area:attach(seg)
	self.length = self.length + self.step

	local segs = {}
	for i = 1, 3 do 
		segs[i] = EasyLD.segment:new(seg.p2:copy(), EasyLD.point:new(self.length + self.step + self.xStart, hMax/4 * i))
		self.area:attach(segs[i])
	end

	local a,b = math.random(1,3), math.random(1,3)
	while a == b do b = math.random(1,3) end

	table.insert(self.bonus, bAtk:new(self.length + self.step + self.xStart, hMax/4 * a))
	table.insert(self.bonus, bDef:new(self.length + self.step + self.xStart, hMax/4 * b))
	self.length = self.length + self.step

	for i = 3, 9 do
			for i = 1, 3 do 
				segs[i] = EasyLD.segment:new(segs[i].p2:copy(), EasyLD.point:new(self.length + self.step + self.xStart, hMax/4 * i))
				self.area:attach(segs[i])
			end
			self.length = self.length + self.step
	end

	for i = 1, 3 do 
		segs[i] = EasyLD.segment:new(segs[i].p2:copy(), EasyLD.point:new(self.length + self.step + self.xStart, hMax/2))
		self.area:attach(segs[i])
	end
	table.insert(self.bonus, bFire:new(self.length + self.step + self.xStart, hMax/2))
	self.bonus[#self.bonus]:hide()
	self.length = self.length + self.step

	self.lastPoint = segs[1].p2


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

	self.bonusArea = self:createAreaBonus()
	self.player:reset()
	EasyLD.flux.to(self, 2, {slowStart = 1})
end

function Level:startAtk()
	self.player:cast()
	self.slow = self.slow / 2
end

function Level:def()
	self.isDef = true
	self.player:def()
	self.slow = self.slow / 2
end

function Level:fire()
	self.player:fire(self.percent)
end

return Level