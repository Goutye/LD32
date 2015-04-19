local class = require 'middleclass'

local GameScreen = require 'screen.GameScreen'
local TitleScreen = class('TitleScreen')
local Boss = require 'Boss'
local Player = require 'Player'

function TitleScreen:initialize()
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
	self.boxMinititle:rotate(-math.pi/6, 0, 0)
	self.boxMinititle:moveTo(00, WINDOW_HEIGHT-100)

	self.boxSign = EasyLD.box:new(WINDOW_WIDTH-300, WINDOW_HEIGHT-300, 295,310)

	self.player = Player:new()
	self.player.areaAnim:moveTo(50, 100)
	self.player.sprite:moveTo(50, 100)
	self.boss = Boss:new(1)
	self.boss:moveTo(WINDOW_WIDTH-100, 100)
	self.boss.life = 99999

	self.projectiles = {}
	self.timerP = EasyLD.timer.every(7, self.player.cast, self.player)
	self.timerP2 = EasyLD.timer.after(2, self.playerHit, self)
end

function TitleScreen:preCalcul(dt)
	return dt
end

function TitleScreen:playerHit()
	self.timerP2 = EasyLD.timer.every(7, self.player.fire, self.player, 100)
end

function TitleScreen:update(dt)
	if EasyLD.mouse:isPressed("l") then
		engine:setNextScreen(GameScreen:new())
	end

	local mustRemove = {}

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
		elseif v.dir.x > 0 and v:collide(self.boss.areaAnim) then
			self.boss:getHit(v.dmg)
			self.player:changeAnim8("yeah")
			if not self.boss.isDead then
			end
			v:onEnd()
			table.insert(mustRemove, i)
		end

		if v.dir.x > 0 then
			self.proj = v
		end
	end

	for i,v in ipairs(mustRemove) do
		table.remove(self.projectiles, v)
	end
end

function TitleScreen:draw()
	EasyLD.graphics:setColor(self.boxTitle.c)
	self.map:draw(math.floor(self.mapDec.x), self.mapDec.y, 30, 40, self.mapBegin.x, self.mapBegin.y)
	self.boxTower:draw()
	self.boxTower2:draw()
	self.player.areaAnim:draw()
	self.player.life = 999999
	self.boss.areaAnim:draw()
	for i,v in ipairs(self.projectiles) do
		v:draw()
	end
	font:printOutLine("Nano VS Bot", 60, self.boxTitle, "center", "center", self.boxTitle.c, EasyLD.color:new(0,0,0), 2)
	font:printOutLine("The adventure begins!", 40, self.boxTitle, "center", "bottom", self.boxTitle.c, EasyLD.color:new(0,0,0), 2)
	font:printOutLine("\"An unconventional way\n   to use your wand!\"", 30, self.boxMinititle , "center", "center", self.boxTitle.c, EasyLD.color:new(0,0,0), 2)
	font:printOutLine("An Unconventional Weapon - LD32\n             A game made by Goutye", 24, self.boxSign, "right", "bottom", self.boxTitle.c, EasyLD.color:new(0,0,0), 1)
end

function TitleScreen:onQuit()
	EasyLD.timer.cancel(self.timerP)
	EasyLD.timer.cancel(self.timerP2)
	engine.musicTitle:stop()
end

return TitleScreen