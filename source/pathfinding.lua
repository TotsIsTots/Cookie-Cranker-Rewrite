local pd <const> = playdate
local gfx <const> = pd.graphics
local pf <const> = pd.pathfinder

function generateHitboxPathfindingGraph(actor, enviroment)
  grid = {}

  actorWidth, actorHeight = actor:getSize()
  enviromentWidth, enviromentHeight = enviroment:getSize()

  for x = 0, enviromentWidth - 1 do
    for y = 0, enviromentHeight - 1 do
      if gfx.checkAlphaCollision(actor, x - (actorWidth / 2), y - (actorHeight / 2), gfx.kImageUnflipped, enviroment, 0, 0, gfx.kImageUnflipped) then
        grid[#grid+1] = 0
      else
        grid[#grid+1] = 1
      end
    end
  end
  graph = pf.graph.new2DGrid(enviromentWidth, enviromentHeight, 1, grid)
  printTable(grid)
  for i = 1, #graph:allNodes() do
    print(graph:allNodes()[i].x, graph:allNodes()[i].y)
  end
  return graph
end