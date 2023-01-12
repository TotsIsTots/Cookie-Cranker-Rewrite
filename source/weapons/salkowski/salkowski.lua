local pd <const> = playdate
local gfx <const> = pd.graphics

class("salkowski").extends(item)

function salkowski:init(user)
  salkowski.super.init(self, user, "Salkowski", "weapons/salkowski/salkowski.png")
  self.damage = 1
end

function salkowski:attack()    
  -- loop through all enemies and check collision
  for i = 1, #enemies do
    local enemy = enemies[i]
    if gfx.checkAlphaCollision
    (enemy.hitbox, enemy.x - (enemy.width / 2), enemy.y - (enemy.height / 2), gfx.kImageUnflipped,
    self:getRotatedImage(self.angle - 90), self.x - (self.width / 2), self.y - (self.height / 2), gfx.kImageUnflipped)
    then
      enemy:takeDamage(self.damage, math.rad(self.angle - 90), 10)
    end
  end
end