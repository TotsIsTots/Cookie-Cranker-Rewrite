class("leveltest").extends(level)

function leveltest:init()
  level.init(self, 0, 0, "levels/leveltest/leveltest.png", "levels/leveltest/leveltesthitbox.png")
end

function leveltest:spawnEnemies()
  self.enemyList = {
    enemy(0, -100, self, 3, .5, 2, 1, "enemies/shrimp/shrimp.png", "enemies/shrimp/shrimphitbox.png", "shrimp", "object", player)
  }
  for i = 1, #self.enemyList do
    self.enemyList[i]:spawn()
  end
end

function leveltest:update()
  print(self.ftimer.frame)
  if self.ftimer.frame == 0 then
    self:spawnEnemies()
  end
end