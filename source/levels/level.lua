import "enemies/enemy"
import "levels/leveltest/leveltest"


local pd <const> = playdate
local gfx <const> = pd.graphics

class("level").extends()

ftimer = pd.frameTimer.new(499)
ftimer.repeats = true

levels = {}

function level:init(x, y, imagePath, hitboxPath)
  self.ftimer = ftimer
  self.x = x
  self.y = y
  self.image = gfx.image.new(imagePath)
  self.sprite = gfx.sprite.new(self.image)
  self.sprite:moveTo(self.x, self.y)
  self.sprite:add()
  self.sprite:setZIndex(-32768)
  self.hitbox = gfx.image.new(hitboxPath)
  self.width, self.height = self.image:getSize()
  self.enemyList = {}

  levels[#levels+1] = self
end

function level:spawnEnemies(enemies)
  for i = 1, #enemies do
    self.enemyList[#self.enemyList+1] = enemies[i]
  end
end

function level:update()
  
end

function levels.update()
  for i = 1, #levels do
    levels[i]:update()
  end
end