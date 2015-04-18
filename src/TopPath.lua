local class = require 'middleclass'

local TopPath = class('TopPath')

local Level = require 'level.Level4'

function TopPath:initialize(player, bottomPath)
	self.h = WINDOW_HEIGHT / 4 * 3
	self.background = EasyLD.box:new(0,0,WINDOW_WIDTH, self.h, EasyLD.color:new(10,10,0), "fill")
	self.minBackC = 0
	self.maxBackC = 20
	self.minRatio = 2
	self.maxRatio = 2.5
	self.player = player

	self.percentMin = 50

	self.timeOut = 0
	self.timeLevel = 4
	self.currentTime = 0
	self.level = Level:new(self.timeLevel, self.h, player, nil, bottomPath)

	self.timer = nil
	self.bottomPath = bottomPath

	--UI
	self.boxPercent = EasyLD.box:new(0, 0, WINDOW_WIDTH, self.h, EasyLD.color:new(20, 20, 0))
	self.percent = 100
end

function TopPath:update(dt)
	self.level:update(dt)
	self.percent = self.level:getPercent()
	
	if self.level.isStart then
		self.currentTime = self.currentTime + dt
	end
	if self.level.isEnd and self.timer == nil then
		self:updateColor()
		self.timer = EasyLD.timer.after(1, TopPath.nextLevel, self)
		if self.percent > self.percentMin then
			self.timerColor = EasyLD.timer.every(0.12, TopPath.switchColor, self)
		else
			self.timerColor = EasyLD.timer.every(0.2, TopPath.switchColor, self)
		end
	end

	local tier = 100/3
	local cinq = 100/5

	if not self.level.isEnd then
		self:updateColor()
	end
end

function TopPath:nextLevel()
	EasyLD.timer.cancel(self.timerColor)
	if self.percent < self.percentMin then
		self.level:goBack()
		self.bottomPath:goBack()
		self.timer = nil
	else
		self.level:onEnd(TopPath.generateNewLevel, self)
	end
	self.currentTime = 0
end

function TopPath:generateNewLevel()
	self.bottomPath:goNext(self.level.next)
	if self.bottomPath.steps[self.bottomPath.current + 2] ~= nil and #self.bottomPath.steps[self.bottomPath.current + 2] > 1 then
		self.level = Level:new(self.timeLevel, self.h, self.player, true, bottomPath)
	else
		self.level = Level:new(self.timeLevel, self.h, self.player, nil, bottomPath)
	end
	self.timer = nil
end

function TopPath:draw()
	self.background:draw()
	self:drawUI()

	self.level:draw()
end

function TopPath:switchColor()
	local c = self.background.c
	self.background.c = self.boxPercent.c
	self.boxPercent.c = c
end

function TopPath:drawUI()
	font:print(self.percent .. "%", 256, self.boxPercent, "center", "center", self.boxPercent.c)
end

function TopPath:updateColor()
	local tier = 100/3
	local cinq = 100/5

	if self.percent < tier then
		self.background.c.r = self.maxBackC
		self.background.c.g = self.minBackC

		self.boxPercent.c.r = self.background.c.r * self.maxRatio
		self.boxPercent.c.g = self.background.c.g * self.minRatio
	elseif self.percent < tier*2 then
		local perc = (self.percent-tier) / tier
		self.background.c.r = self.maxBackC
		self.background.c.g = (self.maxBackC - self.minBackC) * (perc) + self.minBackC

		self.boxPercent.c.g = self.background.c.g * (perc * (self.maxRatio - self.minRatio) + self.minRatio)
		self.boxPercent.c.r = self.background.c.r * self.maxRatio
	elseif self.percent < cinq * 4 then
		local perc = 1 - (self.percent-2*tier) / (4*cinq - tier*2)
		self.background.c.r = (self.maxBackC - self.minBackC) * (perc) + self.minBackC
		self.background.c.g = self.maxBackC

		self.boxPercent.c.r = self.background.c.r * (perc * (self.maxRatio - self.minRatio) + self.minRatio)
		self.boxPercent.c.g = self.background.c.g * self.maxRatio
	else
		self.background.c.g = self.maxBackC
		self.background.c.r = self.minBackC

		self.boxPercent.c.r = self.background.c.r * self.minRatio
		self.boxPercent.c.g = self.background.c.g * self.maxRatio
	end
end

return TopPath