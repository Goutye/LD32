local class = require 'middleclass'

local Engine = class('Engine')

function Engine:initialize(screen)
	self.nextScreen = nil
	self.screen = screen
end

function Engine:preCalcul(dt)
	return self.screen:preCalcul(dt)
end

function Engine:update(dt)
	if self.nextScreen ~= nil then
		self.screen:onQuit()
		self.screen = self.nextScreen
		self.nextScreen = nil
	end

	self.screen:update(dt)
end

function Engine:draw()
	self.screen:draw()
end

return Engine