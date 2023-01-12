local pd <const> = playdate
local gfx <const> = pd.graphics

class('big_iron').extends(item)

function big_iron:init(user)
  big_iron.super.init(self, user, "Big Iron", "weapons/big_iron/big_iron.png")
  self.damage = 5
end

function big_iron:attack()
  if self.ftimer.frame % 25 == 0 then
    bullet = projectile("weapons/projectiles/smallbullet/smallbullet.png", self.x, self.y, self.angle - 90, 10,
      self.damage, 0, 50)
  end
end
