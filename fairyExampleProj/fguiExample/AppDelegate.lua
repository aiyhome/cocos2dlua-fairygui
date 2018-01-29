require "fairygui.init"
local fileUtils = cc.FileUtils:getInstance()
local director = cc.Director:getInstance()
fileUtils:addSearchPath("Resources/")
fgui.UIConfig:registerFont(fgui.UIConfig.defaultFont, "fonts/DroidSansFallback.ttf")
local MenuScene = require("MenuScene").new()
director:runWithScene(MenuScene)