-- Credit: ElvUI_WindTools by fang2hou
-- https://github.com/fang2hou/ElvUI_WindTools/blob/development/Modules/Social/FriendList.lua

local F, C, L = unpack(select(2, ...))
local BLIZZARD = F:GetModule('Blizzard')

-- #FIXME

local cache = {}

-- Manully code the atlas "battlenetclienticon"
-- note: Destiny 2 is not included
local projectCodes = {
    ['anbs'] = 'Diablo Immortal',
    ['hero'] = 'Heroes of the Storm',
    ['osi'] = 'Diablo II',
    ['s2'] = 'StarCraft II',
    ['vipr'] = 'Call of Duty: Black Ops 4',
    ['W3'] = 'WarCraft III',
    ['app'] = 'Battle.net App',
    ['fore'] = 'Call of Duty: Vanguard',
    ['lazr'] = 'Call of Duty: MW2 Campaign Remastered',
    ['rtro'] = 'Blizzard Arcade Collection',
    ['wlby'] = "Crash Bandicoot 4: It's About Time",
    ['wtcg'] = 'Hearthstone',
    ['zeus'] = 'Call of Duty: Blac Ops Cold War',
    ['d3'] = 'Diablo III',
    ['gry'] = 'Warcraft Arclight Rumble',
    ['odin'] = 'Call of Duty: Mordern Warfare II',
    ['s1'] = 'StarCraft',
    ['wow'] = 'World of Warcraft',
    ['pro'] = 'Overwatch',
    ['PRO-ZHCN'] = 'Overwatch',
}

local clientData = {
    ['Diablo Immortal'] = {
        color = { r = 0.768, g = 0.121, b = 0.231 },
    },
    ['Heroes of the Storm'] = {
        color = { r = 0, g = 0.8, b = 1 },
    },
    ['Diablo II'] = {
        color = { r = 0.768, g = 0.121, b = 0.231 },
    },
    ['StarCraft II'] = {
        color = { r = 0.749, g = 0.501, b = 0.878 },
    },
    ['Call of Duty: Black Ops 4'] = {
        color = { r = 0, g = 0.8, b = 0 },
    },
    ['WarCraft III'] = {
        color = { r = 0.796, g = 0.247, b = 0.145 },
    },
    ['Battle.net App'] = {
        color = { r = 0.509, g = 0.772, b = 1 },
    },
    ['Call of Duty: Vanguard'] = {
        color = { r = 0, g = 0.8, b = 0 },
    },
    ['Call of Duty: MW2 Campaign Remastered'] = {
        color = { r = 0, g = 0.8, b = 0 },
    },
    ['Blizzard Arcade Collection'] = {
        color = { r = 0.509, g = 0.772, b = 1 },
    },
    ["Crash Bandicoot 4: It's About Time"] = {
        color = { r = 0.509, g = 0.772, b = 1 },
    },
    ['Hearthstone'] = {
        color = { r = 1, g = 0.694, b = 0 },
    },
    ['Call of Duty: Blac Ops Cold War'] = {
        color = { r = 0, g = 0.8, b = 0 },
    },
    ['Diablo III'] = {
        color = { r = 0.768, g = 0.121, b = 0.231 },
    },
    ['Warcraft Arclight Rumble'] = {
        color = { r = 0.945, g = 0.757, b = 0.149 },
    },
    ['Call of Duty: Mordern Warfare II'] = {
        color = { r = 0, g = 0.8, b = 0 },
    },
    ['StarCraft'] = {
        color = { r = 0.749, g = 0.501, b = 0.878 },
    },
    ['World of Warcraft'] = {
        color = { r = 0.866, g = 0.690, b = 0.180 },
    },
    ['Overwatch'] = {
        color = { r = 1, g = 1, b = 1 },
    },
}

for code, name in pairs(projectCodes) do
    if clientData[name] then
        if code ~= 'PRO-ZHCN' then -- There is a special Overwatch Chinese version
            clientData[name]['icon'] = {
                modern = C.ASSET_PATH .. 'textures\\client\\' .. code,
                blizzard = BNet_GetClientAtlas('Battlenet-ClientIcon-', code),
            }
        end
    end
end

