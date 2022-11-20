local pd <const> = playdate
local gfx <const> = pd.graphics

class("level").extends()

function level:init(x, y, imagePath, hitboxPath)
  self.x = x
  self.y = y
  self.image = gfx.image.new(imagePath)
  self.sprite = gfx.sprite.new(self.image)
  self.sprite:moveTo(self.x, self.y)
  self.sprite:add()
  self.sprite:setZIndex(-32768)
  self.hitbox = gfx.image.new(hitboxPath)
  self.width, self.height = self.image:getSize()
end

function level:draw()
end
