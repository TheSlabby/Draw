gamestate = require('hump.gamestate')
sock = require('sock')
server = require('server')
--gamestates
menu = require('menu')
game = require('game')

function love.load()
  print('Draw loading...')

  --swithc to menu
  gamestate.registerEvents()
  gamestate.switch(menu)
end

function love.update(dt)
  --main update function
  server.update(dt)
end
