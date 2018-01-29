local DemoScene = require("DemoScene")
local ModalWaitingScene = class("GuideScene", DemoScene)

function ModalWaitingScene:ctor()
    ModalWaitingScene.super.ctor(self)
end

function ModalWaitingScene:continueInit()
    fgui.UIPackage:addPackage("UI/ModalWaiting")
    fgui.UIConfig.globalModalWaiting = "ui://ModalWaiting/GlobalModalWaiting"
    fgui.UIConfig.windowModalWaiting = "ui://ModalWaiting/WindowModalWaiting"

    self._view = fgui.UIPackage:createObject("ModalWaiting", "Main")
    self._groot:addChild(self._view)

    self._testWin = fgui.Window:create()
    self._testWin:retain()
    self._testWin:setContentPane(fgui.UIPackage:createObject("ModalWaiting", "TestWin"))
    self._testWin:getContentPane():getChild("n1"):addClickListener(function(context)
        self._testWin:showModalWait()
        --simulate a asynchronous request
        self:scheduleOnce(function()
            self._testWin:closeModalWait()
        end, 3, "wait")
    end)

    self._view:getChild("n0"):addClickListener(function()  self._testWin:show() end)

    self._groot:showModalWait()

    --simulate a asynchronous request

    self:scheduleOnce(function()
        self._groot:closeModalWait()
    end, 3, "wait")
end

return ModalWaitingScene