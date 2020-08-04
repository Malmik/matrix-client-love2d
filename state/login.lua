local login = {}

function login:init()
  menu = ui.newWindow(tileset, 0, 0, sw, sh, sxx, syy)
  ui.textBox("login", menu, "libs/boxer/text_box/text_box.png", "libs/boxer/text_box/quads.lua", (menu.w / 2) - 100, 100)
  ui.textBox("password", menu, "libs/boxer/text_box/text_box.png", "libs/boxer/text_box/quads.lua", (menu.w / 2) - 100, 200)
  ui.button("done", menu, tileset, "buttonNormal", "buttonHover", "buttonClick", (menu.w / 2) - 100, 300)
end

function login:update(dt)
  ui.update(menu, sxx, syy)

  if ui.state("done", menu) == "click" then
    local token, error = matrix.login(menu.textBox.login.text, menu.textBox.password.text)
    if not error then
      tank.token = token
      local token_file, error = io.open(os.getenv("HOME").."/.local/share/tank/token", "w")
      if token_file then
        token_file:write(tank.token)
        token_file:close()
      else
        --error
      end
      gs.switch(s.roomview)
    end
  end
end

function login:draw()
  ui.draw(menu)
end

function login:keypressed(key, scancode, isrepeat)
  ui.keypressed(key, menu)
end

return login
