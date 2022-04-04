local F, C, L = unpack(select(2, ...))
local INFOBAR = F:GetModule('InfoBar')

local WOW_PROJECT_ID = _G.WOW_PROJECT_ID or 1
local WOW_PROJECT_60 = _G.WOW_PROJECT_CLASSIC or 2
local WOW_PROJECT_TBC = _G.WOW_PROJECT_BURNING_CRUSADE_CLASSIC or 5
local CLIENT_WOW_DIFF = 'WoV' -- for sorting

local infoFrame, updateRequest, prevTime
local friendTable = {}
local bnetTable = {}
local activeZone, inactiveZone = '|cff4cff4c', C.GREY_COLOR
local noteString = '|TInterface\\Buttons\\UI-GuildButton-PublicNote-Up:12|t %s'
local broadcastString = '|TInterface\\FriendsFrame\\BroadcastIcon:12|t %s (%s)'
local onlineString = string.gsub(_G.ERR_FRIEND_ONLINE_SS, '.+h', '')
local offlineString = string.gsub(_G.ERR_FRIEND_OFFLINE_S, '%%s', '')

local menuList = {[1] = {text = L['Join or Invite'], isTitle = true, notCheckable = true}}

local function sortFriends(a, b)
    if a[1] and b[1] then
        return a[1] < b[1]
    end
end

local function buildFriendTable(num)
    table.wipe(friendTable)

    for i = 1, num do
        local info = C_FriendList.GetFriendInfoByIndex(i)
        if info and INFOBAR.connected then
            local status = _G.FRIENDS_TEXTURE_ONLINE
            if INFOBAR.afk then
                status = _G.FRIENDS_TEXTURE_AFK
            elseif INFOBAR.dnd then
                status = _G.FRIENDS_TEXTURE_DND
            end
            local class = C.ClassList[INFOBAR.className]
            table.insert(friendTable, {INFOBAR.name, INFOBAR.level, class, INFOBAR.area, status})
        end
    end

    table.sort(friendTable, sortFriends)
end

local function sortBNFriends(a, b)
    if a[5] and b[5] then
        return a[5] > b[5]
    end
end

local function CanCooperateWithUnit(gameAccountInfo)
    return gameAccountInfo.playerGuid and (gameAccountInfo.factionName == C.FACTION) and (gameAccountInfo.realmID ~= 0)
end

local function GetOnlineInfoText(client, isMobile, rafLinkType, locationText)
    if not locationText or locationText == '' then
        return _G.UNKNOWN
    end
    if isMobile then
        return 'APP'
    end
    if (client == _G.BNET_CLIENT_WOW) and (rafLinkType ~= _G.Enum.RafLinkType.None) and not isMobile then
        if rafLinkType == _G.Enum.RafLinkType.Recruit then
            return string.format(_G.RAF_RECRUIT_FRIEND, locationText)
        else
            return string.format(_G.RAF_RECRUITER_FRIEND, locationText)
        end
    end

    return locationText
end

