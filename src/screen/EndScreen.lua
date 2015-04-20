local class = require 'middleclass'

local EndScreen = class('EndScreen')
local Boss = require 'Boss'
local Player = require 'Player'

function EndScreen:initialize(GS)
	self.tileset = EasyLD.tileset:new("assets/tilesets/tileset.png", 32, 32)
	self.map = EasyLD.map:new("assets/maps/titlescreen.map", self.tileset)
	self.mapDec = EasyLD.point:new(0,0)
	self.mapBegin = EasyLD.point:new(0,0)
	self.tower = EasyLD.image:new("assets/tilesets/tower.png")
	self.boxTower = EasyLD.box:new(0, WINDOW_HEIGHT-32*5+0.25*32, 128, 128)
	self.boxTower:attachImg(self.tower)
	self.boxTower2 = self.boxTower:copy()
	self.boxTower2:moveTo(WINDOW_WIDTH-32*4, WINDOW_HEIGHT-32*5+0.25*32, 128, 128)
	self.boxTower2:attachImg(self.tower)

	font = EasyLD.font:new("assets/fonts/FORCED_SQUARE.ttf")
	font:load(60, EasyLD.color:new(255,255,255))
	self.boxTitle = EasyLD.box:new(0,30, WINDOW_WIDTH, 200)
	self.boxMinititle = EasyLD.box:new(0,0,500, 50)
	self.boxMinititle:moveTo(00, 400)

	self.boxSign = EasyLD.box:new(WINDOW_WIDTH-300, WINDOW_HEIGHT-300, 295,310)

	self.GS = GS

	self.player = Player:new()
	self.player.areaAnim:moveTo(50, 120)
	self.player.sprite:moveTo(50, 120)
	self.boss = {}
	for i = 1, 5 do
	 	table.insert(self.boss, Boss:new(1))
	 	self.boss[i]:moveTo(WINDOW_WIDTH-150+i*10, 80+i*10)
		self.boss[i].life = 99999
	end

	self.fail = self.GS.topPath.nbOut
	self.total = math.floor(self.GS.totalTime/60).. " min" .. (math.floor(self.GS.totalTime) % 60) .. " sec"
	self.score = math.floor(2000/self.GS.totalTime*100) - self.fail
	

	self.projectiles = {}
	self.timerP = EasyLD.timer.every(3, self.player.cast, self.player)
	self.timerP2 = EasyLD.timer.after(1, self.playerHit, self)

	engine.musicEnd:play()
end

function EndScreen:preCalcul(dt)
	return dt
end

function EndScreen:playerHit()
	self.timerP2 = EasyLD.timer.every(3, self.player.fire, self.player, 100)
end

function EndScreen:update(dt)
	local mustRemove = {}

	for i, v in ipairs(self.boss) do
		if v.canFire then
			v:fire()
		end
	end

	for i,v in ipairs(self.projectiles) do
		v:update(dt)
		if v.dir.x < 0 and v:collide(self.player.sprite) then
			local wasHit = self.player:getHit(v.dmg)
			if wasHit then
				if self.player.isDead then
					self.level = self.level - 1
				end
			else
				engine.sfx.parry:play("next")
			end
			v:onEnd()
			table.insert(mustRemove, i)
		elseif v.dir.x > 0 then
			for j = 1, #self.boss do
				if v:collide(self.boss[j].areaAnim) then
					self.boss[j]:getHit(v.dmg)
					self.player:changeAnim8("yeah")
					v:onEnd()
					table.insert(mustRemove, i)
					break
				end
			end
		end

		if v.dir.x > 0 then
			self.proj = v
		end
	end

	for i,v in ipairs(mustRemove) do
		table.remove(self.projectiles, v)
	end
end

function EndScreen:draw()
	EasyLD.graphics:setColor(self.boxTitle.c)
	self.map:draw(math.floor(self.mapDec.x), self.mapDec.y, 30, 40, self.mapBegin.x, self.mapBegin.y)
	self.boxTower:draw()
	self.boxTower2:draw()
	self.player.areaAnim:draw()
	self.player.life = 999999
	for i, v in ipairs(self.boss) do
		self.boss[i].areaAnim:draw()
	end
	for i,v in ipairs(self.projectiles) do
		v:draw()
	end
	font:printOutLine("Well played! Score: ".. self.score, 60, self.boxTitle, "center", "center", self.boxTitle.c, EasyLD.color:new(0,0,0), 2)
	font:printOutLine("Thank you for playing my game!", 40, self.boxTitle, "center", "bottom", self.boxTitle.c, EasyLD.color:new(0,0,0), 2)

	self.text = "Boss defeated: 4/4\nPlayer damage: "..self.GS.player.dmg.."\nPlayer life: "..self.GS.player.life
	self.text = self.text .. "\nFail: " .. self.fail.."\nTotal time: " .. self.total

	font:printOutLine(self.text, 30, self.boxMinititle , "center", "center", self.boxTitle.c, EasyLD.color:new(0,0,0), 2)
	font:printOutLine("An Unconventional Weapon - LD32\n             A game made by Goutye", 24, self.boxSign, "right", "bottom", self.boxTitle.c, EasyLD.color:new(0,0,0), 1)
end

function EndScreen:onQuit()
	EasyLD.timer.cancel(self.timerP)
	EasyLD.timer.cancel(self.timerP2)
	engine.musicTitle:stop()
end

return EndScreen