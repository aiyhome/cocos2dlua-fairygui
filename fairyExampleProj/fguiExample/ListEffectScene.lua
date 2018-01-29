local MailItem = require("MailItem")
local DemoScene = require("DemoScene")
local ListEffectScene = class("ListEffectScene", DemoScene)

function ListEffectScene:ctor()
	ListEffectScene.super.ctor(self)
end

function ListEffectScene:continueInit()
    fgui.UIPackage:addPackage("UI/Extension")
    fgui.UIConfig.horizontalScrollBar = ""
    fgui.UIConfig.verticalScrollBar = ""
    fgui.UIObjectFactory:setPackageItemExtension("ui://Extension/mailItem", function() return MailItem:new() end)

    self._view = fgui.UIPackage:createObject("Extension", "Main")
    self._groot:addChild(self._view)

    self._list = self._view:getChild("mailList")

    for i=0,9,1 do
        local item = self._list:addItemFromPool()
        item:setFetched(i % 3 == 0)
        item:setRead(i % 2 == 0)
        item:setTime("5 Nov 2015 16:24:33")
        item:setTitle("Mail title here")
    end

    self._list:ensureBoundsCorrect()
    local delay = 1.0
    for i=0,9,1 do
        local item = self._list:getChildAt(i)
        if self._list:isChildInView(item) then
            item:playEffect(delay)
            delay = delay + 0.2
        else
            break
        end
    end
end

return ListEffectScene