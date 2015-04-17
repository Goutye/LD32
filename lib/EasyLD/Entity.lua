local class = require 'middleclass'

local Entity = class('Entity')

function Entity:initialize(pos, collideArea, spriteAnimation)
	self.pos = pos
	self.collideArea = collideArea
	self.spriteAnimation = spriteAnimation
end

function Entity:collide(otherEntity)
	return self.collideArea:collide(otherEntity.collideArea)
end

function Entity:draw()
	if self.spriteAnimation ~= nil then
		self.spriteAnimation:draw(self.pos)
end

return Entity