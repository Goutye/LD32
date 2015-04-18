package.path = package.path .. ';src/?.lua'
package.path = package.path .. ';lib/?.lua'
package.path = package.path .. ';lib/EasyLD/?.lua'

ezld = require 'EasyLD'

local Engine = require 'Engine'
local GameScreen = require 'screen.GameScreen'

WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600

engine = nil

function EasyLD:load()
	EasyLD.window:resize(WINDOW_WIDTH, WINDOW_HEIGHT)
	engine = Engine:new(GameScreen:new())
end

function EasyLD:preCalcul(dt)
	return engine:preCalcul(dt)
end

function EasyLD:update(dt)
	engine:update(dt)
end

function EasyLD:draw()
	engine:draw()
end