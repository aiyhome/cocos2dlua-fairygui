fgui = fgui or {}
local _UIConfig = fgui.UIConfig or {}

local UIConfigCache = {}
UIConfigCache.defaultFont = ""
UIConfigCache.buttonSound = ""

UIConfigCache.buttonSoundVolumeScale = 1
UIConfigCache.defaultScrollStep = 25
UIConfigCache.defaultScrollDecelerationRate = 0.967
UIConfigCache.defaultScrollTouchEffect = true
UIConfigCache.defaultScrollBounceEffect = true
UIConfigCache.defaultScrollBarDisplay = fgui.ScrollBarDisplayType.DEFAULT
UIConfigCache.verticalScrollBar = ""
UIConfigCache.horizontalScrollBar = ""
UIConfigCache.touchDragSensitivity = 10
UIConfigCache.clickDragSensitivity = 2
UIConfigCache.touchScrollSensitivity = 20
UIConfigCache.defaultComboBoxVisibleItemCount = 10
UIConfigCache.globalModalWaiting = ""
UIConfigCache.tooltipsWin = ""
UIConfigCache.modalLayerColor = cc.c4b(0, 0, 0, 0.4)
UIConfigCache.bringWindowToFrontOnClick = true
UIConfigCache.windowModalWaiting = ""
UIConfigCache.popupMenu = ""
UIConfigCache.popupMenu_seperator = ""

fgui.UIConfig = {}

local _R_meta = {}
function _R_meta:__index(key, ...)
	if UIConfigCache[key] then
		return UIConfigCache[key]
	elseif _UIConfig[key] then
		return function(table, ...)
			_UIConfig[key](_UIConfig, ...)
		end
	end
end

function _R_meta:__newindex(key, value)
	UIConfigCache[key] = value
    _UIConfig:setProperty(key, value)
end

setmetatable(fgui.UIConfig, _R_meta)
fgui._UIConfig = _UIConfig