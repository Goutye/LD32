local class = require 'middleclass'

local IScreen = require 'screen.IScreen'
local GameScreen = class('GameScreen', IScreen)

local TopPath = require 'TopPath'
local BottomPath = require 'BottomPath'
local BottomFight = require 'BottomFight'
local Player = require 'Player'
local Boss = require 'Boss'

function GameScreen:initialize()
	---
	self.player = Player:new()
	self.bottomPath = BottomPath:new(2, self.player)
	self.topPath = TopPath:new(self.player, self.bottomPath)
	self.projectiles = {}

	---
	font = EasyLD.font:new("assets/fonts/FORCED_SQUARE.ttf")
	font:load(16, EasyLD.color:new(255,255,255))

	self.fight = false
	self.level = 1
	self.topPath:changeLevel(1, self.fight, self.bottomPath)

	self.lastDt = 1
	self.slower = false
end

function GameScreen:preCalcul(dt)
	if self.proj ~= nil then
		if self.proj.dmg > self.boss.life and not self.boss.isDead then
			self.slower = true
			dt = dt * math.min(1/10 + (self.boss.areaAnim.x - self.proj.sprite.x)/(WINDOW_WIDTH/4)*9/10, 1)
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
	self.topPath:update(dt, self.fight)

	if self.fight then
		self.bottomFight:update(dt)
		if self.bottomFight.isEnd then
			self.level = self.level + 1
			self.fight = false
			self.projectiles = {}
			self.bottomPath = BottomPath:new(2, self.player, self.level)
			self.topPath:changeLevel(self.level, self.fight, self.bottomPath)
		end
	else
		self.bottomPath:update(dt, self.topPath.level:getProgress())
		if self.bottomPath.isEnd then
			self.fight = true
			self.boss = Boss:new(self.level)
			self.bottomFight = BottomFight:new(1, self.player, self.boss, self.level)
			self.topPath:changeLevel(self.level, self.fight, self.bottomFight)
		end
	end

	self.player:update(dt)

	local mustRemove = {}

	for i,v in ipairs(self.projectiles) do
		v:update(dt)
		if v.dir.x < 0 and v:collide(self.player.sprite) then
			self.player:getHit(v.dmg)
			v:onEnd()
			table.insert(mustRemove, i)
		elseif v.dir.x > 0 and v:collide(self.boss.areaAnim) then
			self.boss:getHit(v.dmg)
			self.player:changeAnim8("yeah")
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
end

function GameScreen:backToNormal()
	self.proj = nil
	print("ok")
end

return GameScreen