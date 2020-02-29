gamestate = require('hump.gamestate')
vector = require('hump.vector')
server = require('server')
game = require('game')

menu = {}

--define some important variables
width, height = love.graphics.getDimensions()
float = 0
ip = ''

debounce = {}

function isClicked(button)
    if not love.mouse.isDown(button) then debounce[button] = false end
        if not debounce[button] and love.mouse.isDown(button) then
            debounce[button] = true
        return true
    else
        return false
    end
end


local function play()
  print('starting game...')
  game.host = ip
  gamestate.switch(game)
end
local function host()
  ip = 'localhost'
  if not server.server then server.listen() end
end

buttons = {
  {love.graphics.newImage('assets/playButton.png'),vector(.5*width,.3*height),play},
  {love.graphics.newImage('assets/hostButton.png'),vector(.5*width,.7*height),host}
}

function menu:enter()
  print('entering menu...')
end
function menu:update(dt)
  float = float + dt

  --check if buttons pressed
  if isClicked(1) then
    local mouseX,mouseY = love.mouse.getPosition()
    for _, button in pairs(buttons) do
      local x,y = button[2].x,button[2].y
      y = y + math.sin(float) * 10
      local xOffset, yOffset = button[1]:getDimensions()
      --print(x+xOffset/2, mouseX)
      if mouseX > x-xOffset/2 and mouseX < x+xOffset/2 and mouseY > y-yOffset/2 and mouseY < y+yOffset/2 then
        button[3]()
      end
    end
  end
end
function menu:draw()
  love.graphics.setBackgroundColor(0, .5, .5)
  for _, button in pairs(buttons) do
    local x,y = button[2].x, button[2].y
    --x = x + math.sin(float) * 10

    local xOffset, yOffset = button[1]:getDimensions()
    y = y - yOffset/2
    x = x - xOffset/2

    y = y + math.sin(float) * 10
    love.graphics.draw(button[1], x, y)

    --textbox
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill',.1*width,.1*height,.8*width,.1*height)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print('Host to connect to: ['..ip..']', .1*width,.1*height)
  end
end
function menu:textinput(char)
  ip = ip..char
end
function menu:keypressed(key)
  if key == 'backspace' then
    ip = string.sub(ip,1, string.len(ip) - 1)
  end
end


return menu
