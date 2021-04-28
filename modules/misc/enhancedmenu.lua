--[[
    Extends popup menus
    Based on EnhancedMenu by enderneko
    https://github.com/enderneko/EnhancedMenu
]]

local _G = _G
local unpack = unpack
local select = select
local wipe = wipe
local tinsert = tinsert
local strsplit = strsplit
local strlen = strlen
local gsub = gsub
local strsub = strsub
local strlower = strlower
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local UIDropDownMenu_Initialize = UIDropDownMenu_Initialize
local UIDropDownMenu_AddButton = UIDropDownMenu_AddButton
local UnitPopup_HasVisibleMenu = UnitPopup_HasVisibleMenu
local UIDropDownMenu_GetCurrentDropDown = UIDropDownMenu_GetCurrentDropDown
local UIDropDownMenu_AddSeparator = UIDropDownMenu_AddSeparator
local UIDropDownMenu_CreateInfo = UIDropDownMenu_CreateInfo
local ToggleDropDownMenu = ToggleDropDownMenu
local C_FriendList_SetWhoToUi = C_FriendList.SetWhoToUi
local C_FriendList_SendWho = C_FriendList.SendWho
local C_BattleNet_GetFriendNumGameAccounts = C_BattleNet.GetFriendNumGameAccounts
local C_BattleNet_GetFriendGameAccountInfo = C_BattleNet.GetFriendGameAccountInfo
local C_PartyInfo_InviteUnit = C_PartyInfo.InviteUnit
local GetRealmName = GetRealmName
local BNGetFriendIndex = BNGetFriendIndex
local IsAltKeyDown = IsAltKeyDown
local ChatEdit_ChooseBoxForSend = ChatEdit_ChooseBoxForSend
local ChatEdit_ActivateChat = ChatEdit_ActivateChat
local StaticPopup_Show = StaticPopup_Show
local GuildInvite = GuildInvite
local YES = YES
local NO = NO
local CHAT_GUILD_INVITE_SEND = CHAT_GUILD_INVITE_SEND

local F, C, L = unpack(select(2, ...))
local EM = F:RegisterModule('EnhancedMenu')
local LRI = F.Libs.LRI

local EnhancedMenu_Func = {}
local EnhancedMenu_Which = {}

local EnhancedMenu_ItemOrder = {
    'GUILD_INVITE',
    'COPY_NAME',
    'SEND_WHO',
    'ARMORY_URL',
    'RAIDER_IO'
}

local EnhancedMenu_Items = {
    ['ENHANCED_MENU'] = {text = L['Enhanced Menu'], isTitle = true, notCheckable = 1},
    ['GUILD_INVITE'] = {text = L['Guild Invite'], notCheckable = 1},
    ['COPY_NAME'] = {text = L['Copy Name'], notCheckable = 1},
    ['SEND_WHO'] = {text = L['Who'], notCheckable = 1},
    ['ARMORY_URL'] = {text = L['Armory'], notCheckable = 1},
    ['RAIDER_IO'] = {text = L['Raider.IO'], notCheckable = 1},
}

EnhancedMenu_Which['GUILD_INVITE'] = {
    ['PLAYER'] = true,
    ['FRIEND'] = true,
    ['PARTY'] = true,
    ['RAID_PLAYER'] = true,
    ['BN_FRIEND'] = true,
}

EnhancedMenu_Which['COPY_NAME'] = {
    ['SELF'] = true,
    ['TARGET'] = true,
    ['PARTY'] = true,
    ['PLAYER'] = true,
    ['RAID_PLAYER'] = true,
    ['FRIEND'] = true,
    ['FRIEND_OFFLINE'] = true,
    ['COMMUNITIES_GUILD_MEMBER'] = true,
    ['BN_FRIEND'] = true,
}

EnhancedMenu_Which['SEND_WHO'] = {
    ['FRIEND'] = true
}

if LRI:GetCurrentRegion() == 'CN' then
    EnhancedMenu_Which['ARMORY_URL'] = {}
else
    EnhancedMenu_Which['ARMORY_URL'] = {
        ['SELF'] = true,
        ['PARTY'] = true,
        ['PLAYER'] = true,
        ['RAID_PLAYER'] = true,
        ['FRIEND'] = true,
        ['FRIEND_OFFLINE'] = true,
        ['COMMUNITIES_GUILD_MEMBER'] = true,
        ['BN_FRIEND'] = true,
    }
end

EnhancedMenu_Which['RAIDER_IO'] = {
    ['SELF'] = true,
    ['PARTY'] = true,
    ['PLAYER'] = true,
    ['RAID_PLAYER'] = true,
    ['FRIEND'] = true,
    ['FRIEND_OFFLINE'] = true,
    ['COMMUNITIES_GUILD_MEMBER'] = true,
    ['BN_FRIEND'] = true,
}

