local class = require 'middleclass'

local Engine = class('Engine')

function Engine:initialize(screen)
	self.nextScreen = nil
	self.screen = screen

	local s = {}
	s.bossCast = EasyLD.music:new("assets/sfx/bossCast.wav", true)
	s.bossDead = EasyLD.music:new("assets/sfx/bossDead.wav", true)
	s.explode = EasyLD.music:new("assets/sfx/explode.wav", true)
	s.fail = EasyLD.music:new("assets/sfx/fail.wav", true)
	s.missileOut = EasyLD.music:new("assets/sfx/missileOut.wav", true)
	s.ok = EasyLD.music:new("assets/sfx/ok.wav", true)
	s.parry = EasyLD.music:new("assets/sfx/parry.wav", true)
	s.pickup = EasyLD.music:new("assets/sfx/pickup.wav", true)
	s.star = EasyLD.music:new("assets/sfx/star.wav", true)
	s.speed = EasyLD.music:new("assets/sfx/speed.wav", true)
	s.slow = EasyLD.music:new("assets/sfx/slow.wav", true)
	s.attack = EasyLD.music:new("assets/sfx/attack.wav", true)
	s.defense = EasyLD.music:new("assets/sfx/defense.wav", true)
	s.youaredead = EasyLD.music:new("assets/sfx/youaredead.wav", true)
	s.KO = EasyLD.music:new("assets/sfx/KO.wav", true)
	s.bossHit = EasyLD.music:new("assets/sfx/bossHit.wav", true)

	self.sfx = s

	local p = EasyLD.playlist:new("inside")
	local m, mBool = {}, {false, false, false, false, false}
	table.insert(m, EasyLD.music:new("assets/music/1.ogg"))
	table.insert(m, EasyLD.music:new("assets/music/2.ogg"))
	table.insert(m, EasyLD.music:new("assets/music/3.ogg"))
	table.insert(m, EasyLD.music:new("assets/music/4.ogg"))
	table.insert(m, EasyLD.music:new("assets/music/5.ogg"))
	for i,v in ipairs(m) do
		v:setLooping(true)
		v:setVolume(0.5)
	end

	self.musicTitle = m[4]
	m[4]:play()
	
	for i = 1, #m do
		local choice = math.random(1,#m)
		while mBool[choice] do
			choice = math.random(1,#m)
		end
		p:add(m[choice])
		mBool[choice] = true
	end

	self.playlistInside = p

	local p = EasyLD.playlist:new("outside")
	local m, mBool = {}, {false, false, false, false, false, false}
	table.insert(m, EasyLD.music:new("assets/music/1_out.ogg"))
	table.insert(m, EasyLD.music:new("assets/music/2_out.ogg"))
	table.insert(m, EasyLD.music:new("assets/music/3_out.ogg"))
	table.insert(m, EasyLD.music:new("assets/music/4_out.ogg"))
	table.insert(m, EasyLD.music:new("assets/music/5_out.ogg"))
	table.insert(m, EasyLD.music:new("assets/music/6_out.ogg"))
	for i,v in ipairs(m) do
		v:setLooping(true)
		v:setVolume(0.5)
	end
	for i = 1, #m do
		local choice = math.random(1,#m)
		while mBool[choice] do
			choice = math.random(1,#m)
		end
		p:add(m[choice])
		mBool[choice] = true
	end

	self.playlistOutside = p

	self.musicEnd = EasyLD.music:new("assets/music/end.ogg")
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

function Engine:setNextScreen(screen)
	self.nextScreen = screen
end

return Engine