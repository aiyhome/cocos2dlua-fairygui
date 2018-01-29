local DemoScene = require("DemoScene")
local LoopListScene = class("LoopListScene", DemoScene)

function LoopListScene:continueInit()
    fgui.UIPackage:addPackage("UI/LoopList");
    fgui.UIConfig.horizontalScrollBar = "";
    fgui.UIConfig.verticalScrollBar = "";

    self._view = fgui.UIPackage:createObject("LoopList", "Main")
    self._groot:addChild(self._view)

    self._list = self._view:getChild("list")
    self._list:setItemRenderer(handler(self, self.renderListItem))
    self._list:setVirtualAndLoop()
    self._list:setNumItems(5)
    self._list:addEventListener(fgui.UIEventType.Scroll, handler(self, self.doSpecialEffect))

    self:doSpecialEffect(nil)
end

function LoopListScene:renderListItem(index, obj)
    obj:setPivot(0.5, 0.5)
    obj:setIcon("ui://LoopList/n" .. tostring(index + 1))
end

function LoopListScene:doSpecialEffect(context)
    --change the scale according to the distance to middle
    local midX = self._list:getScrollPane():getPosX() + self._list:getViewWidth() / 2
    local cnt = self._list:numChildren()
    for i=0,cnt-1,1 do 
        local obj = self._list:getChildAt(i)
        local dist = math.abs(midX - obj:getX() - obj:getWidth() / 2)
        if dist > obj:getWidth() then --no intersection
            obj:setScale(1, 1)
        else
            local ss = 1 + (1 - dist / obj:getWidth()) * 0.24
            obj:setScale(ss, ss)
        end
    end
    self._view:getChild("n3"):setText(tostring((self._list:getFirstChildInView() + 1) % self._list:getNumItems()))
end

return LoopListScene