local expansionData = {
    [1] = {
        name = 'Retail',
        suffix = nil,
        maxLevel = GetMaxLevelForPlayerExpansion(),
        icon = C.ASSET_PATH .. 'textures\\client\\wow-retail',
    },
    [2] = {
        name = 'Classic',
        suffix = 'Classic',
        maxLevel = 60,
        icon = C.ASSET_PATH .. 'textures\\client\\wow-classic',
    },
    [5] = {
        name = 'TBC',
        suffix = 'TBC',
        maxLevel = 70,
        icon = C.ASSET_PATH .. 'textures\\client\\wow-tbc',
    },
    [11] = {
        name = 'WotLK',
        suffix = 'WotLK',
        maxLevel = 80,
        icon = C.ASSET_PATH .. 'textures\\client\\wow-wotlk',
    },
}

local factionIcons = {
    ['Alliance'] = C.ASSET_PATH .. 'textures\\faction-alliance',
    ['Horde'] = C.ASSET_PATH .. 'textures\\faction-horde',
}

local statusIcons = {
    Online = _G.FRIENDS_TEXTURE_ONLINE,
    Offline = _G.FRIENDS_TEXTURE_OFFLINE,
    DND = _G.FRIENDS_TEXTURE_DND,
    AFK = _G.FRIENDS_TEXTURE_AFK,
}

local regionLocales = {
    [1] = L['America'],
    [2] = L['Korea'],
    [3] = L['Europe'],
    [4] = L['Taiwan'],
    [5] = L['China'],
}

local function getClassColor(className)
    for class, localizedName in pairs(_G.LOCALIZED_CLASS_NAMES_MALE) do
        if className == localizedName then
            return C.ClassColors[class]
        end
    end

    -- 德语及法语有分性别的职业名
    if GetLocale() == 'deDE' or GetLocale() == 'frFR' then
        for class, localizedName in pairs(_G.LOCALIZED_CLASS_NAMES_FEMALE) do
            if className == localizedName then
                return C.ClassColors[class]
            end
        end
    end
end

local useNoteAsName = true
local useClientColor = true
local useClassColor = true
local factionIcon = false
local areaColor = { r = 1, g = 1, b = 1 }