local function buildBNetTable(num)
    table.wipe(bnetTable)

    for i = 1, num do
        local accountInfo = C_BattleNet.GetFriendAccountInfo(i)
        if accountInfo then
            local accountName = accountInfo.accountName
            local battleTag = accountInfo.battleTag
            local isAFK = accountInfo.isAFK
            local isDND = accountInfo.isDND
            local note = accountInfo.note
            local broadcastText = accountInfo.customMessage
            local broadcastTime = accountInfo.customMessageTime
            local rafLinkType = accountInfo.rafLinkType

            local gameAccountInfo = accountInfo.gameAccountInfo
            local isOnline = gameAccountInfo.isOnline
            local gameID = gameAccountInfo.gameAccountID

            if isOnline and gameID then
                local charName = gameAccountInfo.characterName
                local client = gameAccountInfo.clientProgram
                local class = gameAccountInfo.className or _G.UNKNOWN
                local zoneName = gameAccountInfo.areaName or _G.UNKNOWN
                local level = gameAccountInfo.characterLevel
                local gameText = gameAccountInfo.richPresence or ''
                local isGameAFK = gameAccountInfo.isGameAFK
                local isGameBusy = gameAccountInfo.isGameBusy
                local wowProjectID = gameAccountInfo.wowProjectID
                local isMobile = gameAccountInfo.isWowMobile
                local canCooperate = CanCooperateWithUnit(gameAccountInfo)

                charName = _G.BNet_GetValidatedCharacterName(charName, battleTag, client)
                class = C.ClassList[class]

                local status = _G.FRIENDS_TEXTURE_ONLINE
                if isAFK or isGameAFK then
                    status = _G.FRIENDS_TEXTURE_AFK
                elseif isDND or isGameBusy then
                    status = _G.FRIENDS_TEXTURE_DND
                end

                if wowProjectID == WOW_PROJECT_60 then
                    gameText = _G.EXPANSION_NAME0
                elseif wowProjectID == _G.WOW_PROJECT_TBC then
                    gameText = string.gsub(gameText, '%s%-.+', '')
                end

                local infoText = GetOnlineInfoText(client, isMobile, rafLinkType, gameText)
                if client == _G.BNET_CLIENT_WOW and wowProjectID == WOW_PROJECT_ID then
                    infoText = GetOnlineInfoText(client, isMobile, rafLinkType, zoneName)
                end

                if client == _G.BNET_CLIENT_WOW and wowProjectID ~= WOW_PROJECT_ID then
                    client = CLIENT_WOW_DIFF
                end

                table.insert(bnetTable, {i, accountName, charName, canCooperate, client, status, class, level, infoText, note, broadcastText, broadcastTime})
            end
        end
    end

    table.sort(bnetTable, sortBNFriends)
end

local function isPanelCanHide(self, elapsed)
    self.timer = (self.timer or 0) + elapsed
    if self.timer > .1 then
        if not infoFrame:IsMouseOver() then
            self:Hide()
            self:SetScript('OnUpdate', nil)
        end

        self.timer = 0
    end
end

function INFOBAR:FriendsPanel_Init()
    if infoFrame then
        infoFrame:Show()
        return
    end

    local anchorTop = C.DB.Infobar.AnchorTop

    infoFrame = CreateFrame('Frame', 'FreeUIFriendsFrame', INFOBAR.Bar)
    infoFrame:SetSize(400, 495)
    infoFrame:SetPoint(anchorTop and 'TOP' or 'BOTTOM', INFOBAR.FriendsBlock, anchorTop and 'BOTTOM' or 'TOP', 0, anchorTop and -6 or 6)
    infoFrame:SetClampedToScreen(true)
    infoFrame:SetFrameStrata('DIALOG')
    F.SetBD(infoFrame)

    infoFrame:SetScript('OnLeave', function(self)
        self:SetScript('OnUpdate', isPanelCanHide)
    end)
    infoFrame:SetScript('OnHide', function()
        if F.EasyMenu:IsShown() then
            F.EasyMenu:Hide()
        end
    end)

    F.CreateFS(infoFrame, C.Assets.Font.Bold, 16, nil, F:RGBToHex({.9, .8, .6}) .. _G.FRIENDS_LIST, nil, true, 'TOPLEFT', 15, -10)
    infoFrame.friendCountText = F.CreateFS(infoFrame, C.Assets.Font.Regular, 14, nil, '-/-', nil, true, 'TOPRIGHT', -15, -12)

    local scrollFrame = CreateFrame('ScrollFrame', 'FreeUIFriendsInfobarScrollFrame', infoFrame, 'HybridScrollFrameTemplate')
    scrollFrame:SetSize(370, 400)
    scrollFrame:SetPoint('TOPLEFT', 10, -35)
    infoFrame.scrollFrame = scrollFrame

    local scrollBar = CreateFrame('Slider', '$parentScrollBar', scrollFrame, 'HybridScrollBarTemplate')
    scrollBar.doNotHide = true
    F.ReskinScroll(scrollBar)
    scrollFrame.scrollBar = scrollBar

    local scrollChild = scrollFrame.scrollChild
    local numButtons = 20 + 1
    local buttonHeight = 22
    local buttons = {}
    for i = 1, numButtons do
        buttons[i] = INFOBAR:FriendsPanel_CreateButton(scrollChild, i)
    end

    scrollFrame.buttons = buttons
    scrollFrame.buttonHeight = buttonHeight
    scrollFrame.update = INFOBAR.FriendsPanel_Update
    scrollFrame:SetScript('OnMouseWheel', INFOBAR.FriendsPanel_OnMouseWheel)
    scrollChild:SetSize(scrollFrame:GetWidth(), numButtons * buttonHeight)
    scrollFrame:SetVerticalScroll(0)
    scrollFrame:UpdateScrollChildRect()
    scrollBar:SetMinMaxValues(0, numButtons * buttonHeight)
    scrollBar:SetValue(0)

    F.CreateFS(infoFrame, C.Assets.Font.Regular, 13, nil, C.LINE_STRING, nil, true, 'BOTTOMRIGHT', -12, 42)
    local whspInfo = C.INFO_COLOR .. C.MOUSE_RIGHT_BUTTON .. L['Whisper']
    F.CreateFS(infoFrame, C.Assets.Font.Regular, 13, nil, whspInfo, nil, true, 'BOTTOMRIGHT', -15, 26)
    local invtInfo = C.INFO_COLOR .. 'ALT +' .. C.MOUSE_LEFT_BUTTON .. L['Invite']
    F.CreateFS(infoFrame, C.Assets.Font.Regular, 13, nil, invtInfo, nil, true, 'BOTTOMRIGHT', -15, 10)
