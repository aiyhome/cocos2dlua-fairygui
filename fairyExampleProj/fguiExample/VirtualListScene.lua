local DemoScene = require("DemoScene")
local MailItem = require("MailItem")
local VirtualListScene = class("VirtualListScene", DemoScene)

function VirtualListScene:ctor()
    VirtualListScene.super.ctor(self)
end

function VirtualListScene:continueInit()
    fgui.UIPackage:addPackage("UI/VirtualList")
    fgui.UIConfig.horizontalScrollBar = ""
    fgui.UIConfig.verticalScrollBar = ""
    fgui.UIObjectFactory:setPackageItemExtension("ui://VirtualList/mailItem", function ()
        return MailItem:create()
    end)

    self._view = fgui.UIPackage:createObject("VirtualList", "Main")
    self._groot:addChild(self._view);

    self._view:getChild("n6"):addClickListener(function(context) self._list:addSelection(500, true) end)
    self._view:getChild("n7"):addClickListener(function(context) self._list:getScrollPane():scrollTop() end)
    self._view:getChild("n8"):addClickListener(function(context) self._list:getScrollPane():scrollBottom() end)

    self._list = self._view:getChild("mailList")
    self._list:setItemRenderer(handler(self, self.renderListItem))
    self._list:setVirtual()
    self._list:setNumItems(1000)
end

function VirtualListScene:renderListItem(index, obj)
    local item = obj
    item:setFetched(index % 3 == 0)
    item:setRead(index % 2 == 0)
    item:setTime("5 Nov 2015 16:24:33")
    item:setText(tostring(index) .. " Mail title here")
end

return VirtualListScene
