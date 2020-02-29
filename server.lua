server = {}
sock = require('sock')

server.server = nil

function server.update(dt)
  if server.server then
    server.server:update()
  end
end
function server.listen(port)
  port = port or 4545
  print('Creating new server on port '..port)
  server.server = sock.newServer('*',port)
  server.server:on('connect',function(client,data)
    print('new client connected!')
  end)
end


return server