end

local function inviteFunc(_, bnetIDGameAccount, guid)
    _G.FriendsFrame_InviteOrRequestToJoin(guid, bnetIDGameAccount)
end

local function buttonOnClick(self, btn)
    if btn == 'LeftButton' then
        if IsAltKeyDown() then
            if self.isBNet then
                local index = 2
                if #menuList > 1 then
                    for i = 2, #menuList do
                        table.wipe(menuList[i])
                    end
                end

                local numGameAccounts = C_BattleNet.GetFriendNumGameAccounts(self.data[1])
                local lastGameAccountID, lastGameAccountGUID
                if numGameAccounts > 0 then
                    for i = 1, numGameAccounts do
                        local gameAccountInfo = C_BattleNet.GetFriendGameAccountInfo(self.data[1], i)
                        local charName = gameAccountInfo.characterName
                        local client = gameAccountInfo.clientProgram
                        local class = gameAccountInfo.className or _G.UNKNOWN
                        local bnetIDGameAccount = gameAccountInfo.gameAccountID
                        local guid = gameAccountInfo.playerGuid
                        local wowProjectID = gameAccountInfo.wowProjectID
                        if client == _G.BNET_CLIENT_WOW and CanCooperateWithUnit(gameAccountInfo) and wowProjectID == WOW_PROJECT_ID then
                            if not menuList[index] then
                                menuList[index] = {}
                            end
                            menuList[index].text = F:RGBToHex(F:ClassColor(C.ClassList[class])) .. charName
                            menuList[index].notCheckable = true
                            menuList[index].arg1 = bnetIDGameAccount
                            menuList[index].arg2 = guid
                            menuList[index].func = inviteFunc
                            lastGameAccountID = bnetIDGameAccount
                            lastGameAccountGUID = guid

                            index = index + 1
                        end
                    end
                end

                if index == 2 then
                    return
                end
                if index == 3 then
                    _G.FriendsFrame_InviteOrRequestToJoin(lastGameAccountGUID, lastGameAccountID)
                else
                    _G.EasyMenu(menuList, F.EasyMenu, self, 0, 0, 'MENU', 1)
                end
            else
                C_PartyInfo.InviteUnit(self.data[1])
            end
        end
    else
        if self.isBNet then
            _G.ChatFrame_SendBNetTell(self.data[2])
        else
            _G.ChatFrame_SendTell(self.data[1], _G.SELECTED_DOCK_FRAME)
        end
    end
end

