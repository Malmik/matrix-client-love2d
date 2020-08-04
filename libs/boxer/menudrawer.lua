local ui = {}

function ui.addtileset(quad_path, image_path, min_filter, mag_filter)
  -- Set up defaults and load files
  min_filter = min_filter or "nearest"
  mag_filter = mag_filter or "nearest"
  local cordinates = dofile(arg[1].."/"..quad_path)

  -- Create basic tileset table structure
  local tileset = {
    image = love.graphics.newImage(image_path),
    cords = cordinates,
    quad = {},
    bg = {}
  }

  -- Set filter type
  tileset.image:setFilter(min_filter, mag_filter)

  local i
  -- Create quads based on canvas info
  while next(cordinates, i) ~= nil do
    tileset.quad[next(cordinates, i)] = love.graphics.newQuad(cordinates[next(cordinates, i)].x, cordinates[next(cordinates, i)].y, cordinates[next(cordinates, i)].w, cordinates[next(cordinates, i)].h, tileset.image:getDimensions())-- ,cordinates[next(cordinates, i)].sw, cordinates[next(cordinates, i)].sh)
    i = next(cordinates, i)
  end
  -- Get background rgb values
  local canvas = love.graphics.newCanvas(1,1)
  canvas:renderTo(function() love.graphics.draw(tileset.image, tileset.quad.background, 0, 0) end)
  tileset.bg.r, tileset.bg.g, tileset.bg.b, tileset.bg.a = canvas:newImageData():getPixel(0, 0)

  return tileset
end

function ui.newWindow(tileset, x, y, w, h, sx, sy)
  local window = {
    tileset = tileset,
    blink = false,
    blinkTimer = 0,
    x = x or 0,
    y = y or 0,
    w = w or tileset.cords.leftDown.w + tileset.cords.rightTop.w,
    h = h or tileset.cords.leftTop.h + tileset.cords.rightDown.h,
    sx = sx or 1,
    sy = sy or 1,

    button = {},
    textBox = {},
    item = {}
  }

  window.top = {
    x = window.x + tileset.cords.leftTop.w * window.sx,
    y = nil,
    w = window.w - (tileset.cords.leftTop.w + tileset.cords.rightTop.w) * window.sx,
    h = nil
  }
  window.down = {
    x = window.x + tileset.cords.leftDown.w * window.sx,
    y = window.y + window.h - tileset.cords.leftDown.h * window.sy,
    w = window.w - (tileset.cords.leftDown.w + tileset.cords.rightDown.w) * window.sx,
    h = nil
  }
  window.left = {
    x = nil,
    y = window.y + tileset.cords.leftTop.h * window.sy,
    w = nil,
    h = window.h - (tileset.cords.leftTop.h + tileset.cords.leftDown.h) * window.sy
  }
  window.right = {
    x = window.x + window.w - tileset.cords.rightTop.w * window.sx,
    y = window.y + tileset.cords.rightTop.h * window.sy,
    w = nil,
    h = window.h - (tileset.cords.rightTop.h + tileset.cords.rightDown.h) * window.sy
  }

  window.leftTop = {
    x = window.x,
    y = window.y
  }
  window.rightTop = {
    x = window.x + window.w - tileset.cords.rightTop.w * window.sx,
    y = window.y
  }
  window.leftDown = {
    x = window.x,
    y = window.y + window.h - tileset.cords.leftDown.h * window.sy
  }
  window.rightDown = {
    x = window.x + window.w - tileset.cords.rightDown.w * window.sx,
    y = window.y + window.h - tileset.cords.rightDown.h * window.sy
  }

  window.bg = {
    x = window.x + tileset.cords.leftTop.w * window.sx,
    y = window.y + tileset.cords.leftTop.h * window.sy,
    w = window.w - (tileset.cords.leftDown.w + tileset.cords.rightTop.w) * window.sx,
    h = window.h - (tileset.cords.leftTop.h + tileset.cords.rightDown.h) * window.sy
  }

  return window
end

function ui.button(name, window, tileset, normal, hover, click, x, y)
  local button = {
    quad = {
      normal = tileset.quad[normal],
      hover = tileset.quad[hover],
      click = tileset.quad[click],
    },
    x = x or 0,
    y = y or 0,
    w = tileset.cords[normal].w,
    h = tileset.cords[normal].h,
    state = "normal"
  }

  window.button[name] = button