function BLIZZARD:UpdateFriendButton(button)
    if button.buttonType == _G.FRIENDS_BUTTON_TYPE_DIVIDER then
        return
    end

    local gameCode, gameName, realID, name, server, class, area, level, note, faction, status, isInCurrentRegion, regionID, wowID

    if button.buttonType == _G.FRIENDS_BUTTON_TYPE_WOW then
        -- WoW friends
        gameCode = 'WoW'
        gameName = projectCodes['wow'].name
        local friendInfo = C_FriendList.GetFriendInfoByIndex(button.id)
        name, server = strsplit('-', friendInfo.name) -- server is nil if it's not a cross-realm friend
        level = friendInfo.level
        class = friendInfo.className
        area = friendInfo.area
        note = friendInfo.notes
        faction = C.MY_FACTION -- friend should in the same faction

        if friendInfo.connected then
            if friendInfo.afk then
                status = 'AFK'
            elseif friendInfo.dnd then
                status = 'DND'
            else
                status = 'Online'
            end
        else
            status = 'Offline'
        end
    elseif button.buttonType == _G.FRIENDS_BUTTON_TYPE_BNET and BNConnected() then
        -- Battle.net friends
        local friendAccountInfo = C_BattleNet.GetFriendAccountInfo(button.id)
        if friendAccountInfo then
            realID = friendAccountInfo.accountName
            note = friendAccountInfo.note

            local gameAccountInfo = friendAccountInfo.gameAccountInfo
            gameCode = gameAccountInfo.clientProgram
            gameName = projectCodes[strupper(gameAccountInfo.clientProgram)]

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

            -- Fetch version if friend playing WoW
            if gameName == 'World of Warcraft' then
                wowID = gameAccountInfo.wowProjectID
                name = gameAccountInfo.characterName or ''
                level = gameAccountInfo.characterLevel or 0
                faction = gameAccountInfo.factionName or nil
                class = gameAccountInfo.className or ''
                area = gameAccountInfo.areaName or ''
                isInCurrentRegion = gameAccountInfo.isInCurrentRegion or false
                regionID = gameAccountInfo.regionID or false

                if wowID and wowID ~= 1 then
                    local expansion = expansionData[wowID]
                    local suffix = expansion.suffix and ' (' .. expansion.suffix .. ')' or ''
                    local serverStrings = { strsplit(' - ', gameAccountInfo.richPresence) }
                    server = (serverStrings[#serverStrings] or _G.BNET_FRIEND_TOOLTIP_WOW_CLASSIC .. suffix) .. '*'
                else
                    server = gameAccountInfo.realmDisplayName or ''
                end
            end
        end
    end

    -- 状态图标
    if status then
        --button.status:SetTexture(statusIcons[status])
    end

    if gameName then
        local buttonTitle, buttonText

        -- override Real ID or name with note
        if useNoteAsName and note and note ~= '' then
            if realID then
                realID = note
            else
                name = note
            end
        end

        -- real ID
        local clientColor = useClientColor and clientData[gameName] and clientData[gameName].color
        local realIDString = realID and clientColor and F:CreateColorString(realID, clientColor) or realID

        -- name
        local classColor = useClassColor and getClassColor(class)
        local nameString = name and classColor and F:CreateColorString(name, classColor) or name

        if wowID and expansionData[wowID] and level and level ~= 0 then
            if level ~= expansionData[wowID].maxLevel then
                nameString = nameString .. F:CreateColorString(': ' .. level, GetQuestDifficultyColor(level))
            end
        end

        -- combine Real ID and Name
        if nameString and realIDString then
            buttonTitle = realIDString .. ' \124\124 ' .. nameString
        elseif nameString then
            buttonTitle = nameString
        else
            buttonTitle = realIDString or ''
        end

        button.name:SetText(buttonTitle)

        -- area
        if area then
            if server and server ~= '' and server ~= C.MY_REALM then
                buttonText = F:CreateColorString(area .. ' - ' .. server, areaColor)
            else
                buttonText = F:CreateColorString(area, areaColor)
            end

            if not isInCurrentRegion and regionLocales[regionID] then
                -- Unblocking profanity filter will change the region
                local regionText = format('[%s]', regionLocales[regionID])
                buttonText = buttonText .. ' ' .. F:CreateColorString(regionText, { r = 0.62, g = 0.62, b = 0.62 })
            end

            button.info:SetText(buttonText)
        end

        -- game icon
        local texOrAtlas = clientData[gameName] and clientData[gameName]['icon']

        if wowID then
            texOrAtlas = expansionData[wowID]['icon']
        end

        if factionIcon then
            if faction and factionIcons[faction] then
                texOrAtlas = factionIcons[faction]
            end
        end

        if texOrAtlas then
            button.gameIcon:SetTexture(texOrAtlas)
            button.gameIcon:SetAlpha(1)
        end
    else
        if useNoteAsName and note and note ~= '' then
            button.name:SetText(note)
        end
    end

    -- #FIXME
    -- font style hack
    -- if not cache.name then
    --     local name, size, style = button.name:GetFont()
    --     cache.name = {
    --         name = name,
    --         size = size,
    --         style = style,
    --     }
    -- end

    -- if not cache.info then
    --     local name, size, style = button.info:GetFont()
    --     cache.info = {
    --         name = name,
    --         size = size,
    --         style = style,
    --     }
    -- end

    -- button.name:SetFont(C.Assets.Fonts.Bold, 13, 'OUTLINE')
    -- button.info:SetFont(C.Assets.Fonts.Condensed, 12, 'OUTLINE')

    if button.name then
        local fontName, fontSize, fontFlag = button.name:GetFont()
        print(fontName, fontSize, fontFlag)
    end

    -- favorite icon
    -- if button.Favorite:IsShown() then
    --     button.Favorite:ClearAllPoints()
    --     button.Favorite:Point('LEFT', button.name, 'LEFT', button.name:GetStringWidth(), 0)
    -- end
end

function BLIZZARD:EnhancedFriendsList()
    hooksecurefunc('FriendsFrame_UpdateFriendButton', BLIZZARD.UpdateFriendButton)
    _G.FriendsFrame_Update()
end