-- func
local subInfos = {}

local submenu = CreateFrame('Frame', 'EnhancedMenu_SubMenu')
local function ToggleEnhancedMenu_SubMenu(funcName)
    UIDropDownMenu_Initialize(submenu, function(self, level)
        for _, info in pairs(subInfos) do
            if funcName == 'GUILD_INVITE' then
                info.func = function(self)
                    EM:ConfirmGuildInvite(info.name, info.server)
                end
            elseif funcName == 'COPY_NAME' then
                info.func = function(self)
                    EM:ShowName(info.name, info.server)
                end
            elseif funcName == 'ARMORY_URL' then
                info.func = function(self)
                    EM:ShowArmoryURL(info.name, info.server)
                end
            elseif funcName == 'RAIDER_IO' then
                info.func = function(self)
                    EM:ShowRaiderIO(info.name, info.server)
                end
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end)
    ToggleDropDownMenu(1, nil, submenu, 'cursor', 0, 60)
end

EnhancedMenu_Func['GUILD_INVITE'] = function(name, server)
    if name and server then
        EM:ConfirmGuildInvite(name, server)
    else
        ToggleEnhancedMenu_SubMenu('GUILD_INVITE')
    end
end

EnhancedMenu_Func['COPY_NAME'] = function(name, server)
    if name and server then
        EM:ShowName(name, server)
    else
        ToggleEnhancedMenu_SubMenu('COPY_NAME')
    end
end

EnhancedMenu_Func['SEND_WHO'] = function(name, server)
    -- local _, name, nameForAPI = LRI:GetRealmInfo(server)
    C_FriendList_SetWhoToUi(false)
    C_FriendList_SendWho('n-' .. name)
end

EnhancedMenu_Func['ARMORY_URL'] = function(name, server)
    if name and server then
        EM:ShowArmoryURL(name, server)
    else
        ToggleEnhancedMenu_SubMenu('ARMORY_URL')
    end
end

EnhancedMenu_Func['RAIDER_IO'] = function(name, server)
    if name and server then
        EM:ShowRaiderIO(name, server)
    else
        ToggleEnhancedMenu_SubMenu('RAIDER_IO')
    end
end

-- prepare buttons
local buttons = {}
local function PrepareButtons(which, name, server)
    wipe(buttons)
    if not server then
        server = GetRealmName()
    end

    local i = 0
    for _, itemName in pairs(EnhancedMenu_ItemOrder) do
        if EnhancedMenu_Which[itemName][which] then
            i = i + 1
            -- add item
            tinsert(buttons, EnhancedMenu_Items[itemName])
            -- set func
            buttons[i].func = function()
                EnhancedMenu_Func[itemName](name, server)
            end
        end
    end

    if i ~= 0 then
        tinsert(buttons, 1, EnhancedMenu_Items['ENHANCED_MENU']) -- insert title
        return true
    end
end

-- Alt + LeftButton = Invite
local function GetNameFromLink(link)
    local _, name, _ = strsplit(':', link)
    if (name and (strlen(name) > 0)) then -- necessary?
        name = gsub(name, '([^%s]*)%s+([^%s]*)%s+([^%s]*)', '%3')
        name = gsub(name, '([^%s]*)%s+([^%s]*)', '%2')
    end
    return name
end

local function EnhancedMenu_ChatFrame_OnHyperlinkShow(self, playerString, text, button)
    if (playerString and strsub(playerString, 1, 6) == 'player') then
        if IsAltKeyDown() and button == 'LeftButton' then
            _G.DEFAULT_CHAT_FRAME.editBox:Hide()
            C_PartyInfo_InviteUnit(GetNameFromLink(playerString))
            return
        end
    end
end


function EM:ShowArmoryURL(characterName, realmName)
    local id, name, nameForAPI, rules, locale, battlegroup, region, timezone, connectedIDs, englishName,
        englishNameForAPI = LRI:GetRealmInfo(realmName)

    region = strlower(region)

    locale = strlower(strsub(locale, 1, 2) .. '-' .. strsub(locale, 3, 4))
    realmName = string.gsub(englishName, '\'', '')
    realmName = strlower(string.gsub(realmName, ' ', '-'))

    local armory = 'https://worldofwarcraft.com/' .. locale .. '/character/' .. region .. '/' .. realmName .. '/' ..
                       characterName

    local editBox = ChatEdit_ChooseBoxForSend()
    ChatEdit_ActivateChat(editBox)
    editBox:SetText(armory)
    editBox:SetCursorPosition(0)
    editBox:HighlightText()
end

