--[[
    @Class      : main
    @Description: cocos2d调用lua入口文件
    @Author     : 
    @Version    : V1.0
    @Date       : 
--]]

local fileUtils = cc.FileUtils:getInstance()
--load image fail notify enable/disable
fileUtils:setPopupNotify(false)
-- --add local apk script path
-- cc.FileUtils:getInstance():addSearchPath("src/")
-- --add local apk res path
-- cc.FileUtils:getInstance():addSearchPath("res/")

local appWritablePath = cc.FileUtils:getInstance():getWritablePath()
-- 比较版本, 1: versionA < versionB, -1: versionA > versionB, 0: versionA == versionB
local function compareVersion(versionA, versionB)
    local verSegmentsA = string.split(versionA, ".")
    local verSegmentsB = string.split(versionB, ".")
    local n = #verSegmentsA
    local maxIdx = 0
    if n > #verSegmentsB then
        maxIdx = 1
        n = #verSegmentsB
    elseif n < #verSegmentsB then
        maxIdx = 2
    end
    local ret = 0
    for i=1,n do
        if verSegmentsA[i] < verSegmentsB[i] then
            ret = 1
            break
        elseif verSegmentsA[i] > verSegmentsB[i] then
            ret = -1
            break
        end
    end
    if ret == 0 then
        if maxIdx == 1 then
            ret = -1
        elseif maxIdx == 2 then
            ret = 1
        end
    end
    return ret
end

-- 检查是否存在版本在存储内存里
local function checkStorageVersionValid()
    require "cocos/cocos2d/functions"
    local json = require("cocos/cocos2d/json")
    local updateVerFilePath = appWritablePath.."upd/project.manifest"
    local localVersion

    if io.exists(updateVerFilePath) then
        local verData = json.decode(io.readfile(updateVerFilePath))
        localVersion = verData.version
    end
    if localVersion then
        local jsonStr = cc.FileUtils:getInstance():getDataFromFile("version/project.manifest")
        if jsonStr then
            local versionJsonInApp = json.decode(jsonStr)
            return compareVersion(versionJsonInApp.version, localVersion)
        else
            return 1
        end
    else
        return -1
    end
end

-- 检查是否存在本地版本
if checkStorageVersionValid() == 1 then
    --add update path
    fileUtils:addSearchPath(appWritablePath.."upd/", true)
    fileUtils:addSearchPath(appWritablePath.."upd/src/", true)
    fileUtils:addSearchPath(appWritablePath.."upd/res/", true)
end
----------------------------------------------------分界线-----------------------------------------------------


-- ccs = {}
require "config"
require "cocos.init"

local director = cc.Director:getInstance()

local function main()
    -- 谨慎修改此文件，热更不了当前文件
    math.newrandomseed()
    director:setProjection(cc.DIRECTOR_PROJECTION_2D)

    -- 设置不同平台对应的默认字体
    device.systemFont  = "DroidSansFallback"
    if device.platform == "android" then
        device.systemFont = "/system/fonts/" .. device.systemFont
    elseif device.platform == "ios" then
        device.systemFont = "Heiti SC"
    elseif device.platform == "windows" then
        device.systemFont = "Droid Sans Fallback"
        device.errorLogPath = device.writablePath.."error.txt"
    end

    fileUtils:addSearchPath("fguiExample/")
    require("AppDelegate")
end

function ReportException(errorName, errorStr)
    if not Native then
        local director = cc.Director:getInstance()
        if device.platform == "windows" then
            Native = require( "app/platform/windows" )
        elseif device.platform == "android" then
            Native = require( "app/platform/android" )
        elseif device.platform == "ios" then
            Native = require( "app/platform/ios" )
        else        
            Native = require( "app/platform/base" )
        end
    end
    if Global then
        Native:reportExceptionByBugly(errorName, errorStr, Global.UserInfo.uid, Global.UserInfo.name)
        Native:reportErrorByUmeng(errorStr)
    else
        Native:reportExceptionByBugly("LUA-EXCEPTION", errorStr)
        Native:reportErrorByUmeng(errorStr)
    end
end

__G__TRACKBACK__ = function(msg)
    local errorStr = "\n[TRACKBACK]----------------------------------------\n" .. 
                  "[TRACKBACK]LUA ERROR: " .. tostring(msg) .."\n" .. 
                  "[TRACKBACK]"..debug.traceback() .. "\n" .. 
                  "[TRACKBACK]----------------------------------------\n"
    if device.platform == "windows" then
        print(errorStr)
        local W = require 'winapi'
        if device.errorLogPath then
            local file = assert(io.open(device.errorLogPath,"wb"))
            file:write(__G__PRINTINFO__)
            file:close()
            local window = W.get_foreground_window()
            window:destroy()

            local console = W.get_console()
            console:read_async(function(line)
                if line:match '^t' then
                    local notepadExePath = '"C:/Program Files (x86)/Notepad++/notepad++.exe" '
                    os.execute(notepadExePath .. device.errorLogPath)
                else                        
                    os.exit()
                end
            end)
            W.sleep(-1)
        else
            director:endToLua()
        end
    else
        local verInfo = ""
        if RES_VERSION_CODE ~= 0 then
            string.format("[Res v%s Build%04d]", RES_VERSION_NAME, RES_VERSION_CODE)
        end
        if Global and Global.UserInfo.deviceId and #Global.UserInfo.deviceId > 0 then
            errorStr = Global.UserInfo.deviceId .. ":" .. verInfo .. errorStr
        else
            errorStr = verInfo .. errorStr
        end
        print(errorStr)
        ReportException("LUA-EXCEPTION", errorStr)
    end
end
-- if device.platform == "windows" then
--     local _print = print
--     __G__PRINTINFO__ = ""
--     print = function(...)
--         _print(...)
--         local infos = {...}
--         for _,v in ipairs(infos) do
--             __G__PRINTINFO__ = __G__PRINTINFO__ .. tostring(v)
--         end
--         __G__PRINTINFO__ = __G__PRINTINFO__ .. "\n"
--     end
--     local W = require 'winapi'
--     local window = W.get_foreground_window()
--     local desktopWidth,desktopHeight = winapi.get_desktop_window():get_bounds()
--     local window = W.get_foreground_window()
--     window:set_text(string.format("FantasySports[%d]-%d", 0, 0))
--     local winLeft,winTop = window:get_position()
--     local winWidth,winHeight = window:get_bounds()
--     local newLeft = desktopWidth - winWidth - 40
--     local newTop = 40
--     window:resize(newLeft,newTop,winWidth,winHeight)
-- end

local status, retMsg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(retMsg)
end