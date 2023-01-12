import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("player").extends()

function player:init(x, y, level, --[[optional]]maxSpeed, --[[optional]]acceleration)
  self.level = level

  self.x = x
  self.y = y
  self.dir = 0
  self.maxSpeed = maxSpeed or 5
  self.xvel = 0
  self.yvel = 0
  self.accel = acceleration or 0.5
  self.image = gfx.image.new("images/player.png")
  self.hitbox = gfx.image.new("images/playerhitbox.png")
  self.width, self.height = self.image:getSize()
  self.sprite = gfx.sprite.new(self.image)
  self.sprite:moveTo(self.x, self.y)
  self.sprite:add()

  self.health = 10
end


function player:move()
  -- set direction
  local dirx
  local diry
  local moving = false
  if pd.buttonIsPressed("left") then
    dirx = math.pi
    moving = true
  elseif pd.buttonIsPressed("right") then
    dirx = 0
    moving = true
  else
    dirx = nil
  end
  if pd.buttonIsPressed("up") then
    diry = math.pi / 2
    moving = true
  elseif pd.buttonIsPressed("down") then
    diry = math.pi * 3 / 2
    moving = true
  else
    diry = nil
  end
  
  -- set self.dir to average of dirx and diry
  if dirx and diry then
    if dirx == 0 and diry == math.pi * 3 / 2 then
      dirx = 2 * math.pi
    end
    self.dir = (dirx + diry) / 2
  elseif dirx then
    self.dir = dirx
  elseif diry then
    self.dir = diry
  end

  -- move player
  if moving then
    -- accelerate to maxSpeed
    self.xvel += math.cos(self.dir) * self.accel
    self.yvel += math.sin(self.dir) * self.accel
    local speed = math.sqrt(self.xvel ^ 2 + self.yvel ^ 2)
    if speed > self.maxSpeed then
      self.xvel = self.xvel / speed * self.maxSpeed
      self.yvel = self.yvel / speed * self.maxSpeed
    end

  else
    -- accelerate to 0
    if self.xvel > 0 then
      self.xvel -= self.accel
      if self.xvel < 0 then
        self.xvel = 0
      end
    elseif self.xvel < 0 then
      self.xvel += self.accel
      if self.xvel > 0 then
        self.xvel = 0
      end
    end
    if self.yvel > 0 then
      self.yvel -= self.accel
      if self.yvel < 0 then
        self.yvel = 0
      end
    elseif self.yvel < 0 then
      self.yvel += self.accel
      if self.yvel > 0 then
        self.yvel = 0
      end
    end
  end
  if gfx.checkAlphaCollision
  (self.hitbox, self.x + self.xvel - (self.width / 2), self.y - (self.height / 2), gfx.kImageUnflipped, 
  self.level.hitbox, self.level.x - (self.level.width / 2), self.level.y - (self.level.height / 2), gfx.kImageUnflipped)
  then
    self.xvel = 0
  end
  if gfx.checkAlphaCollision
  (self.hitbox, self.x - (self.width / 2), self.y - self.yvel - (self.height / 2), gfx.kImageUnflipped, 
  self.level.hitbox, self.level.x - (self.level.width / 2), self.level.y - (self.level.height / 2), gfx.kImageUnflipped)
  then
    self.yvel = 0
  end
  self.x += self.xvel
  self.y -= self.yvel
  
  self.sprite:moveTo(self.x, self.y)

  if gfx.checkAlphaCollision
  (self.hitbox, self.x - (self.width / 2), self.y - (self.height / 2), gfx.kImageUnflipped, 
  self.level.hitbox, self.level.x - (self.level.width / 2), self.level.y - (self.level.height / 2), gfx.kImageUnflipped) 
  then
    self.x -= self.xvel
    self.y += self.yvel
    self.sprite:moveTo(self.x, self.y)
    self.xvel = 0
    self.yvel = 0
  end

end

function player:takeDamage(damage, dir, knockback)
  self.health -= damage
  if dir ~= nil then
    self.xvel += math.cos(dir) * (knockback or 3)
    self.yvel += math.sin(dir) * (knockback or 3)
  end
end

function player:update()
  self:move()
end