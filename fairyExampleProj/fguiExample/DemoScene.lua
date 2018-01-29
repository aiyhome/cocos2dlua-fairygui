local DemoScene = class("DemoScene", cc.Scene)

function DemoScene:ctor()
    self._groot = fgui.GRoot:create(self)
    self._groot:retain()
    self:continueInit()

    --add a closebutton to scene
    local closeButton = fgui.UIPackage:createObject("MainMenu", "CloseButton");
    closeButton:setPosition(self._groot:getWidth() - closeButton:getWidth() - 10, self._groot:getHeight() - closeButton:getHeight() - 10)
    closeButton:addRelation(self._groot, fgui.RelationType.Right_Right)
    closeButton:addRelation(self._groot, fgui.RelationType.Bottom_Bottom)
    closeButton:setSortingOrder(100000)
    closeButton:addClickListener(handler(self, self.onClose))
    self._groot:addChild(closeButton)
end

function DemoScene:continueInit()
	-- body
end

function DemoScene:scheduleOnce(callback, delay)
    local sharedScheduler = cc.Director:getInstance():getScheduler()
    local handle
    handle = sharedScheduler:scheduleScriptFunc(function()
        sharedScheduler:unscheduleScriptEntry(handle)
        callback()
    end, delay, false)
end

function DemoScene:onClose(context)
    if self.__cname ~= "MenuScene" then
        local MenuScene = require("MenuScene")
        local scene = cc.TransitionFlipX:create(1, MenuScene:create())
        cc.Director:getInstance():replaceScene(scene)
    else
        cc.Director:getInstance():endToLua()
    end
end

return DemoScene