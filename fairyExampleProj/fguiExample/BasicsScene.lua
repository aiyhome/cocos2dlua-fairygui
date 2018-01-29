local Window1 = require("Window1")
local Window2 = require("Window2")

local DemoScene = require("DemoScene")
local BasicsScene = class("BasicsScene", DemoScene)

function BasicsScene:ctor()
    BasicsScene.super.ctor(self)
end

function BasicsScene:continueInit()

    fgui.UIConfig.buttonSound = "ui://Basics/click"
    fgui.UIConfig.verticalScrollBar = "ui://Basics/ScrollBar_VT"
    fgui.UIConfig.horizontalScrollBar = "ui://Basics/ScrollBar_HZ"
    fgui.UIConfig.tooltipsWin = "ui://Basics/WindowFrame"
    fgui.UIConfig.popupMenu = "ui://Basics/PopupMenu"

    fgui.UIPackage:addPackage("UI/Basics")
    self._view = fgui.UIPackage:createObject("Basics", "Main")
    self._groot:addChild(self._view)

    self._backBtn = self._view:getChild("btn_Back")
    self._backBtn:setVisible(false)
    self._backBtn:addClickListener(handler(self, self.onClickBack))

    self._demoContainer = self._view:getChild("container")
    self._cc = self._view:getController("c1")

    local cnt = self._view:numChildren()
    for i=0,cnt-1,1 do
        local obj = self._view:getChildAt(i)
        if obj:getGroup() and obj:getGroup():getName() == "btns" then
            print("obj:getGroup():getName()",obj:getGroup():getName())
            obj:addClickListener(handler(self, self.runDemo))
        end        
    end
    self._demoObjects = {}
    self:registerScriptHandler(function (event)
        if event == "enter" then
            self:onEnter()
        elseif event == "exit" then
            self:onExit()
        end
    end)
end

function BasicsScene:onEnter()
end

function BasicsScene:onExit()
    for i,v in pairs(self._demoObjects) do
        if not tolua.isnull(v) then
            if v._isAdded and v:getReferenceCount() >= 2 then
                v:release()
            -- elseif v:getReferenceCount() >= 1 then
            --     v:release()
            end
        end
    end
    self._demoObjects = {}
end

function BasicsScene:onClickBack(context)
    self._cc:setSelectedIndex(0)
    self._backBtn:setVisible(false)
end

function BasicsScene:runDemo(context)
    local nType = string.sub(context:getSender():getName(),5, -1)
    local it = self._demoObjects[nType]
    local obj
    if it == nil then
        obj = fgui.UIPackage:createObject("Basics", "Demo_" .. nType)
        self._demoObjects[nType] = obj
    else
        obj = it
    end
    for i,v in pairs(self._demoObjects) do
        if v._isAdded then
            if v:getReferenceCount() < 2 then
               v:retain()
            end
        else
            if v:getReferenceCount() < 1 then
               v:retain()
            end
        end
        v._isAdded = false
    end
    self._demoContainer:removeChildren()
    self._demoContainer:addChild(obj)
    obj._isAdded = true

    self._cc:setSelectedIndex(1)
    self._backBtn:setVisible(true)

    if nType == "Text" then
        self:playText()
    elseif nType == "Depth" then
        self:playDepth()
    elseif nType == "Window" then
        self:playWindow()
    elseif nType == "Drag&Drop" then
        self:playDragDrop()
    elseif nType == "Popup" then
        self:playPopup()
    end
end

function BasicsScene:playText()
    local obj = self._demoObjects["Text"]
    obj:getChild("n12"):addEventListener(fgui.UIEventType.ClickLink, function(context)
        local t = context:getSender()
        t:setText("[img]ui://Basics/pet[/img][color=#FF0000]You click the link[/color]:" .. context:getDataValue())
    end)
    obj:getChild("n25"):addClickListener(function (context)
        obj:getChild("n24"):setText(obj:getChild("n22"):getText())
    end)
end

