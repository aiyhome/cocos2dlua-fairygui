local BagWindow = require("BagWindow")
local DemoScene = require("DemoScene")
local BagScene = class("BagScene", DemoScene)

function BagScene:ctor()
	BagScene.super.ctor(self)
end

function BagScene:continueInit()
    fgui.UIPackage:addPackage("UI/Bag")
    fgui.UIConfig.horizontalScrollBar = ""
    fgui.UIConfig.verticalScrollBar = ""

    self._view = fgui.UIPackage:createObject("Bag", "Main")
    self._groot:addChild(self._view)

    self._bagWindow = BagWindow:new()
    self._bagWindow:retain()
    self._view:getChild("bagBtn"):addClickListener(function() self._bagWindow:show() end)
end

return BagScene