end

function ui.textBox(name, window, image, quad, x, y, w, h)
  local image = love.graphics.newImage(image)
  local cords = dofile(arg[1].."/"..quad)

  local textBox = {
    image = image,
    cords = cords,
    quad = {},
    type = "textBox",
    state = "normal",
    text = name,
    x = x or 0,
    y = y or 0,
    w = w or 100,
    h = h or 24
  }

  textBox.image:setFilter("nearest", "nearest")

  for k,v in pairs(cords) do
    textBox.quad[k] = love.graphics.newQuad(v.x, v.y, v.w, v.h, textBox.image:getDimensions())
  end

  window.textBox[name] = textBox
end

function ui.update(window, sx, sy)
  window.blinkTimer = window.blinkTimer + love.timer.getDelta()
  if window.blinkTimer >= 1 then
    window.blinkTimer = 0
    window.blink = (not window.blink)
  end
  if (sx ~= window.sx) or (sy ~= window.sy) then

    local oldx = window.oldx or window.x
    local oldy = window.oldy or window.y

    window.sx = sx or window.sx
    window.sy = sy or window.sy

    window.top = {
      x = window.x + tileset.cords.leftTop.w * window.sx,
      y = nil,
      w = window.w - (tileset.cords.leftTop.w + tileset.cords.rightTop.w) * window.sx,
      h = nil
    }
    window.down = {
      x = window.x + tileset.cords.leftDown.w * window.sx,
      y = window.y + window.h - tileset.cords.leftDown.h * window.sy,
      w = window.w - (tileset.cords.leftDown.w + tileset.cords.rightDown.w) * window.sx,
      h = nil
    }
    window.left = {
      x = nil,
      y = window.y + tileset.cords.leftTop.h * window.sy,
      w = nil,
      h = window.h - (tileset.cords.leftTop.h + tileset.cords.leftDown.h) * window.sy
    }
    window.right = {
      x = window.x + window.w - tileset.cords.rightTop.w * window.sx,
      y = window.y + tileset.cords.rightTop.h * window.sy,
      w = nil,
      h = window.h - (tileset.cords.rightTop.h + tileset.cords.rightDown.h) * window.sy
    }

    window.leftTop = {
      x = window.x,
      y = window.y
    }
    window.rightTop = {
      x = window.x + window.w - tileset.cords.rightTop.w * window.sx,
      y = window.y
    }
    window.leftDown = {
      x = window.x,
      y = window.y + window.h - tileset.cords.leftDown.h * window.sy
    }
    window.rightDown = {
      x = window.x + window.w - tileset.cords.rightDown.w * window.sx,
      y = window.y + window.h - tileset.cords.rightDown.h * window.sy
    }

    window.bg = {
      x = window.x + tileset.cords.leftTop.w * window.sx,
      y = window.y + tileset.cords.leftTop.h * window.sy,
      w = window.w - (tileset.cords.leftDown.w + tileset.cords.rightTop.w) * window.sx,
      h = window.h - (tileset.cords.leftTop.h + tileset.cords.rightDown.h) * window.sy
    }

    window.isSync = 1
  end
  for k,v in pairs(window.button) do
    --v.x = v.x - window.oldx + window.x
    --v.y = v.y - window.oldy + window.y

    if v.x > window.bg.w + window.bg.x - v.w then v.x = window.bg.w + window.bg.x - v.w * window.sx end
    if v.x < window.bg.x then v.x = window.bg.x end
    if v.y > window.bg.h + window.bg.y - v.h then v.y = window.bg.h + window.bg.y - v.h end
    if v.y < window.bg.y then v.y = window.bg.y end

    if love.mouse.getX() < v.x + v.w * window.sx and love.mouse.getX() > v.x and love.mouse.getY() < v.y + v.h * window.sy and love.mouse.getY() > v.y then
      if love.mouse.isDown(1) then
        v.state = "click"
      else
        v.state = "hover"
      end
    else
      v.state = "normal"
    end
  end
  for k,v in pairs(window.textBox) do
    if love.mouse.getX() < v.x + v.w * window.sx and love.mouse.getX() > v.x and love.mouse.getY() < v.y + v.h * window.sy and love.mouse.getY() > v.y then
      if love.mouse.isDown(1) then
        v.state = "click"
        window.focus = v
      else
        v.state = "hover"
      end
    else
      v.state = "normal"
    end
  end
