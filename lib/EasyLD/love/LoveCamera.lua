local Camera = {}

function Camera:scale(scale, scaleY)
	EasyLD.camera.scaleValue = EasyLD.camera.scaleValue + scale

	if scaleY ~= nil then
		EasyLD.camera.scaleValueY = (Camera.scaleValueY or 1) + scaleY
	end
end

function Camera:move(dx, dy, time, ...)
	if EasyLD.camera.mode ~= "normal" then
		local tween = EasyLD.flux.to(EasyLD.camera, time, {x = EasyLD.camera.x + dx, y = EasyLD.camera.y + dy}, ...):ease(EasyLD.camera.mode)
	else
		EasyLD.camera.x = EasyLD.camera.x + dx
		EasyLD.camera.y = EasyLD.camera.y + dy
	end
end

function Camera:rotate(angle, ox, oy, time, ...)
	if ox ~= nil and oy ~= nil then
		EasyLD.camera.ox = ox
		EasyLD.camera.oy = oy
	end

	if EasyLD.camera.mode ~= "normal" then
		local tween = EasyLD.flux.to(EasyLD.camera, time, {angle = EasyLD.camera.angle + angle}, ...):ease(EasyLD.camera.mode)
	else
		EasyLD.camera.angle = EasyLD.camera.angle + angle
	end
end

function Camera:draw()
	love.graphics.translate(EasyLD.window.w/2, EasyLD.window.h/2)
	love.graphics.rotate(-EasyLD.camera.angle)
	love.graphics.translate(-EasyLD.window.w/2, -EasyLD.window.h/2)
	love.graphics.translate(-EasyLD.camera.ox - EasyLD.camera.x, -EasyLD.camera.oy - EasyLD.camera.y)
	love.graphics.scale(EasyLD.camera.scaleValue, EasyLD.camera.scaleValueY or EasyLD.camera.scaleValueY)
end

return Camera