local BBCodeParser = class("BBCodeParser")

BBCodeParser._inst = nil

-- BBCode 
local defaultImgWidth = 0
local defaultImgHeight = 0
function BBCodeParser:ctor()
    self._handlers = {}
    self._handlers["url"] = self.onTag_URL
    self._handlers["img"] = self.onTag_IMG
    self._handlers["b"] = self.onTag_Simple
    self._handlers["i"] = self.onTag_Simple
    self._handlers["u"] = self.onTag_Simple
    self._handlers["sup"] = self.onTag_Simple
    self._handlers["sub"] = self.onTag_Simple
    self._handlers["color"] = self.onTag_COLOR
    self._handlers["font"] = self.onTag_FONT
    self._handlers["size"] = self.onTag_SIZE
    self._handlers["align"] = self.onTag_ALIGN
end

function BBCodeParser:getInstance()
    if BBCodeParser._inst == nil then
        BBCodeParser._inst = BBCodeParser.new()
    end
    return BBCodeParser._inst
end

function BBCodeParser:parse(text)
    self._text = text
    local startPos = 1
    local _, p = string.find(text, '%[', startPos)
    if not p then
        return text
    else
        local retText  = ""
        self._endPos = 0
        local tag,attr
        local repl
        local isEnd
        local italicSign 
        while p do
            if p > startPos then
                retText = retText .. string.sub(text, startPos, p - 1)
                startPos = p
            end
            _, self._endPos = string.find(text, '%]', startPos + 1)
            if not self._endPos then
                retText = retText .. string.sub(text, startPos)
                break
            end
            italicSign = string.sub(text, p+1, p+1)
            if italicSign == '/' then
                tag = string.sub(text, p + 2, self._endPos - 1)
                isEnd = true
            else
                tag = string.sub(text, p + 1, self._endPos - 1)                
                isEnd = false
            end
            attr = ""
            repl = ""
            _,p = string.find(text, "=", p + 1)
            if p and p < self._endPos then
                print( startPos + 2, p-1)
                if isEnd then
                    tag = string.sub(text, startPos + 2, p-1)
                else
                    tag = string.sub(text, startPos + 1, p-1)
                end
                attr = string.sub(text, p+1, self._endPos - 1)
            end
            tag = string.lower(tag)
            if self._handlers[tag] then
                repl = self._handlers[tag](self, tag, isEnd, attr)
                retText = retText .. repl
            else
                retText = retText .. string.sub(text, startPos, self._endPos)
            end
            startPos = self._endPos + 1
            _, p = string.find(text, '%[', startPos)
        end
        retText = retText .. string.sub(text, startPos)
        return retText
    end
end


function BBCodeParser:getTagText(remove)
    local _,p = string.find(self._text, '%[', self._endPos + 1)
    if not p then
        return
    end
    local out = string.sub(self._text, self._endPos+1, p - 1)
    if remove then
        self._endPos = p - 1
    end
    return out
end

function BBCodeParser:onTag_Emoji(tagName, isEnd, attr)
    local str = string.sub(tagName, 2)
    str = string.lower(str)
    return "<img src='ui://Emoji/" .. str .. "'/>"
end


function BBCodeParser:onTag_URL(tagName, isEnd, attr)
	local replacement = ""
    if not isEnd then
        if attr and #attr > 0 then
            replacement = "<a href=\"" .. attr .. "\" target=\"_blank\">";
        else
            local href = self:getTagText(false)
            replacement = "<a href=\"" .. (href or "") .. "\" target=\"_blank\">";
        end
    else
        replacement = "</a>"
    end
    return replacement 
end

function BBCodeParser:onTag_IMG(tagName, isEnd, attr)
    local replacement = ""
    if not isEnd then
        local src = self:getTagText(true)
        if not src or #src == 0 then
            return
        end        
        if defaultImgWidth ~= 0 then
            replacement = "<img src=\"" .. src .. "\" width=\"" .. tostring(defaultImgWidth) .. "\" height=\"" .. tostring(defaultImgHeight) .. "\"/>";
        else
            replacement = "<img src=\"" .. src .. "\"/>"
        end
    end
    return replacement
end

function BBCodeParser:onTag_Simple(tagName, isEnd, attr)
    return isEnd and ("</" .. tagName .. ">") or ("<" .. tagName .. ">")
end

function BBCodeParser:onTag_COLOR(tagName, isEnd, attr)
    if not isEnd then
        return "<font color=\"" .. attr .. "\">"
    else
        return "</font>"
    end
end

function BBCodeParser:onTag_FONT(tagName, isEnd, attr)
    if not isEnd then
        return "<font face=\"" .. attr .. "\">"
    else
        return "</font>"
    end
end

function BBCodeParser:onTag_SIZE(tagName, isEnd, attr)
    if not isEnd then
        return "<font size=\"" .. attr .. "\">"
    else
        return "</font>"
    end
end

function BBCodeParser:onTag_ALIGN(tagName, isEnd, attr)
    if not isEnd then
        return "<p align=\"" .. attr .. "\">"
    else
        return "</p>"
    end
end

return BBCodeParser