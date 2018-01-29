local JoystickModule = require("JoystickModule")
local DemoScene = require("DemoScene")
local JoystickScene = class("JoystickScene", DemoScene)

function JoystickScene:ctor()
    JoystickScene.super.ctor(self)
end

function JoystickScene:continueInit()
    fgui.UIPackage:addPackage("UI/Joystick")

    self._view = fgui.UIPackage:createObject("Joystick", "Main")
    self._groot:addChild(self._view)

    self._joystick = JoystickModule.new(self._view)
    self._joystick:retain()

    local tf = self._view:getChild("n9")

    self._joystick:addEventListener(JoystickModule.MOVE, function(context)
        tf:setText(context:getDataValue())
    end)

    self._joystick:addEventListener(JoystickModule.END, function(context)
        tf:setText("")
    end)
end

return  JoystickScene