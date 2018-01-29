local ScrollPaneHeader = class("ScrollPaneHeader", fgui.GComponent)

function ScrollPaneHeader:ctor()
    self:addEventListener(fgui.UIEventType.constructFromXML, handler(self, self.constructFromXML))
end

function ScrollPaneHeader:constructFromXML()
    self._c1 = self:getController("c1")

    self:addEventListener(fgui.UIEventType.SizeChange, handler(self, self.onSizeChanged))
end

function ScrollPaneHeader:isReadyToRefresh()
    return self._c1:getSelectedIndex() == 1
end

function ScrollPaneHeader:onSizeChanged(context)
    if self._c1:getSelectedIndex() == 2 or self._c1:getSelectedIndex() == 3 then
        return
    end
    local sourceSize = self:getSourceSize()
    if self:getHeight() > sourceSize.height then
        self._c1:setSelectedIndex(1)
    else
        self._c1:setSelectedIndex(0)
    end
end

function ScrollPaneHeader:setRefreshStatus(value)
    self._c1:setSelectedIndex(value)
end

local DemoScene = require("DemoScene")
local PullToRefreshScene = class("PullToRefreshScene", DemoScene)

function PullToRefreshScene:ctor()
    PullToRefreshScene.super.ctor(self)
end

function PullToRefreshScene:continueInit()
    fgui.UIPackage:addPackage("UI/PullToRefresh")
    fgui.UIObjectFactory:setPackageItemExtension("ui://PullToRefresh/Header", function() return ScrollPaneHeader:create() end)

    self._view = fgui.UIPackage:createObject("PullToRefresh", "Main")
    self._groot:addChild(self._view)

    self._list1 = self._view:getChild("list1")
    self._list1:setItemRenderer(handler(self, self.renderListItem1))
    self._list1:setVirtual()
    self._list1:setNumItems(1)
    self._list1:addEventListener(fgui.UIEventType.PullDownRelease, handler(self, self.onPullDownToRefresh))

    self._list2 = self._view:getChild("list2")
    self._list2:setItemRenderer(handler(self, self.renderListItem2))
    self._list2:setVirtual()
    self._list2:setNumItems(1)
    self._list2:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullUpToRefresh))
end

function PullToRefreshScene:renderListItem1(index, obj)
    obj:setText("Item " .. tostring(self._list1:getNumItems() - index - 1))
end

function PullToRefreshScene:renderListItem2(index, obj)
    obj:setText("Item " .. tostring(index))
end

function PullToRefreshScene:onPullDownToRefresh(context)
    local header = self._list1:getScrollPane():getHeader()
    if header:isReadyToRefresh() then
        header:setRefreshStatus(2)
        self._list1:getScrollPane():lockHeader(header:getSourceSize().height)

        --Simulate a async resquest

        self:scheduleOnce(function()
            self._list1:setNumItems(self._list1:getNumItems() + 5)

            --Refresh completed
            header:setRefreshStatus(3)
            self._list1:getScrollPane():lockHeader(35)

            self:scheduleOnce(function()
                header:setRefreshStatus(0)
                self._list1:getScrollPane():lockHeader(0)
            end, 2, "pull_down2")
        end, 2, "pull_down1")
    end
end

function PullToRefreshScene:onPullUpToRefresh(context)
    local footer = self._list2:getScrollPane():getFooter()

    footer:getController("c1"):setSelectedIndex(1)
    self._list2:getScrollPane():lockFooter(footer:getSourceSize().height)

    --Simulate a async resquest
    self:scheduleOnce(function()
        self._list2:setNumItems(self._list2:getNumItems() + 5)

        --Refresh completed
        footer:getController("c1"):setSelectedIndex(0)
        self._list2:getScrollPane():lockFooter(0)
    end, 2, "pull_up")
end

return PullToRefreshScene