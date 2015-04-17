local Camera = {}

Camera.scaleValue = 1
Camera.scaleValueY = nil
Camera.x = 0
Camera.y = 0
Camera.dx = 0
Camera.dy = 0
Camera.ox = 0
Camera.oy = 0
Camera.follower = nil
Camera.angle = 0
Camera.mode = "normal"
Camera.shakeDuration = 0

function Camera:setMode(mode)
	EasyLD.camera.mode = mode
end

function Camera:scaleTo(scale, scaleY)
	EasyLD.camera:scale(scale - EasyLD.camera.scaleValue, (scaleY or scale) - (Camera.scaleValueY or Camera.scaleValue))
end

function Camera:scale(scale, scaleY)
	
end

function Camera:moveTo(x, y)
	EasyLD.camera:move(x - EasyLD.camera.x, y - EasyLD.camera.y)
end

function Camera:move(x, y)

end

function Camera:rotateTo(angle, ox, oy)
	EasyLD.camera:rotate(angle - EasyLD.camera.angle, ox, oy)
end

function Camera:rotate(angle, ox, oy)

end

function Camera:follow(obj)
	EasyLD.camera.follower = obj
end

function Camera:update(dt)
	if EasyLD.camera.follower ~= nil then
		local f = EasyLD.camera.follower
		EasyLD.camera.ox = f.x
		EasyLD.camera.oy = f.y
	end
	if EasyLD.camera.shakeDuration > 0 then
		EasyLD.camera.shakeDuration = EasyLD.camera.shakeDuration - dt
		EasyLD.camera:makeShake(EasyLD.camera.shakeVars)
	elseif EasyLD.camera.shakeOld ~= nil then
		local old = EasyLD.camera.shakeOld
		if old.x ~= nil then
			EasyLD.camera.x = old.x
		end
		if old.y ~= nil then
			EasyLD.camera.y = old.y
		end
		if old.angle ~= nil then
			EasyLD.camera.angle = old.angle
		end

		EasyLD.camera.shakeOld = nil
	end
end

function Camera:getPosition()
	local p = EasyLD.point:new(-EasyLD.camera.ox - EasyLD.camera.x, -EasyLD.camera.oy - EasyLD.camera.y)
	return p
end

function Camera:shake(vars, duration)
	EasyLD.camera.shakeVars = vars
	EasyLD.camera.shakeDuration = duration
	EasyLD.camera.shakeOld = {x = EasyLD.camera.x, y = EasyLD.camera.y, angle = EasyLD.camera.angle}
end

function Camera:makeShake(vars)
	if vars.x ~= nil then
		EasyLD.camera.x = EasyLD.camera.shakeOld.x + math.random(-vars.x, vars.x)
	end
	if vars.y ~= nil then
		EasyLD.camera.y = EasyLD.camera.shakeOld.y + math.random(-vars.y, vars.y)
	end
	if vars.angle ~= nil then
		EasyLD.camera.angle = EasyLD.camera.shakeOld.angle + (math.random() - 0.5) * vars.angle
	end
end

return Camera