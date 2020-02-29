--this script runs when connected to a server
gamestate = require('hump.gamestate')
server = require('server')
sock = require('sock')
vector = require('hump.vector')


game = {}
game.client = nil
width, height = love.graphics.getDimensions()

--variables for color and shit
local pixels = {}
local color = {1,0,0}
local brushSize = 5

local function draw(pos)
  pos = vector(pos.x/width,pos.y/height)
  local pixel = {color={color},pos=pos,size=brushSize}
  pixels[pos] = pixel
  game.client:send('draw',pixel)
end

function game:enter()
  love.graphics.setBackgroundColor(1, 1, 1)
  print('entered game!')

  if game.host then
    game.client = sock.newClient(game.host, 4545)
    game.client:on('connect',function(data)
      game.client:send('getPixels')
    end)
    game.client:on('draw',function(data)
      pixels[data.pos] = data
    end)
    game.client:connect()
  else
    print('no host to connect to!')
  end
end
function game:update(dt)
  if game.client then game.client:update() end

  --Draw
  if love.mouse.isDown(1) then
    local x,y = love.mouse.getPosition()
    draw(vector(x,y))
  end
end
function game:draw()
  --toolbar
  for _, pixel in pairs(pixels) do
    local pos = pixel.pos
    local color = pixel.color
    local size = pixel.size
    love.graphics.setColor(color[1],color[2],color[3])
    love.graphics.circle('fill',pos.x*width-size/2,pos.y*height-size/2,size,size)
  end
end


return game
