Class = require('hump.class')
gui = {}
gui.elements = {}

--get clicked
local debounce = {}
local function isClicked(button)
    if not love.mouse.isDown(button) then debounce[button] = false end
        if not debounce[button] and love.mouse.isDown(button) then
            debounce[button] = true
        return true
    else
        return false
    end
end


gui.ImageButton = Class{
  init=function(self, image, x, y, sx, callback)
    self.image = image
    self.x = x
    self.y = y
    self.callback = callback
    self.imageSizeX,self.imageSizeY = self.image:getDimensions()
    --find out image sacle
    self.scale = sx / self.imageSizeX
    self.imageSizeX,self.imageSizeY = self.imageSizeX * self.scale, self.imageSizeY * self.scale

    table.insert(gui.elements,self)
  end,
  update = function(self,dt,clicked)
    if clicked then
      local x,y = love.mouse.getPosition()
      if x > self.x - self.imageSizeX/2 and x < self.x + self.imageSizeX/2 and y > self.y - self.imageSizeY/2 and y < self.y + self.imageSizeY/2 then
        self.callback()
      end
    end
  end,
  draw = function(self)
    love.graphics.draw(self.image, self.x - self.imageSizeX/2, self.y - self.imageSizeY/2, nil, self.scale, self.scale)
  end
}

function gui.update(dt)
  local clicked = isClicked(1)
  for _, element in pairs(gui.elements) do
    element:update(dt,clicked)
  end
end
function gui.draw()
  for _, element in pairs(gui.elements) do
    element:draw()
  end
end

return gui
