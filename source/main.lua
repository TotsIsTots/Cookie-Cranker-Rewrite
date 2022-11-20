import "player"
import "weapons/item"
import "levels/level"
import "camera"

local level = level(0, 0, "images/leveltest.png", "images/leveltesthitbox.png")
local player = player(0, 0, level, 5, 1)
local knife = item(player, "knife", "images/knife.png")
local camera = camera("object", player)

local pd <const> = playdate
local gfx <const> = pd.graphics
local font = gfx.font.new('font/Mini Sans 2X')

local function loadGame()
	playdate.display.setRefreshRate(50) -- Sets framerate to 50 fps
	math.randomseed(playdate.getSecondsSinceEpoch()) -- seed for math.random
	gfx.setFont(font)

	camera:setLimit(level.x - (level.width / 2), level.x + (level.width / 2), level.y - (level.height / 2), level.y + (level.height / 2))
	-- camera:setLimit(0, 0, -80, 80)

end

local function updateGame()
	camera:update()
	gfx.setDrawOffset(-camera.x + 200, -camera.y + 120)
	player:update()
	knife:update()
	if pd.buttonIsPressed("a") then
		camera:setTarget("position", {0, 0})
	end
	if pd.buttonIsPressed("b") then
		camera:setTarget("object", player)
	end
	
	gfx.sprite.update()
end

local function drawGame()
	level:draw()
end

loadGame()

function playdate.update()
	updateGame()
	drawGame()
	playdate.drawFPS(0,0) -- FPS widget
end