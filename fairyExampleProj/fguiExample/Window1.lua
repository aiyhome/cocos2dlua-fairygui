local Window1 = class("Window1", fgui.Window)

function Window1:ctor()
    self:setOverride(true)
    self:addEventListener(fgui.UIEventType.onWinInit, handler(self, self.onInit))
    self:addEventListener(fgui.UIEventType.onWinShown, handler(self, self.onShown))
    self:addEventListener(fgui.UIEventType.onWinHide, handler(self, self.onHide))
    self:addEventListener(fgui.UIEventType.onWinDoShowAnimation, handler(self, self.doShowAnimation))
    self:addEventListener(fgui.UIEventType.onWinDoHideAnimation, handler(self, self.doHideAnimation))
end

function Window1:onHide()
end

function Window1:onInit()
    self._contentPane = fgui.UIPackage:createObject("Basics", "WindowA")
    self:setContentPane(self._contentPane)
    self:center()
end

function Window1:doShowAnimation()
    self:onShown()
end

function Window1:doHideAnimation()
    self:hideImmediately()
end

function Window1:onShown()
    local list = self._contentPane:getChild("n6")
    list:removeChildrenToPool()
    for i=0,6,1 do        
        local item = list:addItemFromPool()
        item:setTitle(tostring(i))
        item:setIcon("ui://Basics/r4")
    end
end

return Window1