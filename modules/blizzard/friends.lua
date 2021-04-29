--[[
    Enhanced friends list
    Credit ElvUI_WindTool
]]

local _G = _G
local unpack = unpack
local select = select
local strsplit = strsplit
local hooksecurefunc = hooksecurefunc
local BNET_CLIENT_APP = BNET_CLIENT_APP
local BNET_CLIENT_CLNT = BNET_CLIENT_CLNT
local BNET_CLIENT_COD = BNET_CLIENT_COD
local BNET_CLIENT_COD_MW = BNET_CLIENT_COD_MW
local BNET_CLIENT_COD_MW2 = BNET_CLIENT_COD_MW2
local BNET_CLIENT_COD_BOCW = BNET_CLIENT_COD_BOCW
local BNET_CLIENT_D3 = BNET_CLIENT_D3
local BNET_CLIENT_HEROES = BNET_CLIENT_HEROES
local BNET_CLIENT_OVERWATCH = BNET_CLIENT_OVERWATCH
local BNET_CLIENT_SC = BNET_CLIENT_SC
local BNET_CLIENT_SC2 = BNET_CLIENT_SC2
local BNET_CLIENT_WC3 = BNET_CLIENT_WC3
local BNET_CLIENT_WOW = BNET_CLIENT_WOW
local BNET_CLIENT_WTCG = BNET_CLIENT_WTCG
local FRIENDS_TEXTURE_AFK = FRIENDS_TEXTURE_AFK
local FRIENDS_TEXTURE_DND = FRIENDS_TEXTURE_DND
local FRIENDS_TEXTURE_OFFLINE = FRIENDS_TEXTURE_OFFLINE
local FRIENDS_TEXTURE_ONLINE = FRIENDS_TEXTURE_ONLINE
local LOCALIZED_CLASS_NAMES_FEMALE = LOCALIZED_CLASS_NAMES_FEMALE
local LOCALIZED_CLASS_NAMES_MALE = LOCALIZED_CLASS_NAMES_MALE
local FRIENDS_BUTTON_TYPE_DIVIDER = FRIENDS_BUTTON_TYPE_DIVIDER
local FRIENDS_BUTTON_TYPE_BNET = FRIENDS_BUTTON_TYPE_BNET
local BNET_FRIEND_TOOLTIP_WOW_CLASSIC = BNET_FRIEND_TOOLTIP_WOW_CLASSIC
local BNConnected = BNConnected
local BNet_GetClientTexture = BNet_GetClientTexture
local GetQuestDifficultyColor = GetQuestDifficultyColor
local C_BattleNet_GetFriendAccountInfo = C_BattleNet.GetFriendAccountInfo

local F, C = unpack(select(2, ...))
local EFL = F:RegisterModule('EnhancedFriendsList')

local mediaPath = 'Interface\\AddOns\\FreeUI\\assets\\textures\\'

