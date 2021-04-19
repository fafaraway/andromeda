local F, C = unpack(select(2, ...))

--	Get target NPC name and ID
_G.SlashCmdList.NPCID = function()
	local name = UnitName("target")
	local unitGUID = UnitGUID("target")
	local id = unitGUID and select(6, strsplit('-', unitGUID))
	if id then
		print(name..": "..id)
	end
end
_G.SLASH_NPCID1 = "/getid"

--	Show frame you currently have mouseovered
_G.SlashCmdList.FRAME = function(arg)
    if arg ~= '' then
        arg = _G[arg]
    else
        arg = GetMouseFocus()
    end
    if arg ~= nil then
        _G.FRAME = arg
    end
    if arg ~= nil and not arg:IsForbidden() and arg:GetName() ~= nil then
        local point, relativeTo, relativePoint, xOfs, yOfs = arg:GetPoint()
        print(C.LineString)
        print('Name: |cffFFD100' .. arg:GetName() .. '|r')
        if arg:GetParent() and arg:GetParent():GetName() then
            print('Parent: |cffFFD100' .. arg:GetParent():GetName() .. '|r')
        end

        print('Width: |cffFFD100' .. format('%.2f', arg:GetWidth()) .. '|r')
        print('Height: |cffFFD100' .. format('%.2f', arg:GetHeight()) .. '|r')
        print('Strata: |cffFFD100' .. arg:GetFrameStrata() .. '|r')
        print('Level: |cffFFD100' .. arg:GetFrameLevel() .. '|r')

        if relativeTo and relativeTo:GetName() then
            print('Point: |cffFFD100 "' .. point .. '", ' .. relativeTo:GetName() .. ', "' .. relativePoint .. '"' ..
                      '|r')
        end
        if xOfs then
            print('X: |cffFFD100' .. format('%.2f', xOfs) .. '|r')
        end
        if yOfs then
            print('Y: |cffFFD100' .. format('%.2f', yOfs) .. '|r')
        end
        print(C.LineString)
    elseif arg == nil then
        print('Invalid frame name')
    else
        print('Could not find frame info')
    end
end
_G.SLASH_FRAME1 = '/frame'

_G.SlashCmdList['FSTACK'] = function()
    UIParentLoadAddOn('Blizzard_DebugTools')
    FrameStackTooltip_Toggle(false, true, true)
end
_G.SLASH_FSTACK1 = '/fs'
_G.SLASH_FRAMESTK1 = nil -- fix LFGFilter

_G.SlashCmdList['FRAMENAME'] = function()
    local frame = EnumerateFrames()
    while frame do
        if (frame:IsVisible() and MouseIsOver(frame)) then
            print(frame:GetName() or string.format(UNKNOWN .. ': [%s]', tostring(frame)))
        end
        frame = EnumerateFrames(frame)
    end
end
_G.SLASH_FRAMENAME1 = '/fsn'

_G.SlashCmdList['EVENTTRACE'] = function(msg)
    UIParentLoadAddOn('Blizzard_DebugTools')
    EventTraceFrame_HandleSlashCmd(msg)
end
_G.SLASH_EVENTTRACE1 = '/et'

_G.SlashCmdList['INSTANCEINFO'] = function()
    local name, instanceType, difficultyID, difficultyName, _, _, _, instanceMapID = GetInstanceInfo()
    print(C.LineString)
    print(C.InfoColor .. 'Name ' .. C.RedColor .. name)
    print(C.InfoColor .. 'instanceType ' .. C.RedColor .. instanceType)
    print(C.InfoColor .. 'difficultyID ' .. C.RedColor .. difficultyID)
    print(C.InfoColor .. 'difficultyName ' .. C.RedColor .. difficultyName)
    print(C.InfoColor .. 'instanceMapID ' .. C.RedColor .. instanceMapID)
    print(C.LineString)
end
_G.SLASH_INSTANCEINFO1 = '/getinstinfo'

_G.SlashCmdList['QUESTINFO'] = function(id)
    if id == '' then
        print(C.RedColor .. 'Please enter a Quest ID.|r')
    else
        local isCompleted = C_QuestLog.IsQuestFlaggedCompleted(id)
        print(C.BlueColor .. 'Quest ID |r |Hquest:' .. id .. '|h[' .. id .. ']|h')

        if isCompleted == true then
            print(C.InfoColor .. 'Complete|r (YES)')
        else
            print(C.InfoColor .. 'Complete|r (NO)')
        end
    end
end
_G.SLASH_QUESTINFO1 = '/getquestinfo'

_G.SlashCmdList['UISCALE'] = function()
    print(C.LineString)
    print('C.ScreenWidth ' .. C.ScreenWidth)
    print('C.ScreenHeight ' .. C.ScreenHeight)
    print('C.Mult ' .. C.Mult)
    print('uiScale ' .. _G.FREE_ADB.UIScale)
    print('UIParentScale ' .. _G.UIParent:GetScale())
    print(C.LineString)
end
_G.SLASH_UISCALE1 = '/getuiscale'

_G.SlashCmdList['ITEMINFO'] = function(id)
    if id == '' then
        print(C.RedColor .. 'Please enter a item ID.|r')
    else
        local name, link, rarity, level, minLevel, type, subType, _, _, _, _, classID, subClassID, bindType =
            GetItemInfo(id)

        print(C.LineString)
        print('Name: ' .. name)
        print('Link: ' .. link)
        print('Rarity: ' .. rarity)
        print('Level: ' .. level)
        print('MinLevel: ' .. minLevel)
        print('Type: ' .. type)
        print('SubType: ' .. subType)
        print('ClassID: ' .. classID)
        print('SubClassID: ' .. subClassID)
        print('BindType: ' .. bindType)
        print(C.LineString)
    end
end
_G.SLASH_ITEMINFO1 = '/getiteminfo'

-- Test DBM
_G.SlashCmdList.DBMTEST = function()
    if IsAddOnLoaded('DBM-Core') then
        _G.DBM:DemoMode()
    end
end
_G.SLASH_DBMTEST1 = '/dbmtest'
