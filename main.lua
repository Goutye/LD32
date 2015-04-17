package.path = package.path .. ';src/?.lua'
package.path = package.path .. ';lib/?.lua'
package.path = package.path .. ';lib/EasyLD/?.lua'

ezld = require 'EasyLD'

WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600

function EasyLD:load()
	EasyLD.window:resize(WINDOW_WIDTH, WINDOW_HEIGHT)
end


function EasyLD:update(dt)

end

function EasyLD:draw()

end