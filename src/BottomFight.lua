local class = require 'middleclass'

local BottomFight = class('BottomFight')

function BottomFight:initialize(level, player, boss)
	self.h = WINDOW_HEIGHT / 4
	self.nbSteps = nbSteps
	self.area = nil
	self.background = EasyLD.box:new(0, self.h * 3, WINDOW_WIDTH, self.h, EasyLD.color:new(0,0,0), "fill")

	self.player = player
	self.player:restore()
	self.player.sprite:moveTo(30 , self.h * 3 + self.h/2 - self.player.sprite.forms[1].h/2)
	self.posPlayer = EasyLD.point:new(30, 0)

	self.timeEase = 0.5
	self.typeEase = "quadout"

	self.boss = boss
	self.boss:moveTo(WINDOW_WIDTH - 100 , self.h * 3 + self.h/2 - self.boss.sprite.forms[1].h/2)
end

function BottomFight:generate()

end

function BottomFight:update(dt)
	if self.boss.isDead then
		self.isEnd = true
	elseif self.player.isDead then
		self.boss:reset()
		self.player:restore()
		--GO BACK => UI YOU DIED, TRY AGAIN
	end
end

function BottomFight:goNext(id)
	
end

function BottomFight:goBack()
	
end

function BottomFight:draw()
	self.background:draw()
	self.player.sprite:draw()
	self.boss:draw()
	self.player:drawUI()
	self.boss:drawUI()
end

return BottomFight