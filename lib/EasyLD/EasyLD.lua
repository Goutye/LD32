local class = require 'middleclass'

require 'lib.utf8'
require "table_io"

EasyLD = {}
EasyLD.tileset = require 'Tileset'
EasyLD.map = require 'Map'
EasyLD.spriteAnimation = require 'SpriteAnimation'
EasyLD.areaAnimation = require 'AreaAnimation'
EasyLD.camera = require 'Camera'

EasyLD.matrix = require 'Matrix'
EasyLD.vector = require 'Vector'
EasyLD.collide = require 'Collide'

EasyLD.area = require 'Area'
EasyLD.polygon = require 'Polygon'
EasyLD.box = require 'Box'
EasyLD.circle = require 'Circle'
EasyLD.segment = require 'Segment'
EasyLD.point = require 'Point'

EasyLD.color = require 'Color'
EasyLD.font = require 'Font'
EasyLD.printTimed = require 'PrintTimed'

EasyLD.playlist = require 'Playlist'

EasyLD.mouse = require 'Mouse'
EasyLD.keyboard = require 'Keyboard'

EasyLD.inputText = require 'InputText'
EasyLD.timer = require 'cron'
EasyLD.flux = require 'flux'

local function loadAdapterImage(base)
	EasyLD.image = base
end

local function loadAdapterGraphics(base)
	EasyLD.graphics = base
end

local function loadAdapterMouse(base)
	EasyLD.mouse.getPosition = base.getPosition
end

local function loadAdapterFont(base)
	EasyLD.font.newFont = base.newFont
	EasyLD.font.printAdapter = base.printAdapter
	EasyLD.font.printOutLineAdapter = base.printOutLineAdapter
	EasyLD.font.sizeOfAdapter = base.sizeOfAdapter
end

local function loadAdapterWindow(base)
	EasyLD.window = base
end

local function loadAdapterCamera(base)
	EasyLD.camera.scale = base.scale
	EasyLD.camera.move = base.move
	EasyLD.camera.rotate = base.rotate
	EasyLD.camera.draw = base.draw
end

local function loadAdapterMusic(base)
	EasyLD.music = base
end

local function loadAPI(name)
	if name == "Drystal" then
		drystal = require 'drystal'
		require 'drystal.DrystalMain'
		require 'drystal.DrystalKeyboard'
		loadAdapterMouse(require 'drystal.DrystalMouse')
		loadAdapterGraphics(require 'drystal.DrystalGraphics')
		loadAdapterImage(require 'drystal.DrystalImage')
		loadAdapterFont(require 'drystal.DrystalFont')
		loadAdapterMusic(require 'drystal.DrystalMusic')
		loadAdapterWindow(require 'drystal.DrystalWindow')
		loadAdapterCamera(require 'drystal.DrystalCamera')
	elseif name == "Löve2D" then
		require 'love.LoveMain'
		require 'love.LoveKeyboard'
		loadAdapterMouse(require 'love.LoveMouse')
		loadAdapterGraphics(require 'love.LoveGraphics')
		loadAdapterImage(require 'love.LoveImage')
		loadAdapterFont(require 'love.LoveFont')
		loadAdapterMusic(require 'love.LoveMusic')
		loadAdapterWindow(require 'love.LoveWindow')
		loadAdapterCamera(require 'love.LoveCamera')
	end
end

function EasyLD:updateComponents(dt)
	EasyLD.keyboard:reset()
	EasyLD.mouse:reset()
	EasyLD.timer.update(dt)
	EasyLD.flux.update(dt)
	EasyLD.camera:update(dt)
end

if love ~= nil then
	loadAPI("Löve2D")
else
	loadAPI("Drystal")
end

function string:split(delimiter)
	local result = { }
	local from = 1
	local delim_from, delim_to = string.find( self, delimiter, from)
	while delim_from do
		table.insert(result, string.sub(self, from , delim_from-1))
		from = delim_to + 1
		delim_from, delim_to = string.find(self, delimiter, from)
	end
	table.insert(result, string.sub( self, from ))
	return result
end

return EasyLD