local function buttonOnEnter(self)
    _G.GameTooltip:SetOwner(self, 'ANCHOR_NONE')
    _G.GameTooltip:SetPoint('TOPRIGHT', infoFrame, 'TOPLEFT', -5, 0)
    _G.GameTooltip:ClearLines()
    if self.isBNet then
        _G.GameTooltip:AddLine(L['Battle.NET Friend'], .9, .8, .6)
        _G.GameTooltip:AddLine(' ')

        local index, accountName, _, _, _, _, _, _, _, note, broadcastText, broadcastTime = unpack(self.data)
        local numGameAccounts = C_BattleNet.GetFriendNumGameAccounts(index)
        for i = 1, numGameAccounts do
            local gameAccountInfo = C_BattleNet.GetFriendGameAccountInfo(index, i)
            local charName = gameAccountInfo.characterName
            local client = gameAccountInfo.clientProgram
            local realmName = gameAccountInfo.realmName or ''
            local faction = gameAccountInfo.factionName
            local class = gameAccountInfo.className or _G.UNKNOWN
            local zoneName = gameAccountInfo.areaName or _G.UNKNOWN
            local level = gameAccountInfo.characterLevel
            local gameText = gameAccountInfo.richPresence or ''
            local wowProjectID = gameAccountInfo.wowProjectID
            local clientString = _G.BNet_GetClientEmbeddedTexture(client, 16)
            if client == _G.BNET_CLIENT_WOW then
                if charName ~= '' then -- fix for weird account
                    realmName = (C.REALM == realmName or realmName == '') and '' or '-' .. realmName

                    -- Get TBC realm name from richPresence
                    if wowProjectID == WOW_PROJECT_TBC then
                        local realm, count = string.gsub(gameText, '^.-%-%s', '')
                        if count > 0 then
                            realmName = '-' .. realm
                        end
                    end

                    class = C.ClassList[class]
                    local classColor = F:RGBToHex(F:ClassColor(class))
                    if faction == 'Horde' then
                        clientString = '|TInterface\\FriendsFrame\\PlusManz-Horde:16:|t'
                    elseif faction == 'Alliance' then
                        clientString = '|TInterface\\FriendsFrame\\PlusManz-Alliance:16:|t'
                    end
                    _G.GameTooltip:AddLine(string.format('%s%s %s%s%s', clientString, level, classColor, charName, realmName))

                    if wowProjectID ~= WOW_PROJECT_ID then
                        zoneName = '*' .. zoneName
                    end
                    _G.GameTooltip:AddLine(string.format('%s%s', inactiveZone, zoneName))
                end
            else
                _G.GameTooltip:AddLine(string.format('|cffffffff%s%s', clientString, accountName))
                if gameText ~= '' then
                    _G.GameTooltip:AddLine(string.format('%s%s', inactiveZone, gameText))
                end
            end
        end

        if note and note ~= '' then
            _G.GameTooltip:AddLine(' ')
            _G.GameTooltip:AddLine(string.format(noteString, note), 1, .8, 0)
        end

        if broadcastText and broadcastText ~= '' then
            _G.GameTooltip:AddLine(' ')
            _G.GameTooltip:AddLine(string.format(broadcastString, broadcastText, _G.FriendsFrame_GetLastOnline(broadcastTime)), .3, .6, .8, 1)
        end
    else
        _G.GameTooltip:AddLine(L['WoW'], 1, .8, 0)
        _G.GameTooltip:AddLine(' ')
        local name, level, class, area = unpack(self.data)
        local classColor = F:RGBToHex(F:ClassColor(class))
        _G.GameTooltip:AddLine(string.format('%s %s%s', level, classColor, name))
        _G.GameTooltip:AddLine(string.format('%s%s', inactiveZone, area))
    end
    _G.GameTooltip:Show()
end

