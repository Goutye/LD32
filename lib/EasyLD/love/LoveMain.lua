function love.load()
	EasyLD:load()
end

function love.update(dt)
	EasyLD:update(dt)
	EasyLD:updateComponents(dt)
end

function love.draw()
	EasyLD.camera:draw()
	EasyLD:draw()
end