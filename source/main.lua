import "player"
local player = player(100, 100, 5, 1)

local gfx <const> = playdate.graphics
local font = gfx.font.new('font/Mini Sans 2X')

local function loadGame()
	playdate.display.setRefreshRate(50) -- Sets framerate to 50 fps
	math.randomseed(playdate.getSecondsSinceEpoch()) -- seed for math.random
	gfx.setFont(font)
end

local function updateGame()
	gfx.sprite.update()
	player:update()
end

local function drawGame()

end

loadGame()

function playdate.update()
	updateGame()
	drawGame()
	playdate.drawFPS(0,0) -- FPS widget
end