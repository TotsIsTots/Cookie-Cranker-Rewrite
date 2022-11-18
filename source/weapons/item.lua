import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("item").extends()

function item:init(user, name, image)
  self.user = user
  self.name = name
  self.OGimage = gfx.image.new(image)
  -- make self.image, an array with a key of every even number 0 to 358
  self.image = {}
  for deg = 0, 358, 2 do
    self.image[deg] = self.OGimage:rotatedImage(deg)
  end
  self.angle = pd.getCrankPosition()
  self.sprite = gfx.sprite.new(self:getRotatedImage(self.angle - 90))
  self.sprite:moveTo(self.user.x + self.user.offx + (math.cos(math.rad(self.angle - 90)) * 24), self.user.y + self.user.offy + (math.sin(math.rad(self.angle - 90)) * 24))
  self.sprite:add()
end

function item:getRotatedImage(deg)
  return self.image[(math.floor(deg / 2) * 2) % 360]
end

function item:update()
  self.angle = pd.getCrankPosition()
  self.sprite:setImage(self:getRotatedImage(self.angle - 90))
  self.sprite:moveTo(self.user.x + self.user.offx + (math.cos(math.rad(self.angle - 90)) * 24), self.user.y + self.user.offy + (math.sin(math.rad(self.angle - 90)) * 24))
end