function EM:ShowRaiderIO(characterName, realmName)
    local id, name, nameForAPI, rules, locale, battlegroup, region, timezone, connectedIDs, englishName,
        englishNameForAPI = LRI:GetRealmInfo(realmName)

    region = strlower(region)
    realmName = string.gsub(englishName, '\'', '')
    realmName = strlower(string.gsub(realmName, ' ', '-'))

    local armory = 'https://raider.io/characters/' .. region .. '/' .. realmName .. '/' .. characterName

    local editBox = ChatEdit_ChooseBoxForSend()
    ChatEdit_ActivateChat(editBox)
    editBox:SetText(armory)
    editBox:SetCursorPosition(0)
    editBox:HighlightText()
end

function EM:ShowName(characterName, realmName)
    local _, name, nameForAPI = LRI:GetRealmInfo(realmName)
    local fullName = characterName .. '-' .. nameForAPI

    if _G.SendMailNameEditBox and _G.SendMailNameEditBox:IsVisible() then
        _G.SendMailNameEditBox:SetText(fullName)
        _G.SendMailNameEditBox:HighlightText()
    else
        local editBox = ChatEdit_ChooseBoxForSend()
        if editBox:HasFocus() then
            editBox:Insert(fullName)
        else
            ChatEdit_ActivateChat(editBox)
            editBox:SetText(fullName)
            editBox:HighlightText()
        end
    end
end

-- ConfirmGuildInvitePopupDialog
_G.StaticPopupDialogs['ENHANCED_MENU_CONFIRM_GUILD_INVITE'] = {
    text = '',
    button1 = YES,
    button2 = NO,
    OnAccept = function() end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
}

function EM:ConfirmGuildInvite(characterName, realmName)
    local _, name, nameForAPI = LRI:GetRealmInfo(realmName)
    local fullName = characterName .. '-' .. nameForAPI

    _G.StaticPopupDialogs['ENHANCED_MENU_CONFIRM_GUILD_INVITE'].text = CHAT_GUILD_INVITE_SEND .. '\n' .. fullName
    _G.StaticPopupDialogs['ENHANCED_MENU_CONFIRM_GUILD_INVITE'].OnAccept = function() GuildInvite(fullName) end

    StaticPopup_Show('ENHANCED_MENU_CONFIRM_GUILD_INVITE')
end


function EM:OnLogin()
    if not C.DB.General.EnhancedMenu then return end

    -- Hook
    hooksecurefunc('UnitPopup_ShowMenu', function(self, which)
        if which == 'BN_FRIEND' then
            return
        end

        local menuLevel = _G.UIDROPDOWNMENU_MENU_LEVEL
        if menuLevel > 1 then
            return
        end

        local menu = UnitPopup_HasVisibleMenu() and UIDropDownMenu_GetCurrentDropDown() or nil
        if not menu then
            return
        end
        -- texplore(menu)

        local show = PrepareButtons(menu.which, menu.name, menu.server)
        -- Interface\SharedXML\UIDropDownMenu.lua
        if show then
            UIDropDownMenu_AddSeparator()
            for _, info in pairs(buttons) do
                UIDropDownMenu_AddButton(info)
            end
        end
    end)

    -- BNFriends
    hooksecurefunc('FriendsFrame_ShowBNDropdown', function(name, connected, lineID, chatType, chatFrame, friendsList, bnetIDAccount)
        if connected then
            local friendIndex = BNGetFriendIndex(bnetIDAccount)
            local numGameAccounts = C_BattleNet_GetFriendNumGameAccounts(friendIndex)

            wipe(subInfos)
            for accountIndex = 1, numGameAccounts do
                local gameAccountInfo = C_BattleNet_GetFriendGameAccountInfo(friendIndex, accountIndex)

                if gameAccountInfo['wowProjectID'] == 1 and gameAccountInfo['clientProgram'] == _G.BNET_CLIENT_WOW then
                    local info = UIDropDownMenu_CreateInfo()
                    info.text = gameAccountInfo['characterName'] .. '-' .. gameAccountInfo['realmName']
                    info.name = gameAccountInfo['characterName']
                    info.server = gameAccountInfo['realmName']
                    info.notCheckable = 1
                    tinsert(subInfos, info)
                end
            end

            -- texplore(subInfos)
            if #subInfos == 0 then
                return
            elseif #subInfos == 1 then
                PrepareButtons('BN_FRIEND', subInfos[1]['name'], subInfos[1]['server'])
            else
                PrepareButtons('BN_FRIEND')
            end

            UIDropDownMenu_AddSeparator()
            for _, info in pairs(buttons) do
                UIDropDownMenu_AddButton(info)
            end
        end
    end)

    -- Alt + LeftButton = Invite
    hooksecurefunc('ChatFrame_OnHyperlinkShow', EnhancedMenu_ChatFrame_OnHyperlinkShow)
end
