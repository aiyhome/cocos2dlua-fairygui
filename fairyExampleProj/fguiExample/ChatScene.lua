local DemoScene = require("DemoScene")
local EmojiParser = require("EmojiParser")
local ChatScene = class("ChatScene", DemoScene)

function ChatScene:ctor()
    ChatScene.super.ctor(self)
end

function ChatScene:continueInit()
    self._messages = {}
    fgui.UIPackage:addPackage("UI/Emoji")
    fgui.UIConfig.verticalScrollBar = ""

    self._view = fgui.UIPackage:createObject("Emoji", "Main")
    self._groot:addChild(self._view)

    self._list = self._view:getChild("list")
    self._list:setVirtual()
    self._list:setItemProvider(handler(self, self.getListItemResource))
    self._list:setItemRenderer(handler(self, self.renderListItem))

    self._input = self._view:getChild("input")
    self._input:addEventListener(fgui.UIEventType.Submit, handler(self, self.onSubmit))

    self._view:getChild("btnSend"):addClickListener(handler(self, self.onClickSendBtn))
    self._view:getChild("btnEmoji"):addClickListener(handler(self, self.onClickEmojiBtn))

    self._emojiSelectUI = fgui.UIPackage:createObject("Emoji", "EmojiSelectUI")
    self._emojiSelectUI:retain()
    self._emojiSelectUI:getChild("list"):addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickEmoji))
end

function ChatScene:onClickSendBtn(context)
    local msg = self._input:getText()
    if not msg or #msg == 0 then
        return
    end

    self:addMsg("Unity", "r0", msg, true)
    self._input:setText("")
end

function ChatScene:onClickEmojiBtn(context)
    self._groot:showPopup(self._emojiSelectUI, context:getSender(), fgui.PopupDirection.UP)
end

function ChatScene:onClickEmoji(context)
    local item = context:getData()
    self._input:setText(self._input:getText() .. "[:" .. item:getText() .. "]")
end

function ChatScene:onSubmit(context)
    self:onClickSendBtn(nil)
end

function ChatScene:renderListItem(index, obj)
    local item = obj
    local msg = self._messages[index + 1]
    if not msg.fromMe then
        item:getChild("name"):setText(msg.sender)
    end
    item:setIcon("ui://Emoji/" .. msg.senderIcon)

    local tf = item:getChild("msg")
    tf:setText("")
    tf:setWidth(tf:getInitSize().width)
    tf:setText(EmojiParser:getInstance():parse(msg.msg))
    tf:setWidth(tf:getTextSize().width)
end

function ChatScene:getListItemResource(index)
    local msg = self._messages[index + 1]
    if msg.fromMe then
        return "ui://Emoji/chatRight"
    else
        return "ui://Emoji/chatLeft"
    end
end

function ChatScene:addMsg(sender, senderIcon, msg, fromMe)
    local isScrollBottom = self._list:getScrollPane():isBottomMost()
    local newMessage = {}
    newMessage.sender = sender
    newMessage.senderIcon = senderIcon
    newMessage.msg = msg
    newMessage.fromMe = fromMe
    table.insert(self._messages, newMessage)


    if newMessage.fromMe then
        if #self._messages == 1 or math.random() < 0.5 then
            local replyMessage = {}
            replyMessage.sender = "FairyGUI"
            replyMessage.senderIcon = "r1"
            replyMessage.msg = "Today is a good day. [:cool]"
            replyMessage.fromMe = false
            table.insert(self._messages, replyMessage)
        end
    end

    if #self._messages > 100 then
        for i=#self._messages - 100,1,-1 do
            table.remove(self._messages, i)
        end
    end
    self._list:setNumItems(#self._messages)

    if isScrollBottom then
        self._list:getScrollPane():scrollBottom(true)
    end
end

return ChatScene