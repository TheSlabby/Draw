server = {}
sock = require('sock')

server.server = nil
server.pixels = {}

function server.update(dt)
  if server.server then
    server.server:update()
  end
end
function server.listen(port)
  port = port or 4545
  print('Creating new server on port '..port)
  server.server = sock.newServer('*',port)
  server.server:on('draw',function(pixel,client)
    server.pixels[pixel.pos] = pixel
    server.server:sendToAll('draw',pixel)
  end)
  server.server:on('getPixels',function(data,client)
    print('sending new client pixels...')
    client:send(server.pixels)
  end)
end


return server
