local BagWindow = class("BagWindow", fgui.Window)

function BagWindow:ctor()
    self:setOverride(true)
    self:addEventListener(fgui.UIEventType.onWinInit, handler(self, self.onInit))
    self:addEventListener(fgui.UIEventType.onWinShown, handler(self, self.onShown))
    self:addEventListener(fgui.UIEventType.onWinHide, handler(self, self.onHide))
    self:addEventListener(fgui.UIEventType.onWinDoShowAnimation, handler(self, self.doShowAnimation))
    self:addEventListener(fgui.UIEventType.onWinDoHideAnimation, handler(self, self.doHideAnimation))
end

function BagWindow:onInit()
    self._contentPane = fgui.UIPackage:createObject("Bag", "BagWin")
    self:setContentPane(self._contentPane)
    self:center()
    self:setModal(true)

    self._list = self._contentPane:getChild("list")
    self._list:setItemRenderer(handler(self, self.renderListItem))
    self._list:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
    self._list:setNumItems(45)
end

function BagWindow:onShown()
end

function BagWindow:onHide()
end

function BagWindow:renderListItem(index, obj)
    obj:setIcon("icons/i" .. math.floor(math.random() * 10) .. ".png")
    obj:setText( tostring(math.floor(math.random() * 100)) )
end

function BagWindow:doShowAnimation()
    self:setScale(0.1, 0.1)
    self:setPivot(0.5, 0.5)

    local action = fgui.ActionFloat2:create(0.3, self:getScale(), cc.p(1.0,1.0), handler(self, self.setScale))
    action = fgui.composeActions(action, cc.tweenfunc.Quad_EaseOut, 0, handler(self, self.onShown))
    self:displayObject():runAction(action)
end

function BagWindow:doHideAnimation()
    local action = fgui.ActionFloat2:create(0.3, self:getScale(), cc.p(0.1, 0.1), handler(self, self.setScale))
    action = fgui.composeActions(action, cc.tweenfunc.Quad_EaseOut, 0, handler(self, self.hideImmediately))
    self:displayObject():runAction(action)
end

function BagWindow:onClickItem(context)
    local item = context:getData()
    self._contentPane:getChild("n11"):setIcon(item:getIcon())
    self._contentPane:getChild("n13"):setText(item:getText())
end

return BagWindow