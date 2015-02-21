package = "sharecart"
version = "dev-1"
source = {
  url = "git://github.com/leafo/sharecart.lua.git",
}
description = {
  summary = "sharecart",
  homepage = "https://github.com/alts/sharecart.lua",
  license = "MIT"
}
dependencies = {
  "lua ~> 5.1"
}
build = {
  type = "builtin",
  modules = {
    ["sharecart.inifile"] = "sharecart/inifile.lua",
    ["sharecart"] = "sharecart/init.lua",
  }
}
