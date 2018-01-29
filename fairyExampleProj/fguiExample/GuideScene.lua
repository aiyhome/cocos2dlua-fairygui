local DemoScene = require("DemoScene")
local GuideScene = class("GuideScene", DemoScene)

function GuideScene:ctor()
    GuideScene.super.ctor(self)
end

function GuideScene:continueInit()
    fgui.UIPackage:addPackage("UI/Guide")

    self._view = fgui.UIPackage:createObject("Guide", "Main")
    self._groot:addChild(self._view)

    self._guideLayer = fgui.UIPackage:createObject("Guide", "GuideLayer")
    self._guideLayer:makeFullScreen()
    self._guideLayer:addRelation(self._groot, fgui.RelationType.Size)

    local bagBtn = self._view:getChild("bagBtn")
    bagBtn:addClickListener(function(context)
        self._guideLayer:removeFromParent()
    end)

    self._view:getChild("n2"):addClickListener(function (context)
        
        self._groot:addChild(self._guideLayer) --!!Before using TransformRect(or GlobalToLocal), the object must be added first
        local rect = bagBtn:transformRect(cc.rect(0,0, bagBtn:getSize().width, bagBtn:getSize().height), self._guideLayer)

        local window = self._guideLayer:getChild("window")
        window:setSize(math.floor(rect.width), math.floor(rect.height))

        local action = fgui.ActionFloat2:create(0.5, window:getPosition(), cc.p(rect.x, rect.y),handler(window, window.setPosition))
        window:displayObject():runAction(action)

    end
end

return GuideScene