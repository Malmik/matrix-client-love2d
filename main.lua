package.cpath = package.cpath .. ";./libs/?.so;./libs/?/?.so"
package.path = package.path .. ";./libs/?.lua;./libs/?/?.lua"

ssl = require("ssl")

print("LUA MODULES:\n",(package.path:gsub("%;","\n\t")),"\n\nC MODULES:\n",(package.cpath:gsub("%;","\n\t")))


matrix = require "matrixApi"

tank = {}

ui = require "boxer/menudrawer"
gs = require "hump.gamestate"

s = {
  login = require "/state/login",
  register = require "/state/register",
   roomview = require "/state/roomview"
}

os.exists = function (file)
   local ok, err, code = os.rename(file, file)
   if not ok then
      if code == 13 then
         -- File exists, but we have not enought permissions to access it
         return true
      end
   end
   return ok, err
end

os.existsDir  = function (dir)
   return os.exists(dir.."/")
end

function love.load()

  sw, sh = love.graphics.getDimensions()
  tileset = ui.addtileset("libs/boxer/menuquads.lua", "libs/boxer/Menu_Atlas.png")
  sxx, syy = 1, 1

  gs.registerEvents()
  if os.getenv("XDG_DATA_HOME") then
    print(true)
  else
    if os.getenv("HOME") then
      if os.existsDir(os.getenv("HOME").."/.local") then
        if os.existsDir(os.getenv("HOME").."/.local/share") then
          if os.existsDir(os.getenv("HOME").."/.local/share/tank") then
            local token_file, error = io.open(os.getenv("HOME").."/.local/share/tank/token")
            if token_file then
              tank.token = token_file:read("*all")
              token_file:close()
              gs.switch(s.roomview)
            else
              gs.switch(s.login)
            end
          else
            os.execute("mkdir -p " .. os.getenv("HOME").."/.local/share/tank")
            gs.switch(s.login)
          end
        else
          os.execute("mkdir -p " .. os.getenv("HOME").."/.local/share/tank")
          gs.switch(s.login)
        end
      else
        os.execute("mkdir -p " .. os.getenv("HOME").."/.local/share/tank")
        gs.switch(s.login)
      end
    end
  end
end

function love.update(dt)
  --
end

function love.draw()
  --
end

function love.keypressed(key, scancode, isrepeat)
  if key == "q" then
    love.event.quit()
  --[[
    sxx = sxx + 1
    syy = syy + 1 --]]
  end
end