local gameIcons = {
    ['Alliance'] = {Default = BNet_GetClientTexture(BNET_CLIENT_WOW), Modern = mediaPath .. 'game_icons\\Alliance'},
    ['Horde'] = {Default = BNet_GetClientTexture(BNET_CLIENT_WOW), Modern = mediaPath .. 'game_icons\\Horde'},
    ['Neutral'] = {Default = BNet_GetClientTexture(BNET_CLIENT_WOW), Modern = mediaPath .. 'game_icons\\WoW'},
    [BNET_CLIENT_WOW] = {Default = BNet_GetClientTexture(BNET_CLIENT_WOW), Modern = mediaPath .. 'game_icons\\WoWSL'},
    [BNET_CLIENT_WOW .. 'C'] = {Default = BNet_GetClientTexture(BNET_CLIENT_WOW), Modern = mediaPath .. 'game_icons\\WoW'},
    [BNET_CLIENT_D3] = {Default = BNet_GetClientTexture(BNET_CLIENT_D3), Modern = mediaPath .. 'game_icons\\D3'},
    [BNET_CLIENT_WTCG] = {Default = BNet_GetClientTexture(BNET_CLIENT_WTCG), Modern = mediaPath .. 'game_icons\\HS'},
    [BNET_CLIENT_SC] = {Default = BNet_GetClientTexture(BNET_CLIENT_SC), Modern = mediaPath .. 'game_icons\\SC'},
    [BNET_CLIENT_SC2] = {Default = BNet_GetClientTexture(BNET_CLIENT_SC2), Modern = mediaPath .. 'game_icons\\SC2'},
    [BNET_CLIENT_APP] = {Default = BNet_GetClientTexture(BNET_CLIENT_APP), Modern = mediaPath .. 'game_icons\\App'},
    ['BSAp'] = {Default = BNet_GetClientTexture(BNET_CLIENT_APP), Modern = mediaPath .. 'game_icons\\Mobile'},
    [BNET_CLIENT_HEROES] = {Default = BNet_GetClientTexture(BNET_CLIENT_HEROES), Modern = mediaPath .. 'game_icons\\HotS'},
    [BNET_CLIENT_OVERWATCH] = {Default = BNet_GetClientTexture(BNET_CLIENT_OVERWATCH), Modern = mediaPath .. 'game_icons\\OW'},
    [BNET_CLIENT_COD] = {Default = BNet_GetClientTexture(BNET_CLIENT_COD), Modern = mediaPath .. 'game_icons\\COD'},
    [BNET_CLIENT_COD_BOCW] = {Default = BNet_GetClientTexture(BNET_CLIENT_COD_BOCW), Modern = mediaPath .. 'game_icons\\COD_CW'},
    [BNET_CLIENT_COD_MW] = {Default = BNet_GetClientTexture(BNET_CLIENT_COD_MW), Modern = mediaPath .. 'game_icons\\COD_MW'},
    [BNET_CLIENT_COD_MW2] = {Default = BNet_GetClientTexture(BNET_CLIENT_COD_MW2), Modern = mediaPath .. 'game_icons\\COD_MW2'},
    [BNET_CLIENT_WC3] = {Default = BNet_GetClientTexture(BNET_CLIENT_WC3), Modern = mediaPath .. 'game_icons\\WC3'},
}

local statusIcons = {
    ['Online'] = FRIENDS_TEXTURE_ONLINE,
    ['Offline'] = FRIENDS_TEXTURE_OFFLINE,
    ['DND'] = FRIENDS_TEXTURE_DND,
    ['AFK'] = FRIENDS_TEXTURE_AFK
}

local MaxLevel = {
    [BNET_CLIENT_WOW .. 'C'] = 60,
    [BNET_CLIENT_WOW] = C.MaxLevel
}

local clientColor = {
    [BNET_CLIENT_CLNT] = {r = 0.509, g = 0.772, b = 1}, -- 未知
    [BNET_CLIENT_APP] = {r = 0.509, g = 0.772, b = 1}, -- 战网
    [BNET_CLIENT_WC3] = {r = 0.796, g = 0.247, b = 0.145}, -- 魔兽争霸重置版 3
    [BNET_CLIENT_SC] = {r = 0.749, g = 0.501, b = 0.878}, -- 星际争霸 1
    [BNET_CLIENT_SC2] = {r = 0.749, g = 0.501, b = 0.878}, -- 星际争霸 2
    [BNET_CLIENT_D3] = {r = 0.768, g = 0.121, b = 0.231}, -- 暗黑破坏神 3
    [BNET_CLIENT_WOW] = {r = 0.866, g = 0.690, b = 0.180}, -- 魔兽世界
    [BNET_CLIENT_WTCG] = {r = 1, g = 0.694, b = 0}, -- 炉石传说
    [BNET_CLIENT_HEROES] = {r = 0, g = 0.8, b = 1}, -- 风暴英雄
    [BNET_CLIENT_OVERWATCH] = {r = 1, g = 1, b = 1}, -- 守望先锋
    [BNET_CLIENT_COD] = {r = 0, g = 0.8, b = 0}, -- 使命召唤
    [BNET_CLIENT_COD_MW] = {r = 0, g = 0.8, b = 0}, -- 使命召唤：现代战争 2
    [BNET_CLIENT_COD_BOCW] = {r = 0, g = 0.8, b = 0}, -- 使命召唤：冷战
    -- 命运 2 因为已经分家了，不会出现了，下面为自定客户端代码
    [BNET_CLIENT_WOW .. 'C'] = {r = 0.866, g = 0.690, b = 0.180}, -- 魔兽世界怀旧版
    ['BSAp'] = {r = 0.509, g = 0.772, b = 1}, -- 手机战网 App
}

