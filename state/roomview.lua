local roomview = {}

function roomview:init()
  roomview.ui = ui.newWindow(tileset, 0, 0, sw, sh, sxx, syy)

  tank.sync, error = matrix.sync(tank.token)
  if type(tank.sync) == "table" then
    tank.room = {}
    tank.roomId = {}
    for k, v in pairs(tank.sync.rooms.join) do
      tank.roomId[#tank.roomId + 1] = v
      tank.room[#tank.room + 1], error = matrix.getRoomName(k, tank.token)
    end
  end
  for k,v in pairs(tank.roomId[7].timeline.events) do
    if v.type == "m.room.message" then
      print(v.content.body)
    end
  end
end

function roomview:update(dt)
  if #tank.room > #roomview.ui.button then
    ui.button(#roomview.ui.button + 1, roomview.ui, tileset, "checkbox0Normal", "checkbox0Hover", "checkbox0Click", 0, 10 + (30 * (#roomview.ui.button + 1)))
  elseif #tank.room < #roomview.ui.button then
    roomview.ui.button[#roomview.ui.button] = nil
  end
  ui.update(roomview.ui)
end

function roomview:draw()
  ui.draw(roomview.ui)
  local i = 0
  for k, v in pairs(tank.room) do
    love.graphics.print(v, 60, 45 + i)
    i = i + 30
  end
end


return roomview