function BasicsScene:playPopup()
    if self._pm == nil then
        self._pm = fgui.PopupMenu:create()
        self._pm:retain()
        self._pm:addItem("Item 1", handler(self, self.onClickMenu))
        self._pm:addItem("Item 2", handler(self, self.onClickMenu))
        self._pm:addItem("Item 3", handler(self, self.onClickMenu))
        self._pm:addItem("Item 4", handler(self, self.onClickMenu))
    end

    if self._popupCom == nil then
        self._popupCom = fgui.UIPackage:createObject("Basics", "Component12")
        self._popupCom:retain()
        self._popupCom:center()
    end
    local obj = self._demoObjects["Popup"]
    obj:getChild("n0"):addClickListener(function (context)
        self._pm:show(context:getSender(), fgui.PopupDirection.DOWN)
    end)

    obj:getChild("n1"):addClickListener(function (context)
        local UIRoot = fgui.GRoot:getInstance()
        UIRoot:showPopup(self._popupCom)
    end)

    obj:addEventListener(fgui.UIEventType.RightClick, function (context)
        self._pm:show()
    end)
end

function BasicsScene:onClickMenu(context)
    local sender = context:getSender()
    print("click %s", sender:getTitle())
end

function BasicsScene:playWindow()
    local obj = self._demoObjects["Window"]
    if self._winA == nil then
        self._winA = Window1:create()
        self._winA:retain()

        self._winB = Window2:create()
        self._winB:retain()

        obj:getChild("n0"):addClickListener(function (context)
            self._winA:show()
        end)

        obj:getChild("n1"):addClickListener(function (context)
            self._winB:show()
        end)
    end
end

local startPos
function BasicsScene:playDepth()
    local obj = self._demoObjects["Depth"]
    local testContainer = obj:getChild("n22")
    local fixedObj = testContainer:getChild("n0")
    fixedObj:setSortingOrder(100)
    fixedObj:setDraggable(true)

    local numChildren = testContainer:numChildren()
    local i = 0
    while i < numChildren do
        local child = testContainer:getChildAt(i)
        if child ~= fixedObj then
            testContainer:removeChildAt(i)
            numChildren = numChildren - 1
        else
            i = i + 1
        end
    end
    startPos = fixedObj:getPosition()

    obj:getChild("btn0"):addClickListener(function (context)
        local graph = fgui.GGraph:create()
        startPos.x = startPos.x + 10
        startPos.y = startPos.y + 10
        graph:setPosition(startPos.x, startPos.y)
        graph:drawRect(150, 150, 1, cc.c4f(0,0,0,1.0), cc.c4f(1.0,0,0,1.0))
        obj:getChild("n22"):addChild(graph)
    end, 1) --avoid duplicate register

    obj:getChild("btn1"):addClickListener(function (context)
        local graph = fgui.GGraph:create()
        startPos.x = startPos.x + 10
        startPos.y = startPos.y + 10
        graph:setPosition(startPos.x, startPos.y)
        graph:drawRect(150, 150, 1, cc.c4f(0,0,0,1.0), cc.c4f(0,1.0,0,1.0))
        graph:setSortingOrder(200)
        obj:getChild("n22"):addChild(graph)
    end, 2)
end

function BasicsScene:playDragDrop()
    local obj = self._demoObjects["Drag&Drop"]
    obj:getChild("a"):setDraggable(true)

    local b = obj:getChild("b")
    b:setDraggable(true)
    b:addEventListener(fgui.UIEventType.DragStart, function (context)
        --Cancel the original dragging, and start a new one with a agent.
        context:preventDefault()

        fgui.DragDropManager:getInstance():startDrag(b:getIcon(), b:getIcon(), context:getInput():getTouchId())
    end)

    local c = obj:getChild("c")
    c:setIcon("")
    c:addEventListener(fgui.UIEventType.Drop, function(context)
        c:setIcon(context:getDataValue())
    end)

    local bounds = obj:getChild("n7")
    local rect = bounds:transformRect(cc.rect(0, 0, bounds:getSize().width, bounds:getSize().height), self._groot)
    -----!!Because at self time the container is on the right side of the stage and beginning to move to left(transition), so we need to caculate the final position
    rect.x = rect.x  - obj:getParent():getX()
    ------

    local d = obj:getChild("d")
    d:setDraggable(true)
    d:setDragBounds(rect)
end

return BasicsScene