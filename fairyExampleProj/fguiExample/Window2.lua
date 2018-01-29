local Window2 = class("Window2", fgui.Window)

function Window2:ctor()
    self:setOverride(true)
    self:addEventListener(fgui.UIEventType.onWinInit, handler(self, self.onInit))
    self:addEventListener(fgui.UIEventType.onWinShown, handler(self, self.onShown))
    self:addEventListener(fgui.UIEventType.onWinHide, handler(self, self.onHide))
    self:addEventListener(fgui.UIEventType.onWinDoShowAnimation, handler(self, self.doShowAnimation))
    self:addEventListener(fgui.UIEventType.onWinDoHideAnimation, handler(self, self.doHideAnimation))
end

function Window2:onInit()
    self._contentPane = fgui.UIPackage:createObject("Basics", "WindowB")
    self:setContentPane(self._contentPane)
    self:center()
end

function Window2:onShown()
    self._contentPane:getTransition("t1"):play()
end

function Window2:onHide()
    self._contentPane:getTransition("t1"):stop()
end

function  Window2:doShowAnimation()
    self:setScale(0.1, 0.1)
    self:setPivot(0.5, 0.5)

    local action = fgui.ActionFloat2:create(0.3, self:getScale(), cc.p(1.0,1.0), handler(self, self.setScale))
    action = fgui.composeActions(action, cc.tweenfunc.Quad_EaseOut, 0, handler(self, self.onShown))
    self:displayObject():runAction(action)
end

function  Window2:doHideAnimation()
    local action = fgui.ActionFloat2:create(0.3, self:getScale(), cc.p(0.1, 0.1), handler(self, self.setScale))
    action = fgui.composeActions(action, cc.tweenfunc.Quad_EaseOut, 0, handler(self, self.hideImmediately))
    self:displayObject():runAction(action)
end

return Window2