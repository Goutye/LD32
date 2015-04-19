local class = require 'middleclass'

local BottomPath = class('BottomPath')

local function getPositionSegment(p1, p2, percent)
	local step = WINDOW_WIDTH * 3 / 4 / 2
	local a = (p2.y - p1.y) / (p2.x - p1.x)
	local x = percent * step
	return p1.x + x, p1.y + a * x
end

function BottomPath:initialize(nbSteps, player)
	self.steps = {}
	self.stepsCirc = {}
	self.h = WINDOW_HEIGHT / 4
	self.nbSteps = nbSteps
	self.area = nil
	self.background = EasyLD.box:new(0, self.h * 3, WINDOW_WIDTH, self.h, EasyLD.color:new(0,0,0), "fill")

	self.current = 1 --step
	self.step = WINDOW_WIDTH * 3 / 4 / 2

	self.previous = nil
	self.player = player
	self.posPlayer = EasyLD.point:new(30, 0)
	self.progress = 0

	self.timeEase = 0.5
	self.typeEase = "quadout"

	self.idNext = 1
	self.idPrevious = 1

	self.isEnd = false

	self:generate()

	self.tileset = EasyLD.tileset:new("assets/tilesets/tileset.png", 32, 32)
	self.map = EasyLD.map:new("assets/maps/mapoutside.map", self.tileset)
	self.mapDec = EasyLD.point:new(0,0)
	self.mapBegin = EasyLD.point:new(0,0)
	self.tower = EasyLD.image:new("assets/tilesets/tower.png")
	self.boxTower = EasyLD.box:new(WINDOW_WIDTH - 128, self.h*3, 128, self.h)
	self.boxTower:attachImg(self.tower)
end

function BottomPath:generate()
	local img = EasyLD.image:new("assets/tilesets/circle.png")
	local bLife = EasyLD.image:new("assets/tilesets/lifeUp.png")
	local bBoost = EasyLD.image:new("assets/tilesets/boost.png")
	local yPos = self.h * 3 + self.h / 2
	local xPos = 30
	local p1, p2 = EasyLD.point:new(xPos, yPos), EasyLD.point:new(self.step + xPos, yPos)
	table.insert(self.steps, {p1})
	table.insert(self.steps, {p2})
	self.areaSeg = EasyLD.area:new(EasyLD.segment:new(p1, p2))
	self.previous = p1

	local circ = EasyLD.circle:new(p1.x, p1.y, 5, EasyLD.color:new(100,0,0))
	circ:attachImg(img, "center")
	self.area = EasyLD.area:new(circ)
	table.insert(self.stepsCirc, {circ})

	local xPoint = self.step * 2 + xPos
	local yPoint = (self.h - 10) / 4

	for i = 2, self.nbSteps do
		if i == 3 then
			local p = p2
			local r1,r2 = math.random(-1,1), math.random(-1,1)
			while r1 == r2 do r2 = math.random(-1,1) end

			p1 = EasyLD.point:new(xPoint, r1 * yPoint  + yPos)
			p2 = EasyLD.point:new(xPoint, r2 * yPoint  + yPos)
			circ = EasyLD.circle:new(p.x, p.y, 5, EasyLD.color:new(100,0,0))
			circ:attachImg(img, "center")
			table.insert(self.steps, {p1, p2})
			table.insert(self.stepsCirc, {circ})
			self.areaSeg:attach(EasyLD.segment:new(p, p1))
			self.areaSeg:attach(EasyLD.segment:new(p, p2))
			self.area:attach(circ)
		elseif i == 4 then
			local p = p2
			p2 = EasyLD.point:new(xPoint, math.random(-1,1) * yPoint  + yPos)
			circ1 = EasyLD.circle:new(p1.x, p1.y, 5, EasyLD.color:new(100,0,0))
			circ2 = EasyLD.circle:new(p.x, p.y, 5, EasyLD.color:new(100,0,0))
			circ1:attachImg(bLife, "center")
			circ2:attachImg(bBoost, "center")
			circ1.bLife = 10
			circ2.bBoost = 2
			table.insert(self.steps, {p2})
			table.insert(self.stepsCirc, {circ1, circ2})
			self.areaSeg:attach(EasyLD.segment:new(p1, p2))
			self.areaSeg:attach(EasyLD.segment:new(p, p2))
			self.area:attach(circ1)
			self.area:attach(circ2)
		else
			p1 = p2
			p2 = EasyLD.point:new(xPoint, math.random(-1,1) * yPoint  + yPos)
			circ = EasyLD.circle:new(p1.x, p1.y, 5, EasyLD.color:new(100,0,0))
			circ:attachImg(img, "center")
			table.insert(self.steps, {p2})
			table.insert(self.stepsCirc, {circ})
			self.areaSeg:attach(EasyLD.segment:new(p1, p2))
			self.area:attach(circ)
		end
	end

	circ = EasyLD.circle:new(p2.x, p2.y, 5, EasyLD.color:new(100,0,0))
	circ:attachImg(img, "center")
	self.area:attach(circ)
	table.insert(self.stepsCirc, {circ})

	self.areaCirc = self.area
	self.area = EasyLD.area:new(self.area)
	self.area:attach(self.areaSeg)
	--self.area = self.areaSeg
