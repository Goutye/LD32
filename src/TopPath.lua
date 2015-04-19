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

	self.numLevel = 1
	self.currentTime = 0

	self.level = {}
	self.listLevel = {}
	self.listLevelFight = {}
	self.listLevelPath = {}
	self:loadLevel()

	self.timer = nil
	self.bottomPath = bottomPath

	--UI
	self.boxPercent = EasyLD.box:new(0, 0, WINDOW_WIDTH, self.h, EasyLD.color:new(20, 20, 0))
	self.percent = 100
end

function TopPath:loadLevel()
	Level = require 'level.Level4'
	table.insert(self.listLevelFight, Level)
	for i = 3, 3 do
		Level = require("level.Level" .. i)
		table.insert(self.listLevelPath, Level)
	end
end

function TopPath:changeLevel(i, fight, bottom)
	self.listLevel = {}
	if fight then
		self.percentMin = 50
		self.listLevel = self.listLevelFight
	else
		self.percentMin = 50
		self.listLevel = self.listLevelPath
	end
	self.numLevel = i
	self.bottomPath = bottom
	self:generateNewLevel()
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
			engine.sfx.ok:play()
		else
			self.timerColor = EasyLD.timer.every(0.2, TopPath.switchColor, self)
			engine.sfx.fail:play()
		end
	end

	if self.bottomPath.text ~= nil then
		self:updateColor()
		self.text = self.bottomPath.text
		self.bottomPath.text = nil
		self.timerColor2 = EasyLD.timer.every(0.12, TopPath.switchColor, self, 2)
		self.timerText = EasyLD.timer.after(1.5, TopPath.displayText, self, 2)
	elseif self.level.text ~= nil then
		if self.timerColor3 ~= nil then
			EasyLD.timer.cancel(self.timerText3)
			EasyLD.timer.cancel(self.timerColor3)
			self.timerColor3 = nil
		end
		self:updateColor()
		self.text = self.level.text
		self.level.text = nil
		self.timerColor3 = EasyLD.timer.every(0.12, TopPath.switchColor, self, 3)
		self.timerText3 = EasyLD.timer.after(1.5, TopPath.displayText, self, 3)
	end

	local tier = 100/3
	local cinq = 100/5

	if not self.level.isEnd and self.timerColor2 == nil and self.timerColor3 == nil then
		self:updateColor()
	end
end

function TopPath:displayText(id)
	if id == 2 and self.timerColor2 ~= nil then
		EasyLD.timer.cancel(self.timerColor2)
		self.timerColor2 = nil
	elseif id == 3 and self.timerColor3 ~= nil then
		EasyLD.timer.cancel(self.timerColor3)
		self.timerColor3 = nil
	end
	self.text = nil
end

function TopPath:nextLevel()
	EasyLD.timer.cancel(self.timerColor)
	if self.percent < self.percentMin or (self.level.key or 0) < (self.level.maxKey or 0) then
		if (self.level.key or 0) < (self.level.maxKey or 0) then
			self.text = "KEY!"
			self.percent = 0
			self:updateColor()
			self.timerColor2 = EasyLD.timer.every(0.12, TopPath.switchColor, self, 2)
			self.timerText = EasyLD.timer.after(1.5, TopPath.displayText, self, 2)
		end
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
	if self.bottomPath.current ~= nil then
		if self.bottomPath.steps[self.bottomPath.current + 2] ~= nil and self.bottomPath.steps[self.bottomPath.current + 2] ~= nil and #self.bottomPath.steps[self.bottomPath.current + 2] > 1 then
			self.level = self.listLevel[math.random(1, #self.listLevel)]:new(self.numLevel, self.h, self.player, true, bottomPath)
		else
			self.level = self.listLevel[math.random(1, #self.listLevel)]:new(self.numLevel, self.h, self.player, nil, bottomPath)
		end
	else
		self.level = self.listLevel[math.random(1, #self.listLevel)]:new(self.numLevel, self.h, self.player, nil, bottomPath)
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
	local text = self.percent .. "%"
	local size = 256
	if self.text ~= nil then
		text = self.text
		if string.len(text) > 6 then
			size = 150
		end
	end
	font:print(text, size, self.boxPercent, "center", "center", self.boxPercent.c)

	local key = self.level.key or 0
	local maxKey = self.level.maxKey or 0
	font:print(key.."/"..maxKey, 40, EasyLD.box:new(WINDOW_WIDTH-200, 5, 195, 50), "right","center", self.boxPercent.c)
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