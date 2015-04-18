local class = require 'middleclass'

local ILevel = class('ILevel')

function ILevel:initialize()
end

function ILevel:update(dt)
	EasyLD.camera:moveTo(0,0)

	if not self.isStart then
		self.slow = self.slowStart
	end
	
	if not self.isEnd and not self.levelBack then
		self.currentTime = self.currentTime + dt

		local dx = dt / self.maxTime * self.length / self.slow

		self.area:translate(-dx, 0)
		if self.bonusArea ~= nil then
			self.bonusArea:translate(-dx, 0)
		end

		if self.player.area:collide(self.lastPoint) and self.percent >= self.minPercent then
			self.gotEnd = true
		end

		if self.lastPoint.x < 10 or self.gotEnd then
			self.isEnd = true
		end

		if self.isStart then
			if self:collide(self.player.area) then
				self.isOut = false
			else
				EasyLD.camera:shake({x = 5, y = 5}, dt)
				self.timeOut = self.timeOut + dt
				if not self.isOut then
					self.isOut = true
					self.nbOut = self.nbOut + 1

					if self.isDef then
						self.isEnd = true
						self.timeOut = self.currentTime
					end
				end
			end

			for i,v in ipairs(self.bonus) do
				if v:collide(self.player.area) then
					v:get(self)
				end
			end
		end
	end

	if not self.isStart and not self.levelBack then
		if self.area.x < 0 or self.startPoint:collide(self.player.area) then
			self.isStart = true
		end
	end
end

function ILevel:draw()
	self.area:draw()
	if self.bonusArea ~= nil then
		for i,v in ipairs(self.bonus) do
			v:draw()
		end
	end
end

function ILevel:goBack()
	self.levelBack = true
	EasyLD.flux.to(self.area, self.timeEase/2, {x = self.xStart}):ease(self.easeType)
	EasyLD.flux.to(self, self.timeEase/2, {prevPercent = 0}):ease(self.easeType)
	if self.bonusArea ~= nil then
		EasyLD.flux.to(self.bonusArea, self.timeEase/2, {x = self.xStart}):ease(self.easeType)
	end
	self.isStart = false
	self.currentTime = 0
	self.timeOut = 0
	self.nbOut = 0
	self.gotEnd = false
	self.isDef = false
	self.bonus[#self.bonus]:hide()
	self.isEnd = false
	self.timer = EasyLD.timer.after(self.timeEase/2, self.start, self)
	for i, v in ipairs(self.bonus) do
		v:reset()
	end

	self.player:reset()
end

function ILevel:start()
	self.isStart = true
	self.levelBack = false
end

function ILevel:getPercent()
	if self.currentTime == 0 then
		if self.gotEnd then
			return math.ceil(self.prevPercent)
		else
			return math.floor(self.prevPercent or 100)
		end
	else
		self.prevPercent = self.percent
		self.percent = math.floor((self.currentTime - self.timeOut) / self.currentTime * 100)
		return self.percent
	end
end

function ILevel:getProgress()
	if self.gotEnd then
		return 1
	end
	local percent = (self.player.area.x - self.startPoint.x) / self.length
	if percent < 0 then percent = 0 end
	if percent > 1 then percent = 1 end

	return percent
end

function ILevel:onEnd(callback, arg)
	EasyLD.flux.to(self.area, self.timeEaseEnd, {x = -WINDOW_WIDTH}, "relative"):ease(self.easeTypeEnd)
	self.currentTime = 0
	EasyLD.flux.to(self, self.timeEaseEnd, {prevPercent = 100}):ease(self.easeType)
	self.timer = EasyLD.timer.after(self.timeEaseEnd, callback, arg)
end

function ILevel:collide(area)
	return area:collide(self.area)
end

function ILevel:createAreaBonus()
	local a = EasyLD.area:new(self.area.forms[1]:copy())

	if #self.bonus > 0 then
		for i = 1, #self.bonus do
			a:attach(self.bonus[i].area)
		end
		
		return a
	end
	return nil
end

return ILevel