local class = require 'middleclass'

local IScreen = require 'screen.IScreen'
local GameScreen = class('GameScreen', IScreen)

local TopPath = require 'TopPath'
local BottomPath = require 'BottomPath'
local BottomFight = require 'BottomFight'
local Player = require 'Player'
local Boss = require 'Boss'

local EndScreen = require 'screen.EndScreen'

function GameScreen:initialize()
	---
	self.player = Player:new()
	self.bottomPath = BottomPath:new(9, self.player, 1)
	self.topPath = TopPath:new(self.player, self.bottomPath)
	self.projectiles = {}

	---
	font = EasyLD.font:new("assets/fonts/FORCED_SQUARE.ttf")
	font:load(16, EasyLD.color:new(255,255,255))

	self.fight = false
	self.level = 1
	self.topPath:changeLevel(self.level, self.fight, self.bottomPath)

	self.lastDt = 1
	self.slower = false
	self.music = false
	self.totalTime = 0
end

function GameScreen:preCalcul(dt)
	self.totalTime = self.totalTime + dt
	if self.proj ~= nil then
		if self.proj.dmg > self.boss.life and not self.boss.isDead and not self.proj.idDead then
			self.prevBossLife = self.boss.life
			self.slower = true
			dt = dt * math.min(2/10 + math.abs(self.boss.areaAnim.x - self.proj.sprite.x)/(WINDOW_WIDTH/4)*8/10, 1)
		elseif self.boss.isDead then
			dt = self.lastDt + 0.0001

			if self.slower then
				EasyLD.camera:shake({x = 5, y = 5}, 2)
				self.slower = false
				self.timer = EasyLD.timer.after(0.5, self.backToNormal, self)
			end
		end
	end
	self.lastDt = dt
	return dt
end

function GameScreen:update(dt)
	

	if not self.music then
		engine.playlistOutside:play()
		self.music = true
	end
	self.topPath:update(dt, self.fight)

	if self.fight then
		self.bottomFight:update(dt)
		if self.bottomFight.isEnd then
			self.level = self.level + 1
			if self.level > 4 then
				engine:setNextScreen(EndScreen:new(self))
				return
			end
			self.fight = false
			self.projectiles = {}
			self.bottomPath = BottomPath:new(9, self.player, self.level)
			self.topPath:changeLevel(self.level, self.fight, self.bottomPath)
			engine.playlistInside:stop()
			engine.playlistOutside:play("next")
		end
	else
		self.bottomPath:update(dt, self.topPath.level:getProgress(), self.level)
		if self.bottomPath.isEnd then
			self.fight = true
			self.boss = Boss:new(self.level)
			self.bottomFight = BottomFight:new(1, self.player, self.boss, self.level)
			self.topPath:changeLevel(self.level, self.fight, self.bottomFight)
			engine.playlistOutside:stop()
			engine.playlistInside:play("next")
		end
	end

	self.player:update(dt)

	local mustRemove = {}

	for i,v in ipairs(self.projectiles) do
		v:update(dt)
		if v.dir.x < 0 and v:collide(self.player.sprite) then
			local wasHit = self.player:getHit(v.dmg)
			if wasHit then
				self.bottomFight.text = "OUCH"
				if self.player.isDead then
					self.level = self.level - 1
				end
			else
				self.bottomFight.text = "PARRY"
				engine.sfx.parry:play("next")
			end
			v:onEnd()
			table.insert(mustRemove, i)
		elseif v.dir.x > 0 and v:collide(self.boss.areaAnim) then
			self.boss:getHit(v.dmg)
			self.player:changeAnim8("yeah")
			if not self.boss.isDead then
				self.bottomFight.text = "NICE!"
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

function GameScreen:draw()
	self.topPath:draw()
	self.player:draw()
	
	if self.fight then
		self.bottomFight:draw()
		for i,v in ipairs(self.projectiles) do
			v:draw()
		end
	else
		self.bottomPath:draw()
	end
end

function GameScreen:onQuit()
	engine.playlistOutside:stop()
	engine.playlistInside:stop()
end

function GameScreen:backToNormal()
	self.proj = nil
	for i = 1, #self.projectiles do
		table.remove(self.projectiles, i)
	end
end

return GameScreen