function INFOBAR:FriendsPanel_CreateButton(parent, index)
    local button = CreateFrame('Button', nil, parent)
    button:SetSize(370, 20)
    button:SetPoint('TOPLEFT', 0, -(index - 1) * 20)
    button.HL = button:CreateTexture(nil, 'HIGHLIGHT')
    button.HL:SetAllPoints()
    button.HL:SetColorTexture(C.r, C.g, C.b, .2)

    button.status = button:CreateTexture(nil, 'ARTWORK')
    button.status:SetPoint('LEFT', button, 5, 0)
    button.status:SetSize(16, 16)

    button.name = F.CreateFS(button, C.Assets.Font.Regular, 13, nil, 'Tag (name)', nil, true, 'LEFT', 25, 0)
    button.name:SetPoint('RIGHT', button, 'LEFT', 230, 0)
    button.name:SetJustifyH('LEFT')
    button.name:SetTextColor(.5, .7, 1)
    button.name:SetWordWrap(false)

    button.zone = F.CreateFS(button, C.Assets.Font.Regular, 13, nil, 'Zone', nil, true, 'RIGHT', -28, 0)
    button.zone:SetPoint('LEFT', button, 'RIGHT', -130, 0)
    button.zone:SetJustifyH('RIGHT')
    button.zone:SetWordWrap(false)

    button.gameIcon = button:CreateTexture(nil, 'ARTWORK')
    button.gameIcon:SetPoint('RIGHT', button, -8, 0)
    button.gameIcon:SetSize(16, 16)
    button.gameIcon:SetTexCoord(.17, .83, .17, .83)
    F.CreateBDFrame(button.gameIcon)

    button:RegisterForClicks('AnyUp')
    button:SetScript('OnClick', buttonOnClick)
    button:SetScript('OnEnter', buttonOnEnter)
    button:SetScript('OnLeave', F.HideTooltip)

    return button
end

function INFOBAR:FriendsPanel_UpdateButton(button)
    local index = button.index
    local onlineFriends = INFOBAR.onlineFriends

    if index <= onlineFriends then
        if next(friendTable) == nil then
            return
        end
        local name, level, class, area, status = unpack(friendTable[index])
        button.status:SetTexture(status)
        local zoneColor = GetRealZoneText() == area and activeZone or inactiveZone
        local levelColor = F:RGBToHex(GetQuestDifficultyColor(level))
        local classColor = C.ClassColors[class] or levelColor
        button.name:SetText(string.format('%s%s|r %s%s', levelColor, level, F:RGBToHex(classColor), name))
        button.zone:SetText(string.format('%s%s', zoneColor, area))
        button.gameIcon:SetTexture(_G.BNet_GetClientTexture(_G.BNET_CLIENT_WOW))

        button.isBNet = nil
        button.data = friendTable[index]
    else
        local bnetIndex = index - onlineFriends
        local _, accountName, charName, canCooperate, client, status, class, _, infoText = unpack(bnetTable[bnetIndex])

        button.status:SetTexture(status)
        local zoneColor = inactiveZone
        local name = inactiveZone .. charName
        if client == _G.BNET_CLIENT_WOW then
            if canCooperate then
                local color = C.ClassColors[class] or GetQuestDifficultyColor(1)
                name = F:RGBToHex(color) .. charName
            end
            zoneColor = GetRealZoneText() == infoText and activeZone or inactiveZone
        end
        button.name:SetText(string.format('%s%s|r (%s|r)', C.INFO_COLOR, accountName, name))
        button.zone:SetText(string.format('%s%s', zoneColor, infoText))
        if client == CLIENT_WOW_DIFF then
            button.gameIcon:SetTexture(_G.BNet_GetClientTexture(_G.BNET_CLIENT_WOW))
            button.gameIcon:SetVertexColor(.3, .3, .3)
        else
            button.gameIcon:SetTexture(_G.BNet_GetClientTexture(client))
            button.gameIcon:SetVertexColor(1, 1, 1)
        end

        button.isBNet = true
        button.data = bnetTable[bnetIndex]
    end
end

function INFOBAR:FriendsPanel_Update()
    local scrollFrame = _G.FreeUIFriendsInfobarScrollFrame
    local usedHeight = 0
    local buttons = scrollFrame.buttons
    local height = scrollFrame.buttonHeight
    local numFriendButtons = INFOBAR.totalOnline
    local offset = _G.HybridScrollFrame_GetOffset(scrollFrame)
    for i = 1, #buttons do
        local button = buttons[i]
        local index = offset + i
        if index <= numFriendButtons then
            button.index = index
            INFOBAR:FriendsPanel_UpdateButton(button)
            usedHeight = usedHeight + height
            button:Show()
        else
            button.index = nil
            button:Hide()
        end
    end
    _G.HybridScrollFrame_Update(scrollFrame, numFriendButtons * height, usedHeight)
end

function INFOBAR:FriendsPanel_OnMouseWheel(delta)
    local scrollBar = self.scrollBar
    local step = delta * self.buttonHeight
    if IsShiftKeyDown() then
        step = step * 19
    end
    scrollBar:SetValue(scrollBar:GetValue() - step)
    INFOBAR:FriendsPanel_Update()
