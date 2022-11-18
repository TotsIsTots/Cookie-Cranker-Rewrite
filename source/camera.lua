local pd <const> = playdate
local gfx <const> = pd.graphics

class("camera").extends()

function camera:init(targetType, target, --[[optional]]easing)
  self.targetType = targetType
  self.target = target
  if self.targetType == "position" then
    self.x = self.target[1]
    self.y = self.target[2]
  elseif self.targetType == "object" then
    self.x = self.target.x
    self.y = self.target.y
  else
    error("Invalid camera target type: " .. self.targetType .. ". Must be 'position' or 'object'.")
  end
  self.easing = easing or 0.1
  self.limit = {x = {min = -9999999999, max = 9999999999}, y = {min = 9999999999, max = 9999999999}}
end

function camera:setLimit(xmin, xmax, ymin, ymax)
  self.limit.x.min = xmin
  self.limit.x.max = xmax
  self.limit.y.min = ymin
  self.limit.y.max = ymax
end

function camera:setTarget(targetType, target)
  self.targetType = targetType
  self.target = target
end

function camera:update()
  if self.targetType == "position" then
    self.x = math.max(math.min(self.x + ((self.target[1] - self.x) * self.easing), self.limit.x.max - 200), self.limit.x.min + 200)
    self.y = math.max(math.min(self.y + ((self.target[2] - self.y) * self.easing), self.limit.y.max - 120), self.limit.y.min + 120)
  elseif self.targetType == "object" then
    self.x = math.max(math.min(self.x + ((self.target.x - self.x) * self.easing), self.limit.x.max - 200), self.limit.x.min + 200)
    self.y = math.max(math.min(self.y + ((self.target.y - self.y) * self.easing), self.limit.y.max - 120), self.limit.y.min + 120)
  end
end

