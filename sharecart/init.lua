local inifile = require('sharecart.inifile')

-- translators
local id = function (v)
  return v
end

local string_to_bool = function (v)
  if v == 'TRUE' then
    return true
  elseif v == 'FALSE' then
    return false
  else
    return nil
  end
end

local bool_to_string = function (v)
  if v == true then
    return 'TRUE'
  elseif v == false then
    return 'FALSE'
  else
    return nil
  end
end


-- constraints
local is_whole_positive_number = function (v)
  return type(v) == 'number' and v >= 0 and v % 1 == 0
end

local uint10 = function (v)
  return is_whole_positive_number(v) and v < 1024
end

local uint16 = function (v)
  return is_whole_positive_number(v) and v < 65536
end

local is_bool = function (v)
  return type(v) == 'boolean'
end

local is_name_string = function (v)
  return type(v) == 'string' and string.len(v) < 1024
end


local get_translators = {
  MapX = id,
  MapY = id,
  Misc0 = id,
  Misc1 = id,
  Misc2 = id,
  Misc3 = id,
  PlayerName = id,
  Switch0 = string_to_bool,
  Switch1 = string_to_bool,
  Switch2 = string_to_bool,
  Switch3 = string_to_bool,
  Switch4 = string_to_bool,
  Switch5 = string_to_bool,
  Switch6 = string_to_bool,
  Switch7 = string_to_bool
}

local set_translators = {
  MapX = id,
  MapY = id,
  Misc0 = id,
  Misc1 = id,
  Misc2 = id,
  Misc3 = id,
  PlayerName = id,
  Switch0 = bool_to_string,
  Switch1 = bool_to_string,
  Switch2 = bool_to_string,
  Switch3 = bool_to_string,
  Switch4 = bool_to_string,
  Switch5 = bool_to_string,
  Switch6 = bool_to_string,
  Switch7 = bool_to_string
}

local set_constraints = {
  MapX = uint10,
  MapY = uint10,
  Misc0 = uint16,
  Misc1 = uint16,
  Misc2 = uint16,
  Misc3 = uint16,
  PlayerName = is_name_string,
  Switch0 = is_bool,
  Switch1 = is_bool,
  Switch2 = is_bool,
  Switch3 = is_bool,
  Switch4 = is_bool,
  Switch5 = is_bool,
  Switch6 = is_bool,
  Switch7 = is_bool
}


local _ini_data = {}

local _ini_get = function (t, key)
  local translator = get_translators[key] or id
  return translator(_ini_data.Main[key])
end

local _ini_set = function (t, key, value)
  local translator = set_translators[key]
  if translator == nil then
    error(string.format("Key \"%s\" isn't a sharecart save key", key))
  end

  if set_constraints[key](value) == false then
    error(string.format("Key \"%s\" can't store the given value (%s)", key, tostring(value)))
  end

  _ini_data.Main[key] = translator(value)
  inifile.save(t.path, _ini_data, 'io')
end


local sharecart = {}

local file_exists = function (path)
  local f = io.open(path)
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

sharecart.valid = function (pwd)
  return file_exists(pwd .. '/../dat/o_o.ini', 'r')
end

sharecart.load = function (pwd, unsafe)
  if unsafe ~= true then
    unsafe = false
  end

  local t = {
    unsafe = unsafe,
    path = pwd .. '/../dat/o_o.ini'
  }

  _ini_data = inifile.parse(t.path, 'io')
  _ini_data.Main = _ini_data.Main or {}

  return setmetatable(t, {
    __index = _ini_get,
    __newindex = _ini_set
  })
end


sharecart.love_load = function (love, load_args)
  -- we can't reliably do anything in the case that we can't identify the os
  if love._os == nil then
    return nil
  end

  local cwd

  if load_args[1] == nil then
    -- case: Fused windows executables don't supply the argument at position 1
    -- if that value doesn't exist, .getWorkingDirectory is our only alternative
    cwd = love.filesystem.getWorkingDirectory()
  elseif love._os == 'OS X' and love.filesystem.isFused() then
    -- case: Mac love.app with integrated .love file
    -- since the executable and the .love file don't sit in a sibling
    -- directory of `dat`, we have to correct the path. The .app file should
    -- be in the correct location, and we can build the path based on that
    match_start, match_end = load_args[1]:find('[^/]+.app')
    cwd = load_args[1]:sub(0, match_start - 1)
  elseif load_args[1] ~= nil and load_args[1]:find('[^/\\]+.love') then
    -- case: Running the game from the .love archive

    -- The .love archive should follow the positioning rules for executables
    match_start, match_end = load_args[1]:find('[^/\\]+.love')
    cwd = load_args[1]:sub(0, match_start - 1)

    -- In the case that the first love argument is just the path to the archive,
    -- then we know that the current directory is the containing directory
    if #cwd == 0 then
      cwd = '.'
    end
  else
    -- otherwise whatever is passed as the first argument should work
    cwd = load_args[1]
  end

  if not sharecart.valid(cwd) then
    return nil
  end

  return sharecart.load(cwd)
end

return sharecart
