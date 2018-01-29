local BBCodeParser = require("BBCodeParser")
local EmojiParser = class("EmojiParser",BBCodeParser)

EmojiParser._inst = nil

-- BBCode 
local defaultImgWidth = 0
local defaultImgHeight = 0
function EmojiParser:ctor()
    EmojiParser.super.ctor(self)
    local tags = { "88","am","bs","bz","ch","cool","dhq","dn","fd","gz","han","hx","hxiao","hxiu" }

    for _,v in ipairs(tags) do
        self._handlers[":" .. v] = self.onTag_Emoji
    end
end

function EmojiParser:getInstance()
    if EmojiParser._inst == nil then
        EmojiParser._inst = EmojiParser.new()
    end
    return EmojiParser._inst
end

return EmojiParser