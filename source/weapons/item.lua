import "CoreLibs/sprites"
import "Corelibs/frameTimer"
import "enemies/enemy"
import "weapons/projectiles/projectile"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("item").extends()

ftimer = pd.frameTimer.new(99)
ftimer.repeats = true

function item:init(user, name, image)
  self.ftimer = ftimer
  self.user = user
  self.name = name
  self.OGimage = gfx.image.new(image)
  self.image = {}
  for deg = 0, 358, 2 do
    if deg > 90 and deg < 270 then
      self.image[deg] = self.OGimage:scaledImage(1, -1):rotatedImage(deg)
    else
      self.image[deg] = self.OGimage:rotatedImage(deg)
    end
  end
  self.width, self.height = self.OGimage:getSize()
  self.angle = pd.getCrankPosition()
  self.sprite = gfx.sprite.new(self:getRotatedImage(self.angle - 90))
  self.sprite:moveTo(self.user.x + (math.cos(math.rad(self.angle - 90)) * 24), self.user.y + (math.sin(math.rad(self.angle - 90)) * 24))
  self.sprite:add()
end

function item:getRotatedImage(deg)
  return self.image[(math.floor(deg / 2) * 2) % 360]
end

function item:attack()
end

function item:update()
  -- print(ftimer.frame)

  self.angle = pd.getCrankPosition()
  self.sprite:setImage(self:getRotatedImage(self.angle - 90))
  self.x = self.user.x + (math.cos(math.rad(self.angle - 90)) * 24)
  self.y = self.user.y + (math.sin(math.rad(self.angle - 90)) * 24)
  self.sprite:moveTo(self.x, self.y)
  self:attack()
end