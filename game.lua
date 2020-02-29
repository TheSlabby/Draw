--this script runs when connected to a server
gamestate = require('hump.gamestate')
server = require('server')
sock = require('sock')
vector = require('hump.vector')
camera = require('hump.camera')
function lerp(a,b,t) return a * (1-t) + b * t end

game = {}
game.client = nil
game.camera = nil
width, height = love.graphics.getDimensions()
cameraSensitivity = 5
zoomSensitivity = .5

--variables for color and shit
local pixels = {}
local color = {1,0,0}
local brushSize = 5

--camera smoothing
local zoom = 1
local actualZoom = zoom
local focus = vector(width/2,height/2)
local actualFocus = focus

local function draw(pos)
  pos = vector(pos.x/width,pos.y/height)
  local pixel = {color={color},pos=pos,size=brushSize}
  pixels[pos] = pixel
  game.client:send('draw',pixel)
end

function game:enter()
  love.graphics.setBackgroundColor(0, 0, 0)
  print('entered game!')

  game.camera = camera.new()
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

  --smooth camera movement
  actualZoom = lerp(actualZoom, zoom, dt*cameraSensitivity)
  game.camera:zoomTo(actualZoom)
  if zoom < 1 then zoom = 1 end
  if zoom > 10 then zoom = 10 end

  actualFocus = vector(lerp(actualFocus.x,focus.x,dt*cameraSensitivity),lerp(actualFocus.y,focus.y,dt*cameraSensitivity))
  game.camera:lookAt(actualFocus.x,actualFocus.y)

  --Draw
  if love.mouse.isDown(1) then
    local x,y = game.camera:mousePosition()
    draw(vector(x,y))
  end
end

local function renderPixels()
  love.graphics.setColor(1,1,1)
  love.graphics.rectangle('fill',0,0,width,height)
  for _, pixel in pairs(pixels) do
    local pos = pixel.pos
    local color = pixel.color
    local size = pixel.size
    love.graphics.setColor(color[1],color[2],color[3])
    love.graphics.circle('fill',pos.x*width-size/2,pos.y*height-size/2,size,size)
  end
end
local function renderUI()
  love.graphics.setColor(.5,.5,.5)
  love.graphics.rectangle('fill',0,.8*height,width,.2*height)
end
function game:draw()
  --toolbar
  game.camera:draw(renderPixels)
  renderUI()
end
function game:wheelmoved(x,y)
  zoom = zoom + (y*zoomSensitivity)
end
function game:mousepressed(x,y,button)
  if button == 1 then
    --ui work
  elseif button == 2 then
    local x,y = game.camera:mousePosition()
    focus = vector(x,y)
  end
end

return game
