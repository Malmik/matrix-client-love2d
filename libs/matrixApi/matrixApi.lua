local http = require("socket.http")
local https = require("ssl/ssl/https")
local json = require("json")

local matrixApi = {}

matrixApi.request = function(request_body, url, method, token)
  request_body = json.encode(request_body)
  local response_body = {}

  if token then
    token = "Bearer " .. token
  end

  local res, code, response_headers = https.request{
    url = url,
    method = method,
    headers =
      {
          ["Content-Type"] = "application/json",
          ["Content-Length"] = #request_body,
          ["Authorization"] = token
      },
      source = ltn12.source.string(request_body),
      sink = ltn12.sink.table(response_body),
  }
  response_body = json.decode(table.concat(response_body))

  return response_body, code
end

matrixApi.login = function(userId, password)
  local request_body = {
    type = "m.login.password",
    identifier = {
      type = "m.id.user",
      user = userId
    },
    password = password,
    device_id = "TANK_PROTOTYPE"
  }
  local response, code = matrixApi.request(request_body, "https://matrix.org/_matrix/client/r0/login", "POST")
  if response.errcode then
    return nil, response.errcode
  else
    return response.access_token
  end
end

matrixApi.sync = function(token)
  local response, code = matrixApi.request(nil, "https://matrix.org/_matrix/client/r0/sync", "GET", token)
  if response.errcode then
    return nil, response.errcode
  else
    return response
  end
end

matrixApi.getRoomName = function(roomId, token)
  local response, code = matrixApi.request(nil, "https://matrix.org/_matrix/client/r0/rooms/"..roomId.."/state/m.room.name/", "GET", token)
  if response.errcode then
    return nil, response.errcode
  else
    return response.name
  end
end
return matrixApi
