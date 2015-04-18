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
	self.bottomPath = BottomPath:new(4, self.player)
	self.topPath = TopPath:new(self.player, self.bottomPath)
	self.projectiles = {}

	---
	font = EasyLD.font:new("assets/fonts/FORCED_SQUARE.ttf")
	font:load(16, EasyLD.color:new(255,255,255))

	self.fight = false
	self.level = 1
	self.topPath:changeLevel(1, self.fight, self.bottomPath)
end

function GameScreen:preCalcul(dt)
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
			self.bottomPath = BottomPath:new(4, self.player, self.level)
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
		elseif v.dir.x > 0 and v:collide(self.boss.sprite) then
			self.boss:getHit(v.dmg)
			v:onEnd()
			table.insert(mustRemove, i)
		end
	end

	for i,v in ipairs(mustRemove) do
		table.remove(self.projectiles, v)
	end
end

function GameScreen:draw()
	self.topPath:draw()

	if self.fight then
		self.bottomFight:draw()
		for i,v in ipairs(self.projectiles) do
			v:draw()
		end
	else
		self.bottomPath:draw()
	end

	self.player:draw()
end

function GameScreen:onQuit()
end

return GameScreen