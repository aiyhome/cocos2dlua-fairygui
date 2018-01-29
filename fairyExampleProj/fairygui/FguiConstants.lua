--[[
    @Class   	: FguiConstants
	@Description:
    @Author  	: 
	@Version 	: V1.0
    @Date    	: 2017-12-25 11:36:55
--]]

fgui = fgui or {}

fgui.PackageItemType = 
{
    IMAGE = 0,
    MOVIECLIP = 1,
    SOUND = 2,
    COMPONENT = 3,
    ATLAS = 4,
    FONT = 5,
    MISC = 6
}

fgui.ButtonMode = 
{
    COMMON = 0,
    CHECK = 1,
    RADIO = 2
}

fgui.ChildrenRenderOrder = 
{
    ASCENT = 0,
    DESCENT = 1,
    ARCH = 2,
}

fgui.OverflowType = 
{
    VISIBLE = 0,
    HIDDEN = 1,
    SCROLL = 2
}

fgui.ScrollType =
{
    HORIZONTAL = 0,
    VERTICAL = 1,
    BOTH = 2
}

fgui.ScrollBarDisplayType =
{
    DEFAULT = 0,
    VISIBLE = 1,
    AUTO = 2,
    HIDDEN = 3
}

fgui.LoaderFillType =
{
    NONE = 0,
    SCALE = 1,
    SCALE_MATCH_HEIGHT = 2,
    SCALE_MATCH_WIDTH = 3,
    SCALE_FREE = 4
}

fgui.ProgressTitleType =
{
    PERCENT = 0,
    VALUE_MAX = 1,
    VALUE = 2,
    MAX = 3
}

fgui.ListLayoutType =
{
    SINGLE_COLUMN = 0,
    SINGLE_ROW = 1,
    FLOW_HORIZONTAL = 2,
    FLOW_VERTICAL = 3,
    PAGINATION = 4
}

fgui.ListSelectionMode =
{
    SINGLE = 0,
    MULTIPLE = 1,
    MULTIPLE_SINGLECLICK = 2,
    NONE = 3
}

fgui.GroupLayoutType =
{
    NONE = 0,
    HORIZONTAL = 1,
    VERTICAL = 2
}

fgui.PopupDirection =
{
    AUTO = 0,
    UP = 1,
    DOWN = 2
}

fgui.TextAutoSize =
{
    NONE = 0,
    BOTH = 1,
    HEIGHT = 2,
    SHRINK = 3
}

fgui.FlipType =
{
    NONE = 0,
    HORIZONTAL = 1,
    VERTICAL = 2,
    BOTH = 3
}

fgui.RelationType = 
{
    Left_Left = 0,
    Left_Center = 1,
    Left_Right = 2,
    Center_Center = 3,
    Right_Left = 4,
    Right_Center = 5,
    Right_Right = 6,

    Top_Top = 7,
    Top_Middle = 8,
    Top_Bottom = 9,
    Middle_Middle = 10,
    Bottom_Top = 11,
    Bottom_Middle = 12,
    Bottom_Bottom = 13,

    Width = 14,
    Height = 15,

    LeftExt_Left = 16,
    LeftExt_Right = 17,
    RightExt_Left = 18,
    RightExt_Right = 19,
    TopExt_Top = 20,
    TopExt_Bottom = 21,
    BottomExt_Top = 22,
    BottomExt_Bottom = 23,

    Size = 24
}


fgui.UIEventType = 
{
    Enter = 0,
    Exit = 1,
    Changed = 2,
    Submit = 3,

    TouchBegin = 10,
    TouchMove = 11,
    TouchEnd = 12,
    Click = 13,
    RollOver = 14,
    RollOut = 15,
    MouseWheel = 16,
    RightClick = 17,
    MiddleClick = 18,

    PositionChange = 20,
    SizeChange = 21,

    KeyDown = 30,
    KeyUp = 31,

    Scroll = 40,
    ScrollEnd = 41,
    PullDownRelease = 42,
    PullUpRelease = 43,

    ClickItem = 50,
    ClickLink = 51,
    ClickMenu = 52,
    RightClickItem = 53,

    DragStart = 60,
    DragMove = 61,
    DragEnd = 62,
    Drop = 63,

    GearStop = 70,

    constructFromResource = 80,
    setup_BeforeAdd = 82,
    setup_AfterAdd = 83,
    constructFromXML = 84, 

    onWinInit = 91,
    onWinShown = 92,
    onWinHide = 93,
    onWinDoShowAnimation = 94,
    onWinDoHideAnimation = 95,
}