end

function BottomPath:update(dt, progress)
	self.progress = progress

	if self.current <= self.nbSteps then
		if self.progress > 1 then
			self.progress = 1
		end
		self.player:moveTo(getPositionSegment(self.previous, self.steps[self.current + 1][self.idNext], self.progress))
		if self.progress == 1 and self.current == self.nbSteps then
			self.progress = 110
		end
	else
		self.isEnd = true
	end

	if self.mapDec.x <= -32 then
		self.mapDec.x = self.mapDec.x + 32
		self.mapBegin.x = self.mapBegin.x + 1
	end
end

function BottomPath:goNext(id)
	if self.current < self.nbSteps then
		self.idPrevious = self.idNext
		self.idNext = id or 1

		if self.steps[self.current + 2] ~= nil and #self.steps[self.current + 2] > 1 and self.steps[self.current + 2][1].y > self.steps[self.current + 2][2].y then
			if self.idNext == 1 then
				self.idNext = 2
			else
				self.idNext = 1
			end
		end

		local img = EasyLD.image:new("assets/tilesets/circle.png")
		for j = self.current + 1, self.current + 2 do
			local points = self.steps[j]
			local circs = self.stepsCirc[j]
			for i,v in ipairs(points) do
				EasyLD.flux.to(v, self.timeEase, {x = -self.step}, "relative"):ease(self.typeEase)
			end
			for i,v in ipairs(circs) do
				EasyLD.flux.to(v, self.timeEase, {x = -self.step}, "relative"):ease(self.typeEase)
				if v.bLife ~= nil and j == self.current + 1 and i == self.idPrevious then
					self.player.maxLife = self.player.maxLife + v.bLife
					v.bLife = nil
					v:attachImg(img, "center")
					self.text = "+10 PV"
				elseif v.bBoost ~= nil and j == self.current + 1 and i == self.idPrevious then
					self.player.dmg = self.player.dmg + v.bBoost
					v.bBoost = nil
					v:attachImg(img, "center")
					self.text = "+2 DMG"
				end
			end
		end
		EasyLD.flux.to(self.player.form, self.timeEase, {x = -self.step}, "relative"):ease(self.typeEase)
		EasyLD.flux.to(self.mapDec, self.timeEase, {x = -self.step}, "relative"):ease(self.typeEase)
		if self.current == self.nbSteps - 1 then
			EasyLD.flux.to(self.boxTower, self.timeEase, {x = -self.step}, "relative"):ease(self.typeEase)
		end
		self.previous = self.steps[self.current + 1][self.idPrevious]
	end
	self.current = self.current + 1
end

function BottomPath:goBack()
	EasyLD.flux.to(self.player.form, self.timeEase, {x = -self.step}, "relative"):ease(self.typeEase)
end

function BottomPath:draw()
	self.background:draw()
	self.map:draw(math.floor(self.mapDec.x), self.mapDec.y + self.h * 3, 30, 5, self.mapBegin.x, self.mapBegin.y)
	self.areaSeg:draw()
	self.areaCirc:draw("reverse")
	self.boxTower:draw()
	self.player.form:draw()
end

return BottomPath