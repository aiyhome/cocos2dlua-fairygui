local DemoScene = require("DemoScene")
local TransitionDemoScene = class("TransitionDemoScene", DemoScene)

function TransitionDemoScene:ctor()
    TransitionDemoScene.super.ctor(self)
end

function TransitionDemoScene:continueInit()
    fgui.UIPackage:addPackage("UI/Transition")
    self._view = fgui.UIPackage:createObject("Transition", "Main")
    self._groot:addChild(self._view)

    self._btnGroup = self._view:getChild("g0")

    self._g1 = fgui.UIPackage:createObject("Transition", "BOSS")
    self._g1:retain()
    self._g2 = fgui.UIPackage:createObject("Transition", "BOSS_SKILL")
    self._g2:retain()
    self._g3 = fgui.UIPackage:createObject("Transition", "TRAP")
    self._g3:retain()
    self._g4 = fgui.UIPackage:createObject("Transition", "GoodHit")
    self._g4:retain()
    self._g5 = fgui.UIPackage:createObject("Transition", "PowerUp")
    self._g5:retain()
    self._g5:getTransition("t0"):setHook("play_num_now", handler(self, self.playNum))

    self._view:getChild("btn0"):addClickListener(function(context)  self:__play(self._g1) end)
    self._view:getChild("btn1"):addClickListener(function(context)  self:__play(self._g2) end)
    self._view:getChild("btn2"):addClickListener(function(context)  self:__play(self._g3) end)
    self._view:getChild("btn3"):addClickListener(handler(self, self.__play4))
    self._view:getChild("btn4"):addClickListener(handler(self, self.__play5))
end

function TransitionDemoScene:__play(target)
    self._btnGroup:setVisible(false)
    self._groot:addChild(target)
    local t = target:getTransition("t0")
    t:play(function()
        self._btnGroup:setVisible(true)
        self._groot:removeChild(target)
    end)
end

function TransitionDemoScene:__play4(context)
    self._btnGroup:setVisible(false)
    self._g4:setPosition(self._groot:getWidth() - self._g4:getWidth() - 20, 100)
    self._groot:addChild(self._g4)
    local t = self._g4:getTransition("t0")
    t:play(3, 0, function()
        self._btnGroup:setVisible(true)
        self._groot:removeChild(self._g4)
    end)
end

function TransitionDemoScene:__play5(context)
    self._btnGroup:setVisible(false)
    self._g5:setPosition(20, self._groot:getHeight() - self._g5:getHeight() - 100)
    self._groot:addChild(self._g5)
    local t = self._g5:getTransition("t0")
    self._startValue = 10000
    local add = 1000 + math.random() * 2000
    self._endValue = self._startValue + add
    self._g5:getChild("value"):setText(tostring(self._startValue))
    self._g5:getChild("add_value"):setText(tostring(add))
    t:play(function()
        self._btnGroup:setVisible(true)
        self._groot:removeChild(self._g5)
    end)
end

function TransitionDemoScene:playNum()
    local action = fgui.ActionFloat:create(0.3, self._startValue, self._endValue, function(value)
        self._g5:getChild("value"):setText(tostring(value))
    end)
    self._view:displayObject():runAction(action)
end

return TransitionDemoScene