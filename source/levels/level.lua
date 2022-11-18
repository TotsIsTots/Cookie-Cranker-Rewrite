local pd <const> = playdate
local gfx <const> = pd.graphics

class("level").extends()

function level:init(x, y, imagePath, hitboxPath)
  self.x = x
  self.y = y
  self.offx = 0
  self.offy = 0
  self.image = gfx.image.new(imagePath)
  self.hitbox = gfx.image.new(hitboxPath)
  self.width, self.height = self.image:getSize()
end

function level:draw()
  self.image:draw(self.x + self.offx, self.y + self.offy)
end