end

function ui.keypressed(key, window)
  if window.focus then
    if window.focus.type == "textBox" then
      if key == "backspace" then
        window.focus.text = window.focus.text:sub(1,-2)
      elseif key == "space" then
        window.focus.text = window.focus.text .. " "
      else
        window.focus.text = window.focus.text .. key
      end
    end
  end
end

function ui.state(name, window)
  return window.button[name].state
end

function ui.draw(name, x, y, w, h, sx, sy)
  local window = name
  local tileset = window.tileset

  if window.w >= (tileset.cords.leftTop.w + tileset.cords.rightDown.w) and window.h >= (tileset.cords.rightTop.h + tileset.cords.leftDown.h) then
    ---[[
    for i = window.top.x, window.top.x + window.top.w do
      love.graphics.draw(tileset.image, tileset.quad.up, i, window.top.y, nil, window.sx, window.sy)
    end
    for i = window.left.y, window.left.y + window.left.h do
      love.graphics.draw(tileset.image, tileset.quad.left, window.left.x, i, nil, window.sx, window.sy)
    end
    for i = window.right.y, window.right.y + window.right.h do
      love.graphics.draw(tileset.image, tileset.quad.right, window.right.x, i, nil, window.sx, window.sy)
    end
    for i = window.down.x, window.down.x + window.down.w do
      love.graphics.draw(tileset.image, tileset.quad.down, i, window.down.y, nil, window.sx, window.sy)
    end
    ---[[
    love.graphics.draw(tileset.image, tileset.quad.leftTop, window.leftTop.x, window.leftTop.y, nil, window.sx, window.sy)
    love.graphics.draw(tileset.image, tileset.quad.rightTop, window.rightTop.x, window.rightTop.y, nil, window.sx, window.sy)
    love.graphics.draw(tileset.image, tileset.quad.leftDown, window.leftDown.x, window.leftDown.y, nil, window.sx, window.sy)
    love.graphics.draw(tileset.image, tileset.quad.rightDown, window.rightDown.x, window.rightDown.y, nil, window.sx, window.sy)
    --]]
    love.graphics.setColor(tileset.bg.r, tileset.bg.g, tileset.bg.b, tileset.bg.a, nil, window.sx, window.sy)
    love.graphics.rectangle("fill", window.bg.x, window.bg.y, window.bg.w, window.bg.h)
    love.graphics.setColor(1,1,1,1)

    for k,v in pairs(window.button) do
      love.graphics.draw(tileset.image, v.quad[v.state], v.x, v.y, nil, window.sx, window.sy)
    end
    for k,v in pairs(window.textBox) do
      love.graphics.draw(v.image, v.quad.left, v.x, v.y, nil, window.sx, window.sy)
      for i = v.x + v.cords.left.w * window.sx, v.x + v.w - v.cords.right.w * window.sx do
        love.graphics.draw(v.image, v.quad.center, i, v.y, nil, window.sx, window.sy)
      end
      love.graphics.draw(v.image, v.quad.right, v.x + v.w - v.cords.right.w, v.y, nil, window.sx, window.sy)
      if window.focus == v then
        if window.blink then
          love.graphics.print(v.text .. "|", v.x + v.cords.left.w, v.y + v.h / 4)
        else
          love.graphics.print(v.text, v.x + v.cords.left.w, v.y + v.h / 4)
        end
      else
        love.graphics.print(v.text, v.x + v.cords.left.w, v.y + v.h / 4)
      end
    end
  end

  if (window.x ~= x and x) or  (window.y ~= y and y) or (window.w ~= w and w) or (window.h ~= h and h) or (window.sx ~= sx and sx) or (window.sy ~= sy and sx) then
    window.oldx = window.x
    window.oldy = window.y
    window.x = x or window.x
    window.y = y or window.y
    window.w = w or window.w
    window.h = h or window.h
    window.sx = sx or window.sx
    window.sy = sy or window.sy
  end
end

return ui