local function GetClassColor(className)
    for class, localizedName in pairs(LOCALIZED_CLASS_NAMES_MALE) do
        if className == localizedName then
            return C.ClassColors[class]
        end
    end

    -- 德语及法语有分性别的职业名
    if C.GameLocale == 'deDE' or C.GameLocale == 'frFR' then
        for class, localizedName in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
            if className == localizedName then
                return C.ClassColors[class]
            end
        end
    end
end

local function UpdateFriendButton(button)
    if button.buttonType == FRIENDS_BUTTON_TYPE_DIVIDER then
        return
    end

    local game, realID, name, server, class, area, level, faction, status

    -- 获取好友游戏情况
    if button.buttonType == FRIENDS_BUTTON_TYPE_BNET and BNConnected() then
        -- 战网好友
        local friendAccountInfo = C_BattleNet_GetFriendAccountInfo(button.id)
        if friendAccountInfo then
            realID = friendAccountInfo.accountName

            local gameAccountInfo = friendAccountInfo.gameAccountInfo
            game = gameAccountInfo.clientProgram

            if gameAccountInfo.isOnline then
                if friendAccountInfo.isAFK or gameAccountInfo.isGameAFK then
                    status = 'AFK'
                elseif friendAccountInfo.isDND or gameAccountInfo.isGameBusy then
                    status = 'DND'
                else
                    status = 'Online'
                end
            else
                status = 'Offline'
            end

            -- 如果是魔兽正式服/怀旧服，进一步获取角色信息
            if game == BNET_CLIENT_WOW then
                name = gameAccountInfo.characterName or ''
                level = gameAccountInfo.characterLevel or 0
                faction = gameAccountInfo.factionName or nil
                class = gameAccountInfo.className or ''
                area = gameAccountInfo.areaName or ''

                if gameAccountInfo.wowProjectID == 2 then
                    game = BNET_CLIENT_WOW .. 'C' -- 标注怀旧服好友
                    local serverStrings = {strsplit(' - ', gameAccountInfo.richPresence)}
                    server = serverStrings[#serverStrings] or BNET_FRIEND_TOOLTIP_WOW_CLASSIC
                    server = server .. '*'
                else
                    server = gameAccountInfo.realmDisplayName or ''
                end
            end
        end
    end

    -- 状态图标
    if status then
        button.status:SetTexture(statusIcons[status])
    end

    if game and game ~= '' then
        local buttonTitle, buttonText

        -- 名字
        local realIDString = realID and F:CreateColorString(realID, clientColor[game]) or realID

        local nameString = name
        local classColor = GetClassColor(class)
        if classColor then
            nameString = F:CreateColorString(name, classColor)
        end

        if level and level ~= 0 and MaxLevel[game] and (level ~= MaxLevel[game]) then
            nameString = nameString .. F:CreateColorString(' ' .. level, GetQuestDifficultyColor(level))
        end

        if nameString and realIDString then
            buttonTitle = realIDString .. '  ' .. nameString
        elseif nameString then
            buttonTitle = nameString
        else
            buttonTitle = realIDString or ''
        end

        button.name:SetText(buttonTitle)

        -- 地区
        if area then
            if server and server ~= C.MyRealm then
                buttonText = F:CreateColorString(area .. ' - ' .. server, {r = .8, g = .8, b = .8})
            else
                buttonText = F:CreateColorString(area, {r = .8, g = .8, b = .8})
            end

            button.info:SetText(buttonText)
        end

        -- 游戏图标
        -- local iconGroup = faction or game
        local iconGroup = game
        local iconTex = gameIcons[iconGroup]['Modern'] or BNet_GetClientTexture(game)
        button.gameIcon:SetTexture(iconTex)
        button.gameIcon:Show() -- 普通角色好友暴雪隐藏了

        if button.summonButton:IsShown() then
            button.gameIcon:Hide()
        else
            button.gameIcon:Show()
            button.gameIcon:Point('TOPRIGHT', -21, -2)
        end
    end

    F:SetFS(button.name, C.Assets.Fonts.Bold, 13, nil, nil, nil, true)
    F:SetFS(button.info, C.Assets.Fonts.Regular, 12, nil, nil, nil, true)

    if button.Favorite:IsShown() then
        button.Favorite:ClearAllPoints()
        button.Favorite:Point('LEFT', button.name, 'LEFT', button.name:GetStringWidth(), 0)
    end
end

function EFL:OnLogin()
    hooksecurefunc('FriendsFrame_UpdateFriendButton', UpdateFriendButton)
end
