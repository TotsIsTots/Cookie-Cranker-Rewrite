import "player"
import "enemies/enemy"
import "weapons/item"
import "weapons/salkowski/salkowski"
import "weapons/big_iron/big_iron"
import "levels/level"
import "camera"

-- local level = level(0, 0, "levels/leveltest/leveltest.png", "levels/leveltest/leveltesthitbox.png")
local level = leveltest()
player = player(0, 100, level, 5, 1)
local weapon = big_iron(player)
print(weapon.isa(item))
local camera = camera("object", player)
level:spawnEnemies()

local pd <const> = playdate
local gfx <const> = pd.graphics
local font = gfx.font.new('font/Mini Sans 2X')

local function loadGame()
	playdate.display.setRefreshRate(50) -- Sets framerate to 50 fps
	math.randomseed(playdate.getSecondsSinceEpoch()) -- seed for math.random
	gfx.setFont(font)

	camera:setLimit(level.x - (level.width / 2), level.x + (level.width / 2), level.y - (level.height / 2), level.y + (level.height / 2))

end

local function updateGame()
	camera:update()
	gfx.setDrawOffset(-camera.x + 200, -camera.y + 120)
	player:update()
	weapon:update()
	if pd.buttonIsPressed("a") then
		camera:setTarget("position", {0, 0})
	end
	if pd.buttonIsPressed("b") then
		camera:setTarget("object", player)
	end
	
	gfx.sprite.update()
	levels.update()
	pd.frameTimer.updateTimers()
	projectiles.update(1)
end

local function drawGame()
end

loadGame()

function playdate.update()
	updateGame()
	drawGame()
	playdate.drawFPS(0,0) -- FPS widget
end