end

function INFOBAR:FriendsPanel_Refresh()
    local numFriends = C_FriendList.GetNumFriends()
    local onlineFriends = C_FriendList.GetNumOnlineFriends()
    local numBNet, onlineBNet = BNGetNumFriends()
    local totalOnline = onlineFriends + onlineBNet
    local totalFriends = numFriends + numBNet

    INFOBAR.numFriends = numFriends
    INFOBAR.onlineFriends = onlineFriends
    INFOBAR.numBNet = numBNet
    INFOBAR.onlineBNet = onlineBNet
    INFOBAR.totalOnline = totalOnline
    INFOBAR.totalFriends = totalFriends
end

local function delayLeave()
    if MouseIsOver(infoFrame) then
        return
    end
    infoFrame:Hide()
end

local function Block_OnMouseUp(self, btn)
    if infoFrame then
        infoFrame:Hide()
    end

    if btn == 'LeftButton' then
        _G.ToggleFriendsFrame()
    elseif btn == 'RightButton' then
        _G.StaticPopupSpecial_Show(_G.AddFriendFrame)
        _G.AddFriendFrame_ShowEntry()
    end
end

local function Block_OnEnter(self)
    local thisTime = GetTime()
    if not prevTime or (thisTime - prevTime > 5) then
        INFOBAR:FriendsPanel_Refresh()
        prevTime = thisTime
    end

    local numFriends = INFOBAR.numFriends
    local numBNet = INFOBAR.numBNet
    local totalOnline = INFOBAR.totalOnline
    local totalFriends = INFOBAR.totalFriends

    if totalOnline == 0 then
        _G.GameTooltip:SetOwner(self, 'ANCHOR_NONE')
        _G.GameTooltip:SetPoint('TOPLEFT', _G.UIParent, 15, -30)
        _G.GameTooltip:ClearLines()
        _G.GameTooltip:AddDoubleLine(_G.FRIENDS_LIST, string.format('%s: %s/%s', _G.GUILD_ONLINE_LABEL, totalOnline, totalFriends), 0, .6, 1, 0, .6, 1)
        _G.GameTooltip:AddLine(' ')
        _G.GameTooltip:AddLine(L['No Online'], 1, 1, 1)
        _G.GameTooltip:Show()
        return
    end

    if not updateRequest then
        if numFriends > 0 then
            buildFriendTable(numFriends)
        end
        if numBNet > 0 then
            buildBNetTable(numBNet)
        end
        updateRequest = true
    end

    INFOBAR:FriendsPanel_Init()
    INFOBAR:FriendsPanel_Update()
    infoFrame.friendCountText:SetText(string.format('%s: %s/%s', _G.GUILD_ONLINE_LABEL, totalOnline, totalFriends))
end

local function Block_OnLeave(self)
    F:HideTooltip()
    if not infoFrame then
        return
    end
    F:Delay(.1, delayLeave)
end

local function Block_OnEvent(self, event, arg1)
    if event == 'CHAT_MSG_SYSTEM' then
        if not string.find(arg1, onlineString) and not string.find(arg1, offlineString) then
            return
        end
    end

    INFOBAR:FriendsPanel_Refresh()
    self.text:SetText(string.format('%s: ' .. C.CLASS_COLOR .. '%d', _G.FRIENDS, INFOBAR.totalOnline))

    updateRequest = false
    if infoFrame and infoFrame:IsShown() then
        Block_OnEnter(self)
    end
end

function INFOBAR:CreateFriendsBlock()
    if not C.DB.Infobar.Friends then
        return
    end

    local friend = INFOBAR:RegisterNewBlock('friend', 'RIGHT', 150)
    friend.onEvent = Block_OnEvent
    friend.onEnter = Block_OnEnter
    friend.onLeave = Block_OnLeave
    friend.onMouseUp = Block_OnMouseUp
    friend.eventList = {'PLAYER_ENTERING_WORLD', 'CHAT_MSG_SYSTEM', 'FRIENDLIST_UPDATE', 'BN_FRIEND_ACCOUNT_ONLINE', 'BN_FRIEND_ACCOUNT_OFFLINE'}

    INFOBAR.FriendsBlock = friend
end
