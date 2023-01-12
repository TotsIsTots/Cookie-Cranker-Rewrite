local pd <const> = playdate
local gfx <const> = pd.graphics

class("projectile").extends()

projectiles = {}

function projectile:init(imagePath, x, y, angle, speed, damage, knockback, lifetime)
  self.angle = math.rad(angle)
  self.image = gfx.image.new(imagePath)
  if angle > 90 and angle < 270 then
    self.image = self.image:scaledImage(1, -1):rotatedImage(math.deg(self.angle))
  else
    self.image = self.image:rotatedImage(math.deg(self.angle))
  end
  self.x = x
  self.y = y
  self.width, self.height = self.image:getSize()
  self.speed = speed
  self.damage = damage
  self.knockback = knockback
  self.lifetime = lifetime
  self.sprite = gfx.sprite.new(self.image)
  self.sprite:moveTo(self.x, self.y)
  self.sprite:add()
  table.insert(projectiles, self)
end

function projectile:update(dt)
  self.lifetime = self.lifetime - dt
  if self.lifetime <= 0 then
    self.sprite:remove()
    self = nil
    return
  end
  self.x = self.x + math.cos(self.angle) * self.speed * dt
  self.y = self.y + math.sin(self.angle) * self.speed * dt
  self.sprite:moveTo(self.x, self.y)
end

function projectiles.update(dt)
  for i = #projectiles, 1, -1 do
    projectiles[i]:update(dt)
    if projectiles[i].lifetime <= 0 then
      table.remove(projectiles, i)
    end
  end
end