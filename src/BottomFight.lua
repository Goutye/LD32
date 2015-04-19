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
	self.player.areaAnim:moveTo(30 , self.h * 3 + self.h/2 - self.player.sprite.forms[1].h/2)
	self.posPlayer = EasyLD.point:new(30, 0)

	self.timeEase = 0.5
	self.typeEase = "quadout"

	self.boss = boss
	self.boss:moveTo(WINDOW_WIDTH - 100 , self.h * 3 + self.h/2 - self.boss.sprite.forms[1].h/2)

	self.tileset = EasyLD.tileset:new("assets/tilesets/tileset.png", 32, 32)
	self.map = EasyLD.map:new("assets/maps/inside.map", self.tileset)
	self.mapDec = EasyLD.point:new(0,0)
	self.mapBegin = EasyLD.point:new(0,0)
end

function BottomFight:generate()

end

function BottomFight:onEnd()
	self.isEnd = true
	self.boss:reset()
	self.player:restore()
	self.boss:stop()
end

function BottomFight:update(dt)
	if self.boss.isDead then
		self.text = "K.O.!"
		self.timer = EasyLD.timer.after(0.4, self.onEnd, self)
	elseif self.player.isDead then
		self.text = "YOU DIED"
		self.timer = EasyLD.timer.after(0.4, self.onEnd, self)
		--GO BACK => UI YOU DIED, TRY AGAIN
	end
end

function BottomFight:goNext(id)
	
end

function BottomFight:goBack()
	
end

function BottomFight:draw()
	self.background:draw()
	self.map:draw(math.floor(self.mapDec.x), self.mapDec.y + self.h * 3, 30, 5, self.mapBegin.x, self.mapBegin.y)
	self.player.currentAnim8:draw()
	self.boss:draw()
	self.player:drawUI()
	self.boss:drawUI()
end

return BottomFight