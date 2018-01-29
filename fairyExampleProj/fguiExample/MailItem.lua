local MailItem = class("MailItem", fgui.GButton)

function MailItem:ctor()
    self:addEventListener(fgui.UIEventType.constructFromXML, handler(self, self.constructFromXML))
end

function MailItem:constructFromXML()
    self._timeText = self:getChild("timeText")
    self._readController = self:getController("IsRead")
    self._fetchController = self:getController("c1")
    self._trans = self:getTransition("t0")
end

function MailItem:setTime(value)
    self._timeText:setText(value)
end

function MailItem:setRead(value)
    self._readController:setSelectedIndex(value and 1 or 0)
end

function MailItem:setFetched(value)
    self._fetchController:setSelectedIndex(value and 1 or 0)
end

function MailItem:playEffect(delay)
    self:setVisible(false)
    self._trans:play(1, delay)
end

return MailItem
