local DemoScene = require("DemoScene")
local HitTestScene = class("HitTestScene", DemoScene)

function HitTestScene:ctor()
    HitTestScene.super.ctor(self)
end

function HitTestScene:continueInit()
    fgui.UIPackage:addPackage("UI/HitTest")
    self._view = fgui.UIPackage:createObject("HitTest", "Main")
    self._groot:addChild(self._view)
end

return HitTestScene