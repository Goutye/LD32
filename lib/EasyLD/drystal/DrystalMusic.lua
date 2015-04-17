local class = require 'middleclass'

local Music = class('Music')

function Music:initialize(name)
	self.m = drystal.load_music(name)
	self.looping = false
	self.isPlaying = false
	self.isPaused = false
	self.isStopped = true
end

function Music:play(callback)
	self.m:play(self.looping, callback)
	--TODO => Callback BUT callback to put isPlaying to false (Easy => self:onEnd(callback))
	self.isPlaying = true
	self.isPaused = false
	self.isStopped = false
end

function Music:stop()
	self.m:stop()
	self.isPlaying = false
	self.isPaused = false
end

function Music:pause()
	self.m:pause()
	self.isPaused = true
end

function Music:rewind()
	if self:isPlaying() then
		self.m:stop()
		self.m:play()
	else
		self.m:stop()
	end
end

function Music:isPlaying()
	return self.isPlaying
end

function Music:isPaused()
	return self.isPaused
end

function Music:isStopped()
	return self.isStopped
end

function Music:setCurrentTime(nbSeconds)
	print("Not yet implemented in drystal")
end

function Music:getCurrentTime()
	print("Not yet implemented in drystal")
	return 0
end

function Music:setPosition(x, y, z)
	print("Not yet implemented in drystal")
end

function Music:setDirection(x, y, z)
	print("Not yet implemented in drystal")
end

function Music:setVelocity(x, y, z)
	print("Not yet implemented in drystal")
end

function Music:setLooping(bool)
	self.looping = bool
end

function Music:setPitch(n)
	self.m:set_pitch(n)
end

function Music:setVolume(v)
	self.m:set_volume(v)
end

return Music