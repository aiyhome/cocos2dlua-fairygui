
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 1

-- use framework, will disable all deprecated API, false - use legacy API
CC_USE_FRAMEWORK = true

-- show FPS on screen
CC_SHOW_FPS = false

-- disable create unexpected global variable
CC_DISABLE_GLOBAL = false

-- for module display
CC_DESIGN_RESOLUTION = {
    width = 1334,
    height = 750,
    
    -- frameWidth = 2048,
    -- frameHeight = 1536,
    -- frameWidth = 1920,
    -- frameHeight = 1080,
    -- frameWidth = 2436, 
    -- frameHeight = 1125,

    autoscale = "FIXED_WIDTH",
    callback = function(framesize)
        local ratio = framesize.width / framesize.height
        if ratio <= 1.34 then
            -- iPad 768*1024(1536*2048) is 4:3 screen
            CC_DESIGN_RESOLUTION.isNearSquare = true
            CC_DESIGN_RESOLUTION.autoscale = "FIXED_WIDTH"
            return {autoscale = "FIXED_WIDTH"}
        elseif ratio >= 1.78  then
            CC_DESIGN_RESOLUTION.autoscale = "FIXED_HEIGHT"
            return {autoscale = "FIXED_HEIGHT"}
        end
    end
}

-- hot update
CC_HOTUPDATE_ENABLE = true

-- app version name
APP_VERSION_NAME = "1.0.0"
APP_VERSION_CODE = 1

PROTO_VERSION = 1001

-- resource version name
RES_VERSION_NAME = "1.0.0.0"
RES_VERSION_CODE = 0