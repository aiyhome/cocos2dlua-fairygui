local DemoScene = require("DemoScene")
local TreeViewScene = class("TreeViewScene", DemoScene)

function TreeViewScene:ctor()
    TreeViewScene.super.ctor(self)
end

function TreeViewScene:continueInit()
    fgui.UIPackage:addPackage("UI/TreeView")

    self._view = fgui.UIPackage:createObject("TreeView", "Main")
    self._groot:addChild(self._view)

    self._treeView = fgui.TreeView:create(self._view:getChild("tree"))
    self._treeView:retain()

    self._treeView:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickNode))
    self._treeView:setTreeNodeRender( handler(self, self.renderTreeNode))

    local topNode = fgui.TreeNode:create(true)
    topNode:setData("I'm a top node")
    self._treeView:getRootNode():addChild(topNode)
    for i=0,4,1 do
        local node = fgui.TreeNode:create()
        node:setData("Hello " .. i)
        topNode:addChild(node)
    end
    local aFolderNode = fgui.TreeNode:create(true)
    aFolderNode:setData("A folder node")
    topNode:addChild(aFolderNode)
    for i=0,4,1 do
        local node = fgui.TreeNode:create()
        node:setData("Good " .. i)
        aFolderNode:addChild(node)
    end

    for i=0,2,1 do   
        local node = fgui.TreeNode:create()
        node:setData("World " .. i)
        topNode:addChild(node)
    end

    local anotherTopNode = fgui.TreeNode:create()
    anotherTopNode:setData({
        "I'm a top node too",
        "ui://TreeView/heart",
    })
    self._treeView:getRootNode():addChild(anotherTopNode)
end

function TreeViewScene:onClickNode(context)
    local node = tolua.cast(context:getData(),"fgui.TreeNode")
    if node:isFolder() and context:getInput():isDoubleClick() then
        node:setExpaned(not node:isExpanded())
    end
end

function TreeViewScene:renderTreeNode(node)
    local btn = node:getCell()
    if node:isFolder() then
   
        if node:isExpanded() then
            btn:setIcon("ui://TreeView/folder_opened")
        else
            btn:setIcon("ui://TreeView/folder_closed")
        end
        btn:setText(tostring(node:getData()))

    elseif type(node:getData()) == "table" then
        local array = node:getData()
        btn:setIcon(tostring(array[2]))
        btn:setText(tostring(array[1]))
    else   
        btn:setIcon("ui://TreeView/file")
        btn:setText(tostring(node:getData()))
    end
end

return TreeViewScene