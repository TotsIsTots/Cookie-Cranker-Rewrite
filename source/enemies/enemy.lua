import "CoreLibs/sprites"
-- import "pathfinding"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("enemy").extends(gfx.sprite)

enemies = {}

function enemy:init(x, y, level, maxSpeed, acceleration, health, attack, imagePath, hitboxPath, name, targetType, target)
  self.level = level
  self.maxSpeed = maxSpeed
  self.acceleration = acceleration
  self.health = health
  self.attack = attack
  self.image = gfx.image.new(imagePath)
  self:setImage(self.image)
  self.x, self.y = x, y
  self.xvel, self.yvel = 0, 0
  self:moveTo(x, y)
  self.hitbox = gfx.image.new(hitboxPath)
  self.width, self.height = self.image:getSize()
  self.name = name

  self.targetType = targetType
  self.target = target

  -- attempt at A* pathfinding below, please ignore

  -- self.pathGrid = generateHitboxPathfindingGraph(self.hitbox, self.level.hitbox)
  -- if self.targetType == "object" then
  --   -- print(math.floor(self.x + (self.level.width / 2)), math.floor(self.y + (self.level.height / 2)))
  --   self.path = self.pathGrid:findPath(self.pathGrid:nodeWithXY(1, 1), self.pathGrid:nodeWithXY(3, 3))
  -- elseif self.targetType == "position" then
  --   self.path = self.pathGrid:findPath(self.pathGrid:nodeWithXY(1, 1), self.pathGrid:nodeWithXY(2, 2))
  -- else
  --   error("Invalid target type")
  -- end
  -- if self.targetType == "object" then
  --   print(math.floor(self.x + (self.level.width / 2)), math.floor(self.y + (self.level.height / 2)))
  --   self.path = self.pathGrid:findPath(self.pathGrid:nodeWithXY(math.floor(self.x + (self.level.width / 2)), math.floor(self.y + (self.level.height / 2))), self.pathGrid:nodeWithXY(math.floor(self.target.x + (self.level.width / 2)), math.floor(self.target.y + (self.level.height / 2))))
  -- elseif self.targetType == "position" then
  --   self.path = self.pathGrid:findPath(self.pathGrid:nodeWithXY(math.floor(self.x + (self.level.width / 2)), math.floor(self.y + (self.level.height / 2))), self.pathGrid:nodeWithXY(math.floor(self.target[1] + (self.level.width / 2)), math.floor(self.target[2] + (self.level.height / 2))))
  -- else
  --   error("Invalid target type")
  -- end

  --calculate direction to target
  if self.targetType == "object" then
    self.dir = math.atan(self.target.y - self.y, self.target.x - self.x)
  elseif self.targetType == "position" then
    self.dir = math.atan(self.target[2] - self.y, self.target[1] - self.x)
  else
    error("Invalid target type")
  end

  self.player = player

  enemies[#enemies + 1] = self
end

function enemy:spawn()
  self:add()
end

function enemy:move()
  if self.targetType == "object" then
    self.dir = math.atan(-(self.target.y - self.y), self.target.x - self.x)
    if self.dir < 0 then
      self.dir = self.dir + 2 * math.pi
    end
  elseif self.targetType == "position" then
    self.dir = math.atan(-(self.target[2] - self.y), self.target[1] - self.x)
    if self.dir < 0 then
      self.dir = self.dir + 2 * math.pi
    end
  else
    error("Invalid target type")
  end
  -- accelerate towards target
  self.xvel += self.acceleration * math.cos(self.dir)
  self.yvel += self.acceleration * math.sin(self.dir)

  local speed = math.sqrt(self.xvel ^ 2 + self.yvel ^ 2)
  if speed > self.maxSpeed then
    self.xvel = self.xvel / speed * self.maxSpeed
    self.yvel = self.yvel / speed * self.maxSpeed
  end
--check collision
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


  -- move
  self.x += self.xvel
  self.y -= self.yvel
  self:moveTo(self.x, self.y)
end

function enemy:takeDamage(damage, dir, knockback)
  self.health -= damage
  if dir ~= nil then
    self.xvel += math.cos(dir) * (knockback or 3)
    self.yvel += math.sin(dir) * (knockback or 3)
  end
end
function enemy:update()
  self:move()
  
  -- check if colliding with player
  if gfx.checkAlphaCollision
  (self.hitbox, self.x - (self.width / 2), self.y - (self.height / 2), gfx.kImageUnflipped,
  player.hitbox, player.x - (player.width / 2), player.y - (player.height / 2), gfx.kImageUnflipped)
  then
    player:takeDamage(self.attack, self.dir, 5)
    self.xvel -= math.cos(self.dir) * 5
    self.yvel -= math.sin(self.dir) * 5
  end

  --check if coliding with projectiles
  for i = #projectiles, 1, -1 do
    if gfx.checkAlphaCollision
    (self.hitbox, self.x - (self.width / 2), self.y - (self.height / 2), gfx.kImageUnflipped,
    projectiles[i].image, projectiles[i].x - (projectiles[i].width / 2), projectiles[i].y - (projectiles[i].height / 2), gfx.kImageUnflipped)
    then
      self:takeDamage(projectiles[i].damage, projectiles[i].angle, projectiles[i].knockback)
      -- projectiles[i]:remove()
    end
  end
  -- check if dead
  if self.health <= 0 then
    self:remove()
  end
end